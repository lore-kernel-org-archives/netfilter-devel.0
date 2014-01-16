From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] src: add new --debug=mnl option to enable libmnl debugging
Date: Thu, 16 Jan 2014 17:56:23 +0100
Message-ID: <1389891383-5254-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45188 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204AbaAPQ4f (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jan 2014 11:56:35 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This allows you to dump the netlink message that is send via
libmnl.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/nftables.h |    1 +
 src/main.c         |    6 +++++-
 src/mnl.c          |    4 ++--
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/nftables.h b/include/nftables.h
index f989161..b36e10a 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -18,6 +18,7 @@ enum debug_level {
 	DEBUG_EVALUATION	= 0x4,
 	DEBUG_NETLINK		= 0x8,
 	DEBUG_SEGTREE		= 0x10,
+	DEBUG_MNL		= 0x20,
 };
 
 #define INCLUDE_PATHS_MAX	16
diff --git a/src/main.c b/src/main.c
index d78eea7..3f5dd04 100644
--- a/src/main.c
+++ b/src/main.c
@@ -111,7 +111,7 @@ static void show_help(const char *name)
 "  -a/--handle			Output rule handle.\n"
 "  -I/--includepath <directory>	Add <directory> to the paths searched for include files.\n"
 #ifdef DEBUG
-"  --debug <level [,level...]>	Specify debugging level (scanner, parser, eval, netlink, segtree, all)\n"
+"  --debug <level [,level...]>	Specify debugging level (scanner, parser, eval, netlink, mnl, segtree, all)\n"
 #endif
 "\n",
 	name);
@@ -139,6 +139,10 @@ static const struct {
 		.level		= DEBUG_NETLINK,
 	},
 	{
+		.name		= "mnl",
+		.level		= DEBUG_MNL,
+	},
+	{
 		.name		= "segtree",
 		.level		= DEBUG_SEGTREE,
 	},
diff --git a/src/mnl.c b/src/mnl.c
index a4a4c4a..1662500 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -39,7 +39,7 @@ mnl_talk(struct mnl_socket *nf_sock, const void *data, unsigned int len,
 	int ret;
 
 #ifdef DEBUG
-	if (debug_level & DEBUG_NETLINK)
+	if (debug_level & DEBUG_MNL)
 		mnl_nlmsg_fprintf(stdout, data, len, sizeof(struct nfgenmsg));
 #endif
 
@@ -207,7 +207,7 @@ static ssize_t mnl_nft_socket_sendmsg(const struct mnl_socket *nl)
 		iov[i].iov_len = mnl_nlmsg_batch_size(batch_page->batch);
 		i++;
 #ifdef DEBUG
-		if (debug_level & DEBUG_NETLINK) {
+		if (debug_level & DEBUG_MNL) {
 			mnl_nlmsg_fprintf(stdout,
 					  mnl_nlmsg_batch_head(batch_page->batch),
 					  mnl_nlmsg_batch_size(batch_page->batch),
-- 
1.7.10.4

