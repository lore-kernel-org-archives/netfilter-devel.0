From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH 2.6.20 12/14] nfnetlink_log: possible NULL pointer dereference in nfulnl_recv_config()
Date: Mon, 12 Feb 2007 21:22:24 +0100
Message-ID: <20070212202224.GC28704@rere.qmqm.pl>
References: <20070212003738.GA8262@rere.qmqm.pl> <20070212202052.GA28704@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org
To: netfilter-devel@lists.netfilter.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S965367AbXBLUWn@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070212202052.GA28704@rere.qmqm.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Eliminate possible NULL pointer dereference in nfulnl_recv_config().

Signed-off-by: Micha=B3 Miros=B3aw <mirq-linux@rere.qmqm.pl>

--- linux-2.6.20/net/netfilter/nfnetlink_log.c.10	2007-02-12 17:05:14.0=
00000000 +0100
+++ linux-2.6.20/net/netfilter/nfnetlink_log.c	2007-02-12 17:35:50.0000=
00000 +0100
@@ -853,6 +853,9 @@ nfulnl_recv_config(struct sock *ctnl, st
 			ret =3D -EINVAL;
 			break;
 		}
+
+		if (!inst)
+			goto out_null;
 	} else {
 		if (!inst) {
 			UDEBUG("no config command, and no instance for "
