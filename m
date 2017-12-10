From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 0/7] get rid of struct nf_afinfo
Date: Sun, 10 Dec 2017 21:43:38 +0100
Message-ID: <20171210204345.13292-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47106 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751994AbdLJUnv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 10 Dec 2017 15:43:51 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5F819DA72B
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Dec 2017 21:43:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 504E6DA81E
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Dec 2017 21:43:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 384BADA793
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Dec 2017 21:43:48 +0100 (CET)
Received: from salvia.here (40.red-212-170-55.staticip.rima-tde.net [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 20260426CC80
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Dec 2017 21:43:48 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch gets rid of the struct nf_afinfo abstraction.

This level of indirection that this structure adds is unnecessary in
most cases, and it can be replaced by direct calls given that we only
need to support IPv4 and IPv6.

Pablo Neira Ayuso (7):
  netfilter: remove checksum indirection in struct nf_afinfo
  netfilter: remove checksum_partial indirection in struct nf_afinfo
  netfilter: remove saveroute indirection in struct nf_afinfo
  netfilter: remove route indirection in struct nf_afinfo
  netfilter: remove reroute indirection in struct nf_afinfo
  netfilter: remove route_key_size field in struct nf_afinfo
  netfilter: core: remove struct nf_afinfo and its helper functions

 include/linux/netfilter.h               | 66 ++++-------------------------
 include/linux/netfilter_ipv4.h          | 18 ++++++++
 include/linux/netfilter_ipv6.h          | 49 +++++++++++++++++++++-
 net/bridge/netfilter/nf_tables_bridge.c | 51 ++---------------------
 net/ipv4/netfilter.c                    | 48 +++++-----------------
 net/ipv6/netfilter.c                    | 44 +++++---------------
 net/ipv6/netfilter/nft_fib_ipv6.c       |  9 +---
 net/netfilter/Makefile                  |  2 +-
 net/netfilter/core.c                    | 22 ----------
 net/netfilter/nf_conntrack_h323_main.c  | 23 ++++-------
 net/netfilter/nf_queue.c                | 28 ++++++++-----
 net/netfilter/nft_rt.c                  | 17 ++++----
 net/netfilter/utils.c                   | 73 +++++++++++++++++++++++++++++++++
 net/netfilter/xt_TCPMSS.c               |  6 +--
 net/netfilter/xt_addrtype.c             | 22 ++++------
 15 files changed, 217 insertions(+), 261 deletions(-)
 create mode 100644 net/netfilter/utils.c

-- 
2.11.0

