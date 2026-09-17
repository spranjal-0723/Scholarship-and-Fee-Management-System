import os
import oracledb

DB_USER = os.getenv("ORACLE_USER", "system")
DB_PASSWORD = os.getenv("ORACLE_PASSWORD", "oracle")
DB_DSN = os.getenv("ORACLE_DSN", "localhost:1521/FREEPDB1")


def get_connection():
    return oracledb.connect(
        user=DB_USER,
        password=DB_PASSWORD,
        dsn=DB_DSN
    )