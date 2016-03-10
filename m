From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH libnftnl] trace: fix missing NFTNL_TRACE_JUMP_TARGET in nftnl_trace_get_str()
Date: Thu, 10 Mar 2016 13:16:50 +0100
Message-ID: <1457612210-10975-1-git-send-email-kaber@trash.net>
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44574 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbcCJMQ6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Mar 2016 07:16:58 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/trace.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/trace.c b/src/trace.c
index 9655f0a..849003b 100644
--- a/src/trace.c
+++ b/src/trace.c
@@ -208,6 +208,7 @@ const char *nftnl_trace_get_str(const struct nftnl_trace *trace, uint16_t type)
 	switch (type) {
 	case NFTNL_TRACE_CHAIN: return trace->chain;
 	case NFTNL_TRACE_TABLE: return trace->table;
+	case NFTNL_TRACE_JUMP_TARGET: return trace->jump_target;
 	default: break;
 	}
 	return NULL;
-- 
2.5.0

