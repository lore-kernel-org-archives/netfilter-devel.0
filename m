From: "Emiel Mols" <emiel@fulgor-hosting.nl>
Subject: nfnetlink-ctnetlink with 2.4.27
Date: Wed, 20 Oct 2004 21:19:48 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <E1CKLzy-0006DE-00@deer.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

 

During compilation of a 2.4.27 stock kernel (from kernel.org) patched with
the nfnetlink-ctnetlink patch from the last pom-ng (patching goes well), the
following error occurs:

 

make[3]: Entering directory
`/usr/src/linux-2.4.27-misluktepatch/net/ipv4/netfilter'

gcc -D__KERNEL__ -I/usr/src/linux-2.4.27-misluktepatch/include -Wall
-Wstrict-prototypes -Wno-trigraphs -O2 -fno-strict-aliasing -fno-common
-fomit-frame-pointer -pipe -mpreferred-stack-boundary=2 -march=c3
-falign-functions=0 -falign-jumps=0 -falign-loops=0   -nostdinc -iwithprefix
include -DKBUILD_BASENAME=ip_conntrack_standalone  -DEXPORT_SYMTAB -c
ip_conntrack_standalone.c

ip_conntrack_standalone.c:463: error: `invert_tuple' undeclared here (not in
a function)

ip_conntrack_standalone.c:463: error: initializer element is not constant

ip_conntrack_standalone.c:463: error: (near initialization for
`__ksymtab_invert_tuple.value')

ip_conntrack_standalone.c:465: error: `ip_conntrack_alloc' undeclared here
(not in a function)

ip_conntrack_standalone.c:465: error: initializer element is not constant

ip_conntrack_standalone.c:465: error: (near initialization for
`__ksymtab_ip_conntrack_alloc.value')

ip_conntrack_standalone.c:466: error: `ip_conntrack_free' undeclared here
(not in a function)

ip_conntrack_standalone.c:466: error: initializer element is not constant

ip_conntrack_standalone.c:466: error: (near initialization for
`__ksymtab_ip_conntrack_free.value')

ip_conntrack_standalone.c:467: error: `ip_conntrack_place_in_lists'
undeclared here (not in a function)

ip_conntrack_standalone.c:467: error: initializer element is not constant

ip_conntrack_standalone.c:467: error: (near initialization for
`__ksymtab_ip_conntrack_place_in_lists.value')

ip_conntrack_standalone.c:482: error: `ip_conntrack_remove_expectations'
undeclared here (not in a function)

ip_conntrack_standalone.c:482: error: initializer element is not constant

ip_conntrack_standalone.c:482: error: (near initialization for
`__ksymtab_ip_conntrack_remove_expectations.value')

ip_conntrack_standalone.c:463: error: __ksymtab_invert_tuple causes a
section type conflict

ip_conntrack_standalone.c:465: error: __ksymtab_ip_conntrack_alloc causes a
section type conflict

ip_conntrack_standalone.c:466: error: __ksymtab_ip_conntrack_free causes a
section type conflict

ip_conntrack_standalone.c:467: error: __ksymtab_ip_conntrack_place_in_lists
causes a section type conflict

ip_conntrack_standalone.c:482: error:
__ksymtab_ip_conntrack_remove_expectations causes a section type conflict

make[3]: *** [ip_conntrack_standalone.o] Error 1

make[3]: Leaving directory
`/usr/src/linux-2.4.27-misluktepatch/net/ipv4/netfilter'

make[2]: *** [first_rule] Error 2

make[2]: Leaving directory
`/usr/src/linux-2.4.27-misluktepatch/net/ipv4/netfilter'

make[1]: *** [_subdir_ipv4/netfilter] Error 2

make[1]: Leaving directory `/usr/src/linux-2.4.27-misluktepatch/net'

make: *** [_dir_net] Error 2

 

The same happens with a 2.4.26 stock kernel.

 

Could any of you help me with this?

 

Thanks in advance,

 

Emiel Mols
