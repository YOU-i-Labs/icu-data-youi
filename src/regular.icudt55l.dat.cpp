#include "regular.icudt55l.dat.h"

namespace youi_private {

alignas(16) unsigned char g_regular_ICU55_data[] = {
#include "generated.regular.data1.h"
#include "generated.regular.data2.h"
};

const unsigned char *GetRegularICU55Data()
{
    return g_regular_ICU55_data;
}

size_t GetRegularICU55Size()
{
    return sizeof(g_regular_ICU55_data);
}

}
