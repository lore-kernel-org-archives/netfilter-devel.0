From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH 2.6.20 04/10] nfnetlink_log: fix possible use-after-free
Date: Mon, 12 Feb 2007 01:39:06 +0100
Message-ID: <20070212003906.GE8262@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org
To: netfilter-devel@lists.netfilter.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S964791AbXBLJJf@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Paranoia: instance_put() might have freed the inst pointer when we
spin_unlock_bh().

Signed-off-by: Micha=B3 Miros=B3aw <mirq-linux@rere.qmqm.pl>

--- linux-2.6.20/net/netfilter/nfnetlink_log.c.2	2007-02-11 20:43:24.00=
0000000 +0100
+++ linux-2.6.20/net/netfilter/nfnetlink_log.c	2007-02-11 20:46:33.0000=
00000 +0100
@@ -393,8 +393,8 @@ static void nfulnl_timer(unsigned long d
=20
 	spin_lock_bh(&inst->lock);
 	__nfulnl_send(inst);
-	instance_put(inst);
 	spin_unlock_bh(&inst->lock);
+	instance_put(inst);
 }
=20
 /* This is an inline function, we don't really care about a long
