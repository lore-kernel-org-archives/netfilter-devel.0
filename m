From: Davide Caratti <dcaratti@redhat.com>
Subject: [PATCH nf-next v2 0/4] netfilter: built-in conntrack support for DCCP, SCTP, UDPlite
Date: Tue, 15 Nov 2016 15:08:23 +0100
Message-ID: <cover.1479217169.git.dcaratti@redhat.com>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Florian Westphal <fw@strlen.de>, mikko.rapeli@iki.fi
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38022 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932756AbcKOOJ3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Nov 2016 09:09:29 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When netfilter needs to match traffic made by one of the above protocols,
layer-4 connection tracking functionality will not be available, unless the
user explicly loads it in the kernel (e.g. "modprobe nf_conntrack_proto_sctp")
or modifies the default kernel configuration and rebuilds.
In order to remove such limitation, this series converts
CONFIG_NF_CT_PROTO_{DCCP,SCTP,UDPLITE} from tristate to boolean: in case
conntrack support for these protocols is enabled in the kernel configuration,
it will be built into nf_conntrack.ko.

Patch 1/4 fixes nf_conntrack_tuple_common.h to avoid compile-time errors
when moving module per-net private data.
Patches 2/4  3,4 and 4/4 remove loadable kernel module support from DCCP,
SCTP and UDPlite respectively.

footprint test (nf-next.git, x86_64, RHEL7)

Patches 2/4 to 4/4 in this series have been individually tested on a
nf-next.git kernel with standard RHEL7 configuration on x86_64 architecture,
recording the unstripped binary size after module clean/rebuild:

$ ls -l net/netfilter/nf_conntrack{,_proto_{dccp,sctp,udplite}}.ko \
        net/ipv4/netfilter/nf_conntrack_ipv4.ko \
        net/ipv6/netfilter/nf_conntrack_ipv6.ko

(builtin)||  dccp  |  sctp  |  udplite  |  ipv4  |  ipv6  | nf_conntrack
---------++--------+--------+-----------+--------+--------+--------------
none     || 469140 | 498243 |  432538   | 828755 | 828676 | 6141434
DCCP     ||   -    | 498987 |  432746   | 830566 | 829935 | 6533526
SCTP     || 469276 |   -    |  432690   | 829254 | 829175 | 6547872
UDPlite  || 469484 | 498587 |    -      | 829649 | 829362 | 6498204
all      ||   -    |   -    |    -      | 831999 | 831104 | 7298358

v2:
    - patch 1/4: use #ifndef __KERNEL__ directive instead of just removing
    "#include <linux/netfilter.h>" line
    - patch 1/4: reword commit message

Davide Caratti (4):
  netfilter: nf_conntrack_tuple_common.h: fix #include
  netfilter: conntrack: built-in support for DCCP
  netfilter: conntrack: built-in support for SCTP
  netfilter: conntrack: built-in support for UDPlite

 include/linux/netfilter/nf_conntrack_dccp.h        |  2 +-
 include/net/netfilter/ipv4/nf_conntrack_ipv4.h     |  9 +++
 include/net/netfilter/ipv6/nf_conntrack_ipv6.h     |  9 +++
 include/net/netns/conntrack.h                      | 43 ++++++++++++
 .../linux/netfilter/nf_conntrack_tuple_common.h    |  3 +
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c     |  9 +++
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c     |  9 +++
 net/netfilter/Kconfig                              | 18 ++---
 net/netfilter/Makefile                             |  7 +-
 net/netfilter/nf_conntrack_proto_dccp.c            | 79 +++-------------------
 net/netfilter/nf_conntrack_proto_sctp.c            | 76 +++------------------
 net/netfilter/nf_conntrack_proto_udplite.c         | 79 +++-------------------
 12 files changed, 123 insertions(+), 220 deletions(-)

-- 
2.7.4

