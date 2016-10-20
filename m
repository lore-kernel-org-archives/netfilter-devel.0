From: Davide Caratti <dcaratti@redhat.com>
Subject: [PATCH nf-next v2 0/3] netfilter: built-in NAT support for DCCP, SCTP, UDPlite
Date: Thu, 20 Oct 2016 18:33:00 +0200
Message-ID: <cover.1476980105.git.dcaratti@redhat.com>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>,
        Arturo Borrero Gonzalez <arturo@debian.org>,
        Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40174 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755757AbcJTQdJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Oct 2016 12:33:09 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Version 2 changes:
- use #ifdef ... in place of #if IS_ENABLED()
- add footprint test results

The above L4 protocols usually need an explicit modprobe command (e.g
"modprobe nf_nat_proto_sctp") to provide full functionality of REDIRECT
targets and SNAT/DNAT targets where port number translation is explicitly
configured.
In order to remove such limitation, this series converts 
CONFIG_NF_NAT_PROTO_{DCCP,SCTP,UDPLITE} from tristate to boolean: in case 
NAT support for these protocols is enabled in the kernel configuration, it
will be built into nf_nat.ko.

footprint test:

each patch of the series has been individually tested on a nf-next.git
kernel with standard RHEL7 configuration on x86_64 architecture, recording
the unstripped binary size after module clean/rebuild:

# ls -l net/netfilter/nf_nat{,_proto_{dccp,sctp,udplite}}.ko

(nf_nat_proto_)         udplite | sctp   | dccp   || nf_nat
--------------------------------+--------+--------++------------
no builtin              408048  | 428344 | 409800 || 2241312
DCCP builtin            408048  | 428344 |   -    || 2578968
SCTP builtin            408048  |   -    | 409800 || 2597032
UDPLITE builtin           -     | 428344 | 409800 || 2577256
all builtin               -     |   -    |   -    || 3270616

Signed-off-by: Davide Caratti <dcaratti@redhat.com>


Davide Caratti (3):
  netfilter: built-in NAT support for DCCP
  netfilter: built-in NAT support for SCTP
  netfilter: built-in NAT support for UDPlite

 include/net/netfilter/nf_nat_l4proto.h |  9 +++++++++
 net/netfilter/Kconfig                  |  6 +++---
 net/netfilter/Makefile                 | 10 +++++-----
 net/netfilter/nf_nat_core.c            | 12 ++++++++++++
 net/netfilter/nf_nat_proto_dccp.c      | 36 +---------------------------------
 net/netfilter/nf_nat_proto_sctp.c      | 35 +--------------------------------
 net/netfilter/nf_nat_proto_udplite.c   | 35 +--------------------------------
 7 files changed, 32 insertions(+), 111 deletions(-)

-- 
2.5.5

