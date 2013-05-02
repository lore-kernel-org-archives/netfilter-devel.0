From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 0/6] ipset updates for nf-next
Date: Thu,  2 May 2013 11:37:16 +0200
Message-ID: <1367487442-3571-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:50852 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756918Ab3EBJhY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 May 2013 05:37:24 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Here follows the ipset related updates for nf-next: sparse warning fixes,
cleanups and small corrections. Please consider applying them.

Best regards,
Jozsef

The following changes since commit eee1d5a14780b9391ec51f3feaf4cffb521ddbb1:
  Simon Horman (1):
        sctp: Correct type and usage of sctp_end_cksum()

are available in the git repository at:

  git://blackhole.kfki.hu/nf-next master

Jozsef Kadlecsik (6):
      netfilter: ipset: Don't call ip_nest_end needlessly in the error path
      netfilter: ipset: Sparse warning about shadowed variable fixed
      netfilter: ipset: Fix sparse warnings due to missing rcu annotations
      netfilter: ipset: Rename simple macro names to avoid namespace issues.
      netfilter: ipset: Fix "may be used uninitialized" warnings
      netfilter: ipset: Use fix sized type for timeout in the extension part

 include/linux/netfilter/ipset/ip_set.h      |    5 +-
 net/netfilter/ipset/ip_set_bitmap_gen.h     |   49 +++---
 net/netfilter/ipset/ip_set_bitmap_ip.c      |   14 +-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c   |   14 +-
 net/netfilter/ipset/ip_set_bitmap_port.c    |   10 +-
 net/netfilter/ipset/ip_set_hash_gen.h       |  234 +++++++++++++++------------
 net/netfilter/ipset/ip_set_hash_ip.c        |   12 +-
 net/netfilter/ipset/ip_set_hash_ipport.c    |   14 +-
 net/netfilter/ipset/ip_set_hash_ipportip.c  |   14 +-
 net/netfilter/ipset/ip_set_hash_ipportnet.c |   22 ++--
 net/netfilter/ipset/ip_set_hash_net.c       |   16 +-
 net/netfilter/ipset/ip_set_hash_netiface.c  |   16 +-
 net/netfilter/ipset/ip_set_hash_netport.c   |   18 +-
 net/netfilter/ipset/ip_set_list_set.c       |   12 +-
 14 files changed, 240 insertions(+), 210 deletions(-)
