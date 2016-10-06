From: Davide Caratti <dcaratti@redhat.com>
Subject: [PATCH nf-next 0/2] netfilter: autoload NAT support for non-builtin L4 protocols
Date: Thu,  6 Oct 2016 19:09:27 +0200
Message-ID: <cover.1475773632.git.dcaratti@redhat.com>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>, fw@strlen.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57996 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S942018AbcJFRJs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Oct 2016 13:09:48 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

this series fixes SNAT/DNAT rules where port number translation is
explicitly configured, but only the L3 address is translated:

# iptables -t nat -A POSTROUTING -o eth1 -p stcp -j SNAT --to-source 10.0.0.1:61000
# tcpdump -s46 -tni eth1 sctp
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on eth1, link-type EN10MB (Ethernet), capture size 46 bytes
IP 10.0.0.1.37788 > 10.0.0.2.2000: sctp
            ^^^^^
IP 10.0.0.2.2000 > 10.0.0.1.37788: sctp
IP 10.0.0.1.37788 > 10.0.0.2.2000: sctp
IP 10.0.0.2.2000 > 10.0.0.1.37788: sctp
IP 10.0.0.2.2000 > 10.0.0.1.37788: sctp
IP 10.0.0.1.37788 > 10.0.0.2.2000: sctp
IP 10.0.0.2.2000 > 10.0.0.1.37788: sctp

This happens for all protocols that don't have L4 NAT support built into
nf_nat.ko, such as DCCP, SCTP and UDPLite: unless the user modprobes
nf_nat_proto_{dccp,sctp,udplite}.ko, port translation as specified in the
above rule will not be done. 
The first patch provides persistent and generic aliases for the above
modules; the second patch autoloads nf_nat_proto_{dccp,sctp,udplite} when a
SNAT/DNAT rule matching one of the above protocols is created.

Davide Caratti (2):
  netfilter: persistent aliases for l4 nat protocols
  xt_nat: probe module for non-builtin L4 protocols

 include/net/netfilter/nf_nat_l4proto.h |  3 +++
 net/netfilter/nf_nat_proto_dccp.c      |  1 +
 net/netfilter/nf_nat_proto_sctp.c      |  1 +
 net/netfilter/nf_nat_proto_udplite.c   |  1 +
 net/netfilter/xt_nat.c                 | 47 ++++++++++++++++++++++++++++++++++
 5 files changed, 53 insertions(+)

-- 
2.5.5

