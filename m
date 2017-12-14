From: Phil Sutter <phil@nwl.cc>
Subject: [libnftnl PATCH 4/6] src/ruleset: Avoid reading garbage in nftnl_ruleset_cb()
Date: Thu, 14 Dec 2017 20:40:23 +0100
Message-ID: <20171214194025.21334-5-phil@nwl.cc>
References: <20171214194025.21334-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:58070 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751952AbdLNTkw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 Dec 2017 14:40:52 -0500
In-Reply-To: <20171214194025.21334-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If nftnl_ruleset_json_parse() is called with arg == NULL, ctx.data is
left uninitialized and will later be used in nftnl_ruleset_cb(). Avoid
this by using a C99-style initializer for 'ctx' which sets all omitted
fields to zero.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/ruleset.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/src/ruleset.c b/src/ruleset.c
index 3de9b87283292..cf86ca68a51f3 100644
--- a/src/ruleset.c
+++ b/src/ruleset.c
@@ -519,11 +519,11 @@ static int nftnl_ruleset_json_parse(const void *json,
 	json_error_t error;
 	int i, len;
 	const char *key;
-	struct nftnl_parse_ctx ctx;
-
-	ctx.cb = cb;
-	ctx.format = type;
-	ctx.flags = 0;
+	struct nftnl_parse_ctx ctx = {
+		.cb = cb,
+		.format = type,
+		.flags = 0,
+	};
 
 	ctx.set_list = nftnl_set_list_alloc();
 	if (ctx.set_list == NULL)
-- 
2.13.1

