
typedef struct QUADTYPE {
    char* op;
    char* arg1;
    char* arg2;
    char* result;
};

QUADTYPE __quad__[1000];
int __quadTop__ = 0;

FILE __file__;