From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 0/3] ipset patches for nf-next
Date: Fri, 18 Oct 2013 11:41:54 +0200
Message-ID: <1382089317-24311-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:33613 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675Ab3JRJmA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Oct 2013 05:42:00 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Here follows three small patches for nf-next:

- Instead of cb->data, use callback dump args only and introduce
  symbolic names to access the arg members.
- We have to use dev_net() instead of the direct access to ->nd_net,
  otherwise compilation fails if NET_NS is not enabled. Reported by
  the kbuild test robot.
- Unnamed unions should be possible to be initialized directly, but
  unfortunately it's not so and can lead to compile time error.
  Reported by Husnu Demir.

All patches are from me.

Best regards,
Jozsef

The following changes since commit d86946d2c5b4e519ffe435c2deeb2c9436ceb04f:

  netfilter: ipt_CLUSTERIP: use proper net namespace to operate CLUSTERIP (2013-10-17 10:48:47 +0200)

are available in the git repository at:

  git://blackhole.kfki.hu/nf-next master

for you to fetch changes up to e190952746fb81143945d2397f74aa7ae773bc82:

  netfilter: ipset: The unnamed union initialization may lead to compilation error (2013-10-18 11:38:53 +0200)

----------------------------------------------------------------
Jozsef Kadlecsik (3):
      netfilter: ipset: Use netlink callback dump args only
      net: sched: Use dev_net() instead of the direct access to ->nd_net
      netfilter: ipset: The unnamed union initialization may lead to compilation error

 include/linux/netfilter/ipset/ip_set.h       |   10 ++++
 net/netfilter/ipset/ip_set_bitmap_gen.h      |   11 ++--
 net/netfilter/ipset/ip_set_core.c            |   70 +++++++++++++-------------
 net/netfilter/ipset/ip_set_hash_gen.h        |   20 ++++----
 net/netfilter/ipset/ip_set_hash_netnet.c     |   22 ++++----
 net/netfilter/ipset/ip_set_hash_netportnet.c |   22 ++++----
 net/netfilter/ipset/ip_set_list_set.c        |   11 ++--
 net/sched/em_ipset.c                         |    4 +-
 8 files changed, 90 insertions(+), 80 deletions(-)
