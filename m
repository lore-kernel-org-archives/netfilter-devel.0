From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH 2.6.22.3 2/5] nfnetlink_log: Flush queue early
Date: Fri, 21 Sep 2007 18:48:46 +0200
Message-ID: <20070921164846.GB3779@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rere.qmqm.pl ([86.63.132.164]:46456 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273AbXIUQzd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Sep 2007 12:55:33 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

If queue is filled to its threshold, then flush it right away instead
of waiting for timer or next packet.

Signed-off-by: Micha=B3 Miros=B3aw <mirq-linux@rere.qmqm.pl>           =
                                                   =20

--- lq1/net/netfilter/nfnetlink_log.c	2007-09-21 13:27:28.000000000 +02=
00
+++ rechot/net/netfilter/nfnetlink_log.c	2007-09-20 15:14:04.000000000 =
+0200
@@ -644,8 +627,7 @@
 		goto unlock_and_release;
 	}
=20
-	if (inst->qlen >=3D qthreshold ||
-	    (inst->skb && size > skb_tailroom(inst->skb))) {
+	if (inst->skb && size > skb_tailroom(inst->skb)) {
 		/* either the queue len is too high or we don't have
 		 * enough room in the skb left. flush to userspace. */
 		UDEBUG("flushing old skb\n");
@@ -665,9 +647,11 @@
 	__build_packet_message(inst, skb, data_len, pf,
 				hooknum, in, out, li, prefix, plen);
=20
+	if (inst->qlen >=3D qthreshold)
+		__nfulnl_flush(inst);
 	/* timer_pending always called within inst->lock, so there
 	 * is no chance of a race here */
-	if (!timer_pending(&inst->timer)) {
+	else if (!timer_pending(&inst->timer)) {
 		instance_get(inst);
 		inst->timer.expires =3D jiffies + (inst->flushtimeout*HZ/100);
 		add_timer(&inst->timer);
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
