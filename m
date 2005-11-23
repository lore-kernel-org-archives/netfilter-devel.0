From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] iptables compilation on <=2.6.13
Date: Wed, 23 Nov 2005 14:37:10 -0800
Message-ID: <20051123223710.GA20202@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="sdtB3X0nJg68CQEu"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Iptables since at least 1.3.3 will not compile with kernels <= 2.6.13
due to addition of the goto target.  Below patch corrects this, and
closes bug #386.

Phil



--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-goto

diff -ru ipt-orig/iptables.c ipt-new/iptables.c
--- ipt-orig/iptables.c	2005-11-17 05:04:49.000000000 -0800
+++ ipt-new/iptables.c	2005-11-23 14:03:21.000000000 -0800
@@ -1415,8 +1415,10 @@
 	if (format & FMT_NOTABLE)
 		fputs("  ", stdout);
 
+#ifdef IPT_F_GOTO
 	if(fw->ip.flags & IPT_F_GOTO)
 		printf("[goto] ");
+#endif
 
 	IPT_MATCH_ITERATE(fw, print_match, &fw->ip, format & FMT_NUMERIC);
 
diff -ru ipt-orig/iptables-save.c ipt-new/iptables-save.c
--- ipt-orig/iptables-save.c	2005-11-05 01:26:40.000000000 -0800
+++ ipt-new/iptables-save.c	2005-11-23 14:27:12.000000000 -0800
@@ -197,7 +197,11 @@
 	/* Print target name */	
 	target_name = iptc_get_target(e, h);
 	if (target_name && (*target_name != '\0'))
+#ifdef IPT_F_GOTO
 		printf("-%c %s ", e->ip.flags & IPT_F_GOTO ? 'g' : 'j', target_name);
+#else
+		printf("-j %s ", target_name);
+#endif
 
 	/* Print targinfo part */
 	t = ipt_get_target((struct ipt_entry *)e);

--sdtB3X0nJg68CQEu--
