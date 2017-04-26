From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: [nft PATCH v2] expression: print sets and maps in pretty format
Date: Wed, 26 Apr 2017 11:05:55 +0200
Message-ID: <149319751212.24658.15591983938007749887.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:41032 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S936320AbdDZJGF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Apr 2017 05:06:05 -0400
Received: from localhost (unknown [127.0.0.1])
        by smtp.cica.es (Postfix) with ESMTP id 4E70551F34D
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Apr 2017 09:06:02 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
        by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id TUKecSnxWLte for <netfilter-devel@vger.kernel.org>;
        Wed, 26 Apr 2017 11:05:56 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
        (Authenticated sender: servers@cica.es)
        by smtp.cica.es (Postfix) with ESMTP id 7663751F33C
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Apr 2017 11:05:56 +0200 (CEST)
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

NOTE: some testcases require updates because the output change.

Signed-off-by: Arturo Borrero Gonzalez <arturo@debian.org>
---
v2: align column using spaces rather than tabs.
    Cleanup unused variables and declarations.

 src/expression.c |   58 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 src/netlink.c    |    2 ++
 2 files changed, 59 insertions(+), 1 deletion(-)

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

