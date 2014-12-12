From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 0/8] ipset patches for nf-next, v3
Date: Fri, 12 Dec 2014 22:58:01 +0100
Message-ID: <1418421489-17411-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:40170 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725AbaLLV5I (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Dec 2014 16:57:08 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Please review and consider to apply the second part of the patches for
ipset:

- Fix sparse warning "cast to restricted __be32"
- Fix parallel resizing and listing of the same set: when adding elements
  and listing of the same set were executed parallel, listing could start
  to list the original set (before resizing) and continue with the new one.
- Styles warned by checkpatch.pl fixed
- Introduce RCU locking in the hash types. The patch was
  performance tested by Jesper Dangaard Brouer:

  Generator: sending 12.2Mpps (tx:12264083 pps)
  Drop performance in "raw" with ipset: 8Mpps
  Drop performance in "raw" with ipset with RCU-locking: 11.3Mpps
- Introduce RCU locking in the list type
- Introduce RCU locking in the bitmap types
- Introduce RCU locking instead of rwlock per set in the core
- Remove rbtree from hash:net,iface for RCU locking

You can pull the changes from

        git://blackhole.kfki.hu/nf-next master

Best regards,
Jozsef
============================================================================
The following changes since commit d6b00fec5dbbe976904b4d77e7d4f9493df5c2ec:

  macvlan: play well with ipvlan device (2014-12-09 16:10:06 -0500)

are available in the git repository at:

  git://blackhole.kfki.hu/nf-next master

for you to fetch changes up to 57a7e2fd6403f1dac986c045a453412a3cf7dd40:

  netfilter: ipset: Fix sparse warning (2014-12-12 13:21:59 +0100)

----------------------------------------------------------------
Jozsef Kadlecsik (8):
      netfilter: ipset: Remove rbtree from hash:net,iface in order to run under RCU
      netfilter: ipset: Prepare ipset core for RCU locking instead of rwlock per set
      netfilter: ipset: Introduce RCU locking in the bitmap types
      netfilter: ipset: Introduce RCU locking in the list type
      netfilter: ipset: Introduce RCU locking in the hash types
      netfilter: ipset: styles warned by checkpatch.pl fixed
      netfilter: ipset: Fix parallel resizing and listing of the same set
      netfilter: ipset: Fix sparse warning

 include/linux/netfilter/ipset/ip_set.h         |  21 +-
 include/linux/netfilter/ipset/ip_set_timeout.h |  27 +-
 net/netfilter/ipset/ip_set_bitmap_gen.h        |  20 +-
 net/netfilter/ipset/ip_set_bitmap_ip.c         |  10 +-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c      |   6 +-
 net/netfilter/ipset/ip_set_bitmap_port.c       |   7 +-
 net/netfilter/ipset/ip_set_core.c              | 179 +++----
 net/netfilter/ipset/ip_set_getport.c           |   3 +-
 net/netfilter/ipset/ip_set_hash_gen.h          | 661 +++++++++++++++----------
 net/netfilter/ipset/ip_set_hash_ip.c           |   5 +-
 net/netfilter/ipset/ip_set_hash_ipmark.c       |  14 +-
 net/netfilter/ipset/ip_set_hash_ipport.c       |  15 +-
 net/netfilter/ipset/ip_set_hash_ipportip.c     |  17 +-
 net/netfilter/ipset/ip_set_hash_ipportnet.c    |  20 +-
 net/netfilter/ipset/ip_set_hash_mac.c          |   3 +-
 net/netfilter/ipset/ip_set_hash_net.c          |   9 +-
 net/netfilter/ipset/ip_set_hash_netiface.c     | 175 ++-----
 net/netfilter/ipset/ip_set_hash_netnet.c       |  45 +-
 net/netfilter/ipset/ip_set_hash_netport.c      |  20 +-
 net/netfilter/ipset/ip_set_hash_netportnet.c   |  55 +-
 net/netfilter/ipset/ip_set_list_set.c          | 393 +++++++--------
 net/netfilter/ipset/pfxlen.c                   |  16 +-
 net/netfilter/xt_set.c                         |   7 +
 net/sched/em_ipset.c                           |   5 +-
 24 files changed, 896 insertions(+), 837 deletions(-)
