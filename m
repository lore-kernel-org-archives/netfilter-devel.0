From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 0/1] ipset patch for nf
Date: Fri, 28 Aug 2015 19:15:51 +0200
Message-ID: <1440782152-21890-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:60202 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777AbbH1RPE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Aug 2015 13:15:04 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Please apply the next bugfix patch against the nf tree.

- Dave Jones reported that KASan detected out of bounds access in hash:net*
  types, which is fixed in the next patch

Thanks,
Jozsef

The following changes since commit 18e1db67e93ed75d9dc0d34c8d783ccf10547c2b:

  netfilter: bridge: fix IPv6 packets not being bridged with CONFIG_IPV6=n (2015-08-19 21:21:41 +0200)

are available in the git repository at:

  git://blackhole.kfki.hu/nf master

for you to fetch changes up to 6fe7ccfd77415a6ba250c10c580eb3f9acf79753:

  netfilter: ipset: Out of bound access in hash:net* types fixed (2015-08-28 18:51:30 +0200)

----------------------------------------------------------------
Jozsef Kadlecsik (1):
      netfilter: ipset: Out of bound access in hash:net* types fixed

 net/netfilter/ipset/ip_set_hash_gen.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)
kadlec@blackhole ~/git/nf $ 
