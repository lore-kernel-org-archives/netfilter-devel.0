From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH 2.6.20 13/14] nfnetlink_log: fix reference counting
Date: Mon, 12 Feb 2007 21:22:55 +0100
Message-ID: <20070212202255.GD28704@rere.qmqm.pl>
References: <20070212003738.GA8262@rere.qmqm.pl> <20070212202052.GA28704@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org
To: netfilter-devel@lists.netfilter.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S965369AbXBLUXO@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070212202052.GA28704@rere.qmqm.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

=46ix reference counting (memory leak) problem in __nfulnl_send() and c=
allers
related to packet queueing.

Signed-off-by: Micha=B3 Miros=B3aw <mirq-linux@rere.qmqm.pl>

--- linux-2.6.20/net/netfilter/nfnetlink_log.c.11	2007-02-12 17:35:50.0=
00000000 +0100
+++ linux-2.6.20/net/netfilter/nfnetlink_log.c	2007-02-12 17:58:01.0000=
00000 +0100
@@ -223,6 +223,11 @@ _instance_destroy2(struct nfulnl_instanc
=20
 	spin_lock_bh(&inst->lock);
 	if (inst->skb) {
+		/* timer "holds" one reference (we have one more) */
+		if (timer_pending(&inst->timer)) {
+			del_timer(&inst->timer);
+			instance_put(inst);
+		}
 		if (inst->qlen)
 			__nfulnl_send(inst);
 		if (inst->skb) {
@@ -370,9 +375,6 @@ __nfulnl_send(struct nfulnl_instance *in
 {
 	int status;
=20
-	if (timer_pending(&inst->timer))
-		del_timer(&inst->timer);
-
 	if (!inst->skb)
 		return 0;
=20
@@ -399,6 +401,8 @@ static void nfulnl_timer(unsigned long d
 	UDEBUG("timer function called, flushing buffer\n");
=20
 	spin_lock_bh(&inst->lock);
+	if (timer_pending(&inst->timer))	/* is it always true or false here? =
*/
+		del_timer(&inst->timer);
 	__nfulnl_send(inst);
 	spin_unlock_bh(&inst->lock);
 	instance_put(inst);
@@ -683,6 +687,11 @@ nfulnl_log_packet(unsigned int pf,
 		 * enough room in the skb left. flush to userspace. */
 		UDEBUG("flushing old skb\n");
=20
+		/* timer "holds" one reference (we have another one) */
+		if (timer_pending(&inst->timer)) {
+			del_timer(&inst->timer);
+			instance_put(inst);
+		}
 		__nfulnl_send(inst);
 	}
=20
