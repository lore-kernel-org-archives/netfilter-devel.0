From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next,v3 0/7] Flow offload infrastructure
Date: Fri, 22 Dec 2017 20:27:25 +0100
Message-ID: <20171222192732.13188-1-pablo@netfilter.org>
Cc: netdev@vger.kernel.org, f.fainelli@gmail.com,
        simon.horman@netronome.com, ronye@mellanox.com, jiri@mellanox.com,
        nbd@nbd.name, john@phrozen.org, kubakici@wp.pl, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42282 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756596AbdLVT2B (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 22 Dec 2017 14:28:01 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4854BEBAD8
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Dec 2017 20:28:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 33CCFF731B
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Dec 2017 20:28:00 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

This is a new round of the patchset to add the flow offload
infrastructure [1][2].

This round comes with IPv6 and mixed IPv4/IPv6 support, hardware offload
support in a separated nf_flow_table_hw module, port translation, net
namespace support and several bugfixes.

Patch 7/7 has been tagged as RFC, I will keep this one back until
there's an initial driver that introduces flow table offload support,
likely in a branch in nf-next.git once this new infrastructure gets
merged upstream.

Comments welcome, thanks.

[1] https://lwn.net/Articles/738214/
[2] https://marc.info/?l=netfilter-devel&m=151266258119014&w=2

Pablo Neira Ayuso (7):
  netfilter: nf_tables: add flow table netlink frontend
  netfilter: add generic flow table infrastructure
  netfilter: flow table support for IPv4
  netfilter: flow table support for IPv6
  netfilter: flow table support for the mixed IPv4/IPv6 family
  netfilter: nf_tables: flow offload expression
  netfilter: nf_flow_table: add hardware offload support

 include/linux/netdevice.h                |   9 +
 include/net/ipv6.h                       |   2 +
 include/net/netfilter/nf_flow_table.h    | 128 ++++++
 include/net/netfilter/nf_tables.h        |  48 ++
 include/uapi/linux/netfilter/nf_tables.h |  64 +++
 net/ipv4/netfilter/Kconfig               |   8 +
 net/ipv4/netfilter/Makefile              |   3 +
 net/ipv4/netfilter/nf_flow_table_ipv4.c  | 284 ++++++++++++
 net/ipv6/ip6_output.c                    |   3 +-
 net/ipv6/netfilter/Kconfig               |   8 +
 net/ipv6/netfilter/Makefile              |   3 +
 net/ipv6/netfilter/nf_flow_table_ipv6.c  | 278 ++++++++++++
 net/netfilter/Kconfig                    |  31 ++
 net/netfilter/Makefile                   |   5 +
 net/netfilter/nf_flow_table.c            | 447 ++++++++++++++++++
 net/netfilter/nf_flow_table_hw.c         | 127 ++++++
 net/netfilter/nf_flow_table_inet.c       |  48 ++
 net/netfilter/nf_tables_api.c            | 749 ++++++++++++++++++++++++++++++-
 net/netfilter/nft_flow_offload.c         | 272 +++++++++++
 19 files changed, 2515 insertions(+), 2 deletions(-)
 create mode 100644 include/net/netfilter/nf_flow_table.h
 create mode 100644 net/ipv4/netfilter/nf_flow_table_ipv4.c
 create mode 100644 net/ipv6/netfilter/nf_flow_table_ipv6.c
 create mode 100644 net/netfilter/nf_flow_table.c
 create mode 100644 net/netfilter/nf_flow_table_hw.c
 create mode 100644 net/netfilter/nf_flow_table_inet.c
 create mode 100644 net/netfilter/nft_flow_offload.c

-- 
2.11.0

