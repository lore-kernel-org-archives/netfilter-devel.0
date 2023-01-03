Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0DC9C3DA7D
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Jan 2023 21:58:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbjACV6c (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Jan 2023 16:58:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjACV6b (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Jan 2023 16:58:31 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BD2AF14D29
        for <netfilter-devel@vger.kernel.org>; Tue,  3 Jan 2023 13:58:30 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnftnl] chain: relax logic to build NFTA_CHAIN_HOOK
Date:   Tue,  3 Jan 2023 22:58:23 +0100
Message-Id: <20230103215823.1933-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The logic to build NFTA_CHAIN_HOOK enforces the presence of the hook
number and priority to include the devices. Relax this to allow for
incremental device updates.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/chain.c | 41 +++++++++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 16 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index cb5ec6b46219..dcfcd0456734 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -486,40 +486,49 @@ const char *const *nftnl_chain_get_array(const struct nftnl_chain *c, uint16_t a
 EXPORT_SYMBOL(nftnl_chain_nlmsg_build_payload);
 void nftnl_chain_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nftnl_chain *c)
 {
+	struct nlattr *nest = NULL;
 	int i;
 
 	if (c->flags & (1 << NFTNL_CHAIN_TABLE))
 		mnl_attr_put_strz(nlh, NFTA_CHAIN_TABLE, c->table);
 	if (c->flags & (1 << NFTNL_CHAIN_NAME))
 		mnl_attr_put_strz(nlh, NFTA_CHAIN_NAME, c->name);
-	if ((c->flags & (1 << NFTNL_CHAIN_HOOKNUM)) &&
-	    (c->flags & (1 << NFTNL_CHAIN_PRIO))) {
-		struct nlattr *nest;
 
+	if ((c->flags & (1 << NFTNL_CHAIN_HOOKNUM)) ||
+	    (c->flags & (1 << NFTNL_CHAIN_PRIO)) ||
+	    (c->flags & (1 << NFTNL_CHAIN_DEV)) ||
+	    (c->flags & (1 << NFTNL_CHAIN_DEVICES)))
 		nest = mnl_attr_nest_start(nlh, NFTA_CHAIN_HOOK);
+
+	if ((c->flags & (1 << NFTNL_CHAIN_HOOKNUM)))
 		mnl_attr_put_u32(nlh, NFTA_HOOK_HOOKNUM, htonl(c->hooknum));
+	if ((c->flags & (1 << NFTNL_CHAIN_PRIO)))
 		mnl_attr_put_u32(nlh, NFTA_HOOK_PRIORITY, htonl(c->prio));
-		if (c->flags & (1 << NFTNL_CHAIN_DEV))
-			mnl_attr_put_strz(nlh, NFTA_HOOK_DEV, c->dev);
-		else if (c->flags & (1 << NFTNL_CHAIN_DEVICES)) {
-			struct nlattr *nest_dev;
 
-			nest_dev = mnl_attr_nest_start(nlh, NFTA_HOOK_DEVS);
-			for (i = 0; i < c->dev_array_len; i++)
-				mnl_attr_put_strz(nlh, NFTA_DEVICE_NAME,
-						  c->dev_array[i]);
-			mnl_attr_nest_end(nlh, nest_dev);
-		}
-		mnl_attr_nest_end(nlh, nest);
+	if (c->flags & (1 << NFTNL_CHAIN_DEV))
+		mnl_attr_put_strz(nlh, NFTA_HOOK_DEV, c->dev);
+	else if (c->flags & (1 << NFTNL_CHAIN_DEVICES)) {
+		struct nlattr *nest_dev;
+
+		nest_dev = mnl_attr_nest_start(nlh, NFTA_HOOK_DEVS);
+		for (i = 0; i < c->dev_array_len; i++)
+			mnl_attr_put_strz(nlh, NFTA_DEVICE_NAME,
+					  c->dev_array[i]);
+		mnl_attr_nest_end(nlh, nest_dev);
 	}
+
+	if ((c->flags & (1 << NFTNL_CHAIN_HOOKNUM)) ||
+	    (c->flags & (1 << NFTNL_CHAIN_PRIO)) ||
+	    (c->flags & (1 << NFTNL_CHAIN_DEV)) ||
+	    (c->flags & (1 << NFTNL_CHAIN_DEVICES)))
+		mnl_attr_nest_end(nlh, nest);
+
 	if (c->flags & (1 << NFTNL_CHAIN_POLICY))
 		mnl_attr_put_u32(nlh, NFTA_CHAIN_POLICY, htonl(c->policy));
 	if (c->flags & (1 << NFTNL_CHAIN_USE))
 		mnl_attr_put_u32(nlh, NFTA_CHAIN_USE, htonl(c->use));
 	if ((c->flags & (1 << NFTNL_CHAIN_PACKETS)) &&
 	    (c->flags & (1 << NFTNL_CHAIN_BYTES))) {
-		struct nlattr *nest;
-
 		nest = mnl_attr_nest_start(nlh, NFTA_CHAIN_COUNTERS);
 		mnl_attr_put_u64(nlh, NFTA_COUNTER_PACKETS, be64toh(c->packets));
 		mnl_attr_put_u64(nlh, NFTA_COUNTER_BYTES, be64toh(c->bytes));
-- 
2.30.2

