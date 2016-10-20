From: Davide Caratti <dcaratti@redhat.com>
Subject: [PATCH nf-next 0/3] netfilter: built-in NAT support for DCCP, SCTP, UDPlite
Date: Thu, 20 Oct 2016 12:26:22 +0200
Message-ID: <cover.1476956422.git.dcaratti@redhat.com>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>,
        Arturo Borrero Gonzalez <arturo@debian.org>,
        Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35880 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755247AbcJTK0l (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Oct 2016 06:26:41 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The above L4 protocols usually need an explicit modprobe command (e.g
"modprobe nf_nat_proto_sctp") to provide full functionality of REDIRECT
targets and SNAT/DNAT targets where port number translation is explicitly
configured.
In order to remove such limitation, this series converts 
CONFIG_NF_NAT_PROTO_{DCCP,SCTP,UDPLITE} from tristate to boolean: in case 
NAT support for these protocols is enabled in the kernel configuration, it
will be built into nf_nat.ko.

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

