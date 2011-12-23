From: pablo@netfilter.org
Subject: [PATCH 0/2] nfacct infrastructure (version 2)
Date: Fri, 23 Dec 2011 14:42:25 +0100
Message-ID: <1324647747-12646-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, jengelh@medozas.de, kadlec@blackhole.kfki.hu,
	eric.dumazet@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37637 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757186Ab1LWNoG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Dec 2011 08:44:06 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Hi!

These patchset contains the second version of the nfacct infrastructure
after digesting comments from Patrick and Eric.

Now, we've got one new xt_nfacct match instead of the target as suggested
by Jan and Jozsef.

I'd like to apply this to nf-next, if nobody complains in the following
days, I'll do so.

Thanks!

Pablo Neira Ayuso (2):
  netfilter: add extended accounting infrastructure over nfnetlink
  netfilter: xtables: add nfacct match to support extended accounting

 include/linux/netfilter/Kbuild           |    2 +
 include/linux/netfilter/nfnetlink.h      |    3 +-
 include/linux/netfilter/nfnetlink_acct.h |   35 +++
 include/linux/netfilter/xt_nfacct.h      |   17 ++
 net/netfilter/Kconfig                    |   19 ++
 net/netfilter/Makefile                   |    2 +
 net/netfilter/nfnetlink_acct.c           |  345 ++++++++++++++++++++++++++++++
 net/netfilter/xt_nfacct.c                |   76 +++++++
 8 files changed, 498 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/netfilter/nfnetlink_acct.h
 create mode 100644 include/linux/netfilter/xt_nfacct.h
 create mode 100644 net/netfilter/nfnetlink_acct.c
 create mode 100644 net/netfilter/xt_nfacct.c

-- 
1.7.2.5

