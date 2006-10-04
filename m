From: Mohammad Farooq <mohammadfarooq@tango-networks.com>
Subject: iptables won't compile in a debug turned on
Date: Wed, 04 Oct 2006 14:26:37 -0500
Message-ID: <1159989997.28977.166.camel@mfarooq-1.tango-networks.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Are you guys aware of that is in the iptables-1.3.6/Makefile if turn on
debugging:
CFLAGS:=$(COPT_FLAGS) -Wall -Wunused -I$(KERNEL_DIR)/include -Iinclude/
-DIPTABLES_VERSION=\"$(IPTABLES_VERSION)\" -g -DDEBUG -pg  -DIPTC_DEBUG
the compile will fail.

MF

libiptc/libip6tc.c: In function `do_check':
libiptc/libip6tc.c:284: warning: implicit declaration of function
`get_chain_end'
libiptc/libip6tc.c:285: warning: implicit declaration of function
`get_entry'
libiptc/libip6tc.c:285: error: invalid type argument of `->'
libiptc/libip6tc.c:289: error: invalid type argument of `->'
libiptc/libip6tc.c:308: error: invalid type argument of `->'
libiptc/libip6tc.c:312: error: invalid type argument of `->'
libiptc/libip6tc.c:318: error: invalid type argument of `->'
libiptc/libip6tc.c:343: error: invalid type argument of `->'
libiptc/libip6tc.c:349: error: invalid type argument of `->'
libiptc/libip6tc.c:354: error: invalid type argument of `->'
libiptc/libip6tc.c:360: error: invalid type argument of `->'
libiptc/libip6tc.c:373: error: invalid type argument of `->'
libiptc/libip6tc.c:384: error: invalid type argument of `->'
libiptc/libip6tc.c:397: warning: assignment makes pointer from integer
without a cast
libiptc/libip6tc.c:410: warning: passing arg 2 of `iptcb_entry2index'
makes pointer from integer without a cast
libiptc/libip6tc.c:411: warning: passing arg 2 of `iptcb_entry2index'
makes pointer from integer without a cast
libiptc/libip6tc.c:418: error: request for member `size' in something
not a structure or union
libiptc/libip6tc.c:418: error: structure has no member named
`new_number'
libiptc/libip6tc.c:422: error: request for member `name' in something
not a structure or union
libiptc/libip6tc.c:422: error: request for member `name' in something
not a structure or union
libiptc/libip6tc.c:422: error: request for member `name' in something
not a structure or union
libiptc/libip6tc.c:422: error: request for member `name' in something
not a structure or union
libiptc/libip6tc.c:422: error: request for member `name' in something
not a structure or union
libiptc/libip6tc.c:422: error: request for member `name' in something
not a structure or union
libiptc/libip6tc.c:422: error: request for member `name' in something
not a structure or union
libiptc/libip6tc.c:422: error: request for member `name' in something
not a structure or union
libiptc/libip6tc.c:422: error: request for member `name' in something
not a structure or union
libiptc/libip6tc.c:422: error: request for member `name' in something
not a structure or union
libiptc/libip6tc.c:422: error: request for member `name' in something
not a structure or union
libiptc/libip6tc.c:422: error: request for member `name' in something
not a structure or union
libiptc/libip6tc.c:422: error: request for member `name' in something
not a structure or union
libiptc/libip6tc.c:422: error: request for member `name' in something
not a structure or union
libiptc/libip6tc.c:422: error: request for member `name' in something
not a structure or union
libiptc/libip6tc.c:422: error: request for member `name' in something
not a structure or union
libiptc/libip6tc.c:422: error: request for member `name' in something
not a structure or union
libiptc/libip6tc.c:422: error: request for member `name' in something
not a structure or union
libiptc/libip6tc.c:422: error: request for member `name' in something
not a structure or union
libiptc/libip6tc.c:422: error: request for member `name' in something
not a structure or union
libiptc/libip6tc.c: At top level:
libiptc/libip6tc.c:135: warning: 'dump_entry' defined but not used
make: *** [libiptc/libip6tc.o] Error 1
rm libiptc/libip4tc.o
