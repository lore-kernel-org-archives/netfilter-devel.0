From: Borja Pacheco <bpacheco@acisa.es>
Subject: Including iptables.c in my C++ Project
Date: Thu, 03 Mar 2005 17:03:20 +0100
Message-ID: <1109865800.9270.17.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: Netfilter-Devel <netfilter-devel@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Dear all,

I'm developing  a program in C++ which needs to insert rules into the
kernel.
I thought to invoke iptables binary directly, but I think that if I used
it intensively it could be an issue with the performance, so I finally
decided to include the source code of iptables into my own program and
make internal calls to insert_entry (you can found its code into
iptables.c) instead.

To do this, 
I included into my files the following include:
#include "iptables.c"

I modified my g++'s flags:
a) -I -> I add full path to KERNEL_DIR, iptables root dir and iptables
include dir.
b) -L -> I add full path to iptables root dir
c) LDFLAGS -> I added -rdynamic (I'm using shareable libs)

However, after inserting the #include, my programs becomes
uncompilable. 
g++ claims an error related with conversion pointer in the kernel's
source code. 

Suggestion are welcome!!!
Thanks in advance to everybody.

Here you are the messages....


if g++ -DHAVE_CONFIG_H -I. -I. -I.. -I/usr/src/linux/include
-I/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/include
-I/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11
-I/usr/include/cc++2/   -Wall -g  -MT FirewallRule.o -MD -MP -MF
".deps/FirewallRule.Tpo" -c -o FirewallRule.o FirewallRule.cc; \
then mv -f ".deps/FirewallRule.Tpo" ".deps/FirewallRule.Po"; else rm -f
".deps/FirewallRule.Tpo"; exit 1; fi
In file included
from /home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/include/libiptc/libiptc.h:6,

from /home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/include/iptables.h:5,

from /home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:39,
                 from FirewallRule.h:15,
                 from FirewallRule.cc:7:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h: In function `
   ipt_entry_target* ipt_get_target(ipt_entry*)':
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:297: error:
pointer of
   type `void *' used in arithmetic
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:297: error:
invalid
   conversion from `void*' to `ipt_entry_target*'
In file included from FirewallRule.h:15,
                 from FirewallRule.cc:7:
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:
In
   function `ipt_entry_target* ipt_get_target(ipt_entry*)':
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:153: error: redefinition
   of `ipt_entry_target* ipt_get_target(ipt_entry*)'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:296: error: `
   ipt_entry_target* ipt_get_target(ipt_entry*)' previously defined here
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:153: error: redefinition
   of `ipt_entry_target* ipt_get_target(ipt_entry*)'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:296: error: `
   ipt_entry_target* ipt_get_target(ipt_entry*)' previously defined here
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:154: error: pointer
   of type `void *' used in arithmetic
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:154: error: invalid
   conversion from `void*' to `ipt_entry_target*'
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:
In
   function `in_addr* host_to_addr(const char*, unsigned int*)':
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:554: error: invalid
   conversion from `void*' to `in_addr*'
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:
In
   function `in_addr* parse_hostnetwork(const char*, unsigned int*)':
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:592: error: invalid
   conversion from `void*' to `in_addr*'
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:
In
   function `iptables_match* find_match(const char*, ipt_tryload,
   iptables_rule_match**)':
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:712: error: invalid
   conversion from `void*' to `iptables_rule_match*'
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:
In
   function `void set_option(unsigned int*, unsigned int, u_int8_t*,
int)':
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:958: warning: comparison
   between signed and unsigned integer expressions
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:
In
   function `option* merge_options(option*, const option*, unsigned
int*)':
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:1036: error: invalid
   conversion from `void*' to `option*'
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:
In
   function `void print_firewall(const ipt_entry*, const char*, unsigned
int,
   unsigned int, iptc_handle*)':
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:1221: error: call
   of overloaded `ipt_get_target(ipt_entry*&)' is ambiguous
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:296: error:
candidates
   are: ipt_entry_target* ipt_get_target(ipt_entry*)
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:153: error:
                  ipt_entry_target* ipt_get_target(ipt_entry*)
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:1309: error: pointer
   of type `void *' used in arithmetic
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:1309: error: invalid
   conversion from `void*' to `ipt_entry_match*'
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:
In
   function `void print_firewall_line(const ipt_entry*, iptc_handle*)':
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:1329: error: call
   of overloaded `ipt_get_target(ipt_entry*&)' is ambiguous
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:296: error:
candidates
   are: ipt_entry_target* ipt_get_target(ipt_entry*)
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:153: error:
                  ipt_entry_target* ipt_get_target(ipt_entry*)
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:
In
   function `unsigned char* make_delete_mask(ipt_entry*,
iptables_rule_match*)
   ':
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:1417: error: invalid
   conversion from `void*' to `unsigned char*'
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:
In
   function `int for_each_chain(int (*)(const char*, int,
iptc_handle**), int,
   int, iptc_handle**)':
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:1481: error: invalid
   conversion from `void*' to `char*'
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:
In
   function `int list_entries(const char*, int, int, int, int,
iptc_handle**)':
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:1544: error: syntax
   error before `this'
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:1561: error: invalid
   use of `this' in non-member function
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:1562: error: invalid
   use of `this' in non-member function
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:1563: error: invalid
   use of `this' in non-member function
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:1567: error: invalid
   use of `this' in non-member function
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:1572: error: invalid
   use of `this' in non-member function
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:1573: error: invalid
   use of `this' in non-member function
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:
In
   function `char* get_modprobe()':
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:1600: error: invalid
   conversion from `void*' to `char*'
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:
In
   function `ipt_entry* generate_entry(const ipt_entry*,
iptables_rule_match*,
   ipt_entry_target*)':
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:1663: error: invalid
   conversion from `void*' to `ipt_entry*'
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:
In
   function `int do_command(int, char**, char**, iptc_handle**)':
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:1746: error: invalid
   conversion from `unsigned int*' to `int*'
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:1752: error: invalid
   conversion from `unsigned int*' to `int*'
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:1763: error: invalid
   conversion from `unsigned int*' to `int*'
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:1776: error: invalid
   conversion from `unsigned int*' to `int*'
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:1786: error: invalid
   conversion from `unsigned int*' to `int*'
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:1795: error: invalid
   conversion from `unsigned int*' to `int*'
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:1804: error: invalid
   conversion from `unsigned int*' to `int*'
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:1821: error: invalid
   conversion from `unsigned int*' to `int*'
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:1827: error: invalid
   conversion from `unsigned int*' to `int*'
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:1836: error: invalid
   conversion from `unsigned int*' to `int*'
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:1850: error: invalid
   conversion from `unsigned int*' to `int*'
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:1922: error: invalid
   conversion from `void*' to `ipt_entry_target*'
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:1975: error: invalid
   conversion from `void*' to `ipt_entry_match*'
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:2116: error: invalid
   conversion from `void*' to `ipt_entry_match*'
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:2245: error: invalid
   conversion from `void*' to `ipt_entry_target*'
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:2342: warning: comparison
   between signed and unsigned integer expressions
/home/bpacheco-gen/Projects/sources/iptables/iptables-1.2.11/iptables.c:2345: warning: comparison
   between signed and unsigned integer expressions
make[2]: *** [FirewallRule.o] Error 1
make[2]: Leaving directory `/home/bpacheco-gen/Projects/tpfd/src'
make[1]: *** [all-recursive] Error 1
make[1]: Leaving directory `/home/bpacheco-gen/Projects/tpfd'
make: *** [all] Error 2
