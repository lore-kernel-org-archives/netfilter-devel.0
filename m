From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH] netlink: fix memory leaks
Date: Sun, 11 Jan 2015 08:00:09 +0000
Message-ID: <1420963209-19954-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54743 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbbAKIAN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 Jan 2015 03:00:13 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fix two memory leaks in netlink event monitor. Also fix a leak related
to all sets, the ->init expression is not freed.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/netlink.c | 5 ++++-
 src/rule.c    | 2 ++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/src/netlink.c b/src/netlink.c
index feaea19..5347372 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1724,8 +1724,10 @@ static int netlink_events_set_cb(const struct nlmsghdr *nlh, int type,
 		case NFT_MSG_NEWSET:
 			printf("add ");
 			set = netlink_delinearize_set(monh->ctx, nls);
-			if (set == NULL)
+			if (set == NULL) {
+				nft_set_free(nls);
 				return MNL_CB_ERROR;
+			}
 			set_print_plain(set);
 			set_free(set);
 			printf("\n");
@@ -1940,6 +1942,7 @@ static void netlink_events_cache_addset(struct netlink_mon_handler *monh,
 	t = table_lookup(&s->handle);
 	if (t == NULL) {
 		fprintf(stderr, "W: Unable to cache set: table not found.\n");
+		set_free(s);
 		goto out;
 	}
 
diff --git a/src/rule.c b/src/rule.c
index 9576664..dd39e8a 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -74,6 +74,8 @@ void set_free(struct set *set)
 {
 	if (--set->refcnt > 0)
 		return;
+	if (set->init != NULL)
+		expr_free(set->init);
 	handle_free(&set->handle);
 	xfree(set);
 }
-- 
2.1.0

