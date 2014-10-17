From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nft PATCH 2/4 v2] evaluate: fix a crash if we check the transport protocol
Date: Fri, 17 Oct 2014 14:24:35 +0200
Message-ID: <1413548677-10287-2-git-send-email-alvaroneay@gmail.com>
References: <1413548677-10287-1-git-send-email-alvaroneay@gmail.com>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:54881 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbaJQMY0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Oct 2014 08:24:26 -0400
Received: by mail-wg0-f52.google.com with SMTP id a1so783557wgh.23
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Oct 2014 05:24:25 -0700 (PDT)
In-Reply-To: <1413548677-10287-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Example:

nft add rule inet filter input meta l4proto udp reject with tcp reset

When we check if the transport protocol is tcp, we use the network context.
If we don't have this network context, we have a crash.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
[no changes in v2]

 src/evaluate.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index 4b7bda9..2f71e9b 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1339,6 +1339,13 @@ static int stmt_evaluate_reset(struct eval_ctx *ctx, struct stmt *stmt)
 	if (desc == NULL)
 		return 0;
 
+	if (base == NULL) {
+		if (strcmp(desc->name, "tcp") == 0)
+			return 0;
+		else
+			return stmt_error(ctx, stmt,
+				 "you cannot use tcp reset with this protocol");
+	}
 	protonum = proto_find_num(base, desc);
 	switch (protonum) {
 	case IPPROTO_TCP:
-- 
1.7.10.4

