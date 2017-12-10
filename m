From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next,v2 0/7] handle NFPROTO_INET from core
Date: Sun, 10 Dec 2017 21:34:48 +0100
Message-ID: <20171210203455.11651-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45844 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752320AbdLJUfC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 10 Dec 2017 15:35:02 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1B15F1C4420
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Dec 2017 21:35:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F3ACDDA7F7
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Dec 2017 21:35:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CD07CDA7F7
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Dec 2017 21:34:58 +0100 (CET)
Received: from salvia.here (40.red-212-170-55.staticip.rima-tde.net [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 997C1426CC80
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Dec 2017 21:34:58 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

NFPROTO_INET only works for nf_tables, handle this pseudofamily from
the core itself by expanding one NFPROTO_INET hook in two hook
registrations, one for NFPROTO_IPV4 and another for NFPROTO_IPV6.

This removes quite a bit of ad-hoc infrastructure in nf_tables, so it
makes it less complex.

There's a final patch that also removes the family-specific hooks for
filter chains, now all hooks are already define in the chain type.

Pablo Neira Ayuso (7):
  netfilter: core: add nf_remove_net_hook
  netfilter: core: pass hook number, family and device to nf_find_hook_list()
  netfilter: core: pass family as parameter to nf_remove_net_hook()
  netfilter: core: support for NFPROTO_INET hook registration
  netfilter: nf_tables_inet: don't use multihook infrastructure anymore
  netfilter: nf_tables: remove multihook chains and families
  netfilter: nf_tables: remove hooks from family definition

 include/net/netfilter/nf_tables.h       |  13 +---
 include/net/netfilter/nf_tables_ipv4.h  |   2 -
 include/net/netfilter/nf_tables_ipv6.h  |   2 -
 net/bridge/netfilter/nf_tables_bridge.c |  15 +++--
 net/ipv4/netfilter/nf_tables_arp.c      |   9 ++-
 net/ipv4/netfilter/nf_tables_ipv4.c     |  18 +++---
 net/ipv6/netfilter/nf_tables_ipv6.c     |  18 +++---
 net/netfilter/core.c                    |  97 ++++++++++++++++++++----------
 net/netfilter/nf_tables_api.c           | 102 +++++++++++++-------------------
 net/netfilter/nf_tables_inet.c          |  69 +++++++++++++++++----
 net/netfilter/nf_tables_netdev.c        |   9 ++-
 net/netfilter/nft_compat.c              |   8 +--
 12 files changed, 202 insertions(+), 160 deletions(-)

-- 
2.11.0

