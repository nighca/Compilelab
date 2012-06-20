
typedef struct TABLETYPE {
    int addr;
    char* name;
    int type;
    int width;
};

TABLETYPE __table__[1000];
int __tableTop__ = 0;

int __offset__ = 0;

int __genNum__ = 1;
