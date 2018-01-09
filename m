From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 4/7] netfilter: nf_tables: remove struct nft_af_info parameter in nf_tables_chain_type_lookup()
Date: Tue,  9 Jan 2018 19:07:54 +0100
Message-ID: <20180109180757.6104-5-pablo@netfilter.org>
References: <20180109180757.6104-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56242 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934573AbeAISIL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Jan 2018 13:08:11 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D173611ADC7
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Jan 2018 19:08:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BE877DA84B
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Jan 2018 19:08:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 69248DA851
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Jan 2018 19:08:07 +0100 (CET)
Received: from salvia.here (unknown [31.4.245.124])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 3EF664265A31
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Jan 2018 19:08:07 +0100 (CET)
In-Reply-To: <20180109180757.6104-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pass family number instead, this comes in preparation for the removal of
struct nft_af_info.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a2d13ad0f717..0eec4b5412de 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -423,7 +423,7 @@ static inline u64 nf_tables_alloc_handle(struct nft_table *table)
 static const struct nf_chain_type *chain_type[NFPROTO_NUMPROTO][NFT_CHAIN_T_MAX];
 
 static const struct nf_chain_type *
-__nf_tables_chain_type_lookup(int family, const struct nlattr *nla)
+__nf_tables_chain_type_lookup(const struct nlattr *nla, u8 family)
 {
 	int i;
 
@@ -436,22 +436,20 @@ __nf_tables_chain_type_lookup(int family, const struct nlattr *nla)
 }
 
 static const struct nf_chain_type *
-nf_tables_chain_type_lookup(const struct nft_af_info *afi,
-			    const struct nlattr *nla,
-			    bool autoload)
+nf_tables_chain_type_lookup(const struct nlattr *nla, u8 family, bool autoload)
 {
 	const struct nf_chain_type *type;
 
-	type = __nf_tables_chain_type_lookup(afi->family, nla);
+	type = __nf_tables_chain_type_lookup(nla, family);
 	if (type != NULL)
 		return type;
 #ifdef CONFIG_MODULES
 	if (autoload) {
 		nfnl_unlock(NFNL_SUBSYS_NFTABLES);
-		request_module("nft-chain-%u-%.*s", afi->family,
+		request_module("nft-chain-%u-%.*s", family,
 			       nla_len(nla), (const char *)nla_data(nla));
 		nfnl_lock(NFNL_SUBSYS_NFTABLES);
-		type = __nf_tables_chain_type_lookup(afi->family, nla);
+		type = __nf_tables_chain_type_lookup(nla, family);
 		if (type != NULL)
 			return ERR_PTR(-EAGAIN);
 	}
@@ -1325,8 +1323,8 @@ static int nft_chain_parse_hook(struct net *net,
 
 	type = chain_type[afi->family][NFT_CHAIN_T_DEFAULT];
 	if (nla[NFTA_CHAIN_TYPE]) {
-		type = nf_tables_chain_type_lookup(afi, nla[NFTA_CHAIN_TYPE],
-						   create);
+		type = nf_tables_chain_type_lookup(nla[NFTA_CHAIN_TYPE],
+						   afi->family, create);
 		if (IS_ERR(type))
 			return PTR_ERR(type);
 	}
-- 
2.11.0


