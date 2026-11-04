from pathlib import Path
from langchain_community.document_loaders import PyPDFLoader
from langchain_text_splitters import RecursiveCharacterTextSplitter
from langchain_openai import OpenAIEmbeddings, ChatOpenAI
from langchain_qdrant import QdrantVectorStore
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.runnables import RunnablePassthrough
from dotenv import load_dotenv
import os

load_dotenv()
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")


class RetrievalAugmentedGeneration:
    def __init__(self, collection_name):
        self.pdf_path = Path(__file__).parent / "D19740141Lj.pdf"
        self.collection_name = collection_name
        self.embeddings = OpenAIEmbeddings(model="text-embedding-3-small")

    def _load_prompt(self, prompt_file):
        with open(f"prompts/{prompt_file}",mode="r") as file:
            txt = file.read()
            return txt

    def update(self):
        
        loader = PyPDFLoader(file_path=self.pdf_path)
        backup = False

        try:
            docs = loader.load()
        except:
            print("[UPDATE MANAGER]: Plik uszkodzony. Odpalam backup.", flush=True)
            backup = True
            self.pdf_path = Path(__file__).parent / "D19740141Lj_Backup.pdf"
            loader = PyPDFLoader(file_path=self.pdf_path)
            docs = loader.load()
        
        text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=400)
        chunks = text_splitter.split_documents(documents=docs)

        QdrantVectorStore.from_documents(
            api_key=os.getenv("QDRANT_API_KEY"),
            documents=chunks,
            embedding=self.embeddings,
            url=os.getenv("QDRANT_DATABASE"),
            collection_name=self.collection_name,
            force_recreate=True
        )

        if backup:
            print("[UPDATE MANAGER]: File loaded from bakcup.", flush=True)
        else:
            print("[UPDATE MANAGER]: File updated.", flush=True)
        
    def run(self, user_input):
        vector_store = QdrantVectorStore.from_existing_collection(
            api_key=os.getenv("QDRANT_API_KEY"),
            collection_name=self.collection_name, 
            embedding=self.embeddings, 
            url=os.getenv("QDRANT_DATABASE"))
        
        llm = ChatOpenAI(model="gpt-4o-mini", temperature=0.0)
        retriever = vector_store.as_retriever(search_kwargs={"k": 200})
        prompt = ChatPromptTemplate.from_template(self._load_prompt("prompt_1.txt"))
        
        rag_chain = ({"context": retriever, "question": RunnablePassthrough()} | prompt | llm)
        return rag_chain.invoke(user_input).content