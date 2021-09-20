Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF88DC433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Sep 2021 23:21:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AD8D61211
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Sep 2021 23:21:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232690AbhITXWj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Sep 2021 19:22:39 -0400
Received: from mail.netfilter.org ([217.70.188.207]:39378 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240403AbhITXUj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Sep 2021 19:20:39 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 5C7F96005C
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Sep 2021 01:17:53 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 2/2] monitor: honor NLM_F_APPEND flag for rules
Date:   Tue, 21 Sep 2021 01:19:06 +0200
Message-Id: <20210920231906.113614-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Print 'add' or 'insert' according to this netlink flag.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: restrict 'insert' to rule commands.

 src/monitor.c | 40 ++++++++++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 14 deletions(-)

diff --git a/src/monitor.c b/src/monitor.c
index ffaa39b67304..ff69234bfab4 100644
--- a/src/monitor.c
+++ b/src/monitor.c
@@ -40,6 +40,12 @@
 #include <iface.h>
 #include <json.h>
 
+enum {
+	NFT_OF_EVENT_ADD,
+	NFT_OF_EVENT_INSERT,
+	NFT_OF_EVENT_DEL,
+};
+
 #define nft_mon_print(monh, ...) nft_print(&monh->ctx->nft->output, __VA_ARGS__)
 
 struct nftnl_table *netlink_table_alloc(const struct nlmsghdr *nlh)
@@ -120,17 +126,21 @@ struct nftnl_obj *netlink_obj_alloc(const struct nlmsghdr *nlh)
 	return nlo;
 }
 
-static uint32_t netlink_msg2nftnl_of(uint32_t msg)
+static uint32_t netlink_msg2nftnl_of(uint32_t type, uint16_t flags)
 {
-	switch (msg) {
+	switch (type) {
+	case NFT_MSG_NEWRULE:
+		if (flags & NLM_F_APPEND)
+			return NFT_OF_EVENT_ADD;
+		else
+			return NFT_OF_EVENT_INSERT;
 	case NFT_MSG_NEWTABLE:
 	case NFT_MSG_NEWCHAIN:
 	case NFT_MSG_NEWSET:
 	case NFT_MSG_NEWSETELEM:
-	case NFT_MSG_NEWRULE:
 	case NFT_MSG_NEWOBJ:
 	case NFT_MSG_NEWFLOWTABLE:
-		return NFTNL_OF_EVENT_NEW;
+		return NFT_OF_EVENT_ADD;
 	case NFT_MSG_DELTABLE:
 	case NFT_MSG_DELCHAIN:
 	case NFT_MSG_DELSET:
@@ -147,18 +157,20 @@ static uint32_t netlink_msg2nftnl_of(uint32_t msg)
 static const char *nftnl_of2cmd(uint32_t of)
 {
 	switch (of) {
-	case NFTNL_OF_EVENT_NEW:
+	case NFT_OF_EVENT_ADD:
 		return "add";
-	case NFTNL_OF_EVENT_DEL:
+	case NFT_OF_EVENT_INSERT:
+		return "insert";
+	case NFT_OF_EVENT_DEL:
 		return "delete";
 	default:
 		return "???";
 	}
 }
 
-static const char *netlink_msg2cmd(uint32_t msg)
+static const char *netlink_msg2cmd(uint32_t type, uint16_t flags)
 {
-	return nftnl_of2cmd(netlink_msg2nftnl_of(msg));
+	return nftnl_of2cmd(netlink_msg2nftnl_of(type, flags));
 }
 
 static void nlr_for_each_set(struct nftnl_rule *nlr,
@@ -206,7 +218,7 @@ static int netlink_events_table_cb(const struct nlmsghdr *nlh, int type,
 
 	nlt = netlink_table_alloc(nlh);
 	t = netlink_delinearize_table(monh->ctx, nlt);
-	cmd = netlink_msg2cmd(type);
+	cmd = netlink_msg2cmd(type, nlh->nlmsg_flags);
 
 	switch (monh->format) {
 	case NFTNL_OUTPUT_DEFAULT:
@@ -243,7 +255,7 @@ static int netlink_events_chain_cb(const struct nlmsghdr *nlh, int type,
 
 	nlc = netlink_chain_alloc(nlh);
 	c = netlink_delinearize_chain(monh->ctx, nlc);
-	cmd = netlink_msg2cmd(type);
+	cmd = netlink_msg2cmd(type, nlh->nlmsg_flags);
 
 	switch (monh->format) {
 	case NFTNL_OUTPUT_DEFAULT:
@@ -292,7 +304,7 @@ static int netlink_events_set_cb(const struct nlmsghdr *nlh, int type,
 		return MNL_CB_ERROR;
 	}
 	family = family2str(set->handle.family);
-	cmd = netlink_msg2cmd(type);
+	cmd = netlink_msg2cmd(type, nlh->nlmsg_flags);
 
 	switch (monh->format) {
 	case NFTNL_OUTPUT_DEFAULT:
@@ -394,7 +406,7 @@ static int netlink_events_setelem_cb(const struct nlmsghdr *nlh, int type,
 	table = nftnl_set_get_str(nls, NFTNL_SET_TABLE);
 	setname = nftnl_set_get_str(nls, NFTNL_SET_NAME);
 	family = nftnl_set_get_u32(nls, NFTNL_SET_FAMILY);
-	cmd = netlink_msg2cmd(type);
+	cmd = netlink_msg2cmd(type, nlh->nlmsg_flags);
 
 	set = set_lookup_global(family, table, setname, &monh->ctx->nft->cache);
 	if (set == NULL) {
@@ -482,7 +494,7 @@ static int netlink_events_obj_cb(const struct nlmsghdr *nlh, int type,
 		return MNL_CB_ERROR;
 	}
 	family = family2str(obj->handle.family);
-	cmd = netlink_msg2cmd(type);
+	cmd = netlink_msg2cmd(type, nlh->nlmsg_flags);
 
 	switch (monh->format) {
 	case NFTNL_OUTPUT_DEFAULT:
@@ -530,7 +542,7 @@ static int netlink_events_rule_cb(const struct nlmsghdr *nlh, int type,
 	r = netlink_delinearize_rule(monh->ctx, nlr);
 	nlr_for_each_set(nlr, rule_map_decompose_cb, NULL,
 			 &monh->ctx->nft->cache);
-	cmd = netlink_msg2cmd(type);
+	cmd = netlink_msg2cmd(type, nlh->nlmsg_flags);
 
 	switch (monh->format) {
 	case NFTNL_OUTPUT_DEFAULT:
-- 
2.30.2

