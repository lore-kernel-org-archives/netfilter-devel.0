From: pablo@netfilter.org
Subject: [PATCH 2/2] netfilter: nf_tables: don't skip inactive rules and dump generation mask
Date: Fri,  1 Mar 2013 00:08:18 +0100
Message-ID: <1362092898-23306-2-git-send-email-pablo@netfilter.org>
References: <1362092898-23306-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, tomasz.bursztyka@linux.intel.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33355 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758001Ab3B1XIf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Feb 2013 18:08:35 -0500
In-Reply-To: <1362092898-23306-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

The user-space program gets the full rule-set, including active
and inactive ones plus the generation mask to know what the current
state of the rule is.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h |    1 +
 net/netfilter/nf_tables_api.c            |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 76b215f..66d5bde 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -101,6 +101,7 @@ enum nft_rule_attributes {
 	NFTA_RULE_EXPRESSIONS,
 	NFTA_RULE_FLAGS,
 	NFTA_RULE_COMPAT,
+	NFTA_RULE_GENMASK,
 	__NFTA_RULE_MAX
 };
 #define NFTA_RULE_MAX		(__NFTA_RULE_MAX - 1)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index beace28..fd2c8b6 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1287,6 +1287,8 @@ static int nf_tables_fill_rule_info(struct sk_buff *skb, u32 portid, u32 seq,
 		goto nla_put_failure;
 	if (nla_put_be64(skb, NFTA_RULE_HANDLE, cpu_to_be64(rule->handle)))
 		goto nla_put_failure;
+	if (nla_put_be32(skb, NFTA_RULE_GENMASK, htonl(rule->genmask)))
+		return -1;
 
 	list = nla_nest_start(skb, NFTA_RULE_EXPRESSIONS);
 	if (list == NULL)
@@ -1401,8 +1403,6 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 		list_for_each_entry(table, &afi->tables, list) {
 			list_for_each_entry(chain, &table->chains, list) {
 				list_for_each_entry(rule, &chain->rules, list) {
-					if (!nft_rule_is_active(net, rule))
-						goto cont;
 					if (idx < s_idx)
 						goto cont;
 					if (idx > s_idx)
-- 
1.7.10.4

