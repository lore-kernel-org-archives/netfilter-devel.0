From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 01/10] src: quote user-defined strings when used from rule selectors
Date: Wed, 17 Aug 2016 15:29:52 +0200
Message-ID: <1471440601-5327-2-git-send-email-pablo@netfilter.org>
References: <1471440601-5327-1-git-send-email-pablo@netfilter.org>
Cc: fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44008 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbcHQNaL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Aug 2016 09:30:11 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 6A400E9774
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 15:30:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 51447DA7FE
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 15:30:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id EF88AFB469
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 15:30:06 +0200 (CEST)
In-Reply-To: <1471440601-5327-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following selectors display strings using quotes:

* meta iifname
* meta oifname
* meta ibriport
* meta obriport

However, the following do not:

* meta oif
* meta iif
* meta skuid
* meta skgid
* meta iifgroup
* meta oifgroup
* meta rtclassid
* ct label

Given they refer to user-defined values, neither keywords nor internal
built-in known values, let's quote the output of this.

This patch modifies symbolic_constant_print() so we can signal this to
indicate if the string needs to be quoted.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/datatype.h          |  2 +-
 src/ct.c                    |  2 +-
 src/datatype.c              | 12 ++++++----
 src/meta.c                  | 12 +++++-----
 src/proto.c                 |  2 +-
 tests/py/any/meta.t         | 58 ++++++++++++++++++++++-----------------------
 tests/py/any/meta.t.payload | 26 ++++++++++----------
 7 files changed, 59 insertions(+), 55 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index c7e110f..3eb686e 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -188,7 +188,7 @@ extern struct error_record *symbolic_constant_parse(const struct expr *sym,
 						    const struct symbol_table *tbl,
 						    struct expr **res);
 extern void symbolic_constant_print(const struct symbol_table *tbl,
-				    const struct expr *expr);
+				    const struct expr *expr, bool quotes);
 extern void symbol_table_print(const struct symbol_table *tbl,
 			       const struct datatype *dtype);
 
diff --git a/src/ct.c b/src/ct.c
index f6018d8..3575596 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -108,7 +108,7 @@ static void ct_label_type_print(const struct expr *expr)
 	for (s = ct_label_tbl->symbols; s->identifier != NULL; s++) {
 		if (bit != s->value)
 			continue;
-		printf("%s", s->identifier);
+		printf("\"%s\"", s->identifier);
 		return;
 	}
 	/* can happen when connlabel.conf is altered after rules were added */
diff --git a/src/datatype.c b/src/datatype.c
index 002c4c6..2b1619a 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -86,7 +86,8 @@ void datatype_print(const struct expr *expr)
 		if (dtype->print != NULL)
 			return dtype->print(expr);
 		if (dtype->sym_tbl != NULL)
