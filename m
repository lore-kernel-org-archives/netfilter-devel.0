From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] document multiport invert option
Date: Wed, 8 Sep 2004 16:35:35 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040908233535.GA17162@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="gBBFr7Ir9EOA20Yy"
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
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The man/-h pages for multiport don't document that you can use
inversion.  This can be confusing, since multiport uses '! --port x'
instead of '--dport ! x' like tcp/udp.

This closes bugzilla #143

Phil




--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-notmultiport

diff -ru ipt-orig/extensions/libip6t_multiport.c ipt-new/extensions/libip6t_multiport.c
--- ipt-orig/extensions/libip6t_multiport.c	2003-07-14 16:01:29.000000000 -0400
+++ ipt-new/extensions/libip6t_multiport.c	2004-09-08 19:29:59.897221576 -0400
@@ -13,13 +13,13 @@
 {
 	printf(
 "multiport v%s options:\n"
-" --source-ports port[,port,port...]\n"
-" --sports ...\n"
+" [!] --source-ports port[,port,port...]\n"
+" [!] --sports ...\n"
 "				match source port(s)\n"
-" --destination-ports port[,port,port...]\n"
-" --dports ...\n"
+" [!] --destination-ports port[,port,port...]\n"
+" [!] --dports ...\n"
 "				match destination port(s)\n"
-" --ports port[,port,port]\n"
+" [!] --ports port[,port,port]\n"
 "				match both source and destination port(s)\n",
 IPTABLES_VERSION);
 }
diff -ru ipt-orig/extensions/libip6t_multiport.man ipt-new/extensions/libip6t_multiport.man
--- ipt-orig/extensions/libip6t_multiport.man	2004-01-22 10:04:24.000000000 -0500
+++ ipt-new/extensions/libip6t_multiport.man	2004-09-08 19:24:43.199366968 -0400
@@ -4,16 +4,16 @@
 or
 .BR "-p udp" .
 .TP
-.BR "--source-ports " "\fIport\fP[,\fIport\fP[,\fIport\fP...]]"
+.BR "[!] --source-ports " "\fIport\fP[,\fIport\fP[,\fIport\fP...]]"
 Match if the source port is one of the given ports.  The flag
 .B --sports
 is a convenient alias for this option.
 .TP
-.BR "--destination-ports " "\fIport\fP[,\fIport\fP[,\fIport\fP...]]"
+.BR "[!] --destination-ports " "\fIport\fP[,\fIport\fP[,\fIport\fP...]]"
 Match if the destination port is one of the given ports.  The flag
 .B --dports
 is a convenient alias for this option.
 .TP
-.BR "--ports " "\fIport\fP[,\fIport\fP[,\fIport\fP...]]"
+.BR "[!] --ports " "\fIport\fP[,\fIport\fP[,\fIport\fP...]]"
 Match if the both the source and destination ports are equal to each
 other and to one of the given ports.
diff -ru ipt-orig/extensions/libipt_mport.c ipt-new/extensions/libipt_mport.c
--- ipt-orig/extensions/libipt_mport.c	2003-07-14 16:01:29.000000000 -0400
+++ ipt-new/extensions/libipt_mport.c	2004-09-08 19:30:26.468182176 -0400
@@ -13,13 +13,13 @@
 {
 	printf(
 "mport v%s options:\n"
-" --source-ports port[,port:port,port...]\n"
-" --sports ...\n"
+" [!] --source-ports port[,port:port,port...]\n"
+" [!] --sports ...\n"
 "				match source port(s)\n"
-" --destination-ports port[,port:port,port...]\n"
-" --dports ...\n"
+" [!] --destination-ports port[,port:port,port...]\n"
+" [!] --dports ...\n"
 "				match destination port(s)\n"
-" --ports port[,port:port,port]\n"
+" [!] --ports port[,port:port,port]\n"
 "				match both source and destination port(s)\n",
 IPTABLES_VERSION);
 }
