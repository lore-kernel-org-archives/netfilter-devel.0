From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/6] Netfilter fixes for net
Date: Thu,  1 Feb 2018 19:02:11 +0100
Message-ID: <20180201180217.24356-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57818 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752767AbeBASCo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Feb 2018 13:02:44 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F1BAA392E0A
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Feb 2018 19:02:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E1DEBDA729
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Feb 2018 19:02:42 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi David,

The following patchset contains Netfilter fixes for your net tree,
they are:

1) Fix OOM that syskaller triggers with ipt_replace.size = -1 and
   IPT_SO_SET_REPLACE socket option, from Dmitry Vyukov.

2) Check for too long extension name in xt_request_find_{match|target}
   that result in out-of-bound reads, from Eric Dumazet.

3) Fix memory exhaustion bug in ipset hash:*net* types when adding ranges
   that look like x.x.x.x-255.255.255.255, from Jozsef Kadlecsik.

4) Fix pointer leaks to userspace in x_tables, from Dmitry Vyukov.

5) Insufficient sanity checks in clusterip_tg_check(), also from Dmitry.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks!

P.S: Another batch is following up soon, there are more fixes cooking on
     the mailing list.

----------------------------------------------------------------

The following changes since commit d1616f07e8f1a4a490d1791316d4a68906b284aa:

  net: fec: free/restore resource in related probe error pathes (2018-01-05 11:19:11 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 3f34cfae1238848fd53f25e5c8fd59da57901f4b:

  netfilter: on sockopt() acquire sock lock only in the required scope (2018-01-31 16:37:47 +0100)

----------------------------------------------------------------
Dmitry Vyukov (3):
      netfilter: x_tables: fix int overflow in xt_alloc_table_info()
      netfilter: x_tables: fix pointer leaks to userspace
      netfilter: ipt_CLUSTERIP: fix out-of-bounds accesses in clusterip_tg_check()

Eric Dumazet (1):
      netfilter: x_tables: avoid out-of-bounds reads in xt_request_find_{match|target}

Jozsef Kadlecsik (1):
      netfilter: ipset: Fix wraparound in hash:*net* types

Paolo Abeni (1):
      netfilter: on sockopt() acquire sock lock only in the required scope

 net/ipv4/ip_sockglue.c                         | 14 +++--------
 net/ipv4/netfilter/ipt_CLUSTERIP.c             | 16 +++++++++---
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |  6 ++++-
 net/ipv6/ipv6_sockglue.c                       | 17 ++++---------
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c | 18 ++++++++-----
 net/netfilter/ipset/ip_set_hash_ipportnet.c    | 26 +++++++++----------
 net/netfilter/ipset/ip_set_hash_net.c          |  9 +++----
 net/netfilter/ipset/ip_set_hash_netiface.c     |  9 +++----
 net/netfilter/ipset/ip_set_hash_netnet.c       | 28 ++++++++++-----------
 net/netfilter/ipset/ip_set_hash_netport.c      | 19 +++++++-------
 net/netfilter/ipset/ip_set_hash_netportnet.c   | 35 +++++++++++++-------------
 net/netfilter/x_tables.c                       |  9 +++++--
 net/netfilter/xt_IDLETIMER.c                   |  1 +
 net/netfilter/xt_LED.c                         |  1 +
 net/netfilter/xt_limit.c                       |  3 +--
 net/netfilter/xt_nfacct.c                      |  1 +
 net/netfilter/xt_statistic.c                   |  1 +
 17 files changed, 114 insertions(+), 99 deletions(-)
