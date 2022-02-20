#include <stdio.h>
#include <stdlib.h>
#include <getopt.h>
#include <vslc.h>

/* Global state */

node_t *root; // Syntax tree

/* Command line option parsing for the main function */
static void options(int argc, char **argv);
bool
    print_full_tree = false;

/* Entry point */
int main(int argc, char **argv)
{
    options(argc, argv);

    yyparse(); // Generated from grammar/bison, constructs syntax tree

    if (print_full_tree)
        print_syntax_tree();

    destroy_syntax_tree(); // In tree.c
    return 0;
}

static const char *usage =
    "Command line options\n"
    "\t-h\tOutput this text and halt\n"
    "\t-t\tOutput the full syntax tree\n";

static void
options(int argc, char **argv)
{
    int o;
    while ((o = getopt(argc, argv, "ht")) != -1)
    {
        switch (o)
        {
        case 'h':
            printf("%s:\n%s", argv[0], usage);
            exit(EXIT_FAILURE);
            break;
        case 't':
            print_full_tree = true;
            break;
        }
    }
}
