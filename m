From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 2/4] netlink: Fix segfault when using --echo flag
Date: Tue, 15 Aug 2017 01:43:03 +0200
Message-ID: <20170814234305.2829-3-phil@nwl.cc>
References: <20170814234305.2829-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:33857 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752651AbdHNXna (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Aug 2017 19:43:30 -0400
In-Reply-To: <20170814234305.2829-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Commit 07b45939972eb ("src: introduce struct nft_cache") added cache
pointer to struct netlink_mon_handler and the code assumes it is never
NULL. Therefore initialize it in the dummy version of
netlink_mon_handler in netlink_echo_callback().

Fixes: b99c4d072d996 ("Implement --echo option")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/netlink.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/src/netlink.c b/src/netlink.c
index 8aef8d9ab4070..f631c26b2b9ca 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -3075,12 +3075,14 @@ static int netlink_events_cb(const struct nlmsghdr *nlh, void *data)
 
 int netlink_echo_callback(const struct nlmsghdr *nlh, void *data)
 {
+	struct netlink_ctx *ctx = data;
 	struct netlink_mon_handler echo_monh = {
 		.format = NFTNL_OUTPUT_DEFAULT,
-		.ctx = data,
+		.ctx = ctx,
 		.loc = &netlink_location,
 		.monitor_flags = 0xffffffff,
 		.cache_needed = true,
+		.cache = ctx->cache,
 	};
 
 	if (!echo_monh.ctx->octx->echo)
-- 
2.13.1

