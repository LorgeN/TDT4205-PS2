#include <vslc.h>

static void node_print ( node_t *root, int nesting );
static void node_finalize ( node_t *discard );
static void destroy_subtree ( node_t *discard );


/* External interface */
void
destroy_syntax_tree ( void )
{
    destroy_subtree ( root );
}


void
print_syntax_tree ( void )
{
    node_print ( root, 0 );
}


void
node_init (node_t *nd, node_index_t type, void *data, uint64_t n_children, ...)
{
    /* TODO: Initializer function for a syntax tree node */
}


static void
node_print ( node_t *root, int nesting )
{
    if ( root != NULL )
    {
        printf ( "%*c%s", nesting, ' ', node_string[root->type] );
        if ( root->type == IDENTIFIER_DATA ||
             root->type == STRING_DATA ||
             root->type == EXPRESSION ) 
            printf ( "(%s)", (char *) root->data );
        else if ( root->type == NUMBER_DATA )
            printf ( "(%ld)", *((int64_t *)root->data) );
        putchar ( '\n' );
        for ( int64_t i=0; i<root->n_children; i++ )
            node_print ( root->children[i], nesting+1 );
    }
    else
        printf ( "%*c%p\n", nesting, ' ', root );
}


static void
node_finalize ( node_t *discard )
{
    /* TODO: Remove memory allocated for a single syntax tree node */
}


static void
destroy_subtree ( node_t *discard )
{
    /* TODO: Remove all nodes in the subtree rooted at a node */
}
