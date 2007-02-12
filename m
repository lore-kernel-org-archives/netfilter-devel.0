From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH 2.6.20 14/14] nfnetlink_log: micro-optimization: inst->skb != NULL in __nfulnl_send()
Date: Mon, 12 Feb 2007 21:23:19 +0100
Message-ID: <20070212202319.GE28704@rere.qmqm.pl>
References: <20070212003738.GA8262@rere.qmqm.pl> <20070212202052.GA28704@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org
To: netfilter-devel@lists.netfilter.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S965371AbXBLUXi@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070212202052.GA28704@rere.qmqm.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

No other function calls __nfulnl_send() with inst->skb =3D=3D NULL than=
 nfulnl_timer().

Signed-off-by: Micha=B3 Miros=B3aw <mirq-linux@rere.qmqm.pl>

--- linux-2.6.20/net/netfilter/nfnetlink_log.c.12	2007-02-12 17:58:01.0=
00000000 +0100
+++ linux-2.6.20/net/netfilter/nfnetlink_log.c	2007-02-12 17:58:56.0000=
00000 +0100
@@ -375,9 +375,6 @@ __nfulnl_send(struct nfulnl_instance *in
 {
 	int status;
=20
-	if (!inst->skb)
-		return 0;
-
 	if (inst->qlen > 1)
 		inst->lastnlh->nlmsg_type =3D NLMSG_DONE;
=20
@@ -403,7 +400,8 @@ static void nfulnl_timer(unsigned long d
 	spin_lock_bh(&inst->lock);
 	if (timer_pending(&inst->timer))	/* is it always true or false here? =
*/
 		del_timer(&inst->timer);
-	__nfulnl_send(inst);
+	if (inst->skb)
+		__nfulnl_send(inst);
 	spin_unlock_bh(&inst->lock);
 	instance_put(inst);
 }
