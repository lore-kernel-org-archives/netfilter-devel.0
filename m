From: pablo@netfilter.org
Subject: [PATCH 0/2] ctnetlink: updates
Date: Sun, 18 Dec 2011 01:33:15 +0100
Message-ID: <1324168397-7370-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, jengelh@medozas.de, kadlec@blackhole.kfki.hu
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42718 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974Ab1LRAdg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Dec 2011 19:33:36 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Hi!

This patches includes two updates for ctnetlink:

* use the expect tuple, instead of the master tuple for the expect
  get operation.

* allow to atomically-get-and-reset counters via getctrzero operation.

If nobody complains, I'll add it to my nf-next queue:

http://1984.lsi.us.es/git/net-next/log/?h=nf-next

Pablo Neira Ayuso (2):
  netfilter: ctnetlink: use expect instead of master tuple in get
    operation
  netfilter: ctnetlink: support individual atomic-get-and-reset of
    counters

 net/netfilter/nf_conntrack_netlink.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

-- 
1.7.2.5

