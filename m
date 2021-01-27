Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A3CAC433DB
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Jan 2021 06:12:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FCBA2064B
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Jan 2021 06:12:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234911AbhA0GDQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Jan 2021 01:03:16 -0500
Received: from correo.us.es ([193.147.175.20]:41776 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236882AbhA0Dn6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Jan 2021 22:43:58 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E080EDA718
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Jan 2021 03:18:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D1B52DA704
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Jan 2021 03:18:35 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C6F3FDA73D; Wed, 27 Jan 2021 03:18:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 011A8DA704
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Jan 2021 03:18:32 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 27 Jan 2021 03:18:32 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id D34FA426CC84
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Jan 2021 03:18:32 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] netfilter: nftables: introduce table ownership
Date:   Wed, 27 Jan 2021 03:19:28 +0100
Message-Id: <20210127021928.2444-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

A userspace daemon like firewalld might need to monitor for netlink
updates to detect its ruleset removal by the (global) flush ruleset
command to ensure ruleset persistence. This adds extra complexity from
userspace and, for some little time, the firewall policy is not in
place.

This patch adds the NFT_MSG_SETOWNER netlink command which allows a
userspace program to own the table that creates in exclusivity.

Tables that are owned...

- can only be updated and removed by the owner, non-owners hit EPERM if
  they try to update it or remove it.
- are destroyed when the owner send the NFT_MSG_UNSETOWNER command,
  or the netlink socket is closed or the process is gone (implicit
  netlink socket closure).
- are skipped by the global flush ruleset command.
- are listed in the global ruleset.

The userspace process that sends the new NFT_MSG_SETOWNER command need
to leave open the netlink socket.

