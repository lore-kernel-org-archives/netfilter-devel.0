From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 14/19]: nfnetlink_log: flush queue early
Date: Fri, 28 Sep 2007 18:30:57 +0200 (MEST)
Message-ID: <20070928163056.8394.10545.sendpatchset@localhost.localdomain>
References: <20070928163036.8394.36374.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55962 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757784AbXI1Qa6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Sep 2007 12:30:58 -0400
In-Reply-To: <20070928163036.8394.36374.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: nfnetlink_log: flush queue early

If queue is filled to its threshold, then flush it right away instead
of waiting for timer or next packet.

Signed-off-by: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 073e73c1745332ab4e1765041847be760f366f53
tree 5327f298fd041b02c5635d93cf935e266644b90d
parent 7b32724f5d944727be7dcf23b50feb233d11be3f
author Michal Miroslaw <mirq-linux@rere.qmqm.pl> Fri, 28 Sep 2007 18:09:17 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 28 Sep 2007 18:09:17 +0200

 net/netfilter/nfnetlink_log.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 512741a..0fa1742 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -644,9 +644,8 @@ nfulnl_log_packet(unsigned int pf,
 		goto unlock_and_release;
 	}
 
-	if (inst->qlen >= qthreshold ||
-	    (inst->skb && size >
-	     skb_tailroom(inst->skb) - sizeof(struct nfgenmsg))) {
+	if (inst->skb &&
+	    size > skb_tailroom(inst->skb) - sizeof(struct nfgenmsg)) {
 		/* either the queue len is too high or we don't have
 		 * enough room in the skb left. flush to userspace. */
 		UDEBUG("flushing old skb\n");
@@ -666,9 +665,11 @@ nfulnl_log_packet(unsigned int pf,
 	__build_packet_message(inst, skb, data_len, pf,
 				hooknum, in, out, li, prefix, plen);
 
+	if (inst->qlen >= qthreshold)
+		__nfulnl_flush(inst);
 	/* timer_pending always called within inst->lock, so there
 	 * is no chance of a race here */
-	if (!timer_pending(&inst->timer)) {
+	else if (!timer_pending(&inst->timer)) {
 		instance_get(inst);
 		inst->timer.expires = jiffies + (inst->flushtimeout*HZ/100);
 		add_timer(&inst->timer);
