
typedef struct {
    int addr;
    char* name;
    int type;
    int width;
} TABLETYPE;

TABLETYPE __table__[1000];
int __tableTop__ = 0;

int __offset__ = 0;