diff -ru ipt-orig/extensions/libipt_mport.man ipt-new/extensions/libipt_mport.man
--- ipt-orig/extensions/libipt_mport.man	2004-01-22 10:04:25.000000000 -0500
+++ ipt-new/extensions/libipt_mport.man	2004-09-08 19:24:08.047710832 -0400
@@ -4,16 +4,16 @@
 or
 .BR "-p udp" .
 .TP
-.BR "--source-ports " "\fIport\fP[,\fIport\fP[,\fIport\fP...]]"
+.BR "[!] --source-ports " "\fIport\fP[,\fIport\fP[,\fIport\fP...]]"
 Match if the source port is one of the given ports.  The flag
 .B --sports
 is a convenient alias for this option.
 .TP
-.BR "--destination-ports " "\fIport\fP[,\fIport\fP[,\fIport\fP...]]"
+.BR "[!] --destination-ports " "\fIport\fP[,\fIport\fP[,\fIport\fP...]]"
 Match if the destination port is one of the given ports.  The flag
 .B --dports
 is a convenient alias for this option.
 .TP
-.BR "--ports " "\fIport\fP[,\fIport\fP[,\fIport\fP...]]"
+.BR "[!] --ports " "\fIport\fP[,\fIport\fP[,\fIport\fP...]]"
 Match if the both the source and destination ports are equal to each
 other and to one of the given ports.
diff -ru ipt-orig/extensions/libipt_multiport.c ipt-new/extensions/libipt_multiport.c
--- ipt-orig/extensions/libipt_multiport.c	2003-07-14 16:01:29.000000000 -0400
+++ ipt-new/extensions/libipt_multiport.c	2004-09-08 19:30:47.800939104 -0400
@@ -13,13 +13,13 @@
 {
 	printf(
 "multiport v%s options:\n"
-" --source-ports port[,port,port...]\n"
-" --sports ...\n"
+" [!] --source-ports port[,port,port...]\n"
+" [!] --sports ...\n"
 "				match source port(s)\n"
-" --destination-ports port[,port,port...]\n"
-" --dports ...\n"
+" [!] --destination-ports port[,port,port...]\n"
+" [!] --dports ...\n"
 "				match destination port(s)\n"
-" --ports port[,port,port]\n"
+" [!] --ports port[,port,port]\n"
 "				match both source and destination port(s)\n",
 IPTABLES_VERSION);
 }
diff -ru ipt-orig/extensions/libipt_multiport.man ipt-new/extensions/libipt_multiport.man
--- ipt-orig/extensions/libipt_multiport.man	2004-01-22 10:04:25.000000000 -0500
+++ ipt-new/extensions/libipt_multiport.man	2004-09-08 19:23:50.583365816 -0400
@@ -4,16 +4,16 @@
 or
 .BR "-p udp" .
 .TP
-.BR "--source-ports " "\fIport\fP[,\fIport\fP[,\fIport\fP...]]"
+.BR "[!] --source-ports " "\fIport\fP[,\fIport\fP[,\fIport\fP...]]"
 Match if the source port is one of the given ports.  The flag
 .B --sports
 is a convenient alias for this option.
 .TP
-.BR "--destination-ports " "\fIport\fP[,\fIport\fP[,\fIport\fP...]]"
+.BR "[!] --destination-ports " "\fIport\fP[,\fIport\fP[,\fIport\fP...]]"
 Match if the destination port is one of the given ports.  The flag
 .B --dports
 is a convenient alias for this option.
 .TP
-.BR "--ports " "\fIport\fP[,\fIport\fP[,\fIport\fP...]]"
+.BR "[!] --ports " "\fIport\fP[,\fIport\fP[,\fIport\fP...]]"
 Match if the both the source and destination ports are equal to each
 other and to one of the given ports.

--gBBFr7Ir9EOA20Yy--
