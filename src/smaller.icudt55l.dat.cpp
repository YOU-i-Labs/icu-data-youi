#include "smaller.icudt55l.dat.h"

namespace youi_private {

alignas(16) unsigned char g_smaller_ICU55_data[] = {
#include "generated.smaller.data1.h"
};

const unsigned char *GetSmallerICU55Data()
{
    return g_smaller_ICU55_data;
}

size_t GetSmallerICU55Size()
{
    return sizeof(g_smaller_ICU55_data);
}

}
