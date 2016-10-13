From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next,RFC 00/10] Netfilter core updates
Date: Thu, 13 Oct 2016 14:02:41 +0200
Message-ID: <1476360171-2991-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43186 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754594AbcJMMLK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Oct 2016 08:11:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 073CD9B801
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Oct 2016 14:03:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EA86120904
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Oct 2016 14:03:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 83E4820C65
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Oct 2016 14:03:00 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

This is a quick RFC that has passed just very basic testing here. This
patchset achieves what it has been discussed during NetDev 1.2:

1) Deprecate NF_STOP, as this is only used by br_netfilter.

2) Remove threshold handling, this is also only used by br_netfilter
   too.

3) Move NF_QUEUE handling away from the core. Adds a new nf_queue()
   function that must be explicitly called to queue packets to userspace.
   This function returns the verdict that is passed down to the core,
   basically NF_DROP if queue is full, NF_ACCEPT if bypass is enabled
   and NF_STOLEN if packet is succesfully enqueued to userspace.

4) Merge nf_iterate() into nf_hook_slow(), then inline the resulting
   function and rename it to nf_hook_iterate().

This patchset also modifies the pktinfo and xt_action_param structures
(that keep context around while performing packet processing) to store
the netfilter hook state. This change was required by the new NF_QUEUE
handling. As side effect, according to pahole, these two now fit into
one single cacheline after this update.

Thanks!

Pablo Neira Ayuso (10):
  netfilter: get rid of useless debugging from core
  netfilter: remove comments that predate rcu days
  netfilter: bridge: kill NF_HOOK_THRESH() and state->tresh
  netfilter: deprecate NF_STOP
  netfilter: x_tables: move hook state into xt_action_param structure
  netfilter: nf_tables: use hook state from xt_action_param structure
  netfilter: use switch() to handle verdict cases from nf_hook_slow()
  netfilter: move NF_QUEUE handling away from core
  netfilter: merge nf_iterate() into nf_hook_slow()
  netfilter: inline nf_hook_slow() and rename it to nf_hook_iterate()

 include/linux/netfilter.h                  | 91 +++++++++++++++++-------------
 include/linux/netfilter/x_tables.h         | 48 ++++++++++++----
 include/linux/netfilter_ingress.h          |  4 +-
 include/net/netfilter/nf_queue.h           |  3 +
 include/net/netfilter/nf_tables.h          | 36 ++++++++----
 include/uapi/linux/netfilter.h             |  2 +-
 net/bridge/br_netfilter_hooks.c            | 18 +++---
 net/bridge/netfilter/ebt_arpreply.c        |  3 +-
 net/bridge/netfilter/ebt_log.c             | 11 ++--
 net/bridge/netfilter/ebt_nflog.c           |  6 +-
 net/bridge/netfilter/ebt_redirect.c        |  6 +-
 net/bridge/netfilter/ebtable_broute.c      |  2 +-
 net/bridge/netfilter/ebtables.c            |  6 +-
 net/bridge/netfilter/nft_meta_bridge.c     |  2 +-
 net/bridge/netfilter/nft_reject_bridge.c   | 30 ++++++----
 net/ipv4/netfilter/arp_tables.c            |  7 +--
 net/ipv4/netfilter/ip_tables.c             | 10 ++--
 net/ipv4/netfilter/ipt_MASQUERADE.c        |  3 +-
 net/ipv4/netfilter/ipt_REJECT.c            |  4 +-
 net/ipv4/netfilter/ipt_SYNPROXY.c          |  4 +-
 net/ipv4/netfilter/ipt_rpfilter.c          |  2 +-
 net/ipv4/netfilter/nft_dup_ipv4.c          |  2 +-
 net/ipv4/netfilter/nft_masq_ipv4.c         |  4 +-
 net/ipv4/netfilter/nft_redir_ipv4.c        |  3 +-
 net/ipv4/netfilter/nft_reject_ipv4.c       |  4 +-
 net/ipv6/netfilter/ip6_tables.c            | 10 ++--
 net/ipv6/netfilter/ip6t_MASQUERADE.c       |  2 +-
 net/ipv6/netfilter/ip6t_REJECT.c           | 23 +++++---
 net/ipv6/netfilter/ip6t_SYNPROXY.c         |  4 +-
 net/ipv6/netfilter/ip6t_rpfilter.c         |  3 +-
 net/ipv6/netfilter/nft_dup_ipv6.c          |  2 +-
 net/ipv6/netfilter/nft_masq_ipv6.c         |  3 +-
 net/ipv6/netfilter/nft_redir_ipv6.c        |  3 +-
 net/ipv6/netfilter/nft_reject_ipv6.c       |  6 +-
 net/netfilter/core.c                       | 75 ------------------------
 net/netfilter/ipset/ip_set_core.c          |  6 +-
 net/netfilter/ipset/ip_set_hash_netiface.c |  2 +-
 net/netfilter/nf_dup_netdev.c              |  2 +-
 net/netfilter/nf_internals.h               |  7 ---
 net/netfilter/nf_queue.c                   | 72 +++++++++++++++++------
 net/netfilter/nf_tables_api.c              |  3 +-
 net/netfilter/nf_tables_core.c             | 13 ++---
 net/netfilter/nf_tables_trace.c            |  8 +--
 net/netfilter/nft_log.c                    |  5 +-
 net/netfilter/nft_lookup.c                 |  5 +-
 net/netfilter/nft_meta.c                   |  6 +-
 net/netfilter/nft_queue.c                  |  8 +--
 net/netfilter/nft_reject_inet.c            | 18 +++---
 net/netfilter/xt_AUDIT.c                   | 10 ++--
 net/netfilter/xt_LOG.c                     |  6 +-
 net/netfilter/xt_NETMAP.c                  | 20 +++----
 net/netfilter/xt_NFLOG.c                   |  6 +-
 net/netfilter/xt_NFQUEUE.c                 | 33 +++++------
 net/netfilter/xt_REDIRECT.c                |  4 +-
 net/netfilter/xt_TCPMSS.c                  |  4 +-
 net/netfilter/xt_TEE.c                     |  4 +-
 net/netfilter/xt_TPROXY.c                  | 16 +++---
 net/netfilter/xt_addrtype.c                | 10 ++--
 net/netfilter/xt_cluster.c                 |  2 +-
 net/netfilter/xt_connlimit.c               |  8 +--
 net/netfilter/xt_conntrack.c               |  8 +--
 net/netfilter/xt_devgroup.c                |  4 +-
 net/netfilter/xt_dscp.c                    |  2 +-
 net/netfilter/xt_ipvs.c                    |  4 +-
 net/netfilter/xt_nfacct.c                  |  2 +-
 net/netfilter/xt_osf.c                     | 10 ++--
 net/netfilter/xt_owner.c                   |  2 +-
 net/netfilter/xt_pkttype.c                 |  4 +-
 net/netfilter/xt_policy.c                  |  4 +-
 net/netfilter/xt_recent.c                  | 10 ++--
 net/netfilter/xt_set.c                     | 26 ++++-----
 net/netfilter/xt_socket.c                  |  4 +-
 net/sched/act_ipt.c                        | 13 +++--
 net/sched/em_ipset.c                       | 18 +++---
 74 files changed, 430 insertions(+), 401 deletions(-)

-- 
2.1.4

