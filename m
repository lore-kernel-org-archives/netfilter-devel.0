From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH 2.6.22.3 5/5] nfnetlink_log: Fix some constants
Date: Fri, 21 Sep 2007 18:49:35 +0200
Message-ID: <20070921164935.GE3779@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rere.qmqm.pl ([86.63.132.164]:50455 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497AbXIUQ4X (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Sep 2007 12:56:23 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

=46ix timeout (one second is 1 * HZ) and convert max packet copy length
to #defined constant.

Signed-off-by: Micha=B3 Miros=B3aw <mirq-linux@rere.qmqm.pl>           =
                                                   =20

--- lq4/net/netfilter/nfnetlink_log.c	2007-09-21 18:42:09.000000000 +02=
00
+++ rechot/net/netfilter/nfnetlink_log.c	2007-09-21 18:41:42.000000000 =
+0200
@@ -37,8 +37,9 @@
 #endif
=20
 #define NFULNL_NLBUFSIZ_DEFAULT	NLMSG_GOODSIZE
-#define NFULNL_TIMEOUT_DEFAULT 	100	/* every second */
+#define NFULNL_TIMEOUT_DEFAULT 	HZ	/* every second */
 #define NFULNL_QTHRESH_DEFAULT 	100	/* 100 packets */
+#define NFULNL_COPY_RANGE_MAX	0xFFFF	/* max packet size is limited by =
16-bit struct nfattr nfa_len field */
=20
 #define PRINTR(x, args...)	do { if (net_ratelimit()) \
 				     printk(x, ## args); } while (0);
@@ -172,7 +173,7 @@
 	inst->flushtimeout 	=3D NFULNL_TIMEOUT_DEFAULT;
 	inst->nlbufsiz 		=3D NFULNL_NLBUFSIZ_DEFAULT;
 	inst->copy_mode 	=3D NFULNL_COPY_PACKET;
-	inst->copy_range 	=3D 0xffff;
+	inst->copy_range 	=3D NFULNL_COPY_RANGE_MAX;
=20
 	hlist_add_head(&inst->hlist,
 		       &instance_table[instance_hashfn(group_num)]);
@@ -236,11 +237,7 @@
=20
 	case NFULNL_COPY_PACKET:
 		inst->copy_mode =3D mode;
-		/* we're using struct nfattr which has 16bit nfa_len */
-		if (range > 0xffff)
-			inst->copy_range =3D 0xffff;
-		else
-			inst->copy_range =3D range;
+		inst->copy_range =3D min(range, NFULNL_COPY_RANGE_MAX);
 		break;
=20
 	default:
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