-			return symbolic_constant_print(dtype->sym_tbl, expr);
+			return symbolic_constant_print(dtype->sym_tbl, expr,
+						       false);
 	} while ((dtype = dtype->basetype));
 
 	BUG("datatype %s has no print method or symbol table\n",
@@ -154,7 +155,7 @@ out:
 }
 
 void symbolic_constant_print(const struct symbol_table *tbl,
-			     const struct expr *expr)
+			     const struct expr *expr, bool quotes)
 {
 	unsigned int len = div_round_up(expr->len, BITS_PER_BYTE);
 	const struct symbolic_constant *s;
@@ -173,7 +174,10 @@ void symbolic_constant_print(const struct symbol_table *tbl,
 	if (s->identifier == NULL)
 		return expr_basetype(expr)->print(expr);
 
-	printf("%s", s->identifier);
+	if (quotes)
+		printf("\"%s\"", s->identifier);
+	else
+		printf("%s", s->identifier);
 }
 
 void symbol_table_print(const struct symbol_table *tbl,
@@ -684,7 +688,7 @@ static void __exit mark_table_exit(void)
 
 static void mark_type_print(const struct expr *expr)
 {
-	return symbolic_constant_print(mark_tbl, expr);
+	return symbolic_constant_print(mark_tbl, expr, true);
 }
 
 static struct error_record *mark_type_parse(const struct expr *sym,
diff --git a/src/meta.c b/src/meta.c
index 9dd91de..94263f9 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -47,7 +47,7 @@ static void __exit realm_table_exit(void)
 
 static void realm_type_print(const struct expr *expr)
 {
-	return symbolic_constant_print(realm_tbl, expr);
+	return symbolic_constant_print(realm_tbl, expr, true);
 }
 
 static struct error_record *realm_type_parse(const struct expr *sym,
@@ -144,7 +144,7 @@ static void ifindex_type_print(const struct expr *expr)
 
 	ifindex = mpz_get_uint32(expr->value);
 	if (nft_if_indextoname(ifindex, name))
-		printf("%s", name);
+		printf("\"%s\"", name);
 	else
 		printf("%d", ifindex);
 }
@@ -208,7 +208,7 @@ static void uid_type_print(const struct expr *expr)
 
 		pw = getpwuid(uid);
 		if (pw != NULL)
-			printf("%s", pw->pw_name);
+			printf("\"%s\"", pw->pw_name);
 		else
 			printf("%d", uid);
 		return;
@@ -260,7 +260,7 @@ static void gid_type_print(const struct expr *expr)
 
 		gr = getgrgid(gid);
 		if (gr != NULL)
-			printf("%s", gr->gr_name);
+			printf("\"%s\"", gr->gr_name);
 		else
 			printf("%u", gid);
 		return;
@@ -314,7 +314,7 @@ static const struct symbol_table pkttype_type_tbl = {
 
 static void pkttype_type_print(const struct expr *expr)
 {
-	return symbolic_constant_print(&pkttype_type_tbl, expr);
+	return symbolic_constant_print(&pkttype_type_tbl, expr, false);
 }
 
 static const struct datatype pkttype_type = {
@@ -341,7 +341,7 @@ static void __exit devgroup_table_exit(void)
 
 static void devgroup_type_print(const struct expr *expr)
 {
-	return symbolic_constant_print(devgroup_tbl, expr);
+	return symbolic_constant_print(devgroup_tbl, expr, true);
 }
 
 static struct error_record *devgroup_type_parse(const struct expr *sym,
diff --git a/src/proto.c b/src/proto.c
index 4c12977..94995f1 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -871,7 +871,7 @@ static const struct symbol_table ethertype_tbl = {
 
 static void ethertype_print(const struct expr *expr)
 {
-	return symbolic_constant_print(&ethertype_tbl, expr);
+	return symbolic_constant_print(&ethertype_tbl, expr, false);
 }
 
 const struct datatype ethertype_type = {
diff --git a/tests/py/any/meta.t b/tests/py/any/meta.t
index 909de8b..11ebf75 100644
--- a/tests/py/any/meta.t
+++ b/tests/py/any/meta.t
@@ -61,10 +61,10 @@ meta mark or 0x03 != 0x01;ok;mark | 0x00000003 != 0x00000001
 meta mark xor 0x03 == 0x01;ok;mark 0x00000002
 meta mark xor 0x03 != 0x01;ok;mark != 0x00000002
 
-meta iif eth0 accept;ok;iif eth0 accept
-meta iif eth0 accept;ok;iif eth0 accept
-meta iif != eth0 accept;ok;iif != eth0 accept
-meta iif != eth0 accept;ok;iif != eth0 accept
+meta iif "eth0" accept;ok;iif "eth0" accept
+meta iif "eth0" accept;ok;iif "eth0" accept
+meta iif != "eth0" accept;ok;iif != "eth0" accept
+meta iif != "eth0" accept;ok;iif != "eth0" accept
 
 meta iifname "eth0";ok;iifname "eth0"
 meta iifname != "eth0";ok;iifname != "eth0"
@@ -80,10 +80,10 @@ meta iiftype ether;ok;iiftype ether
 meta iiftype != ppp;ok;iiftype != ppp
 meta iiftype ppp;ok;iiftype ppp
 
-meta oif lo accept;ok;oif lo accept
-meta oif != lo accept;ok;oif != lo accept
-meta oif {eth0, lo} accept;ok
-- meta oif != {eth0, lo} accept;ok
+meta oif "lo" accept;ok;oif "lo" accept
+meta oif != "lo" accept;ok;oif != "lo" accept
+meta oif {"eth0", "lo"} accept;ok
+- meta oif != {"eth0", "lo"} accept;ok
 
 meta oifname "eth0";ok;oifname "eth0"
 meta oifname != "eth0";ok;oifname != "eth0"
@@ -97,10 +97,10 @@ meta oiftype {ether, ppp, ipip, ipip6, loopback, sit, ipgre};ok
 meta oiftype != ether;ok;oiftype != ether
 meta oiftype ether;ok;oiftype ether
 
-meta skuid {bin, root, daemon} accept;ok;skuid { 0, 1, 2} accept
-- meta skuid != {bin, root, daemon} accept;ok
-meta skuid root;ok;skuid 0
-meta skuid != root;ok;skuid != 0
+meta skuid {"bin", "root", "daemon"} accept;ok;skuid { 0, 1, 2} accept
+- meta skuid != {"bin", "root", "daemon"} accept;ok
+meta skuid "root";ok;skuid 0
+meta skuid != "root";ok;skuid != 0
 meta skuid lt 3000 accept;ok;skuid < 3000 accept
 meta skuid gt 3000 accept;ok;skuid > 3000 accept
 meta skuid eq 3000 accept;ok;skuid 3000 accept
@@ -109,10 +109,10 @@ meta skuid != 2001-2005 accept;ok;skuid != 2001-2005 accept
 meta skuid { 2001-2005} accept;ok;skuid { 2001-2005} accept
 - meta skuid != { 2001-2005} accept;ok
 
-meta skgid {bin, root, daemon} accept;ok;skgid { 0, 1, 2} accept
-- meta skgid != {bin, root, daemon} accept;ok
-meta skgid root;ok;skgid 0
-meta skgid != root;ok;skgid != 0
+meta skgid {"bin", "root", "daemon"} accept;ok;skgid { 0, 1, 2} accept
+- meta skgid != {"bin", "root", "daemon"} accept;ok
+meta skgid "root";ok;skgid 0
+meta skgid != "root";ok;skgid != 0
 meta skgid lt 3000 accept;ok;skgid < 3000 accept
 meta skgid gt 3000 accept;ok;skgid > 3000 accept
 meta skgid eq 3000 accept;ok;skgid 3000 accept
@@ -148,7 +148,7 @@ meta skgid 3000;ok;skgid 3000
 # BUG:  meta nftrace 1;ok
 # <cmdline>:1:1-37: Error: Could not process rule: Operation not supported
 - meta nftrace 1;ok
-meta rtclassid cosmos;ok;rtclassid cosmos
+meta rtclassid "cosmos";ok;rtclassid "cosmos"
 
 meta pkttype broadcast;ok;pkttype broadcast
 meta pkttype unicast;ok;pkttype unicast
@@ -167,22 +167,22 @@ meta cpu { 2,3};ok;cpu { 2,3}
 meta cpu { 2-3, 5-7};ok
 -meta cpu != { 2,3};ok; cpu != { 2,3}
 
-meta iifgroup 0;ok;iifgroup default
-meta iifgroup != 0;ok;iifgroup != default
-meta iifgroup default;ok;iifgroup default
-meta iifgroup != default;ok;iifgroup != default
-meta iifgroup {default};ok;iifgroup {default}
-- meta iifgroup != {default};ok
+meta iifgroup 0;ok;iifgroup "default"
+meta iifgroup != 0;ok;iifgroup != "default"
+meta iifgroup "default";ok;iifgroup "default"
+meta iifgroup != "default";ok;iifgroup != "default"
+meta iifgroup {"default"};ok;iifgroup {"default"}
+- meta iifgroup != {"default"};ok
 meta iifgroup { 11,33};ok
 meta iifgroup {11-33};ok
 - meta iifgroup != {11,33};ok
 - meta iifgroup != {11-33};ok
-meta oifgroup 0;ok;oifgroup default
-meta oifgroup != 0;ok;oifgroup != default
-meta oifgroup default;ok;oifgroup default
-meta oifgroup != default;ok;oifgroup != default
-meta oifgroup {default};ok;oifgroup {default}
-- meta oifgroup != {default};ok
+meta oifgroup 0;ok;oifgroup "default"
+meta oifgroup != 0;ok;oifgroup != "default"
+meta oifgroup "default";ok;oifgroup "default"
+meta oifgroup != "default";ok;oifgroup != "default"
+meta oifgroup {"default"};ok;oifgroup {"default"}
+- meta oifgroup != {"default"};ok
 meta oifgroup { 11,33};ok
 meta oifgroup {11-33};ok
 - meta oifgroup != {11,33};ok
diff --git a/tests/py/any/meta.t.payload b/tests/py/any/meta.t.payload
index acd7851..d10d0e6 100644
--- a/tests/py/any/meta.t.payload
+++ b/tests/py/any/meta.t.payload
@@ -340,7 +340,7 @@ ip test-ip4 input
   [ meta load oiftype => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
-# meta skuid {bin, root, daemon} accept
+# meta skuid {"bin", "root", "daemon"} accept
 __set%d test-ip4 3
 __set%d test-ip4 0
 	element 00000001  : 0 [end]	element 00000000  : 0 [end]	element 00000002  : 0 [end]
@@ -349,12 +349,12 @@ ip test-ip4 input
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
-# meta skuid root
+# meta skuid "root"
 ip test-ip4 input
   [ meta load skuid => reg 1 ]
   [ cmp eq reg 1 0x00000000 ]
 
-# meta skuid != root
+# meta skuid != "root"
 ip test-ip4 input
   [ meta load skuid => reg 1 ]
   [ cmp neq reg 1 0x00000000 ]
@@ -405,7 +405,7 @@ ip test-ip4 input
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
-# meta skgid {bin, root, daemon} accept
+# meta skgid {"bin", "root", "daemon"} accept
 __set%d test-ip4 3
 __set%d test-ip4 0
 	element 00000001  : 0 [end]	element 00000000  : 0 [end]	element 00000002  : 0 [end]
@@ -414,12 +414,12 @@ ip test-ip4 input
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
-# meta skgid root
+# meta skgid "root"
 ip test-ip4 input
   [ meta load skgid => reg 1 ]
   [ cmp eq reg 1 0x00000000 ]
 
-# meta skgid != root
+# meta skgid != "root"
 ip test-ip4 input
   [ meta load skgid => reg 1 ]
   [ cmp neq reg 1 0x00000000 ]
@@ -536,7 +536,7 @@ ip test-ip4 input
   [ meta load skgid => reg 1 ]
   [ cmp eq reg 1 0x00000bb8 ]
 
-# meta rtclassid cosmos
+# meta rtclassid "cosmos"
 ip test-ip4 input
   [ meta load rtclassid => reg 1 ]
   [ cmp eq reg 1 0x00000000 ]
@@ -631,17 +631,17 @@ ip test-ip4 input
   [ meta load iifgroup => reg 1 ]
   [ cmp neq reg 1 0x00000000 ]
 
-# meta iifgroup default
+# meta iifgroup "default"
 ip test-ip4 input
   [ meta load iifgroup => reg 1 ]
   [ cmp eq reg 1 0x00000000 ]
 
-# meta iifgroup != default
+# meta iifgroup != "default"
 ip test-ip4 input
   [ meta load iifgroup => reg 1 ]
   [ cmp neq reg 1 0x00000000 ]
 
-# meta iifgroup {default}
+# meta iifgroup {"default"}
 __set%d test-ip4 3
 __set%d test-ip4 0
 	element 00000000  : 0 [end]
@@ -676,17 +676,17 @@ ip test-ip4 input
   [ meta load oifgroup => reg 1 ]
   [ cmp neq reg 1 0x00000000 ]
 
-# meta oifgroup default
+# meta oifgroup "default"
 ip test-ip4 input
   [ meta load oifgroup => reg 1 ]
   [ cmp eq reg 1 0x00000000 ]
 
-# meta oifgroup != default
+# meta oifgroup != "default"
 ip test-ip4 input
   [ meta load oifgroup => reg 1 ]
   [ cmp neq reg 1 0x00000000 ]
 
-# meta oifgroup {default}
+# meta oifgroup {"default"}
 __set%d test-ip4 3
 __set%d test-ip4 0
 	element 00000000  : 0 [end]
-- 
2.1.4

