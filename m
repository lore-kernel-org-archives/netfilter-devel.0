From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next,v3 0/7] get rid of struct nf_afinfo
Date: Thu, 21 Dec 2017 00:12:42 +0100
Message-ID: <20171220231249.10599-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58442 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751955AbdLTXM4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Dec 2017 18:12:56 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8618EEBACC
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Dec 2017 00:12:55 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 76B8034D3
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Dec 2017 00:12:55 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7912134D6
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Dec 2017 00:12:53 +0100 (CET)
Received: from salvia.here (40.red-212-170-55.staticip.rima-tde.net [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 6286A4265A2F
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Dec 2017 00:12:53 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch gets rid of the struct nf_afinfo abstraction.

This adds an innecessary indirection for IPv4 since it can be replaced
by direct calls.

And the IPv6 specific functions can be store in struct nf_ipv6_ops which
is there to avoid IPv6 module autoload due to explicit symbol
dependencies.

Previous patchset version was flawed with CONFIG_IPV6=m.

Pablo Neira Ayuso (7):
  netfilter: move checksum indirection to struct nf_ipv6_ops
  netfilter: move checksum_partial indirection to struct nf_ipv6_ops
  netfilter: remove saveroute indirection in struct nf_afinfo
  netfilter: move route indirection to struct nf_ipv6_ops
  netfilter: move reroute indirection to struct nf_ipv6_ops
  netfilter: remove route_key_size field in struct nf_afinfo
  netfilter: core: remove struct nf_afinfo and its helper functions

 include/linux/netfilter.h               | 68 ++++---------------------
 include/linux/netfilter_ipv4.h          | 16 ++++++
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
 15 files changed, 245 insertions(+), 272 deletions(-)
 create mode 100644 net/netfilter/utils.c

-- 
2.11.0

