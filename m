From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 0/5] promote NFPROTO_INET as real family
Date: Wed, 22 Nov 2017 15:02:45 +0100
Message-ID: <20171122140250.14798-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45778 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751280AbdKVODd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2017 09:03:33 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 837701D94BC
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2017 15:03:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 256CCDA8FF
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2017 15:03:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BE2A9BAC2A
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2017 15:02:53 +0100 (CET)
Received: from salvia.here (129.166.216.87.static.jazztel.es [87.216.166.129])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 79DAC403DFA2
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2017 15:02:53 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

This is a patchset to handle NFPROTO_INET hook registration from the
Netfilter core, as we discussed during the NFWS in Faro, Portugal [1].
>From the hook path, your code just needs to check for state->pf to know
if this either IPv4 or IPv6 traffic, alternatively skb->protocol could
be used for this purpose too.

This is removing a bit of complexity / ad-hoc code for the nf_tables
codebase to handle this family, just to save one single branch in the
packet path. And after this patch, NFPROTO_INET is not a pseudo-family
anymore.

This patchset applies on top of Florian's netfilter: reduce hook sizes in
struct net series.

[1] https://workshop.netfilter.org/2017/wiki/images/4/48/Nf-nfproto-inet.pdf

Pablo Neira Ayuso (5):
  netfilter: add nf_remove_net_hook
  netfilter: pass hook number and family as parameter to nf_find_hook_list()
  netfilter: handle NFPROTO_INET family hook registration from core
  netfilter: nf_tables_inet: don't use multihook infrastructure anymore
  netfilter: nf_tables: remove multihook chains and families

 include/net/netfilter/nf_tables.h       |  9 +--
 include/net/netfilter/nf_tables_ipv4.h  |  2 -
 include/net/netfilter/nf_tables_ipv6.h  |  2 -
 net/bridge/netfilter/nf_tables_bridge.c |  1 -
 net/ipv4/netfilter/nf_tables_arp.c      |  1 -
 net/ipv4/netfilter/nf_tables_ipv4.c     |  4 +-
 net/ipv6/netfilter/nf_tables_ipv6.c     |  4 +-
 net/netfilter/core.c                    | 99 ++++++++++++++++++++++++---------
 net/netfilter/nf_tables_api.c           | 97 +++++++++++++-------------------
 net/netfilter/nf_tables_inet.c          | 65 ++++++++++++++++++----
 net/netfilter/nf_tables_netdev.c        |  3 +-
 net/netfilter/nft_compat.c              |  8 +--
 12 files changed, 175 insertions(+), 120 deletions(-)

-- 
2.11.0

