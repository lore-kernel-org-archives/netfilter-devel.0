From: pablo@netfilter.org
Subject: [PATCH] user-space expectation support updates
Date: Sun, 18 Dec 2011 01:55:53 +0100
Message-ID: <1324169754-20192-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, jengelh@medozas.de, kadlec@blackhole.kfki.hu
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43636 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058Ab1LRA4K (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Dec 2011 19:56:10 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Hi!

This patch was posted in april 2011, it seem it got lost during
the discussion:

http://www.spinics.net/lists/netfilter-devel/msg17992.html
http://www.spinics.net/lists/netfilter-devel/msg17993.html

This reworks the user-space expectation support.

I'm resending this to get it into net-net.

Nobody has been using this support so far. I plan to start
working on some user-space daemon (or extension for conntrackd)
to allow to implement helpers in user-space by beginning 2012.

Pablo Neira Ayuso (1):
  netfilter: rework user-space expectation helper support

 include/linux/netfilter/nf_conntrack_common.h |    4 ++
 include/linux/netfilter/xt_CT.h               |    3 +-
 include/net/netfilter/nf_conntrack_expect.h   |    1 -
 net/netfilter/nf_conntrack_expect.c           |   63 ++++++++----------------
 net/netfilter/nf_conntrack_helper.c           |   12 +++++
 net/netfilter/nf_conntrack_netlink.c          |    5 ++-
 net/netfilter/xt_CT.c                         |    8 ++-
 7 files changed, 48 insertions(+), 48 deletions(-)

-- 
1.7.2.5

