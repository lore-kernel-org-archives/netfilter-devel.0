From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH 2.6.20 02/10] nfnetlink_log: stop reference leak
Date: Mon, 12 Feb 2007 01:38:18 +0100
Message-ID: <20070212003818.GC8262@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org
To: netfilter-devel@lists.netfilter.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S964805AbXBLJJc@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Stop reference leaking in nfulnl_log_packet(). If we start a timer we
are already taking another reference.

Signed-off-by: Micha=B3 Miros=B3aw <mirq-linux@rere.qmqm.pl>

--- linux-2.6.20/net/netfilter/nfnetlink_log.c.0	2007-02-11 20:20:27.00=
0000000 +0100
+++ linux-2.6.20/net/netfilter/nfnetlink_log.c	2007-02-11 20:51:57.0000=
00000 +0100
@@ -705,15 +705,16 @@ nfulnl_log_packet(unsigned int pf,
 		inst->timer.expires =3D jiffies + (inst->flushtimeout*HZ/100);
 		add_timer(&inst->timer);
 	}
-	spin_unlock_bh(&inst->lock);
=20
+unlock_and_release:
+	spin_unlock_bh(&inst->lock);
+	instance_put(inst);
 	return;
=20
 alloc_failure:
-	spin_unlock_bh(&inst->lock);
-	instance_put(inst);
 	UDEBUG("error allocating skb\n");
 	/* FIXME: statistics */
+	goto unlock_and_release;
 }
=20
 static int
