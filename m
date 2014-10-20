From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nft PATCH 4/4 v3] evaluate: fix a crash if we check the transport protocol is tcp
Date: Tue, 21 Oct 2014 01:29:40 +0200
Message-ID: <1413847780-10149-4-git-send-email-alvaroneay@gmail.com>
References: <1413847780-10149-1-git-send-email-alvaroneay@gmail.com>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:64961 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044AbaJTX31 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Oct 2014 19:29:27 -0400
Received: by mail-wi0-f178.google.com with SMTP id r20so343602wiv.5
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Oct 2014 16:29:26 -0700 (PDT)
In-Reply-To: <1413847780-10149-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Example:

nft add rule inet filter input meta l4proto udp reject with tcp reset

If we try to check if the transport protocol is tcp, we use the network context.
If we don't have this network context, we have a crash.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
[changes in v3]
 * Use the proto_inet_service proto in cases that we don't have network context

 src/evaluate.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index 8b19baf..fc3b1a2 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1365,6 +1365,12 @@ static int stmt_evaluate_reset(struct eval_ctx *ctx, struct stmt *stmt)
 	if (desc == NULL)
 		return 0;
 
+	/* If we don't have network context in inet or bridge */
+	if (base == NULL &&
+	    (ctx->pctx.family == NFPROTO_INET ||
+	     ctx->pctx.family == NFPROTO_BRIDGE))
+		base = &proto_inet_service;
+
 	protonum = proto_find_num(base, desc);
 	switch (protonum) {
 	case IPPROTO_TCP:
-- 
1.7.10.4

