import pprint as pp


import sys
import os
sys.path.append(os.getcwd())
sys.path.append('../generators')

import riscv_gen as rg
import nanorv32
import nanorv32_impl as impl

# if __name__ == '__main__':
if True:
    #pp.pprint(nanorv32.spec)
    dic_inst_format = rg.get_instruction_format(nanorv32.spec)
    #pp.pprint(dic_inst_format)
    rg.write_to_file("../../generated", "instruction_format.generated.v",
                     rg.verilog_instruction_format(dic_inst_format))
    rg.write_to_file("../../generated", "instruction_fields.generated.v",
                     rg.verilog_inst_field(dic_inst_format))

    decode_fields = rg.get_decode_fields(nanorv32.spec, dic_inst_format)
    pp.pprint(decode_fields)
    decode_dic = rg.build_decode_string(decode_fields, "32'b", 32)

    pp.pprint(decode_dic)

    rg.write_to_file("../../generated", "inst_decode_definitions.generated.v",
                     rg.verilog_decode_definition(decode_dic))
    print "="*80
    merged_impl = rg.merge_inst_impl(nanorv32.spec, impl.spec)
    print "*"*80
    pp.pprint(merged_impl)
    pass
