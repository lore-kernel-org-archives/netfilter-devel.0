From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH 2.6.20 01/10] nfnetlink_log: don't count max(a,b) twice
Date: Mon, 12 Feb 2007 01:37:59 +0100
Message-ID: <20070212003759.GB8262@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org
To: netfilter-devel@lists.netfilter.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S964809AbXBLJJg@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

We don't need local nlbufsiz (skb size) as nfulnl_alloc_skb() takes
the maximum anyway.

Signed-off-by: Micha=B3 Miros=B3aw <mirq-linux@rere.qmqm.pl>

--- linux-2.6.20/net/netfilter/nfnetlink_log.c.orig	2007-02-10 18:25:14=
=2E000000000 +0100
+++ linux-2.6.20/net/netfilter/nfnetlink_log.c	2007-02-11 20:20:27.0000=
00000 +0100
@@ -596,7 +596,6 @@ nfulnl_log_packet(unsigned int pf,
 	struct nfulnl_instance *inst;
 	const struct nf_loginfo *li;
 	unsigned int qthreshold;
-	unsigned int nlbufsiz;
 	unsigned int plen;
=20
 	if (li_user && li_user->type =3D=3D NF_LOG_TYPE_ULOG)=20
@@ -672,13 +671,8 @@ nfulnl_log_packet(unsigned int pf,
 		return;
 	}
=20
-	if (size > inst->nlbufsiz)
-		nlbufsiz =3D size;
-	else
-		nlbufsiz =3D inst->nlbufsiz;
-
 	if (!inst->skb) {
-		if (!(inst->skb =3D nfulnl_alloc_skb(nlbufsiz, size))) {
+		if (!(inst->skb =3D nfulnl_alloc_skb(inst->nlbufsiz, size))) {
 			UDEBUG("error in nfulnl_alloc_skb(%u, %u)\n",
 				inst->nlbufsiz, size);
 			goto alloc_failure;
@@ -691,7 +685,7 @@ nfulnl_log_packet(unsigned int pf,
=20
 		__nfulnl_send(inst);
=20
-		if (!(inst->skb =3D nfulnl_alloc_skb(nlbufsiz, size))) {
+		if (!(inst->skb =3D nfulnl_alloc_skb(inst->nlbufsiz, size))) {
 			UDEBUG("error in nfulnl_alloc_skb(%u, %u)\n",
 				inst->nlbufsiz, size);
 			goto alloc_failure;
