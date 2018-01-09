From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 0/7] nf_tables: remove struct nft_af_info
Date: Tue,  9 Jan 2018 19:07:50 +0100
Message-ID: <20180109180757.6104-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56226 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934735AbeAISIJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Jan 2018 13:08:09 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BAFA111ADC4
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Jan 2018 19:08:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AC83BDA856
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Jan 2018 19:08:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6D5FEDA843
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Jan 2018 19:08:03 +0100 (CET)
Received: from salvia.here (unknown [31.4.245.124])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 3DD854265A31
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Jan 2018 19:08:03 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a follow up after the RFC patchset posted in late December [1].

This patch gets rid of quite a bit of complexity by removing the family
layer and it saves us 64 bytes per netns. Families are basically
defining the default filter chain hooks, that can be placed in the
filter chain definition instead. Then, there is already a hook
validation field that is redundant these days and some fields that are
very much specific of NFPROTO_NETDEV that we can also remove.

Result is less code to maintain (~500 LOC), and hence more simple
infrastructure.

No functional changes after this patchset.

[1] https://marc.info/?l=netfilter-devel&m=151467563814063&w=2

Pablo Neira Ayuso (7):
  netfilter: nf_tables: remove nhooks field from struct nft_af_info
  netfilter: nf_tables: remove flag field from struct nft_af_info
  netfilter: nf_tables: no need for struct nft_af_info to enable/disable table
  netfilter: nf_tables: remove struct nft_af_info parameter in nf_tables_chain_type_lookup()
  netfilter: nf_tables: add single table list for all families
  netfilter: nf_tables: get rid of pernet families
  netfilter: nf_tables: get rid of struct nft_af_info abstraction

 include/net/netfilter/nf_tables.h       |  37 +-
 include/net/netns/nftables.h            |   8 +-
 net/bridge/netfilter/nf_tables_bridge.c |  54 +--
 net/ipv4/netfilter/nf_tables_arp.c      |  49 +-
 net/ipv4/netfilter/nf_tables_ipv4.c     |  49 +-
 net/ipv6/netfilter/nf_tables_ipv6.c     |  49 +-
 net/netfilter/nf_tables_api.c           | 787 ++++++++++++--------------------
 net/netfilter/nf_tables_inet.c          |  49 +-
 net/netfilter/nf_tables_netdev.c        |  70 +--
 net/netfilter/nft_compat.c              |  16 +-
 net/netfilter/nft_ct.c                  |  16 +-
 net/netfilter/nft_flow_offload.c        |   4 +-
 net/netfilter/nft_log.c                 |   4 +-
 net/netfilter/nft_masq.c                |   2 +-
 net/netfilter/nft_meta.c                |   4 +-
 net/netfilter/nft_nat.c                 |   2 +-
 net/netfilter/nft_redir.c               |   2 +-
 17 files changed, 348 insertions(+), 854 deletions(-)

-- 
2.11.0


