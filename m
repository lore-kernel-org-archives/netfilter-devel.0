From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: [nft PATCH v3] expression: print sets and maps in pretty format
Date: Tue, 02 May 2017 11:47:02 +0200
Message-ID: <149371834124.14706.14801320069862319378.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:36089 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750934AbdEBJrM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 May 2017 05:47:12 -0400
Received: from localhost (unknown [127.0.0.1])
        by smtp.cica.es (Postfix) with ESMTP id 4A85B51F32F
        for <netfilter-devel@vger.kernel.org>; Tue,  2 May 2017 09:47:09 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
        by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id kWaZgm9ySj3j for <netfilter-devel@vger.kernel.org>;
        Tue,  2 May 2017 11:47:03 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
        (Authenticated sender: servers@cica.es)
        by smtp.cica.es (Postfix) with ESMTP id 216DA51F328
        for <netfilter-devel@vger.kernel.org>; Tue,  2 May 2017 11:47:02 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Print elements per line instead of all in a single line.
The elements which can be 'short' are printed 5 per line,
and others, like IPv4 addresses are printed 2 per line.

Example:

% nft list ruleset -nnn
table ip t {
	set s {
		type inet_service
		elements = { 1, 2, 3, 4, 10,
			     432, 433, 434, 435, 436,
			     437, 438, 439, 440, 441,
			     442, 443, 444, 445, 446,
			     447, 448, 449, 450, 12345 }
	}

	map m {
		type inet_service . iface_index : verdict
		elements = { 123 . "lo" : accept,
			     1234 . "lo" : accept,
			     12345 . "lo" : accept,
			     12346 . "lo" : accept,
			     12347 . "lo" : accept }
	}

	set s3 {
		type ipv4_addr
		elements = { 1.1.1.1, 2.2.2.2,
			     3.3.3.3 }
	}
}

Signed-off-by: Arturo Borrero Gonzalez <arturo@debian.org>
---
v2: align column using spaces rather than tabs.
    Cleanup unused variables and declarations.

v3: update testcases which depends on sets textual output

 .../testcases/maps/0003map_add_many_elements_0     |   15 +++++++++++----
 .../testcases/maps/0004interval_map_create_once_0  |   15 +++++++++++----
 .../maps/0005interval_map_add_many_elements_0      |   15 +++++++++++----
 3 files changed, 33 insertions(+), 12 deletions(-)

diff --git a/src/expression.c b/src/expression.c
index 45f3ed8..5defa63 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -742,10 +742,66 @@ struct expr *list_expr_alloc(const struct location *loc)
 	return compound_expr_alloc(loc, &list_expr_ops);
 }
 
+static const char *calculate_delim(const struct expr *expr, int *count)
+{
+	const char *newline = ",\n\t\t\t     ";
+	const char *singleline = ", ";
+
+	if (expr->set_flags & NFT_SET_ANONYMOUS)
+		return singleline;
+
+	if (!expr->dtype)
+		return newline;
+
+	switch (expr->dtype->type) {
+	case TYPE_NFPROTO:
+	case TYPE_INTEGER:
+	case TYPE_ARPOP:
+	case TYPE_INET_PROTOCOL:
+	case TYPE_INET_SERVICE:
+	case TYPE_TCP_FLAG:
+	case TYPE_DCCP_PKTTYPE:
+	case TYPE_MARK:
+	case TYPE_IFINDEX:
+	case TYPE_CLASSID:
+	case TYPE_UID:
+	case TYPE_GID:
+	case TYPE_CT_DIR:
+		if (*count < 5)
+			return singleline;
+		*count = 0;
+		break;
+	case TYPE_IPADDR:
+	case TYPE_CT_STATE:
+	case TYPE_CT_STATUS:
+	case TYPE_PKTTYPE:
+		if (*count < 2)
+			return singleline;
+		*count = 0;
+		break;
+
+	default:
+		break;
+	}
+
+	return newline;
+}
+
 static void set_expr_print(const struct expr *expr)
 {
+	const struct expr *i;
+	const char *d = "";
+	int count = 0;
+
 	printf("{ ");
-	compound_expr_print(expr, ", ");
+
+	list_for_each_entry(i, &expr->expressions, list) {
+		printf("%s", d);
+		expr_print(i);
+		count++;
+		d = calculate_delim(expr, &count);
+	}
+
 	printf(" }");
 }
 