The NFTA_TABLE_OWNER netlink attribute specifies the netlink port ID to
identify the owner.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h        |   1 +
 include/uapi/linux/netfilter/nf_tables.h |  15 ++
 net/netfilter/nf_tables_api.c            | 235 +++++++++++++++++++----
 3 files changed, 210 insertions(+), 41 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 99d4571fef46..f626706035e2 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1104,6 +1104,7 @@ struct nft_table {
 	u16				family:6,
 					flags:8,
 					genmask:2;
+	u32				nlpid;
 	char				*name;
 	u16				udlen;
 	u8				*udata;
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index b1633e7ba529..e073aec8a8d9 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -97,6 +97,8 @@ enum nft_verdicts {
  * @NFT_MSG_NEWFLOWTABLE: add new flow table (enum nft_flowtable_attributes)
  * @NFT_MSG_GETFLOWTABLE: get flow table (enum nft_flowtable_attributes)
  * @NFT_MSG_DELFLOWTABLE: delete flow table (enum nft_flowtable_attributes)
+ * @NFT_MSG_SETOWNER: set ruleset owner (enum nft_owner_attributes)
+ * @NFT_MSG_UNSETOWNER: unset ruleset owner (enum nft_owner_attributes)
  */
 enum nf_tables_msg_types {
 	NFT_MSG_NEWTABLE,
@@ -124,6 +126,8 @@ enum nf_tables_msg_types {
 	NFT_MSG_NEWFLOWTABLE,
 	NFT_MSG_GETFLOWTABLE,
 	NFT_MSG_DELFLOWTABLE,
+	NFT_MSG_SETOWNER,
+	NFT_MSG_UNSETOWNER,
 	NFT_MSG_MAX,
 };
 
@@ -173,6 +177,7 @@ enum nft_table_flags {
  * @NFTA_TABLE_FLAGS: bitmask of enum nft_table_flags (NLA_U32)
  * @NFTA_TABLE_USE: number of chains in this table (NLA_U32)
  * @NFTA_TABLE_USERDATA: user data (NLA_BINARY)
+ * @NFTA_TABLE_OWNER: owner of this table through netlink portID (NLA_U32)
  */
 enum nft_table_attributes {
 	NFTA_TABLE_UNSPEC,
@@ -182,6 +187,7 @@ enum nft_table_attributes {
 	NFTA_TABLE_HANDLE,
 	NFTA_TABLE_PAD,
 	NFTA_TABLE_USERDATA,
+	NFTA_TABLE_OWNER,
 	__NFTA_TABLE_MAX
 };
 #define NFTA_TABLE_MAX		(__NFTA_TABLE_MAX - 1)
@@ -1483,6 +1489,15 @@ enum nft_gen_attributes {
 };
 #define NFTA_GEN_MAX		(__NFTA_GEN_MAX - 1)
 
+/**
+ * enum nft_owner_attributes - nf_tables netlink ownership
+ */
+enum nft_owner_attributes {
+	NFTA_OWNER_UNSPEC,
+	__NFTA_OWNER_MAX
+};
+#define NFTA_OWNER_MAX		(__NFTA_OWNER_MAX - 1)
+
 /*
  * enum nft_fib_attributes - nf_tables fib expression netlink attributes
  *
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1d76d07592bf..bfb5662c2383 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -30,8 +30,32 @@ static LIST_HEAD(nf_tables_objects);
 static LIST_HEAD(nf_tables_flowtables);
 static LIST_HEAD(nf_tables_destroy_list);
 static DEFINE_SPINLOCK(nf_tables_destroy_list_lock);
+static DEFINE_MUTEX(nf_tables_owner_mutex);
 static u64 table_handle;
 
+struct nft_owner {
+	struct list_head	list;
+	possible_net_t		net;
+	u32			nlpid;
+};
+
+static LIST_HEAD(nft_owner_list);
+
+static struct nft_owner *nf_tables_set_owner_find(struct net *net, u32 nlpid)
+{
+	struct nft_owner *owner;
+	struct net *owner_net;
+
+	list_for_each_entry(owner, &nft_owner_list, list) {
+		owner_net = read_pnet(&owner->net);
+		if (owner_net == net &&
+		    owner->nlpid == nlpid)
+			return owner;
+	}
+
+	return NULL;
+}
+
 enum {
 	NFT_VALIDATE_SKIP	= 0,
 	NFT_VALIDATE_NEED,
@@ -508,7 +532,7 @@ static int nft_delflowtable(struct nft_ctx *ctx,
 
 static struct nft_table *nft_table_lookup(const struct net *net,
 					  const struct nlattr *nla,
-					  u8 family, u8 genmask)
+					  u8 family, u8 genmask, u32 nlpid)
 {
 	struct nft_table *table;
 
@@ -519,8 +543,12 @@ static struct nft_table *nft_table_lookup(const struct net *net,
 				lockdep_is_held(&net->nft.commit_mutex)) {
 		if (!nla_strcmp(nla, table->name) &&
 		    table->family == family &&
-		    nft_active_genmask(table, genmask))
+		    nft_active_genmask(table, genmask)) {
+			if (nlpid && table->nlpid && table->nlpid != nlpid)
+				return ERR_PTR(-EPERM);
+
 			return table;
+		}
 	}
 
 	return ERR_PTR(-ENOENT);
@@ -679,6 +707,9 @@ static int nf_tables_fill_table_info(struct sk_buff *skb, struct net *net,
 	    nla_put_be64(skb, NFTA_TABLE_HANDLE, cpu_to_be64(table->handle),
 			 NFTA_TABLE_PAD))
 		goto nla_put_failure;
+	if (table->nlpid &&
+	    nla_put_be32(skb, NFTA_TABLE_OWNER, htonl(table->nlpid)))
+		goto nla_put_failure;
 
 	if (table->udata) {
 		if (nla_put(skb, NFTA_TABLE_USERDATA, table->udlen, table->udata))
@@ -821,7 +852,7 @@ static int nf_tables_gettable(struct net *net, struct sock *nlsk,
 		return nft_netlink_dump_start_rcu(nlsk, skb, nlh, &c);
 	}
 
-	table = nft_table_lookup(net, nla[NFTA_TABLE_NAME], family, genmask);
+	table = nft_table_lookup(net, nla[NFTA_TABLE_NAME], family, genmask, 0);
 	if (IS_ERR(table)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_TABLE_NAME]);
 		return PTR_ERR(table);
@@ -1003,7 +1034,8 @@ static int nf_tables_newtable(struct net *net, struct sock *nlsk,
 
 	lockdep_assert_held(&net->nft.commit_mutex);
 	attr = nla[NFTA_TABLE_NAME];
-	table = nft_table_lookup(net, attr, family, genmask);
+	table = nft_table_lookup(net, attr, family, genmask,
+				 NETLINK_CB(skb).portid);
 	if (IS_ERR(table)) {
 		if (PTR_ERR(table) != -ENOENT)
 			return PTR_ERR(table);
@@ -1054,6 +1086,9 @@ static int nf_tables_newtable(struct net *net, struct sock *nlsk,
 	table->flags = flags;
 	table->handle = ++table_handle;
 
+	if (nf_tables_set_owner_find(net, NETLINK_CB(skb).portid))
+		table->nlpid = NETLINK_CB(skb).portid;
+
 	nft_ctx_init(&ctx, net, skb, nlh, family, table, NULL, nla);
 	err = nft_trans_table_add(&ctx, NFT_MSG_NEWTABLE);
 	if (err < 0)
@@ -1160,6 +1195,9 @@ static int nft_flush(struct nft_ctx *ctx, int family)
 		if (!nft_is_active_next(ctx->net, table))
 			continue;
 
+		if (table->nlpid && table->nlpid != ctx->portid)
+			continue;
+
 		if (nla[NFTA_TABLE_NAME] &&
 		    nla_strcmp(nla[NFTA_TABLE_NAME], table->name) != 0)
 			continue;
@@ -1196,7 +1234,8 @@ static int nf_tables_deltable(struct net *net, struct sock *nlsk,
 		table = nft_table_lookup_byhandle(net, attr, genmask);
 	} else {
 		attr = nla[NFTA_TABLE_NAME];
-		table = nft_table_lookup(net, attr, family, genmask);
+		table = nft_table_lookup(net, attr, family, genmask,
+					 NETLINK_CB(skb).portid);
 	}
 
 	if (IS_ERR(table)) {
@@ -1579,7 +1618,7 @@ static int nf_tables_getchain(struct net *net, struct sock *nlsk,
 		return nft_netlink_dump_start_rcu(nlsk, skb, nlh, &c);
 	}
 
-	table = nft_table_lookup(net, nla[NFTA_CHAIN_TABLE], family, genmask);
+	table = nft_table_lookup(net, nla[NFTA_CHAIN_TABLE], family, genmask, 0);
 	if (IS_ERR(table)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_CHAIN_TABLE]);
 		return PTR_ERR(table);
@@ -2299,7 +2338,8 @@ static int nf_tables_newchain(struct net *net, struct sock *nlsk,
 
 	lockdep_assert_held(&net->nft.commit_mutex);
 
-	table = nft_table_lookup(net, nla[NFTA_CHAIN_TABLE], family, genmask);
+	table = nft_table_lookup(net, nla[NFTA_CHAIN_TABLE], family, genmask,
+				 NETLINK_CB(skb).portid);
 	if (IS_ERR(table)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_CHAIN_TABLE]);
 		return PTR_ERR(table);
@@ -2395,7 +2435,8 @@ static int nf_tables_delchain(struct net *net, struct sock *nlsk,
 	u32 use;
 	int err;
 
-	table = nft_table_lookup(net, nla[NFTA_CHAIN_TABLE], family, genmask);
+	table = nft_table_lookup(net, nla[NFTA_CHAIN_TABLE], family, genmask,
+				 NETLINK_CB(skb).portid);
 	if (IS_ERR(table)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_CHAIN_TABLE]);
 		return PTR_ERR(table);
@@ -3041,7 +3082,7 @@ static int nf_tables_getrule(struct net *net, struct sock *nlsk,
 		return nft_netlink_dump_start_rcu(nlsk, skb, nlh, &c);
 	}
 
-	table = nft_table_lookup(net, nla[NFTA_RULE_TABLE], family, genmask);
+	table = nft_table_lookup(net, nla[NFTA_RULE_TABLE], family, genmask, 0);
 	if (IS_ERR(table)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_TABLE]);
 		return PTR_ERR(table);
@@ -3179,7 +3220,8 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 
 	lockdep_assert_held(&net->nft.commit_mutex);
 
-	table = nft_table_lookup(net, nla[NFTA_RULE_TABLE], family, genmask);
+	table = nft_table_lookup(net, nla[NFTA_RULE_TABLE], family, genmask,
+				 NETLINK_CB(skb).portid);
 	if (IS_ERR(table)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_TABLE]);
 		return PTR_ERR(table);
@@ -3403,7 +3445,8 @@ static int nf_tables_delrule(struct net *net, struct sock *nlsk,
 	int family = nfmsg->nfgen_family, err = 0;
 	struct nft_ctx ctx;
 
-	table = nft_table_lookup(net, nla[NFTA_RULE_TABLE], family, genmask);
+	table = nft_table_lookup(net, nla[NFTA_RULE_TABLE], family, genmask,
+				 NETLINK_CB(skb).portid);
 	if (IS_ERR(table)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_TABLE]);
 		return PTR_ERR(table);
@@ -3584,7 +3627,7 @@ static int nft_ctx_init_from_setattr(struct nft_ctx *ctx, struct net *net,
 				     const struct nlmsghdr *nlh,
 				     const struct nlattr * const nla[],
 				     struct netlink_ext_ack *extack,
-				     u8 genmask)
+				     u8 genmask, u32 nlpid)
 {
 	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	int family = nfmsg->nfgen_family;
@@ -3592,7 +3635,7 @@ static int nft_ctx_init_from_setattr(struct nft_ctx *ctx, struct net *net,
 
 	if (nla[NFTA_SET_TABLE] != NULL) {
 		table = nft_table_lookup(net, nla[NFTA_SET_TABLE], family,
-					 genmask);
+					 genmask, nlpid);
 		if (IS_ERR(table)) {
 			NL_SET_BAD_ATTR(extack, nla[NFTA_SET_TABLE]);
 			return PTR_ERR(table);
@@ -4007,7 +4050,7 @@ static int nf_tables_getset(struct net *net, struct sock *nlsk,
 
 	/* Verify existence before starting dump */
 	err = nft_ctx_init_from_setattr(&ctx, net, skb, nlh, nla, extack,
-					genmask);
+					genmask, 0);
 	if (err < 0)
 		return err;
 
@@ -4236,7 +4279,8 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 	if (nla[NFTA_SET_EXPR] || nla[NFTA_SET_EXPRESSIONS])
 		desc.expr = true;
 
-	table = nft_table_lookup(net, nla[NFTA_SET_TABLE], family, genmask);
+	table = nft_table_lookup(net, nla[NFTA_SET_TABLE], family, genmask,
+				 NETLINK_CB(skb).portid);
 	if (IS_ERR(table)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_SET_TABLE]);
 		return PTR_ERR(table);
@@ -4413,7 +4457,7 @@ static int nf_tables_delset(struct net *net, struct sock *nlsk,
 		return -EINVAL;
 
 	err = nft_ctx_init_from_setattr(&ctx, net, skb, nlh, nla, extack,
-					genmask);
+					genmask, NETLINK_CB(skb).portid);
 	if (err < 0)
 		return err;
 
@@ -4608,14 +4652,14 @@ static int nft_ctx_init_from_elemattr(struct nft_ctx *ctx, struct net *net,
 				      const struct nlmsghdr *nlh,
 				      const struct nlattr * const nla[],
 				      struct netlink_ext_ack *extack,
-				      u8 genmask)
+				      u8 genmask, u32 nlpid)
 {
 	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	int family = nfmsg->nfgen_family;
 	struct nft_table *table;
 
 	table = nft_table_lookup(net, nla[NFTA_SET_ELEM_LIST_TABLE], family,
-				 genmask);
+				 genmask, nlpid);
 	if (IS_ERR(table)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_SET_ELEM_LIST_TABLE]);
 		return PTR_ERR(table);
@@ -5032,7 +5076,7 @@ static int nf_tables_getsetelem(struct net *net, struct sock *nlsk,
 	int rem, err = 0;
 
 	err = nft_ctx_init_from_elemattr(&ctx, net, skb, nlh, nla, extack,
-					 genmask);
+					 genmask, NETLINK_CB(skb).portid);
 	if (err < 0)
 		return err;
 
@@ -5612,7 +5656,7 @@ static int nf_tables_newsetelem(struct net *net, struct sock *nlsk,
 		return -EINVAL;
 
 	err = nft_ctx_init_from_elemattr(&ctx, net, skb, nlh, nla, extack,
-					 genmask);
+					 genmask, NETLINK_CB(skb).portid);
 	if (err < 0)
 		return err;
 
@@ -5820,7 +5864,7 @@ static int nf_tables_delsetelem(struct net *net, struct sock *nlsk,
 	int rem, err = 0;
 
 	err = nft_ctx_init_from_elemattr(&ctx, net, skb, nlh, nla, extack,
-					 genmask);
+					 genmask, NETLINK_CB(skb).portid);
 	if (err < 0)
 		return err;
 
@@ -6123,7 +6167,8 @@ static int nf_tables_newobj(struct net *net, struct sock *nlsk,
 	    !nla[NFTA_OBJ_DATA])
 		return -EINVAL;
 
-	table = nft_table_lookup(net, nla[NFTA_OBJ_TABLE], family, genmask);
+	table = nft_table_lookup(net, nla[NFTA_OBJ_TABLE], family, genmask,
+				 NETLINK_CB(skb).portid);
 	if (IS_ERR(table)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_OBJ_TABLE]);
 		return PTR_ERR(table);
