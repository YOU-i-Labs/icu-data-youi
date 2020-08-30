#include "minimal.h"

namespace youi_private {

alignas(16) unsigned char g_minimal_ICU55_data[] = {
#include "generated.minimal.data1.h"
};

const unsigned char *GetMinimalICU55Data()
{
    return g_minimal_ICU55_data;
}

size_t GetMinimalICU55Size()
{
    return sizeof(g_minimal_ICU55_data);
}

}
