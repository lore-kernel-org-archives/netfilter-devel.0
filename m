From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 10/21] libxt_conntrack: fix --ctproto 0 output
Date: Sun, 21 Aug 2011 13:09:25 +0200
Message-ID: <1313924977-8623-11-git-send-email-jengelh@medozas.de>
References: <1313924977-8623-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:38742 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754325Ab1HULJu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 21 Aug 2011 07:09:50 -0400
In-Reply-To: <1313924977-8623-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

First, we are missing XTOPT_PUT when trying to use XTOPT_POINTER.
(Next commit will flag this.) Furthermore, l4proto is of type
uint16_t, while XTTYPE_PROTOCOL wants a uint8_t so the idea would not
work => revert v1.4.12~1^2.

Bug goes back to v1.4.12~1^2.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_conntrack.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index a401125..060b947 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -93,8 +93,7 @@ static const struct xt_option_entry conntrack_mt_opts_v0[] = {
 	{.name = "ctstate", .id = O_CTSTATE, .type = XTTYPE_STRING,
 	 .flags = XTOPT_INVERT},
 	{.name = "ctproto", .id = O_CTPROTO, .type = XTTYPE_PROTOCOL,
-	 .flags = XTOPT_INVERT,
-	 XTOPT_POINTER(s, tuple[IP_CT_DIR_ORIGINAL].dst.protonum)},
+	 .flags = XTOPT_INVERT},
 	{.name = "ctorigsrc", .id = O_CTORIGSRC, .type = XTTYPE_HOST,
 	 .flags = XTOPT_INVERT},
 	{.name = "ctorigdst", .id = O_CTORIGDST, .type = XTTYPE_HOST,
@@ -117,7 +116,7 @@ static const struct xt_option_entry conntrack2_mt_opts[] = {
 	{.name = "ctstate", .id = O_CTSTATE, .type = XTTYPE_STRING,
 	 .flags = XTOPT_INVERT},
 	{.name = "ctproto", .id = O_CTPROTO, .type = XTTYPE_PROTOCOL,
-	 .flags = XTOPT_INVERT, XTOPT_POINTER(s, l4proto)},
+	 .flags = XTOPT_INVERT},
 	{.name = "ctorigsrc", .id = O_CTORIGSRC, .type = XTTYPE_HOSTMASK,
 	 .flags = XTOPT_INVERT},
 	{.name = "ctorigdst", .id = O_CTORIGDST, .type = XTTYPE_HOSTMASK,
@@ -149,7 +148,7 @@ static const struct xt_option_entry conntrack3_mt_opts[] = {
 	{.name = "ctstate", .id = O_CTSTATE, .type = XTTYPE_STRING,
 	 .flags = XTOPT_INVERT},
 	{.name = "ctproto", .id = O_CTPROTO, .type = XTTYPE_PROTOCOL,
-	 .flags = XTOPT_INVERT, XTOPT_POINTER(s, l4proto)},
+	 .flags = XTOPT_INVERT},
 	{.name = "ctorigsrc", .id = O_CTORIGSRC, .type = XTTYPE_HOSTMASK,
 	 .flags = XTOPT_INVERT},
 	{.name = "ctorigdst", .id = O_CTORIGDST, .type = XTTYPE_HOSTMASK,
@@ -336,6 +335,7 @@ static void conntrack_parse(struct xt_option_call *cb)
 			sinfo->invflags |= XT_CONNTRACK_STATE;
 		break;
 	case O_CTPROTO:
+		sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.protonum = cb->val.protocol;
 		if (cb->invert)
 			sinfo->invflags |= XT_CONNTRACK_PROTO;
 		if (sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.protonum == 0
@@ -400,6 +400,7 @@ static void conntrack_mt_parse(struct xt_option_call *cb, uint8_t rev)
 			info->invert_flags |= XT_CONNTRACK_STATE;
 		break;
 	case O_CTPROTO:
+		info->l4proto = cb->val.protocol;
 		if (info->l4proto == 0 && (info->invert_flags & XT_INV_PROTO))
 			xtables_error(PARAMETER_PROBLEM, "conntrack: rule would "
 			           "never match protocol");
-- 
1.7.3.4

