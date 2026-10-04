#include <stdio.h>
#include <string.h>

#define GREETING "Hello from vim-env"

// Наведи gd на project_t / banner нижче, K — для документації,
// почни писати printf — випаде автодоповнення, \f — форматування.
typedef struct {
    const char *name;
    int         year;
} project_t;

static void banner(const project_t *p)
{
    printf("%s — %s (%d)\n", GREETING, p->name, p->year);
}

int main(void)
{
    project_t self = { .name = "vim-env", .year = 2026 };
    banner(&self);
    printf("name length: %zu\n", strlen(self.name));
    return 0;
}
