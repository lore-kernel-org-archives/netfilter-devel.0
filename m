From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next RFC 4/8] netfilter: nf_tables: remove struct nft_af_info parameter in nf_tables_chain_type_lookup()
Date: Sun, 31 Dec 2017 00:13:44 +0100
Message-ID: <20171230231348.5497-5-pablo@netfilter.org>
References: <20171230231348.5497-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39212 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751109AbdL3XN5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Dec 2017 18:13:57 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4D295C51B9
        for <netfilter-devel@vger.kernel.org>; Sun, 31 Dec 2017 00:13:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3D0D271CF
        for <netfilter-devel@vger.kernel.org>; Sun, 31 Dec 2017 00:13:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 30C0171CF
        for <netfilter-devel@vger.kernel.org>; Sun, 31 Dec 2017 00:13:54 +0100 (CET)
Received: from salvia.here (40.red-212-170-55.staticip.rima-tde.net [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 16DF04265A32
        for <netfilter-devel@vger.kernel.org>; Sun, 31 Dec 2017 00:13:54 +0100 (CET)
In-Reply-To: <20171230231348.5497-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pass family instead.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a5590a0106e9..d72182fb447d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -387,7 +387,7 @@ static inline u64 nf_tables_alloc_handle(struct nft_table *table)
 static const struct nf_chain_type *chain_type[NFPROTO_NUMPROTO][NFT_CHAIN_T_MAX];
 
 static const struct nf_chain_type *
-__nf_tables_chain_type_lookup(int family, const struct nlattr *nla)
+__nf_tables_chain_type_lookup(const struct nlattr *nla, u8 family)
 {
 	int i;
 
@@ -400,22 +400,20 @@ __nf_tables_chain_type_lookup(int family, const struct nlattr *nla)
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
@@ -1280,8 +1278,8 @@ static int nft_chain_parse_hook(struct net *net,
 
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

