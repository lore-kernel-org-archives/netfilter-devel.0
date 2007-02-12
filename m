From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH 2.6.20 06/10] nfnetlink_log: micro-optimization: don't modify destroyed instance
Date: Mon, 12 Feb 2007 01:39:41 +0100
Message-ID: <20070212003941.GG8262@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org
To: netfilter-devel@lists.netfilter.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S933127AbXBLJIu@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Simple micro-optimization: Don't change any options if the instance is
being destroyed.

Signed-off-by: Micha=B3 Miros=B3aw <mirq-linux@rere.qmqm.pl>

--- linux-2.6.20/net/netfilter/nfnetlink_log.c.4	2007-02-11 20:46:26.00=
0000000 +0100
+++ linux-2.6.20/net/netfilter/nfnetlink_log.c	2007-02-11 22:24:56.0000=
00000 +0100
@@ -829,7 +829,8 @@ nfulnl_recv_config(struct sock *ctnl, st
 			}
=20
 			instance_destroy(inst);
-			break;
+			/* no point in changing anything in destroyed instance */
+			goto out_put;
 		case NFULNL_CFG_CMD_PF_BIND:
 			UDEBUG("registering log handler for pf=3D%u\n", pf);
 			ret =3D nf_log_register(pf, &nfulnl_logger);
