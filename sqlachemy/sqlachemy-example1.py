#testing sqlachemy python package

from sqlalchemy import create_engine, Column, Integer, ForeignKey, String
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, relationship

Base = declarative_base() # base class can be shared

class User(Base):
    __tablename__ = "person"

    id = Column("id", Integer, primary_key=True)
    username = Column("username", String, unique=True)


#creating engine - will get a dumpy out of the sql
engine = create_engine('sqlite:///:memory:', echo = True)
Base.metadata.create_all(bind=engine)
Session = sessionmaker(bind=engine)

session = Session()
user = User()
user.id= 0
user.username = 'alice'

session.add(user)
session.commit()

session.close()
