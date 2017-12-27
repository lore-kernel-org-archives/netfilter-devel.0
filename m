From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next,v4 0/7] get rid of struct nf_afinfo
Date: Wed, 27 Dec 2017 18:15:40 +0100
Message-ID: <20171227171547.4354-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48976 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751043AbdL0RP4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Dec 2017 12:15:56 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 115C5B4964
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Dec 2017 18:15:55 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 028ABDA3A2
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Dec 2017 18:15:55 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 55D42DA3A3
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Dec 2017 18:15:51 +0100 (CET)
Received: from salvia.here (129.166.216.87.static.jazztel.es [87.216.166.129])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 292634265A32
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Dec 2017 18:15:51 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch gets rid of the struct nf_afinfo abstraction [1].

Previous patchset version was flawed with CONFIG_NETFILTER=y and
CONFIG_INET=n which is valid combination too.

Send a new version to address problems that have been spotted by the
kbuild robot.

[1] https://marc.info/?l=netfilter-devel&m=151381157917882&w=2

Pablo Neira Ayuso (7):
  netfilter: move checksum indirection to struct nf_ipv6_ops
  netfilter: move checksum_partial indirection to struct nf_ipv6_ops
  netfilter: remove saveroute indirection in struct nf_afinfo
  netfilter: move route indirection to struct nf_ipv6_ops
  netfilter: move reroute indirection to struct nf_ipv6_ops
  netfilter: remove route_key_size field in struct nf_afinfo
  netfilter: remove struct nf_afinfo and its helper functions

 include/linux/netfilter.h               | 68 ++++---------------------
 include/linux/netfilter_ipv4.h          | 44 ++++++++++++++++
 include/linux/netfilter_ipv6.h          | 17 +++++++
 net/bridge/netfilter/nf_tables_bridge.c | 51 ++-----------------
 net/ipv4/netfilter.c                    | 62 ++++-------------------
 net/ipv6/netfilter.c                    | 44 +++-------------
 net/ipv6/netfilter/nft_fib_ipv6.c       | 12 ++---
 net/netfilter/Makefile                  |  2 +-
 net/netfilter/core.c                    | 22 --------
 net/netfilter/nf_conntrack_h323_main.c  | 30 +++++------
 net/netfilter/nf_queue.c                | 68 +++++++++++++++++++++----
 net/netfilter/nft_rt.c                  | 15 ++----
 net/netfilter/utils.c                   | 90 +++++++++++++++++++++++++++++++++
 net/netfilter/xt_TCPMSS.c               |  5 +-
 net/netfilter/xt_addrtype.c             | 15 +++---
 15 files changed, 273 insertions(+), 272 deletions(-)
 create mode 100644 net/netfilter/utils.c

-- 
2.11.0

