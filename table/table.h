
typedef struct {
    int addr;
    char* name;
    int type;
    int width;
} TABLETYPE;

TABLETYPE __table__[1000];
static int __tableTop__ = 0;

static int __offset__ = 0;
