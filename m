From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nft PATCH] payload: generate expression using big endian byteorder
Date: Fri, 12 Sep 2014 14:47:03 +0200
Message-ID: <1410526023-4370-1-git-send-email-alvaroneay@gmail.com>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:64510 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052AbaILMrC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Sep 2014 08:47:02 -0400
Received: by mail-wi0-f170.google.com with SMTP id em10so719877wid.3
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Sep 2014 05:46:56 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If we try to add a rule like:

nft add rule filter input udp length {55-9999}

nft shows:

BUG: invalid byte order conversion 0 => 2
nft: src/evaluate.c:153: byteorder_conversion_op: Assertion `0' failed.

Some of the existing payload fields rely on BYTEORDER_INVALID. Therefore, if we
try to convert it in evaluation step, we hit this bug.

The packets from the Internet are always in big endian. Therefore, we can create
all the payload expressions using big endian byteorder.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
This patch replaces the patch "src: add specific byteorder to the struct
proto_hdr_template"

[Tested with the rules]
* nft add rule ip filter input ip length 10-55 counter
* nft add rule ip filter input ip length 55-1000 counter
* nft add rule ip filter input udp length {0-100} udp dport 9999 counter
* nft add rule ip filter input udp length {100-9999} udp dport 9999 counter
* Tested with Ana Rey's tests.

 src/payload.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/payload.c b/src/payload.c
index 7297520..e705974 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -117,7 +117,7 @@ struct expr *payload_expr_alloc(const struct location *loc,
 	}
 
 	expr = expr_alloc(loc, &payload_expr_ops, tmpl->dtype,
-			  tmpl->dtype->byteorder, tmpl->len);
+			  BYTEORDER_BIG_ENDIAN, tmpl->len);
 	expr->flags |= flags;
 
 	expr->payload.desc   = desc;
-- 
1.7.10.4

