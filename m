From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 0/1] ipset patch for nf
Date: Wed, 16 Mar 2016 22:02:29 +0100
Message-ID: <1458162150-13601-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:42301 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755473AbcCPVBn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Mar 2016 17:01:43 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Please apply the next patch against the nf tree:

- There was a race condition between parallel save/swap and delete,
  which resulted a kernel crash due to the increase ref for save, swap,
  wrong ref decrease operations. Reported and fixed by Vishwanath Pai.

The patch should be applied to the older stable kernel branches too.

Best regards,
Jozsef

The following changes since commit fe1c3e3f630ef7765f34d9585d6b524899502b3f:

  netfilter: ipset: Check IPSET_ATTR_ETHER netlink attribute length (2016-03-16 21:43:50 +0100)

are available in the git repository at:

  git://blackhole.kfki.hu/nf master

for you to fetch changes up to 17f8a7334f3aee9783cfa6787172240c083ef394:

  netfilter: ipset: fix race condition in ipset save, swap and delete (2016-03-16 21:49:00 +0100)

----------------------------------------------------------------
Vishwanath Pai (1):
      netfilter: ipset: fix race condition in ipset save, swap and delete

 include/linux/netfilter/ipset/ip_set.h  |  4 ++++
 net/netfilter/ipset/ip_set_bitmap_gen.h |  2 +-
 net/netfilter/ipset/ip_set_core.c       | 33 ++++++++++++++++++++++++++++-----
 net/netfilter/ipset/ip_set_hash_gen.h   |  2 +-
 net/netfilter/ipset/ip_set_list_set.c   |  2 +-
 5 files changed, 35 insertions(+), 8 deletions(-)
