From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH 2.6.20 05/10] nfnetlink_log: micro-optimization for inst==NULL in nfulnl_recv_config()
Date: Mon, 12 Feb 2007 01:39:28 +0100
Message-ID: <20070212003928.GF8262@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org
To: netfilter-devel@lists.netfilter.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S964799AbXBLJJi@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Simple micro-optimization: don't call instance_put() on known NULL poin=
ters.

Signed-off-by: Micha=B3 Miros=B3aw <mirq-linux@rere.qmqm.pl>

--- linux-2.6.20/net/netfilter/nfnetlink_log.c.3	2007-02-11 20:46:33.00=
0000000 +0100
+++ linux-2.6.20/net/netfilter/nfnetlink_log.c	2007-02-11 20:46:26.0000=
00000 +0100
@@ -814,13 +814,13 @@ nfulnl_recv_config(struct sock *ctnl, st
 					       NETLINK_CB(skb).pid);
 			if (!inst) {
 				ret =3D -EINVAL;
-				goto out_put;
+				goto out_null;
 			}
 			break;
 		case NFULNL_CFG_CMD_UNBIND:
 			if (!inst) {
 				ret =3D -ENODEV;
-				goto out_put;
+				goto out_null;
 			}
=20
 			if (inst->peer_pid !=3D NETLINK_CB(skb).pid) {
@@ -850,7 +850,7 @@ nfulnl_recv_config(struct sock *ctnl, st
 				"group=3D%u pid=3D%u =3D>ENOENT\n",
 				group_num, NETLINK_CB(skb).pid);
 			ret =3D -ENOENT;
-			goto out_put;
+			goto out_null;
 		}
=20
 		if (inst->peer_pid !=3D NETLINK_CB(skb).pid) {
@@ -897,6 +897,7 @@ nfulnl_recv_config(struct sock *ctnl, st
=20
 out_put:
 	instance_put(inst);
+out_null:
 	return ret;
 }
=20
