Return-Path: <SRS0=7yxH=7C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98ACDC433E1
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 May 2020 18:17:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85ECF20671
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 May 2020 18:17:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbgETSRB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 May 2020 14:17:01 -0400
Received: from correo.us.es ([193.147.175.20]:43496 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726754AbgETSRB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 May 2020 14:17:01 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2B53CEBAC0
        for <netfilter-devel@vger.kernel.org>; Wed, 20 May 2020 20:16:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1CC1EDA711
        for <netfilter-devel@vger.kernel.org>; Wed, 20 May 2020 20:16:59 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 127C6DA710; Wed, 20 May 2020 20:16:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1815CDA701
        for <netfilter-devel@vger.kernel.org>; Wed, 20 May 2020 20:16:57 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 20 May 2020 20:16:57 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 0522C42EF42A
        for <netfilter-devel@vger.kernel.org>; Wed, 20 May 2020 20:16:56 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 1/7] netfilter: nf_tables: generalise flowtable hook parsing
Date:   Wed, 20 May 2020 20:16:46 +0200
Message-Id: <20200520181652.30285-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200520181652.30285-1-pablo@netfilter.org>
References: <20200520181652.30285-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Update nft_flowtable_parse_hook() to take the flowtable hook list as
parameter. This allows to reuse this function to update the hooks.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 36 ++++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3558e76e2733..87945b4a6789 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6178,21 +6178,30 @@ nft_flowtable_lookup_byhandle(const struct nft_table *table,
        return ERR_PTR(-ENOENT);
 }
 
+struct nft_flowtable_hook {
+	u32			num;
+	int			priority;
+	struct list_head	list;
+};
+
 static const struct nla_policy nft_flowtable_hook_policy[NFTA_FLOWTABLE_HOOK_MAX + 1] = {
 	[NFTA_FLOWTABLE_HOOK_NUM]	= { .type = NLA_U32 },
 	[NFTA_FLOWTABLE_HOOK_PRIORITY]	= { .type = NLA_U32 },
 	[NFTA_FLOWTABLE_HOOK_DEVS]	= { .type = NLA_NESTED },
 };
 
-static int nf_tables_flowtable_parse_hook(const struct nft_ctx *ctx,
-					  const struct nlattr *attr,
-					  struct nft_flowtable *flowtable)
+static int nft_flowtable_parse_hook(const struct nft_ctx *ctx,
+				    const struct nlattr *attr,
+				    struct nft_flowtable_hook *flowtable_hook,
+				    struct nf_flowtable *ft)
 {
 	struct nlattr *tb[NFTA_FLOWTABLE_HOOK_MAX + 1];
 	struct nft_hook *hook;
 	int hooknum, priority;
 	int err;
 
+	INIT_LIST_HEAD(&flowtable_hook->list);
+
 	err = nla_parse_nested_deprecated(tb, NFTA_FLOWTABLE_HOOK_MAX, attr,
 					  nft_flowtable_hook_policy, NULL);
 	if (err < 0)
@@ -6211,19 +6220,19 @@ static int nf_tables_flowtable_parse_hook(const struct nft_ctx *ctx,
 
 	err = nf_tables_parse_netdev_hooks(ctx->net,
 					   tb[NFTA_FLOWTABLE_HOOK_DEVS],
-					   &flowtable->hook_list);
+					   &flowtable_hook->list);
 	if (err < 0)
 		return err;
 
-	flowtable->hooknum		= hooknum;
-	flowtable->data.priority	= priority;
+	flowtable_hook->priority	= priority;
+	flowtable_hook->num		= hooknum;
 
-	list_for_each_entry(hook, &flowtable->hook_list, list) {
+	list_for_each_entry(hook, &flowtable_hook->list, list) {
 		hook->ops.pf		= NFPROTO_NETDEV;
 		hook->ops.hooknum	= hooknum;
 		hook->ops.priority	= priority;
-		hook->ops.priv		= &flowtable->data;
-		hook->ops.hook		= flowtable->data.type->hook;
+		hook->ops.priv		= ft;
+		hook->ops.hook		= ft->type->hook;
 	}
 
 	return err;
@@ -6336,6 +6345,7 @@ static int nf_tables_newflowtable(struct net *net, struct sock *nlsk,
 				  struct netlink_ext_ack *extack)
 {
 	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
+	struct nft_flowtable_hook flowtable_hook;
 	const struct nf_flowtable_type *type;
 	u8 genmask = nft_genmask_next(net);
 	int family = nfmsg->nfgen_family;
@@ -6409,11 +6419,15 @@ static int nf_tables_newflowtable(struct net *net, struct sock *nlsk,
 	if (err < 0)
 		goto err3;
 
-	err = nf_tables_flowtable_parse_hook(&ctx, nla[NFTA_FLOWTABLE_HOOK],
-					     flowtable);
+	err = nft_flowtable_parse_hook(&ctx, nla[NFTA_FLOWTABLE_HOOK],
+				       &flowtable_hook, &flowtable->data);
 	if (err < 0)
 		goto err4;
 
+	list_splice(&flowtable_hook.list, &flowtable->hook_list);
+	flowtable->data.priority = flowtable_hook.priority;
+	flowtable->hooknum = flowtable_hook.num;
+
 	err = nft_register_flowtable_net_hooks(ctx.net, table, flowtable);
 	if (err < 0) {
 		list_for_each_entry_safe(hook, next, &flowtable->hook_list, list) {
-- 
2.20.1

