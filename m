From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next RFC 0/8] simplify nf_tables family and filter chain infra
Date: Sun, 31 Dec 2017 00:13:40 +0100
Message-ID: <20171230231348.5497-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39202 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750947AbdL3XNz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Dec 2017 18:13:55 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2444DC51A9
        for <netfilter-devel@vger.kernel.org>; Sun, 31 Dec 2017 00:13:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1360D71CF
        for <netfilter-devel@vger.kernel.org>; Sun, 31 Dec 2017 00:13:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A20E871CF
        for <netfilter-devel@vger.kernel.org>; Sun, 31 Dec 2017 00:13:51 +0100 (CET)
Received: from salvia.here (40.red-212-170-55.staticip.rima-tde.net [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 8561C4265A32
        for <netfilter-devel@vger.kernel.org>; Sun, 31 Dec 2017 00:13:51 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

This patchset simplifies the nf_tables infrastructure by removing the
family abstraction. As a side effect, nf_tables netns support also
consumes 48 bytes less in x86_64 and its logic becomes simpler.

Last patch consolidate all filter chain definitions.

Note that this patchset depends on removal of the raw socket check [1].

Compiled tested only, will send a new iteration after a more accurate
review and test.

[1] http://patchwork.ozlabs.org/patch/854171/

Pablo Neira Ayuso (8):
  netfilter: nf_tables: remove nhooks field from struct nft_af_info
  netfilter: nf_tables: remove flag field from struct nft_af_info
  netfilter: nf_tables: no need for struct nft_af_info to enable/disable table
  netfilter: nf_tables: remove struct nft_af_info parameter in nf_tables_chain_type_lookup()
  netfilter: nf_tables: add single table list for all families
  netfilter: nf_tables: get rid of pernet families
  netfilter: nf_tables: get rid of struct nft_af_info abstraction
  netfilter: nf_tables: consolidate filter chain definitions

 include/net/netfilter/nf_tables.h       |  40 +-
 include/net/netns/nftables.h            |   7 +-
 net/bridge/netfilter/Makefile           |   1 -
 net/bridge/netfilter/nf_tables_bridge.c | 129 ------
 net/ipv4/netfilter/Makefile             |   2 -
 net/ipv4/netfilter/nf_tables_arp.c      |  49 +--
 net/ipv4/netfilter/nf_tables_ipv4.c     | 112 ------
 net/ipv6/netfilter/Makefile             |   1 -
 net/ipv6/netfilter/nf_tables_ipv6.c     | 110 ------
 net/netfilter/Makefile                  |   5 +-
 net/netfilter/nf_tables_api.c           | 680 ++++++++++++--------------------
 net/netfilter/nf_tables_inet.c          | 141 -------
 net/netfilter/nf_tables_netdev.c        | 186 ---------
 net/netfilter/nft_chain_filter.c        | 294 ++++++++++++++
 14 files changed, 565 insertions(+), 1192 deletions(-)
 delete mode 100644 net/bridge/netfilter/nf_tables_bridge.c
 delete mode 100644 net/ipv4/netfilter/nf_tables_ipv4.c
 delete mode 100644 net/ipv6/netfilter/nf_tables_ipv6.c
 delete mode 100644 net/netfilter/nf_tables_inet.c
 delete mode 100644 net/netfilter/nf_tables_netdev.c
 create mode 100644 net/netfilter/nft_chain_filter.c

-- 
2.11.0