@@ -6393,7 +6438,7 @@ static int nf_tables_getobj(struct net *net, struct sock *nlsk,
 	    !nla[NFTA_OBJ_TYPE])
 		return -EINVAL;
 
-	table = nft_table_lookup(net, nla[NFTA_OBJ_TABLE], family, genmask);
+	table = nft_table_lookup(net, nla[NFTA_OBJ_TABLE], family, genmask, 0);
 	if (IS_ERR(table)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_OBJ_TABLE]);
 		return PTR_ERR(table);
@@ -6467,7 +6512,8 @@ static int nf_tables_delobj(struct net *net, struct sock *nlsk,
 	    (!nla[NFTA_OBJ_NAME] && !nla[NFTA_OBJ_HANDLE]))
 		return -EINVAL;
 
-	table = nft_table_lookup(net, nla[NFTA_OBJ_TABLE], family, genmask);
+	table = nft_table_lookup(net, nla[NFTA_OBJ_TABLE], family, genmask,
+				 NETLINK_CB(skb).portid);
 	if (IS_ERR(table)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_OBJ_TABLE]);
 		return PTR_ERR(table);
@@ -6884,7 +6930,7 @@ static int nf_tables_newflowtable(struct net *net, struct sock *nlsk,
 		return -EINVAL;
 
 	table = nft_table_lookup(net, nla[NFTA_FLOWTABLE_TABLE], family,
-				 genmask);
+				 genmask, NETLINK_CB(skb).portid);
 	if (IS_ERR(table)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_FLOWTABLE_TABLE]);
 		return PTR_ERR(table);
