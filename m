From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] payload: don't decode past last valid template
Date: Thu, 15 Feb 2018 15:29:38 +0100
Message-ID: <20180215142938.9653-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:46474 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1033090AbeBOOgo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Feb 2018 09:36:44 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When trying to decode payload header fields, be sure to bail out
when having exhausted all available templates.

Otherwise, we allocate invalid payload expressions (no dataype,
header length of 0) and then crash when trying to print them.

Fixes: https://bugzilla.netfilter.org/show_bug.cgi?id=1226
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/payload.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/payload.c b/src/payload.c
index 60090accbcd8..63c9f7157e4e 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -618,6 +618,10 @@ void payload_expr_expand(struct list_head *list, struct expr *expr,
 
 	for (i = 1; i < array_size(desc->templates); i++) {
 		tmpl = &desc->templates[i];
+
+		if (tmpl->len == 0)
+			break;
+
 		if (tmpl->offset != expr->payload.offset)
 			continue;
 
-- 
2.16.1

