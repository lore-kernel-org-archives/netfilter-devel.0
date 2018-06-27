From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/6] Netfilter fixes for net
Date: Wed, 27 Jun 2018 17:22:17 +0200
Message-ID: <20180627152223.3633-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi David,

The following patchset contains Netfilter fixes for your net tree:

1) Missing netlink attribute validation in nf_queue, uncovered by KASAN,
   from Eric Dumazet.

2) Use pointer to sysctl table, save us 192 bytes of memory per netns.
   Also from Eric.

3) Possible use-after-free when removing conntrack helper modules due
   to missing synchronize RCU call. From Taehee Yoo.

4) Fix corner case in systcl writes to nf_log that lead to appending
   data to uninitialized buffer, from Jann Horn.

5) Jann Horn says we may indefinitely block other users of nf_log_mutex
   if a userspace access in proc_dostring() blocked e.g. due to a
   userfaultfd.

6) Fix garbage collection race for unconfirmed conntrack entries,
   from Florian Westphal.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 7e85dc8cb35abf16455f1511f0670b57c1a84608:

  net_sched: blackhole: tell upper qdisc about dropped packets (2018-06-17 08:42:33 +0900)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to b36e4523d4d56e2595e28f16f6ccf1cd6a9fc452:

  netfilter: nf_conncount: fix garbage collection confirm race (2018-06-26 18:28:57 +0200)

----------------------------------------------------------------
Eric Dumazet (2):
      netfilter: nf_queue: augment nfqa_cfg_policy
      netfilter: ipv6: nf_defrag: reduce struct net memory waste

Florian Westphal (1):
      netfilter: nf_conncount: fix garbage collection confirm race

Gao Feng (1):
      netfilter: nf_ct_helper: Fix possible panic after nf_conntrack_helper_unregister

Jann Horn (2):
      netfilter: nf_log: fix uninit read in nf_log_proc_dostring
      netfilter: nf_log: don't hold nf_log_mutex during user access

 include/net/net_namespace.h             |  1 +
 include/net/netns/ipv6.h                |  1 -
 net/ipv6/netfilter/nf_conntrack_reasm.c |  6 ++--
 net/netfilter/nf_conncount.c            | 52 +++++++++++++++++++++++++++++----
 net/netfilter/nf_conntrack_helper.c     |  5 ++++
 net/netfilter/nf_log.c                  | 13 +++++++--
 net/netfilter/nfnetlink_queue.c         |  3 ++
 7 files changed, 69 insertions(+), 12 deletions(-)
