From: dann frazier <dannf@hp.com>
Subject: Bug#336431: [PATCH] fix ip_conntrack_helper_pptp build when CONFIG_IP_NF_NAT_NEEDED=n
Date: Mon, 31 Oct 2005 18:13:55 -0700
Message-ID: <1130807635.6630.13.camel@localhost>
Reply-To: dann frazier <dannf@hp.com>, 336431@bugs.debian.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: 336431@bugs.debian.org
Return-path: <bounce-debian-bugs-dist=glddb-debian-bugs-dist=m.gmane.org@lists.debian.org>
Resent-Message-ID: <handler.336431.B336431.113080764416143@bugs.debian.org>
To: netfilter-devel@lists.netfilter.org
List-Post: <mailto:debian-bugs-dist@lists.debian.org>
List-Help: <mailto:debian-bugs-dist-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=unsubscribe>
List-Id: netfilter-devel.vger.kernel.org

As reported in http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=336431,
ip_conntrack_helper_pptp in 2.6.14 fails to build if
CONFIG_IP_NF_NAT_NEEDED isn't enabled.  This patch fixes this by
disabling manipulation of the dir field of ip_conntrack_expect
structures when full nat isn't configured.  Compile tested only.

Signed-off-by: dann frazier <dannf@hp.com>

--- linux-source-2.6.14/net/ipv4/netfilter/ip_conntrack_helper_pptp.c.orig	2005-10-27 18:02:08.000000000 -0600
+++ linux-source-2.6.14/net/ipv4/netfilter/ip_conntrack_helper_pptp.c	2005-10-31 18:12:03.000000000 -0700
@@ -270,13 +270,14 @@
 	exp_orig->expectfn = pptp_expectfn;
 	exp_orig->flags = 0;
 
-	exp_orig->dir = IP_CT_DIR_ORIGINAL;
-
 	/* both expectations are identical apart from tuple */
 	memcpy(exp_reply, exp_orig, sizeof(*exp_reply));
 	memcpy(&exp_reply->tuple, &exp_tuples[1], sizeof(exp_reply->tuple));
 
+#ifdef CONFIG_IP_NF_NAT_NEEDED
+	exp_orig->dir = IP_CT_DIR_ORIGINAL;
 	exp_reply->dir = !exp_orig->dir;
+#endif
 
 	if (ip_nat_pptp_hook_exp_gre)
 		ret = ip_nat_pptp_hook_exp_gre(exp_orig, exp_reply);

-- 
dann frazier <dannf@hp.com>