@@ -7068,7 +7114,7 @@ static int nf_tables_delflowtable(struct net *net, struct sock *nlsk,
 		return -EINVAL;
 
 	table = nft_table_lookup(net, nla[NFTA_FLOWTABLE_TABLE], family,
-				 genmask);
+				 genmask, NETLINK_CB(skb).portid);
 	if (IS_ERR(table)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_FLOWTABLE_TABLE]);
 		return PTR_ERR(table);
@@ -7276,7 +7322,7 @@ static int nf_tables_getflowtable(struct net *net, struct sock *nlsk,
 		return -EINVAL;
 
 	table = nft_table_lookup(net, nla[NFTA_FLOWTABLE_TABLE], family,
-				 genmask);
+				 genmask, 0);
 	if (IS_ERR(table))
 		return PTR_ERR(table);
 
@@ -7492,6 +7538,92 @@ static int nf_tables_getgen(struct net *net, struct sock *nlsk,
 	return err;
 }
 
+static const struct nla_policy nft_owner_policy[NFTA_OWNER_MAX + 1] = {
+};
+
+static int nf_tables_set_owner(struct net *net, struct sock *nlsk,
+			       struct sk_buff *skb, const struct nlmsghdr *nlh,
+			       const struct nlattr * const nla[],
+			       struct netlink_ext_ack *extack)
+{
+	struct nft_owner *owner;
+
+	if (nf_tables_set_owner_find(net, NETLINK_CB(skb).portid))
+		return -EEXIST;
+
+	owner = kmalloc(sizeof(*owner), GFP_KERNEL);
+	if (!owner)
+		return -ENOMEM;
+
+	mutex_lock(&nf_tables_owner_mutex);
+	owner->nlpid = NETLINK_CB(skb).portid;
+	write_pnet(&owner->net, net);
+	list_add(&owner->list, &nft_owner_list);
+	mutex_unlock(&nf_tables_owner_mutex);
+
+	return 0;
+}
+
+static int nf_tables_unset_owner(struct net *net, struct sock *nlsk,
+			    struct sk_buff *skb, const struct nlmsghdr *nlh,
+			    const struct nlattr * const nla[],
+			    struct netlink_ext_ack *extack)
+{
+	struct nft_owner *owner;
+
+	mutex_lock(&nf_tables_owner_mutex);
+	owner = nf_tables_set_owner_find(net, NETLINK_CB(skb).portid);
+	if (!owner)
+		return -ENOENT;
+
+	list_del(&owner->list);
+	mutex_unlock(&nf_tables_owner_mutex);
+	kfree(owner);
+
+	return 0;
+}
+
+static void __nft_release_tables(struct net *net, u32 nlpid);
+
+static int nft_rcv_nl_event(struct notifier_block *this, unsigned long event,
+			    void *ptr)
+{
+	struct netlink_notify *n = ptr;
+	struct net *net = n->net;
+	struct nft_owner *owner;
+	bool found = false;
+
+	if (event != NETLINK_URELEASE || n->protocol != NETLINK_NETFILTER)
+		return NOTIFY_DONE;
+
+	mutex_lock(&nf_tables_owner_mutex);
+	list_for_each_entry(owner, &nft_owner_list, list) {
+		if (n->portid == owner->nlpid &&
+		    net == read_pnet(&owner->net)) {
+			found = true;
+			break;
+		}
+	}
+
+	if (!found) {
+		mutex_unlock(&nf_tables_owner_mutex);
+		return NOTIFY_DONE;
+	}
+	list_del(&owner->list);
+	mutex_unlock(&nf_tables_owner_mutex);
+	kfree(owner);
+
+	mutex_lock(&net->nft.commit_mutex);
+	__nft_release_tables(net, n->portid);
+	mutex_unlock(&net->nft.commit_mutex);
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block nft_nl_notifier = {
+	.notifier_call  = nft_rcv_nl_event,
+};
+
 static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 	[NFT_MSG_NEWTABLE] = {
 		.call_batch	= nf_tables_newtable,
@@ -7606,6 +7738,16 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.attr_count	= NFTA_FLOWTABLE_MAX,
 		.policy		= nft_flowtable_policy,
 	},
+	[NFT_MSG_SETOWNER] = {
+		.call		= nf_tables_set_owner,
+		.attr_count	= NFTA_OWNER_MAX,
+		.policy		= nft_owner_policy,
+	},
+	[NFT_MSG_UNSETOWNER] = {
+		.call		= nf_tables_unset_owner,
+		.attr_count	= NFTA_OWNER_MAX,
+		.policy		= nft_owner_policy,
+	},
 };
 
 static int nf_tables_validate(struct net *net)
