From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH 2.6.22.3 3/5] nfnetlink_log: Fix style
Date: Fri, 21 Sep 2007 18:49:01 +0200
Message-ID: <20070921164901.GC3779@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rere.qmqm.pl ([86.63.132.164]:54332 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752366AbXIUQzs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Sep 2007 12:55:48 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

=46ix function definition style to match other functions in nfnetlink_l=
og.c.

Signed-off-by: Micha=B3 Miros=B3aw <mirq-linux@rere.qmqm.pl>           =
                                                   =20

--- lq2/net/netfilter/nfnetlink_log.c	2007-09-21 13:52:47.000000000 +02=
00
+++ rechot/net/netfilter/nfnetlink_log.c	2007-09-20 15:14:04.000000000 =
+0200
@@ -302,8 +302,8 @@
 	return 0;
 }
=20
-static struct sk_buff *nfulnl_alloc_skb(unsigned int inst_size,
-					unsigned int pkt_size)
+static struct sk_buff *
+nfulnl_alloc_skb(unsigned int inst_size, unsigned int pkt_size)
 {
 	struct sk_buff *skb;
 	unsigned int n;
@@ -364,7 +364,8 @@
 		__nfulnl_send(inst);
 }
=20
-static void nfulnl_timer(unsigned long data)
+static void
+nfulnl_timer(unsigned long data)
 {
 	struct nfulnl_instance *inst =3D (struct nfulnl_instance *)data;
=20
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
