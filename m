From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 3/4] proto_find_num: Avoid potential null pointer dereference
Date: Fri, 12 Aug 2016 18:00:09 +0200
Message-ID: <1471017610-3473-4-git-send-email-phil@nwl.cc>
References: <1471017610-3473-1-git-send-email-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:57217 "EHLO mail.nwl.cc"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953AbcHLQA3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Aug 2016 12:00:29 -0400
In-Reply-To: <1471017610-3473-1-git-send-email-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When being called from stmt_evaluate_reset(), it seems that 'base' might
actually be NULL, so better make sure it is not in proto_find_num().

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
This might be invalid in that if 'base' is NULL, ctx->pctx.family is
always either NFPROTO_INET or NFPROTO_BRIDGE. But if so, the
corresponding check in stmt_evaluate_reset() may be simplified to just
having 'base' falling back to &proto_inet_service.
---
 src/proto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/proto.c b/src/proto.c
index 4c12977cef082..d9210afeaf256 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -75,7 +75,7 @@ int proto_find_num(const struct proto_desc *base,
 {
 	unsigned int i;
 
-	for (i = 0; i < array_size(base->protocols); i++) {
+	for (i = 0; base && i < array_size(base->protocols); i++) {
 		if (base->protocols[i].desc == desc)
 			return base->protocols[i].num;
 	}
-- 
2.8.2

