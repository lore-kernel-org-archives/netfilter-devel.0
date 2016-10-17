From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 00/10, nf-next] Netfilter core updates
Date: Mon, 17 Oct 2016 13:10:26 +0200
Message-ID: <1476702636-3303-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43174 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932790AbcJQLKw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Oct 2016 07:10:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 02EF21324C7
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 13:10:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E40F57842E
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 13:10:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8ECCE78440
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 13:10:44 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is second round of patches to improve Netfilter hooks performance,
following several of the ideas that we discussed during NetDev 1.2. This
patchset implements the following:

1) Deprecate NF_STOP, as this is only used by br_netfilter.

2) Remove threshold handling, this is also only used by br_netfilter
   too.

3) Place nf_state_hook pointer into xt_action_param structure, so
   this structure fits into one single cacheline according to pahole.
   This also implicit affects nftables since it also relies on the
   xt_action_param structure.

4) Move state->hook_entries into nf_queue entry. The hook_entries
   pointer is only required by nf_queue(), so we can store this in the
   queue entry instead.

5) Handle queue bypass flag from nf_queue(), to keep this little
   nf_queue specific handling away from the core path.

6) Merge nf_iterate() into nf_hook_slow() that results in a much more
   simple and readable function.

I have kept back the patches that move NF_QUEUE handling away from the
core and nf_hook_slow() inlining, I would like to explore other options
before following this path.

Using this simple drop-all packets ruleset from ingress:

	nft add table netdev x
	nft add chain netdev x y { type filter hook ingress device eth0 priority 0\; }
	nft add rule netdev x y drop

I generated traffic through Jesper Brouer's
samples/pktgen/pktgen_bench_xmit_mode_netif_receive.sh script using -i
option. perf report shows nf_tables calls in its top 10:

    17.30%  kpktgend_0   [nf_tables]            [k] nft_do_chain
    15.75%  kpktgend_0   [kernel.vmlinux]       [k] __netif_receive_skb_core
    10.39%  kpktgend_0   [nf_tables_netdev]     [k] nft_do_chain_netdev

I'm measuring here an improvement of ~15% in performance with this
patchset, so we got +2.5Mpps more. I have used my old laptop Intel(R)
Core(TM) i5-3320M CPU @ 2.60GHz 4-cores.

Let me know if you have any comment, otherwise I'll place this in the
nf-next tree so we can follow up working on top of these.

Thanks!

Pablo Neira Ayuso (10):
  netfilter: get rid of useless debugging from core
  netfilter: remove comments that predate rcu days
  netfilter: kill NF_HOOK_THRESH() and state->tresh
  netfilter: deprecate NF_STOP
  netfilter: x_tables: move hook state into xt_action_param structure
  netfilter: nf_tables: use hook state from xt_action_param structure
  netfilter: use switch() to handle verdict cases from nf_hook_slow()
  netfilter: remove hook_entries field from nf_hook_state
  netfilter: handle queue bypass flag from nf_queue
  netfilter: merge nf_iterate() into nf_hook_slow()

 include/linux/netfilter.h                  | 58 ++++++-------------
 include/linux/netfilter/x_tables.h         | 48 ++++++++++++----
 include/linux/netfilter_ingress.h          |  4 +-
 include/net/netfilter/nf_queue.h           |  1 +
 include/net/netfilter/nf_tables.h          | 36 ++++++++----
 include/uapi/linux/netfilter.h             |  2 +-
 net/bridge/br_netfilter_hooks.c            | 16 +++---
 net/bridge/netfilter/ebt_arpreply.c        |  3 +-
 net/bridge/netfilter/ebt_log.c             | 11 ++--
 net/bridge/netfilter/ebt_nflog.c           |  6 +-
 net/bridge/netfilter/ebt_redirect.c        |  6 +-
 net/bridge/netfilter/ebtable_broute.c      |  2 +-
 net/bridge/netfilter/ebtables.c            |  6 +-
 net/bridge/netfilter/nft_meta_bridge.c     |  2 +-
 net/bridge/netfilter/nft_reject_bridge.c   | 30 ++++++----
 net/ipv4/netfilter/arp_tables.c            |  6 +-
 net/ipv4/netfilter/ip_tables.c             |  6 +-
 net/ipv4/netfilter/ipt_MASQUERADE.c        |  3 +-
 net/ipv4/netfilter/ipt_REJECT.c            |  4 +-
 net/ipv4/netfilter/ipt_SYNPROXY.c          |  4 +-
 net/ipv4/netfilter/ipt_rpfilter.c          |  2 +-
 net/ipv4/netfilter/nft_dup_ipv4.c          |  2 +-
 net/ipv4/netfilter/nft_masq_ipv4.c         |  4 +-
 net/ipv4/netfilter/nft_redir_ipv4.c        |  3 +-
 net/ipv4/netfilter/nft_reject_ipv4.c       |  4 +-
 net/ipv6/netfilter/ip6_tables.c            |  6 +-
 net/ipv6/netfilter/ip6t_MASQUERADE.c       |  2 +-
 net/ipv6/netfilter/ip6t_REJECT.c           | 23 +++++---
 net/ipv6/netfilter/ip6t_SYNPROXY.c         |  4 +-
 net/ipv6/netfilter/ip6t_rpfilter.c         |  3 +-
 net/ipv6/netfilter/nft_dup_ipv6.c          |  2 +-
 net/ipv6/netfilter/nft_masq_ipv6.c         |  3 +-
 net/ipv6/netfilter/nft_redir_ipv6.c        |  3 +-
 net/ipv6/netfilter/nft_reject_ipv6.c       |  6 +-
 net/netfilter/core.c                       | 92 ++++++++++--------------------
 net/netfilter/ipset/ip_set_core.c          |  6 +-
 net/netfilter/ipset/ip_set_hash_netiface.c |  2 +-
 net/netfilter/nf_dup_netdev.c              |  2 +-
 net/netfilter/nf_internals.h               |  9 +--
 net/netfilter/nf_queue.c                   | 70 +++++++++++++++--------
 net/netfilter/nf_tables_core.c             | 10 ++--
 net/netfilter/nf_tables_trace.c            |  8 +--
 net/netfilter/nfnetlink_queue.c            |  2 +-
 net/netfilter/nft_log.c                    |  5 +-
 net/netfilter/nft_lookup.c                 |  5 +-
 net/netfilter/nft_meta.c                   |  6 +-
 net/netfilter/nft_queue.c                  |  2 +-
 net/netfilter/nft_reject_inet.c            | 18 +++---
 net/netfilter/xt_AUDIT.c                   | 10 ++--
 net/netfilter/xt_LOG.c                     |  6 +-
 net/netfilter/xt_NETMAP.c                  | 20 +++----
 net/netfilter/xt_NFLOG.c                   |  6 +-
 net/netfilter/xt_NFQUEUE.c                 |  4 +-
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
 net/sched/act_ipt.c                        | 12 ++--
 net/sched/em_ipset.c                       | 17 +++---
 74 files changed, 386 insertions(+), 375 deletions(-)

-- 
2.1.4

