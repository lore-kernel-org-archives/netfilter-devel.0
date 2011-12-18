From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/3] libipt_SAME: set PROTO_RANDOM on all ranges
Date: Sun, 18 Dec 2011 03:06:46 +0100
Message-ID: <1324174009-1559-2-git-send-email-jengelh@medozas.de>
References: <1324174009-1559-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:55612 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229Ab1LRCIN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Dec 2011 21:08:13 -0500
In-Reply-To: <1324174009-1559-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Resolve the (justified) WTF remark to a clearer version of when/why
PROTO_RANDOM needs to be set.

Especially when --random is used before --to in SAME, it would have
not been appleid.
---
 extensions/libipt_DNAT.c |   17 ++++++++++-------
 extensions/libipt_SAME.c |   24 ++++++++++++++----------
 extensions/libipt_SNAT.c |   17 ++++++++++-------
 3 files changed, 34 insertions(+), 24 deletions(-)

diff --git a/extensions/libipt_DNAT.c b/extensions/libipt_DNAT.c
index 3b55c69..466c9de 100644
--- a/extensions/libipt_DNAT.c
+++ b/extensions/libipt_DNAT.c
@@ -174,21 +174,23 @@ static void DNAT_parse(struct xt_option_call *cb)
 					   "DNAT: Multiple --to-destination not supported");
 		}
 		*cb->target = parse_to(cb->arg, portok, info);
-		/* WTF do we need this for?? */
-		if (cb->xflags & F_RANDOM)
-			info->mr.range[0].flags |= IP_NAT_RANGE_PROTO_RANDOM;
 		cb->xflags |= F_X_TO_DEST;
 		break;
-	case O_RANDOM:
-		if (cb->xflags & F_TO_DEST)
-			info->mr.range[0].flags |= IP_NAT_RANGE_PROTO_RANDOM;
-		break;
 	case O_PERSISTENT:
 		info->mr.range[0].flags |= IP_NAT_RANGE_PERSISTENT;
 		break;
 	}
 }
 
+static void DNAT_fcheck(struct xt_fcheck_call *cb)
+{
+	static const unsigned int f = F_TO_DEST | F_RANDOM;
+	struct nf_nat_multi_range *mr = cb->data;
+
+	if ((cb->xflags & f) == f)
+		mr->range[0].flags |= IP_NAT_RANGE_PROTO_RANDOM;
+}
+
 static void print_range(const struct nf_nat_range *r)
 {
 	if (r->flags & IP_NAT_RANGE_MAP_IPS) {
@@ -248,6 +250,7 @@ static struct xtables_target dnat_tg_reg = {
 	.userspacesize	= XT_ALIGN(sizeof(struct nf_nat_multi_range)),
 	.help		= DNAT_help,
 	.x6_parse	= DNAT_parse,
+	.x6_fcheck	= DNAT_fcheck,
 	.print		= DNAT_print,
 	.save		= DNAT_save,
 	.x6_options	= DNAT_opts,
diff --git a/extensions/libipt_SAME.c b/extensions/libipt_SAME.c
index 2ff6c82..e603ef6 100644
--- a/extensions/libipt_SAME.c
+++ b/extensions/libipt_SAME.c
@@ -9,7 +9,8 @@ enum {
 	O_TO_ADDR = 0,
 	O_NODST,
 	O_RANDOM,
-	F_RANDOM = 1 << O_RANDOM,
+	F_TO_ADDR = 1 << O_TO_ADDR,
+	F_RANDOM  = 1 << O_RANDOM,
 };
 
 static void SAME_help(void)
@@ -73,7 +74,6 @@ static void parse_to(const char *orig_arg, struct nf_nat_range *range)
 static void SAME_parse(struct xt_option_call *cb)
 {
 	struct ipt_same_info *mr = cb->data;
-	unsigned int count;
 
 	xtables_option_parse(cb);
 	switch (cb->entry->id) {
@@ -84,22 +84,25 @@ static void SAME_parse(struct xt_option_call *cb)
 				   "is %i ranges.\n",
 				   IPT_SAME_MAX_RANGE);
 		parse_to(cb->arg, &mr->range[mr->rangesize]);
-		/* WTF do we need this for? */
-		if (cb->xflags & F_RANDOM)
-			mr->range[mr->rangesize].flags 
-				|= IP_NAT_RANGE_PROTO_RANDOM;
 		mr->rangesize++;
 		break;
 	case O_NODST:
 		mr->info |= IPT_SAME_NODST;
 		break;
-	case O_RANDOM:
-		for (count=0; count < mr->rangesize; count++)
-			mr->range[count].flags |= IP_NAT_RANGE_PROTO_RANDOM;
-		break;
 	}
 }
 
+static void SAME_fcheck(struct xt_fcheck_call *cb)
+{
+	static const unsigned int f = F_TO_ADDR | F_RANDOM;
+	struct ipt_same_info *mr = cb->data;
+	unsigned int count;
+
+	if ((cb->xflags & f) == f)
+		for (count = 0; count < mr->rangesize; ++count)
+			mr->range[count].flags |= IP_NAT_RANGE_PROTO_RANDOM;
+}
+
 static void SAME_print(const void *ip, const struct xt_entry_target *target,
                        int numeric)
 {
@@ -166,6 +169,7 @@ static struct xtables_target same_tg_reg = {
 	.userspacesize	= XT_ALIGN(sizeof(struct ipt_same_info)),
 	.help		= SAME_help,
 	.x6_parse	= SAME_parse,
+	.x6_fcheck	= SAME_fcheck,
 	.print		= SAME_print,
 	.save		= SAME_save,
 	.x6_options	= SAME_opts,
diff --git a/extensions/libipt_SNAT.c b/extensions/libipt_SNAT.c
index 8023306..c8cb26d 100644
--- a/extensions/libipt_SNAT.c
+++ b/extensions/libipt_SNAT.c
@@ -174,21 +174,23 @@ static void SNAT_parse(struct xt_option_call *cb)
 					   "SNAT: Multiple --to-source not supported");
 		}
 		*cb->target = parse_to(cb->arg, portok, info);
-		/* WTF do we need this for?? */
-		if (cb->xflags & F_RANDOM)
-			info->mr.range[0].flags |= IP_NAT_RANGE_PROTO_RANDOM;
 		cb->xflags |= F_X_TO_SRC;
 		break;
-	case O_RANDOM:
-		if (cb->xflags & F_TO_SRC)
-			info->mr.range[0].flags |= IP_NAT_RANGE_PROTO_RANDOM;
-		break;
 	case O_PERSISTENT:
 		info->mr.range[0].flags |= IP_NAT_RANGE_PERSISTENT;
 		break;
 	}
 }
 
+static void SNAT_fcheck(struct xt_fcheck_call *cb)
+{
+	static const unsigned int f = F_TO_SRC | F_RANDOM;
+	struct nf_nat_multi_range *mr = cb->data;
+
+	if ((cb->xflags & f) == f)
+		mr->range[0].flags |= IP_NAT_RANGE_PROTO_RANDOM;
+}
+
 static void print_range(const struct nf_nat_range *r)
 {
 	if (r->flags & IP_NAT_RANGE_MAP_IPS) {
@@ -248,6 +250,7 @@ static struct xtables_target snat_tg_reg = {
 	.userspacesize	= XT_ALIGN(sizeof(struct nf_nat_multi_range)),
 	.help		= SNAT_help,
 	.x6_parse	= SNAT_parse,
+	.x6_fcheck	= SNAT_fcheck,
 	.print		= SNAT_print,
 	.save		= SNAT_save,
 	.x6_options	= SNAT_opts,
-- 
1.7.3.4

