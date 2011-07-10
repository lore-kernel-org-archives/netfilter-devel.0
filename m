From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 6/6] libxt_conntrack: move more data into the xt_option_entry
Date: Sun, 10 Jul 2011 20:22:18 +0200
Message-ID: <1310322139-28505-7-git-send-email-jengelh@medozas.de>
References: <1310322139-28505-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:58436 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756347Ab1GJSW1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 10 Jul 2011 14:22:27 -0400
In-Reply-To: <1310322139-28505-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_conntrack.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index 96400a1..8e1777e 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -93,7 +93,8 @@ static const struct xt_option_entry conntrack_mt_opts_v0[] = {
 	{.name = "ctstate", .id = O_CTSTATE, .type = XTTYPE_STRING,
 	 .flags = XTOPT_INVERT},
 	{.name = "ctproto", .id = O_CTPROTO, .type = XTTYPE_PROTOCOL,
-	 .flags = XTOPT_INVERT},
+	 .flags = XTOPT_INVERT,
+	 XTOPT_POINTER(s, tuple[IP_CT_DIR_ORIGINAL].dst.protonum)},
 	{.name = "ctorigsrc", .id = O_CTORIGSRC, .type = XTTYPE_HOST,
 	 .flags = XTOPT_INVERT},
 	{.name = "ctorigdst", .id = O_CTORIGDST, .type = XTTYPE_HOST,
@@ -110,13 +111,13 @@ static const struct xt_option_entry conntrack_mt_opts_v0[] = {
 };
 #undef s
 
-#define s struct xt_conntrack_mtinfo2 /* for v1-v2 */
-/* We exploit the fact that v1-v2 share the same layout */
+#define s struct xt_conntrack_mtinfo2
+/* We exploit the fact that v1-v2 share the same xt_o_e layout */
 static const struct xt_option_entry conntrack2_mt_opts[] = {
 	{.name = "ctstate", .id = O_CTSTATE, .type = XTTYPE_STRING,
 	 .flags = XTOPT_INVERT},
 	{.name = "ctproto", .id = O_CTPROTO, .type = XTTYPE_PROTOCOL,
-	 .flags = XTOPT_INVERT},
+	 .flags = XTOPT_INVERT, XTOPT_POINTER(s, l4proto)},
 	{.name = "ctorigsrc", .id = O_CTORIGSRC, .type = XTTYPE_HOSTMASK,
 	 .flags = XTOPT_INVERT},
 	{.name = "ctorigdst", .id = O_CTORIGDST, .type = XTTYPE_HOSTMASK,
@@ -148,7 +149,7 @@ static const struct xt_option_entry conntrack3_mt_opts[] = {
 	{.name = "ctstate", .id = O_CTSTATE, .type = XTTYPE_STRING,
 	 .flags = XTOPT_INVERT},
 	{.name = "ctproto", .id = O_CTPROTO, .type = XTTYPE_PROTOCOL,
-	 .flags = XTOPT_INVERT},
+	 .flags = XTOPT_INVERT, XTOPT_POINTER(s, l4proto)},
 	{.name = "ctorigsrc", .id = O_CTORIGSRC, .type = XTTYPE_HOSTMASK,
 	 .flags = XTOPT_INVERT},
 	{.name = "ctorigdst", .id = O_CTORIGDST, .type = XTTYPE_HOSTMASK,
@@ -337,8 +338,6 @@ static void conntrack_parse(struct xt_option_call *cb)
 	case O_CTPROTO:
 		if (cb->invert)
 			sinfo->invflags |= XT_CONNTRACK_PROTO;
-		sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.protonum = cb->val.protocol;
-
 		if (sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.protonum == 0
 		    && (sinfo->invflags & XT_INV_PROTO))
 			xtables_error(PARAMETER_PROBLEM,
@@ -401,7 +400,6 @@ static void conntrack_mt_parse(struct xt_option_call *cb, uint8_t rev)
 			info->invert_flags |= XT_CONNTRACK_STATE;
 		break;
 	case O_CTPROTO:
-		info->l4proto = cb->val.protocol;
 		if (info->l4proto == 0 && (info->invert_flags & XT_INV_PROTO))
 			xtables_error(PARAMETER_PROBLEM, "conntrack: rule would "
 			           "never match protocol");
-- 
1.7.3.4

