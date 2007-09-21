From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH 2.6.22.3 1/5] nfnetlink_log: Kill duplicate code
Date: Fri, 21 Sep 2007 18:48:26 +0200
Message-ID: <20070921164826.GA3779@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rere.qmqm.pl ([86.63.132.164]:59293 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501AbXIUQzz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Sep 2007 12:55:55 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Kill some cut'n'paste effect.
Just after __nfulnl_send() returning, inst->skb is always NULL.

Signed-off-by: Micha=B3 Miros=B3aw <mirq-linux@rere.qmqm.pl>           =
                                                   =20

diff -urN linux-2.6.22.3-routes-ck1-r4/net/netfilter/nfnetlink_log.c lq=
1/net/netfilter/nfnetlink_log.c
--- linux-2.6.22.3-routes-ck1-r4/net/netfilter/nfnetlink_log.c	2007-07-=
09 01:32:17.000000000 +0200
+++ lq1/net/netfilter/nfnetlink_log.c	2007-09-21 13:27:28.000000000 +02=
00
@@ -189,7 +189,7 @@
 	return NULL;
 }
=20
-static int __nfulnl_send(struct nfulnl_instance *inst);
+static int __nfulnl_flush(struct nfulnl_instance *inst);
=20
 static void
 __instance_destroy(struct nfulnl_instance *inst)
@@ -203,17 +203,8 @@
 	/* then flush all pending packets from skb */
=20
 	spin_lock_bh(&inst->lock);
-	if (inst->skb) {
-		/* timer "holds" one reference (we have one more) */
-		if (del_timer(&inst->timer))
-			instance_put(inst);
-		if (inst->qlen)
-			__nfulnl_send(inst);
-		if (inst->skb) {
-			kfree_skb(inst->skb);
-			inst->skb =3D NULL;
-		}
-	}
+	if (inst->skb)
+		__nfulnl_flush(inst);
 	spin_unlock_bh(&inst->lock);
=20
 	/* and finally put the refcount */
@@ -363,6 +354,16 @@
 	return status;
 }
=20
+static int
+__nfulnl_flush(struct nfulnl_instance *inst)
+{
+	/* timer holds a reference */
+	if (del_timer(&inst->timer))
+		instance_put(inst);
+	if (inst->skb)
+		__nfulnl_send(inst);
+}
+
 static void nfulnl_timer(unsigned long data)
 {
 	struct nfulnl_instance *inst =3D (struct nfulnl_instance *)data;
@@ -649,10 +650,7 @@
 		 * enough room in the skb left. flush to userspace. */
 		UDEBUG("flushing old skb\n");
=20
-		/* timer "holds" one reference (we have another one) */
-		if (del_timer(&inst->timer))
-			instance_put(inst);
-		__nfulnl_send(inst);
+		__nfulnl_flush(inst);
 	}
=20
 	if (!inst->skb) {
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