@@ -8987,7 +9129,7 @@ int __nft_release_basechain(struct nft_ctx *ctx)
 }
 EXPORT_SYMBOL_GPL(__nft_release_basechain);
 
-static void __nft_release_tables(struct net *net)
+static void __nft_release_tables(struct net *net, u32 nlpid)
 {
 	struct nft_flowtable *flowtable, *nf;
 	struct nft_table *table, *nt;
@@ -9001,6 +9143,9 @@ static void __nft_release_tables(struct net *net)
 	};
 
 	list_for_each_entry_safe(table, nt, &net->nft.tables, list) {
+		if (nlpid && nlpid != table->nlpid)
+			continue;
+
 		ctx.family = table->family;
 
 		list_for_each_entry(chain, &table->chains, list)
@@ -9059,7 +9204,7 @@ static void __net_exit nf_tables_exit_net(struct net *net)
 	mutex_lock(&net->nft.commit_mutex);
 	if (!list_empty(&net->nft.commit_list))
 		__nf_tables_abort(net, NFNL_ABORT_NONE);
-	__nft_release_tables(net);
+	__nft_release_tables(net, 0);
 	mutex_unlock(&net->nft.commit_mutex);
 	WARN_ON_ONCE(!list_empty(&net->nft.tables));
 	WARN_ON_ONCE(!list_empty(&net->nft.module_list));
@@ -9082,43 +9227,50 @@ static int __init nf_tables_module_init(void)
 
 	err = nft_chain_filter_init();
 	if (err < 0)
-		goto err1;
+		goto err_chain_filter;
 
 	err = nf_tables_core_module_init();
 	if (err < 0)
-		goto err2;
+		goto err_core_module;
 
 	err = register_netdevice_notifier(&nf_tables_flowtable_notifier);
 	if (err < 0)
-		goto err3;
+		goto err_netdev_notifier;
 
 	err = rhltable_init(&nft_objname_ht, &nft_objname_ht_params);
 	if (err < 0)
-		goto err4;
+		goto err_rht_objname;
 
 	err = nft_offload_init();
 	if (err < 0)
-		goto err5;
+		goto err_offload;
+
+	err = netlink_register_notifier(&nft_nl_notifier);
+	if (err < 0)
+		goto err_netlink_notifier;
 
 	/* must be last */
 	err = nfnetlink_subsys_register(&nf_tables_subsys);
 	if (err < 0)
-		goto err6;
+		goto err_nfnl_subsys;
 
 	nft_chain_route_init();
 
 	return err;
-err6:
+
+err_nfnl_subsys:
+	netlink_unregister_notifier(&nft_nl_notifier);
+err_netlink_notifier:
 	nft_offload_exit();
-err5:
+err_offload:
 	rhltable_destroy(&nft_objname_ht);
-err4:
+err_rht_objname:
 	unregister_netdevice_notifier(&nf_tables_flowtable_notifier);
-err3:
+err_netdev_notifier:
 	nf_tables_core_module_exit();
-err2:
+err_core_module:
 	nft_chain_filter_fini();
-err1:
+err_chain_filter:
 	unregister_pernet_subsys(&nf_tables_net_ops);
 	return err;
 }
@@ -9126,6 +9278,7 @@ static int __init nf_tables_module_init(void)
 static void __exit nf_tables_module_exit(void)
 {
 	nfnetlink_subsys_unregister(&nf_tables_subsys);
+	netlink_unregister_notifier(&nft_nl_notifier);
 	nft_offload_exit();
 	unregister_netdevice_notifier(&nf_tables_flowtable_notifier);
 	nft_chain_filter_fini();
-- 
2.20.1

