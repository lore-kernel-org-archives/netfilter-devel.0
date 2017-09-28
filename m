From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH v2 1/5] rule: Use C99-style initializer in cache_init()
Date: Thu, 28 Sep 2017 17:17:41 +0200
Message-ID: <20170928151745.28426-2-phil@nwl.cc>
References: <20170928151745.28426-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>,
        Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:35272 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752059AbdI1PSC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Sep 2017 11:18:02 -0400
In-Reply-To: <20170928151745.28426-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/rule.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index 1e0558eaf0751..85505aecd5091 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -128,17 +128,16 @@ static int cache_init(struct mnl_socket *nf_sock, struct nft_cache *cache,
 	struct handle handle = {
 		.family = NFPROTO_UNSPEC,
 	};
-	struct netlink_ctx ctx;
+	struct netlink_ctx ctx = {
+		.list		= LIST_HEAD_INIT(ctx.list),
+		.nf_sock	= nf_sock,
+		.cache		= cache,
+		.msgs		= msgs,
+		.seqnum		= cache->seqnum++,
+		.debug_mask	= debug_mask,
+	};
 	int ret;
 
-	memset(&ctx, 0, sizeof(ctx));
-	init_list_head(&ctx.list);
-	ctx.nf_sock = nf_sock;
-	ctx.cache = cache;
-	ctx.msgs = msgs;
-	ctx.seqnum = cache->seqnum++;
-	ctx.debug_mask = debug_mask;
-
 	ret = cache_init_tables(&ctx, &handle, cache);
 	if (ret < 0)
 		return ret;
-- 
2.13.1

