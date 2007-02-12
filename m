From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH 2.6.20 10/10] nfnetlink_log: enable packet timestamps
Date: Mon, 12 Feb 2007 01:40:42 +0100
Message-ID: <20070212004042.GK8262@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org
To: netfilter-devel@lists.netfilter.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S933130AbXBLJIx@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

It's nice to log packet arrival time of those little filthy packets. ;)

Signed-off-by: Micha=B3 Miros=B3aw <mirq-linux@rere.qmqm.pl>

--- linux-2.6.20/net/netfilter/nfnetlink_log.c.8	2007-02-11 23:59:01.00=
0000000 +0100
+++ linux-2.6.20/net/netfilter/nfnetlink_log.c	2007-02-12 00:19:16.0000=
00000 +0100
@@ -195,6 +195,10 @@ instance_create(u_int16_t group_num, int
=20
 	write_unlock_bh(&instances_lock);
=20
+	/* we want timestamps! we want to log those bastards! */
+	if (inst)
+		net_enable_timestamp();
+
 	return inst;
 }
=20
@@ -230,6 +234,9 @@ _instance_destroy2(struct nfulnl_instanc
=20
 	/* and finally put the refcount */
 	instance_put(inst);
+
+	/* we don't want timestamps anymore (decrement the counter) */
+	net_disable_timestamp();
 }
=20
 static inline void
