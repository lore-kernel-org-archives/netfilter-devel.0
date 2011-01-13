From: pablo@netfilter.org
Subject: [PATCH 0/1] Netfilter fixes for 2.6.37 (round 3)
Date: Thu, 13 Jan 2011 17:19:18 +0100
Message-ID: <1294935558-4106-1-git-send-email-pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44512 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932965Ab1AMQT0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Jan 2011 11:19:26 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Hi David,

Still another bugfix pending. I'm sorry, this one was incorporated
to Patrick's tree before Dec 16th and I thought that it followed
its patch to your tree.

Holger reported that it didn't. You can pull it from:

git://1984.lsi.us.es/net-2.6 master

Pablo Neira Ayuso (1):
  netfilter: ctnetlink: fix loop in ctnetlink_get_conntrack()

 net/netfilter/nf_conntrack_netlink.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

