From: Yuxuan Shui <yshuiv7@gmail.com>
Subject: [PATCH nftables] payload: use proto_unknown for raw protocol header
Date: Sat,  9 Aug 2014 21:01:17 +0800
Message-ID: <1407589277-15812-1-git-send-email-yshuiv7@gmail.com>
Cc: tomasz.bursztyka@linux.intel.com, netfilter-devel@vger.kernel.org,
	Yuxuan Shui <yshuiv7@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:42942 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbaHINB1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 9 Aug 2014 09:01:27 -0400
Received: by mail-pa0-f53.google.com with SMTP id rd3so8709842pab.12
        for <netfilter-devel@vger.kernel.org>; Sat, 09 Aug 2014 06:01:27 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Otherwise payload.desc would be NULL, which causes the crash in bug 915.

Signed-off-by: Yuxuan Shui <yshuiv7@gmail.com>
---
 src/payload.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/payload.c b/src/payload.c
index a1785a5..842b1ea 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -106,6 +106,7 @@ struct expr *payload_expr_alloc(const struct location *loc,
 	} else {
 		tmpl = &proto_unknown_template;
 		base = PROTO_BASE_INVALID;
+		desc = &proto_unknown;
 	}
 
 	expr = expr_alloc(loc, &payload_expr_ops, tmpl->dtype,
-- 
2.0.4

