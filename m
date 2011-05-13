From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 05/12] libxt_policy: use XTTYPE_PROTOCOL type
Date: Fri, 13 May 2011 02:47:29 +0200
Message-ID: <1305247657-29158-6-git-send-email-jengelh@medozas.de>
References: <1305247657-29158-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54327 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759031Ab1EMAtY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 May 2011 20:49:24 -0400
In-Reply-To: <1305247657-29158-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_policy.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_policy.c b/extensions/libxt_policy.c
index 7affd1b..97722d6 100644
--- a/extensions/libxt_policy.c
+++ b/extensions/libxt_policy.c
@@ -52,7 +52,7 @@ static const struct xt_option_entry policy_opts[] = {
 	 .flags = XTOPT_MULTI | XTOPT_INVERT},
 	{.name = "tunnel-dst", .id = O_TUNNELDST, .type = XTTYPE_HOSTMASK,
 	 .flags = XTOPT_MULTI | XTOPT_INVERT},
-	{.name = "proto", .id = O_PROTO, .type = XTTYPE_STRING,
+	{.name = "proto", .id = O_PROTO, .type = XTTYPE_PROTOCOL,
 	 .flags = XTOPT_MULTI | XTOPT_INVERT},
 	{.name = "mode", .id = O_MODE, .type = XTTYPE_STRING,
 	 .flags = XTOPT_MULTI | XTOPT_INVERT},
@@ -143,7 +143,7 @@ static void policy_parse(struct xt_option_call *cb)
 		if (e->match.proto)
 			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: double --proto option");
-		e->proto = xtables_parse_protocol(cb->arg);
+		e->proto = cb->val.protocol;
 		if (e->proto != IPPROTO_AH && e->proto != IPPROTO_ESP &&
 		    e->proto != IPPROTO_COMP)
 			xtables_error(PARAMETER_PROBLEM,
-- 
1.7.1

