From: Simon Lodal <simonl@parknet.dk>
Subject: [PATCH 1/2] Realm verbosity
Date: Sun, 21 May 2006 18:13:15 +0200
Message-ID: <200605211813.15957.simonl@parknet.dk>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_bGJcEmHqkEG9vqR"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Developer <netfilter-devel@lists.netfilter.org>
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

--Boundary-00=_bGJcEmHqkEG9vqR
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


The realm match should identify itself in lowercase like other matches.

--Boundary-00=_bGJcEmHqkEG9vqR
Content-Type: text/x-diff; charset="us-ascii"; name="realm_verbosity.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="realm_verbosity.diff"

Index: iptables-1.3.5/extensions/libipt_realm.c
===================================================================
--- iptables-1.3.5/extensions/libipt_realm.c	(revision 4)
+++ iptables-1.3.5/extensions/libipt_realm.c	(revision 5)
@@ -17,7 +17,7 @@
 help(void)
 {
 	printf(
-"REALM v%s options:\n"
+"realm v%s options:\n"
 " --realm [!] value[/mask]\n"
 "				Match realm\n"
 "\n", IPTABLES_VERSION);
@@ -49,7 +49,7 @@
 		} else
 			realminfo->mask = 0xffffffff;
 		if (*end != '\0' || end == optarg)
-			exit_error(PARAMETER_PROBLEM, "Bad REALM value `%s'", optarg);
+			exit_error(PARAMETER_PROBLEM, "Bad realm value `%s'", optarg);
 		if (invert)
 			realminfo->invert = 1;
 		*flags = 1;
@@ -81,7 +81,7 @@
 	if (ri->invert)
 		printf("! ");
 
-	printf("REALM match ");
+	printf("realm ");
 	print_realm(ri->id, ri->mask);
 }
 
@@ -105,7 +105,7 @@
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
-			   "REALM match: You must specify `--realm'");
+			   "realm match: You must specify `--realm'");
 }
 
 static struct iptables_match realm = { NULL,

--Boundary-00=_bGJcEmHqkEG9vqR--
