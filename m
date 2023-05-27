Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63A92C83005
	for <netfilter-devel@archiver.kernel.org>; Sat, 27 May 2023 15:08:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232788AbjE0PIL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 27 May 2023 11:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232761AbjE0PIH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 27 May 2023 11:08:07 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E3073E4;
        Sat, 27 May 2023 08:08:06 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        sashal@kernel.org
Subject: [PATCH -stable,4.14 10/11] netfilter: nf_tables: do not allow SET_ID to refer to another table
Date:   Sat, 27 May 2023 18:08:10 +0200
Message-Id: <20230527160811.67779-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230527160811.67779-1-pablo@netfilter.org>
References: <20230527160811.67779-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

[ 470ee20e069a6d05ae549f7d0ef2bdbcee6a81b2 ]

When doing lookups for sets on the same batch by using its ID, a set from a
different table can be used.

Then, when the table is removed, a reference to the set may be kept after
the set is freed, leading to a potential use-after-free.

When looking for sets by ID, use the table that was used for the lookup by
name, and only return sets belonging to that same table.

This fixes CVE-2022-2586, also reported as ZDI-CAN-17470.

Reported-by: Team Orca of Sea Security (@seasecresponse)
Fixes: 958bee14d071 ("netfilter: nf_tables: use new transaction infrastructure to handle sets")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 2 ++
 net/netfilter/nf_tables_api.c     | 7 +++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 4eb90800fc2e..0d625ff7841a 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -381,6 +381,7 @@ void nft_unregister_set(struct nft_set_type *type);
  *
  *	@list: table set list node
  *	@bindings: list of set bindings
+ *	@table: table this set belongs to
  * 	@name: name of the set
  * 	@ktype: key type (numeric type defined by userspace, not used in the kernel)
  * 	@dtype: data type (verdict or numeric type defined by userspace)
@@ -404,6 +405,7 @@ void nft_unregister_set(struct nft_set_type *type);
 struct nft_set {
 	struct list_head		list;
 	struct list_head		bindings;
+	struct nft_table		*table;
 	char				*name;
 	u32				ktype;
 	u32				dtype;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 86913d53eead..345fa29f34b9 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2746,6 +2746,7 @@ static struct nft_set *nf_tables_set_lookup(const struct nft_table *table,
 }
 
 static struct nft_set *nf_tables_set_lookup_byid(const struct net *net,
+						 const struct nft_table *table,
 						 const struct nlattr *nla,
 						 u8 genmask)
 {
@@ -2757,6 +2758,7 @@ static struct nft_set *nf_tables_set_lookup_byid(const struct net *net,
 			struct nft_set *set = nft_trans_set(trans);
 
 			if (id == nft_trans_set_id(trans) &&
+			    set->table == table &&
 			    nft_active_genmask(set, genmask))
 				return set;
 		}
@@ -2777,7 +2779,7 @@ struct nft_set *nft_set_lookup(const struct net *net,
 		if (!nla_set_id)
 			return set;
 
-		set = nf_tables_set_lookup_byid(net, nla_set_id, genmask);
+		set = nf_tables_set_lookup_byid(net, table, nla_set_id, genmask);
 	}
 	return set;
 }
@@ -3272,6 +3274,7 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 	}
 
 	INIT_LIST_HEAD(&set->bindings);
+	set->table = table;
 	set->ops   = ops;
 	set->ktype = ktype;
 	set->klen  = desc.klen;
@@ -4209,7 +4212,7 @@ static int nf_tables_newsetelem(struct net *net, struct sock *nlsk,
 				   genmask);
 	if (IS_ERR(set)) {
 		if (nla[NFTA_SET_ELEM_LIST_SET_ID]) {
-			set = nf_tables_set_lookup_byid(net,
+			set = nf_tables_set_lookup_byid(net, ctx.table,
 					nla[NFTA_SET_ELEM_LIST_SET_ID],
 					genmask);
 		}
-- 
2.30.2

