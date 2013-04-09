From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 0/2] ipset bugfix patches
Date: Tue,  9 Apr 2013 20:57:18 +0200
Message-ID: <1365533840-23794-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:41611 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935256Ab3DIS5V (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Apr 2013 14:57:21 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

The next two patches are bugfixes against the current ipset code in
your nf tree, please apply them. The patches can be pulled from

git://blackhole.kfki.hu/nf master

Best regards,
Jozsef

Jozsef Kadlecsik (2):
  netfilter: ipset: list:set: fix reference counter update
  netfilter: ipset: hash:*net*: nomatch flag not excluded on set resize

 include/linux/netfilter/ipset/ip_set_ahash.h |   30 +++++++++++++++++++------
 net/netfilter/ipset/ip_set_hash_ipportnet.c  |   18 +++++++++++++++
 net/netfilter/ipset/ip_set_hash_net.c        |   22 +++++++++++++++++-
 net/netfilter/ipset/ip_set_hash_netiface.c   |   22 +++++++++++++++++-
 net/netfilter/ipset/ip_set_hash_netport.c    |   18 +++++++++++++++
 net/netfilter/ipset/ip_set_list_set.c        |   10 ++++++--
 6 files changed, 106 insertions(+), 14 deletions(-)

