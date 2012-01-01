From: pablo@netfilter.org
Subject: [PATCH] fix for nfacct infrastructure in net-next
Date: Sun,  1 Jan 2012 17:22:24 +0100
Message-ID: <1325434945-21900-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51555 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829Ab2AAQWk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Jan 2012 11:22:40 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Hi Dave,

Please, pull the following fix for the nfacct infrastructure already
in your net-next tree.

You can pull it from:

git://1984.lsi.us.es/net-net nf-next

Thanks!

Pablo Neira Ayuso (1):
  netfilter: nfnetlink_acct: fix nfnl_acct_get operation

 net/netfilter/nfnetlink_acct.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

-- 
1.7.7.3

