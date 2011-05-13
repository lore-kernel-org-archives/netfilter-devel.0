From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 03/12] libxt_policy: option table fixes, improved error tracking
Date: Fri, 13 May 2011 02:47:27 +0200
Message-ID: <1305247657-29158-4-git-send-email-jengelh@medozas.de>
References: <1305247657-29158-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54318 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272Ab1EMAtU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 May 2011 20:49:20 -0400
In-Reply-To: <1305247657-29158-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Most of the flags are multi-use in this extension. Also transfer
--next => --strict requirement to option table.

Furthermore, augment the error messages emitted from fcheck to contain
the policy element number, and elaborate on what an "empty policy
element" is.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_policy.c   |   35 ++++++++++++++++++++++++++---------
 extensions/libxt_policy.man |    7 ++++++-
 2 files changed, 32 insertions(+), 10 deletions(-)

diff --git a/extensions/libxt_policy.c b/extensions/libxt_policy.c
index a514246..7affd1b 100644
--- a/extensions/libxt_policy.c
+++ b/extensions/libxt_policy.c
@@ -16,7 +16,8 @@ enum {
 	O_MODE,
 	O_TUNNELSRC,
 	O_TUNNELDST,
-	O_NEXT
+	O_NEXT,
+	F_STRICT = 1 << O_STRICT,
 };
 
 static void policy_help(void)
@@ -28,6 +29,7 @@ static void policy_help(void)
 "  --pol none|ipsec		match policy\n"
 "  --strict 			match entire policy instead of single element\n"
 "				at any position\n"
+"These options may be used repeatedly, to describe policy elements:\n"
 "[!] --reqid reqid		match reqid\n"
 "[!] --spi spi			match SPI\n"
 "[!] --proto proto		match protocol (ah/esp/ipcomp)\n"
@@ -42,13 +44,20 @@ static const struct xt_option_entry policy_opts[] = {
 	 .flags = XTOPT_INVERT},
 	{.name = "pol", .id = O_POLICY, .type = XTTYPE_STRING},
 	{.name = "strict", .id = O_STRICT, .type = XTTYPE_NONE},
-	{.name = "reqid", .id = O_REQID, .type = XTTYPE_UINT32},
-	{.name = "spi", .id = O_SPI, .type = XTTYPE_UINT32},
-	{.name = "tunnel-src", .id = O_TUNNELSRC, .type = XTTYPE_HOSTMASK},
-	{.name = "tunnel-dst", .id = O_TUNNELDST, .type = XTTYPE_HOSTMASK},
-	{.name = "proto", .id = O_PROTO, .type = XTTYPE_STRING},
-	{.name = "mode", .id = O_MODE, .type = XTTYPE_STRING},
-	{.name = "next", .id = O_NEXT, .type = XTTYPE_NONE},
+	{.name = "reqid", .id = O_REQID, .type = XTTYPE_UINT32,
+	 .flags = XTOPT_MULTI | XTOPT_INVERT},
+	{.name = "spi", .id = O_SPI, .type = XTTYPE_UINT32,
+	 .flags = XTOPT_MULTI | XTOPT_INVERT},
+	{.name = "tunnel-src", .id = O_TUNNELSRC, .type = XTTYPE_HOSTMASK,
+	 .flags = XTOPT_MULTI | XTOPT_INVERT},
+	{.name = "tunnel-dst", .id = O_TUNNELDST, .type = XTTYPE_HOSTMASK,
+	 .flags = XTOPT_MULTI | XTOPT_INVERT},
+	{.name = "proto", .id = O_PROTO, .type = XTTYPE_STRING,
+	 .flags = XTOPT_MULTI | XTOPT_INVERT},
+	{.name = "mode", .id = O_MODE, .type = XTTYPE_STRING,
+	 .flags = XTOPT_MULTI | XTOPT_INVERT},
+	{.name = "next", .id = O_NEXT, .type = XTTYPE_NONE,
+	 .flags = XTOPT_MULTI, .also = F_STRICT},
 	XTOPT_TABLEEND,
 };
 
@@ -183,9 +192,14 @@ static void policy_check(struct xt_fcheck_call *cb)
 	} else
 		info->len++;	/* increase len by 1, no --next after last element */
 
+	/*
+	 * This is already represented with O_NEXT requiring F_STRICT in the
+	 * options table, but will keep this code as a comment for reference.
+	 *
 	if (!(info->flags & XT_POLICY_MATCH_STRICT) && info->len > 1)
 		xtables_error(PARAMETER_PROBLEM,
 		           "policy match: multiple elements but no --strict");
+	 */
 
 	for (i = 0; i < info->len; i++) {
 		e = &info->pol[i];
@@ -194,7 +208,10 @@ static void policy_check(struct xt_fcheck_call *cb)
 		    !(e->match.reqid || e->match.spi || e->match.saddr ||
 		      e->match.daddr || e->match.proto || e->match.mode))
 			xtables_error(PARAMETER_PROBLEM,
-			           "policy match: empty policy element");
+				"policy match: empty policy element %u. "
+				"--strict is in effect, but at least one of "
+				"reqid, spi, tunnel-src, tunnel-dst, proto or "
+				"mode is required.", i);
 
 		if ((e->match.saddr || e->match.daddr)
 		    && ((e->mode == XT_POLICY_MODE_TUNNEL && e->invert.mode) ||
diff --git a/extensions/libxt_policy.man b/extensions/libxt_policy.man
index 3500025..1b834fa 100644
--- a/extensions/libxt_policy.man
+++ b/extensions/libxt_policy.man
@@ -13,11 +13,16 @@ is valid in the
 chains.
 .TP
 \fB\-\-pol\fP {\fBnone\fP|\fBipsec\fP}
-Matches if the packet is subject to IPsec processing.
+Matches if the packet is subject to IPsec processing. \fB\-\-pol none\fP
+cannot be combined with \fB\-\-strict\fP.
 .TP
 \fB\-\-strict\fP
 Selects whether to match the exact policy or match if any rule of
 the policy matches the given policy.
+.PP
+For each policy element that is to be described, one can use one or more of
+the following options. When \fB\-\-strict\fP is in effect, at least one must be
+used per element.
 .TP
 [\fB!\fP] \fB\-\-reqid\fP \fIid\fP
 Matches the reqid of the policy rule. The reqid can be specified with
-- 
1.7.1

