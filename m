From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] realm match inversion fixes
Date: Sat, 12 Feb 2005 14:39:08 -0800
Message-ID: <20050212223908.GA2960@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="+QahgC5+KEYLbs62"
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


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Below is a combination of Harald's suggested fix for bugzilla
297, plus my addition which fixes the case of ! being used
before the value.  

Phil



--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-realm2

diff -ru ipt-orig/extensions/libipt_realm.c ipt-new/extensions/libipt_realm.c
--- ipt-orig/extensions/libipt_realm.c	2004-12-28 05:11:59.000000000 -0800
+++ ipt-new/extensions/libipt_realm.c	2005-02-12 14:32:24.000000000 -0800
@@ -49,7 +49,7 @@
 	switch (c) {
 		char *end;
 	case '1':
-		check_inverse(argv[optind], &invert, &optind, 0);
+		check_inverse(argv[optind-1], &invert, &optind, 0);
 		optarg = argv[optind-1];
 		realminfo->id = strtoul(optarg, &end, 0);
 		if (*end == '/') {
@@ -70,12 +70,9 @@
 }
 
 static void
-print_realm(unsigned long id, unsigned long mask, int invert, int numeric)
+print_realm(unsigned long id, unsigned long mask)
 {
-	if (invert)
-		printf("! ");
-
-	if(mask != 0xffffffff)
+	if (mask != 0xffffffff)
 		printf("0x%lx/0x%lx ", id, mask);
 	else
 		printf("0x%lx ", id);
@@ -87,10 +84,13 @@
       const struct ipt_entry_match *match,
       int numeric)
 {
+	struct ipt_realm_info *ri = (struct ipt_realm_info *) match->data;
+
+	if (ri->invert)
+		printf("! ");
+
 	printf("REALM match ");
-	print_realm(((struct ipt_realm_info *)match->data)->id,
-		   ((struct ipt_realm_info *)match->data)->mask,
-		   ((struct ipt_realm_info *)match->data)->invert, numeric);
+	print_realm(ri->id, ri->mask);
 }
 
 
@@ -98,10 +98,13 @@
 static void
 save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
 {
+	struct ipt_realm_info *ri = (struct ipt_realm_info *) match->data;
+
+	if (ri->invert)
+		printf("! ");
+
 	printf("--realm ");
-	print_realm(((struct ipt_realm_info *)match->data)->id,
-		   ((struct ipt_realm_info *)match->data)->mask,
-		   ((struct ipt_realm_info *)match->data)->invert, 0);
+	print_realm(ri->id, ri->mask);
 }
 
 /* Final check; must have specified --mark. */

--+QahgC5+KEYLbs62--
