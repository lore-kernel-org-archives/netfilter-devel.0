From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 0/4] ipset patches for nf-next
Date: Fri, 21 Sep 2012 22:49:42 +0200
Message-ID: <1348260582-16565-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:34357 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757856Ab2IUUto (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Sep 2012 16:49:44 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Here follows the ipset patches against your nf-next tree: some cleanup
and new features. (These patches depend on the bugfixes against the stable
tree.) You can pull the changes from

git://blackhole.kfki.hu/nf-next master

Best regards,
Jozsef

Jozsef Kadlecsik (4):
  netfilter: ipset: Add /0 network support to hash:net,iface type
  netfilter: ipset: Include supported revisions in module description
  netfilter: ipset: Coding style fixes
  netfilter: ipset: Support to match elements marked with "nomatch"

 include/linux/netfilter/ipset/ip_set.h       |   15 +++++-
 include/linux/netfilter/ipset/ip_set_ahash.h |    2 +-
 net/netfilter/ipset/ip_set_bitmap_ip.c       |    9 +++-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c    |   13 +++--
 net/netfilter/ipset/ip_set_bitmap_port.c     |    9 +++-
 net/netfilter/ipset/ip_set_core.c            |   15 +++++-
 net/netfilter/ipset/ip_set_hash_ip.c         |    9 +++-
 net/netfilter/ipset/ip_set_hash_ipport.c     |    9 +++-
 net/netfilter/ipset/ip_set_hash_ipportip.c   |    9 +++-
 net/netfilter/ipset/ip_set_hash_ipportnet.c  |   24 ++++++----
 net/netfilter/ipset/ip_set_hash_net.c        |   21 +++++----
 net/netfilter/ipset/ip_set_hash_netiface.c   |   62 +++++++++++++------------
 net/netfilter/ipset/ip_set_hash_netport.c    |   23 +++++----
 net/netfilter/ipset/ip_set_list_set.c        |    9 +++-
 net/netfilter/xt_set.c                       |   22 +++++++++
 15 files changed, 163 insertions(+), 88 deletions(-)

