From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 1/2] netlink: use set location for IO errors
Date: Fri,  7 Mar 2014 11:12:47 +0100
Message-ID: <1394187168-18977-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36103 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbaCGKMz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Mar 2014 05:12:55 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We currently crash when reporting a permission denied error for set additions.
This is due to using the wrong location, fix by passing in the set location.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/netlink.c b/src/netlink.c
index b2bd3c5..daac64c 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -777,7 +777,7 @@ int netlink_add_set(struct netlink_ctx *ctx, const struct handle *h,
 
 	err = mnl_nft_set_add(nf_sock, nls, NLM_F_EXCL | NLM_F_ECHO);
 	if (err < 0)
-		netlink_io_error(ctx, NULL, "Could not add set: %s",
+		netlink_io_error(ctx, &set->location, "Could not add set: %s",
 				 strerror(errno));
 
 	set->handle.set =
-- 
1.8.5.3

