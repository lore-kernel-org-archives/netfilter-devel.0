From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 0/2] netfilter:ipset fixes: list:set and refcounting
Date: Fri, 25 Mar 2011 11:42:11 +0100
Message-ID: <1301049733-32160-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:45454 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934305Ab1CYKmP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Mar 2011 06:42:15 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

Please apply the next two patches for ipset:

- list:set timeout variant fixes
- References are protected by rwlock instead of mutex

Best regards,
Jozsef

Jozsef Kadlecsik (2):
  netfilter:ipset: list:set timeout variant fixes
  netfilter:ipset: References are protected by rwlock instead of mutex

 include/linux/netfilter/ipset/ip_set.h       |    2 +-
 include/linux/netfilter/ipset/ip_set_ahash.h |    3 +-
 net/netfilter/ipset/ip_set_bitmap_ip.c       |    3 +-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c    |    3 +-
 net/netfilter/ipset/ip_set_bitmap_port.c     |    3 +-
 net/netfilter/ipset/ip_set_core.c            |  109 ++++++++++++++++----------
 net/netfilter/ipset/ip_set_list_set.c        |   53 ++++++-------
 7 files changed, 94 insertions(+), 82 deletions(-)

