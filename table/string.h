
bool _strcmp(char* str1, char* str2) {
    for (i = 0; ; i++) {
        if (str1[i] != str2[i])
            return false;
        if (str1[i] == '\0' && str2[i] == '\0') {
            return true;
        }
    }
}

