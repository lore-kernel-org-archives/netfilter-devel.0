From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2/6] netlink: style fixes
Date: Sun, 11 Jan 2015 08:09:38 +0000
Message-ID: <1420963782-21189-3-git-send-email-kaber@trash.net>
References: <1420963782-21189-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54795 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbbAKIJs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 Jan 2015 03:09:48 -0500
In-Reply-To: <1420963782-21189-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We include an empty line between variable definitions and code.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/netlink.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index ceb1d3f..cb22c30 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -48,10 +48,11 @@ const struct location netlink_location = {
 
 static struct mnl_socket *nfsock_open(void)
 {
-	struct mnl_socket *s = mnl_socket_open(NETLINK_NETFILTER);
+	struct mnl_socket *s;
+
+	s = mnl_socket_open(NETLINK_NETFILTER);
 	if (s == NULL)
 		netlink_open_error();
-
 	return s;
 }
 
@@ -1480,10 +1481,11 @@ struct nft_ruleset *netlink_dump_ruleset(struct netlink_ctx *ctx,
 
 static struct nft_table *netlink_table_alloc(const struct nlmsghdr *nlh)
 {
-	struct nft_table *nlt = nft_table_alloc();
+	struct nft_table *nlt;
+
+	nlt = nft_table_alloc();
 	if (nlt == NULL)
 		memory_allocation_error();
-
 	if (nft_table_nlmsg_parse(nlh, nlt) < 0)
 		netlink_abi_error();
 
@@ -1492,10 +1494,11 @@ static struct nft_table *netlink_table_alloc(const struct nlmsghdr *nlh)
 
 static struct nft_chain *netlink_chain_alloc(const struct nlmsghdr *nlh)
 {
-	struct nft_chain *nlc = nft_chain_alloc();
+	struct nft_chain *nlc;
+
+	nlc = nft_chain_alloc();
 	if (nlc == NULL)
 		memory_allocation_error();
-
 	if (nft_chain_nlmsg_parse(nlh, nlc) < 0)
 		netlink_abi_error();
 
@@ -1504,10 +1507,11 @@ static struct nft_chain *netlink_chain_alloc(const struct nlmsghdr *nlh)
 
 static struct nft_set *netlink_set_alloc(const struct nlmsghdr *nlh)
 {
-	struct nft_set *nls = nft_set_alloc();
+	struct nft_set *nls;
+
+	nls = nft_set_alloc();
 	if (nls == NULL)
 		memory_allocation_error();
-
 	if (nft_set_nlmsg_parse(nlh, nls) < 0)
 		netlink_abi_error();
 
@@ -1516,10 +1520,11 @@ static struct nft_set *netlink_set_alloc(const struct nlmsghdr *nlh)
 
 static struct nft_set *netlink_setelem_alloc(const struct nlmsghdr *nlh)
 {
-	struct nft_set *nls = nft_set_alloc();
+	struct nft_set *nls;
+
+	nls = nft_set_alloc();
 	if (nls == NULL)
 		memory_allocation_error();
-
 	if (nft_set_elems_nlmsg_parse(nlh, nls) < 0)
 		netlink_abi_error();
 
@@ -1528,10 +1533,11 @@ static struct nft_set *netlink_setelem_alloc(const struct nlmsghdr *nlh)
 
 static struct nft_rule *netlink_rule_alloc(const struct nlmsghdr *nlh)
 {
-	struct nft_rule *nlr = nft_rule_alloc();
+	struct nft_rule *nlr;
+
+	nlr = nft_rule_alloc();
 	if (nlr == NULL)
 		memory_allocation_error();
-
 	if (nft_rule_nlmsg_parse(nlh, nlr) < 0)
 		netlink_abi_error();
 
-- 
2.1.0

