From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH 2.6.20 03/10] nfnetlink_log: kill duplicate code
Date: Mon, 12 Feb 2007 01:38:33 +0100
Message-ID: <20070212003833.GD8262@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org
To: netfilter-devel@lists.netfilter.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S964807AbXBLJJg@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Kill some duplicate code in nfulnl_log_packet().

Signed-off-by: Micha=B3 Miros=B3aw <mirq-linux@rere.qmqm.pl>

--- linux-2.6.20/net/netfilter/nfnetlink_log.c.1	2007-02-11 20:51:57.00=
0000000 +0100
+++ linux-2.6.20/net/netfilter/nfnetlink_log.c	2007-02-11 20:43:24.0000=
00000 +0100
@@ -666,30 +666,23 @@ nfulnl_log_packet(unsigned int pf,
 		break;
 =09
 	default:
-		spin_unlock_bh(&inst->lock);
-		instance_put(inst);
-		return;
+		goto unlock_and_release;
 	}
=20
-	if (!inst->skb) {
-		if (!(inst->skb =3D nfulnl_alloc_skb(inst->nlbufsiz, size))) {
-			UDEBUG("error in nfulnl_alloc_skb(%u, %u)\n",
-				inst->nlbufsiz, size);
-			goto alloc_failure;
-		}
-	} else if (inst->qlen >=3D qthreshold ||
-		   size > skb_tailroom(inst->skb)) {
+	if (inst->qlen >=3D qthreshold ||
+		   (inst->skb && size > skb_tailroom(inst->skb))) {
 		/* either the queue len is too high or we don't have
 		 * enough room in the skb left. flush to userspace. */
 		UDEBUG("flushing old skb\n");
=20
 		__nfulnl_send(inst);
+	}
=20
-		if (!(inst->skb =3D nfulnl_alloc_skb(inst->nlbufsiz, size))) {
-			UDEBUG("error in nfulnl_alloc_skb(%u, %u)\n",
-				inst->nlbufsiz, size);
+	if (!inst->skb) {
+		inst->skb =3D nfulnl_alloc_skb(inst->nlbufsiz, size);
+
+		if (!inst->skb)
 			goto alloc_failure;
-		}
 	}
=20
 	UDEBUG("qlen %d, qthreshold %d\n", inst->qlen, qthreshold);