diff --git a/src/netlink.c b/src/netlink.c
index 6fbb67d..59e8918 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1730,6 +1730,8 @@ int netlink_get_setelems(struct netlink_ctx *ctx, const struct handle *h,
 	ctx->set = set;
 	set->init = set_expr_alloc(loc);
 	nftnl_set_elem_foreach(nls, list_setelem_cb, ctx);
+	set->init->set_flags = set->flags;
+	set->init->dtype = set->keytype;
 
 	if (!(set->flags & NFT_SET_INTERVAL))
 		list_expr_sort(&ctx->set->init->expressions);
diff --git a/tests/shell/testcases/maps/0003map_add_many_elements_0 b/tests/shell/testcases/maps/0003map_add_many_elements_0
index 36b1be2..047f949 100755
--- a/tests/shell/testcases/maps/0003map_add_many_elements_0
+++ b/tests/shell/testcases/maps/0003map_add_many_elements_0
@@ -24,15 +24,22 @@ generate_add() {
 }
 
 generate_test() {
+	count=0
 	elements=""
 	for ((i=1; i<=HOWMANY; i++)) ; do
 		for ((j=1; j<=HOWMANY; j++)) ; do
-			elements="$elements 10.0.${i}.${j} : 10.0.${i}.${j}"
+			((count++))
+			elements="${elements}10.0.${i}.${j} : 10.0.${i}.${j}"
 			[ "$i" == "$HOWMANY" ] && [ "$j" == "$HOWMANY" ] && break
-			elements="${elements}, "
+			if [ "$count" == "2" ] ; then
+				count=0
+				elements="${elements},\\n\\t\\t\\t     "
+			else
+				elements="${elements}, "
+			fi
 		done
 	done
-	echo $elements
+	echo -e "$elements"
 }
 
 echo "add table x
@@ -49,7 +56,7 @@ $NFT -f $tmpfile
 EXPECTED="table ip x {
 	map y {
 		type ipv4_addr : ipv4_addr
-		elements = { $(generate_test) }
+		elements = { "$(generate_test)" }
 	}
 }"
 GET=$($NFT list ruleset)
diff --git a/tests/shell/testcases/maps/0004interval_map_create_once_0 b/tests/shell/testcases/maps/0004interval_map_create_once_0
index 1f04387..58b399c 100755
--- a/tests/shell/testcases/maps/0004interval_map_create_once_0
+++ b/tests/shell/testcases/maps/0004interval_map_create_once_0
@@ -26,15 +26,22 @@ generate_add() {
 }
 
 generate_test() {
+	count=0
 	elements=""
 	for ((i=1; i<=HOWMANY; i++)) ; do
 		for ((j=1; j<=HOWMANY; j++)) ; do
-			elements="$elements 10.${i}.${j}.0/24 : 10.0.${i}.${j}"
+			((count++))
+			elements="${elements}10.${i}.${j}.0/24 : 10.0.${i}.${j}"
 			[ "$i" == "$HOWMANY" ] && [ "$j" == "$HOWMANY" ] && break
-			elements="${elements}, "
+			if [ "$count" == "2" ] ; then
+				count=0
+				elements="${elements},\\n\\t\\t\\t     "
+			else
+				elements="${elements}, "
+			fi
 		done
 	done
-	echo $elements
+	echo -e "$elements"
 }
 
 echo "add table x
@@ -48,7 +55,7 @@ EXPECTED="table ip x {
 	map y {
 		type ipv4_addr : ipv4_addr
 		flags interval
-		elements = { $(generate_test) }
+		elements = { "$(generate_test)" }
 	}
 }"
 GET=$($NFT list ruleset)
diff --git a/tests/shell/testcases/maps/0005interval_map_add_many_elements_0 b/tests/shell/testcases/maps/0005interval_map_add_many_elements_0
index 4d4f708..55f9055 100755
--- a/tests/shell/testcases/maps/0005interval_map_add_many_elements_0
+++ b/tests/shell/testcases/maps/0005interval_map_add_many_elements_0
@@ -27,15 +27,22 @@ generate_add() {
 }
 
 generate_test() {
+	count=0
 	elements=""
 	for ((i=1; i<=HOWMANY; i++)) ; do
 		for ((j=1; j<=HOWMANY; j++)) ; do
-			elements="$elements 10.${i}.${j}.0/24 : 10.0.${i}.${j}"
+			((count++))
+			elements="${elements}10.${i}.${j}.0/24 : 10.0.${i}.${j}"
 			[ "$i" == "$HOWMANY" ] && [ "$j" == "$HOWMANY" ] && break
-			elements="${elements}, "
+			if [ "$count" == "2" ] ; then
+				count=0
+				elements="${elements},\\n\\t\\t\\t     "
+			else
+				elements="${elements}, "
+			fi
 		done
 	done
-	echo $elements
+	echo -e "$elements"
 }
 
 echo "add table x
@@ -54,7 +61,7 @@ EXPECTED="table ip x {
 	map y {
 		type ipv4_addr : ipv4_addr
 		flags interval
-		elements = { $(generate_test) }
+		elements = { "$(generate_test)" }
 	}
 }"
 GET=$($NFT list ruleset)

