From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 15/19]: nfnetlink_log: fix style
Date: Fri, 28 Sep 2007 18:30:58 +0200 (MEST)
Message-ID: <20070928163058.8394.7263.sendpatchset@localhost.localdomain>
References: <20070928163036.8394.36374.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55964 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759034AbXI1Qa7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Sep 2007 12:30:59 -0400
In-Reply-To: <20070928163036.8394.36374.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: nfnetlink_log: fix style

Fix function definition style to match other functions in nfnetlink_log.c.

Signed-off-by: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit d18594f2d34d0751245bfbfec7e5f6d742775774
tree 1067caecf6ba0583cbc2bb1db90ffa59a124529e
parent 073e73c1745332ab4e1765041847be760f366f53
author Michal Miroslaw <mirq-linux@rere.qmqm.pl> Fri, 28 Sep 2007 18:09:17 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 28 Sep 2007 18:09:17 +0200

 net/netfilter/nfnetlink_log.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 0fa1742..d2e811f 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -301,8 +301,8 @@ nfulnl_set_flags(struct nfulnl_instance *inst, u_int16_t flags)
 	return 0;
 }
 
-static struct sk_buff *nfulnl_alloc_skb(unsigned int inst_size,
-					unsigned int pkt_size)
+static struct sk_buff *
+nfulnl_alloc_skb(unsigned int inst_size, unsigned int pkt_size)
 {
 	struct sk_buff *skb;
 	unsigned int n;
@@ -365,7 +365,8 @@ __nfulnl_flush(struct nfulnl_instance *inst)
 		__nfulnl_send(inst);
 }
 
-static void nfulnl_timer(unsigned long data)
+static void
+nfulnl_timer(unsigned long data)
 {
 	struct nfulnl_instance *inst = (struct nfulnl_instance *)data;
 
