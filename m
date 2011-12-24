From: pablo@netfilter.org
Subject: [PATCH] nfacct infrastructure (version 3)
Date: Sat, 24 Dec 2011 02:25:45 +0100
Message-ID: <1324689946-20269-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, xiaosuo@gmail.com, eric.dumazet@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35407 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752982Ab1LXB0G (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Dec 2011 20:26:06 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Hi!

These patchset contains the third version of the nfacct infrastructure
including Changli Gao and Eric Dumazet comments.

I'm not including the xt_nfacct part as I made no changes to it.

As said, I'd like to apply this to nf-next, if nobody finds any other
issue in the following days, I'll do so.

Thanks!

Pablo Neira Ayuso (1):
  netfilter: add extended accounting infrastructure over nfnetlink

 include/linux/netfilter/Kbuild           |    1 +
 include/linux/netfilter/nfnetlink.h      |    3 +-
 include/linux/netfilter/nfnetlink_acct.h |   36 +++
 net/netfilter/Kconfig                    |    8 +
 net/netfilter/Makefile                   |    1 +
 net/netfilter/nfnetlink_acct.c           |  361 ++++++++++++++++++++++++++++++
 6 files changed, 409 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/netfilter/nfnetlink_acct.h
 create mode 100644 net/netfilter/nfnetlink_acct.c

-- 
1.7.2.5

