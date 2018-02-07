From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 00/11] Netfilter fixes for net
Date: Wed,  7 Feb 2018 18:42:18 +0100
Message-ID: <20180207174229.4098-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46964 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754141AbeBGRmg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Feb 2018 12:42:36 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3CA113066A2
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Feb 2018 18:42:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2A293DA2CC
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Feb 2018 18:42:35 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi David,

The following patchset contains Netfilter fixes for you net tree, they
are:

1) Restore __GFP_NORETRY in xt_table allocations to mitigate effects of
   large memory allocation requests, from Michal Hocko.

2) Release IPv6 fragment queue in case of error in fragmentation header,
   this is a follow up to amend patch 83f1999caeb1, from Subash Abhinov
   Kasiviswanathan.

3) Flowtable infrastructure depends on NETFILTER_INGRESS as it registers
   a hook for each flowtable, reported by John Crispin.

4) Missing initialization of info->priv in xt_cgroup version 1, from
   Cong Wang.

5) Give a chance to garbage collector to run after scheduling flowtable
   cleanup.

6) Releasing flowtable content on nft_flow_offload module removal is
   not required at all, there is not dependencies between this module
   and flowtables, remove it.

7) Fix missing xt_rateest_mutex grabbing for hash insertions, also from
   Cong Wang.

8) Move nf_flow_table_cleanup() routine to flowtable core, this patch is
   a dependency for the next patch in this list.

9) Flowtable resources are not properly released on removal from the
   control plane. Fix this resource leak by scheduling removal of all
   entries and explicit call to the garbage collector.

10) nf_ct_nat_offset() declaration is dead code, this function prototype
    is not used anywhere, remove it. From Taehee Yoo.

11) Fix another flowtable resource leak on entry insertion failures,
    this patch also fixes a possible use-after-free. Patch from Felix
    Fietkau.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks!

P.S: Again more fixes cooking on netfilter-devel@vger.kernel.org, so
     another round is likely coming up soon.

----------------------------------------------------------------

The following changes since commit 743ffffefac1c670c6618742c923f6275d819604:

  net: pxa168_eth: add netconsole support (2018-02-01 14:58:37 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 0ff90b6c20340e57616a51ae1a1bf18156d6638a:

  netfilter: nf_flow_offload: fix use-after-free and a resource leak (2018-02-07 11:55:52 +0100)

----------------------------------------------------------------
Cong Wang (2):
      netfilter: xt_cgroup: initialize info->priv in cgroup_mt_check_v1()
      netfilter: xt_RATEEST: acquire xt_rateest_mutex for hash insert

Felix Fietkau (1):
      netfilter: nf_flow_offload: fix use-after-free and a resource leak

Michal Hocko (1):
      netfilter: x_tables: make allocation less aggressive

Pablo Neira Ayuso (5):
      netfilter: flowtable infrastructure depends on NETFILTER_INGRESS
      netfilter: nft_flow_offload: wait for garbage collector to run after cleanup
      netfilter: nft_flow_offload: no need to flush entries on module removal
      netfilter: nft_flow_offload: move flowtable cleanup routines to nf_flow_table
      netfilter: nf_tables: fix flowtable free

Subash Abhinov Kasiviswanathan (1):
      netfilter: ipv6: nf_defrag: Kill frag queue on RFC2460 failure

Taehee Yoo (1):
      netfilter: remove useless prototype

 include/net/netfilter/nf_conntrack.h    |  5 ---
 include/net/netfilter/nf_flow_table.h   |  6 ++-
 net/ipv4/netfilter/Kconfig              |  3 +-
 net/ipv4/netfilter/nf_flow_table_ipv4.c |  1 +
 net/ipv6/netfilter/Kconfig              |  3 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c |  1 +
 net/ipv6/netfilter/nf_flow_table_ipv6.c |  1 +
 net/netfilter/Kconfig                   |  8 ++--
 net/netfilter/nf_flow_table.c           | 76 ++++++++++++++++++++++-----------
 net/netfilter/nf_flow_table_inet.c      |  1 +
 net/netfilter/nf_tables_api.c           | 17 +++-----
 net/netfilter/nft_flow_offload.c        | 24 +----------
 net/netfilter/x_tables.c                |  7 ++-
 net/netfilter/xt_RATEEST.c              | 22 +++++++---
 net/netfilter/xt_cgroup.c               |  1 +
 15 files changed, 97 insertions(+), 79 deletions(-)
