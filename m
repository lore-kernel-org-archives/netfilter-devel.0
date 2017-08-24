From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH] Fix debug_proto_ctx()
Date: Thu, 24 Aug 2017 18:04:18 +0200
Message-ID: <20170824160418.19507-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:50075 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753405AbdHXQEb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Aug 2017 12:04:31 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Debug mask check was done against wrong flag, causing protocol context
debug output being printed when only --debug=netlink was given.

Fixes: be441e1ffdc24 ("src: add debugging mask to context structure")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
This led to almost all testcases in tests/py to fail due to differing
output when checking netlink messages. Pablo, did you just forget to run
the testsuite, or is there a bug in your environment somewhere so this
could slip through?
---
 src/proto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/proto.c b/src/proto.c
index 5bd50b7b96195..a72c10c3a1680 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -143,7 +143,7 @@ static void proto_ctx_debug(const struct proto_ctx *ctx, enum proto_bases base,
 {
 	unsigned int i;
 
-	if (!(debug_mask & DEBUG_NETLINK))
+	if (!(debug_mask & DEBUG_PROTO_CTX))
 		return;
 
 	pr_debug("update %s protocol context:\n", proto_base_names[base]);
-- 
2.13.1

