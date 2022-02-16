Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DD56C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Feb 2022 14:55:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235242AbiBPO4D (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Feb 2022 09:56:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232406AbiBPO4C (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Feb 2022 09:56:02 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7041E1F6B93
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Feb 2022 06:55:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=NUbf+gXBsBCgzpul2IXB0BJ/iRE+zdVo6AFO06XTN3o=; b=JIrHkhtYlDO5KUCxLzI9mVVHqV
        ruwL1zOXYYPO0vjE9nQQ0msYgueZS7m6sfbAwYGbWn45sz8gZJ+cWnwKKr1iAYBld14WFJXeT0exu
        N1JctRDK4+thchZ1yMJ2yLC0ekQeoO35xIc3ERfY/x2iIcLbAdyP5fGeUrP4NbjEb5b9RpkSLAxwf
        SQMxNK9Kav/Yi8vmJK7Mjz9n/SeVa8PGfCDEEkv5SzY6Nxu8377dc3HYTCQGiakg02/OMriG8XKbG
        rjC7b0Xl7qY97axv7p/HlUvkEGVSg7Ui6SbHnHNK3hjeb4o9j0okLpbvlXA9sEay4EJywIPXK6+zm
        IWVe6Dtg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nKLic-0007JK-Qp; Wed, 16 Feb 2022 15:55:46 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: [nf-next PATCH v3] netfilter: nf_tables: Reject tables of unsupported family
Date:   Wed, 16 Feb 2022 15:55:38 +0100
Message-Id: <20220216145538.19070-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

An nftables family is merely a hollow container, its family just a
number and such not reliant on compile-time options other than nftables
support itself. Add an artificial check so attempts at using a family
the kernel can't support fail as early as possible. This helps user
space detect kernels which lack e.g. NFPROTO_INET.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v2:
- Casting family from u8 to int via parameter resulted in an always
  negative result. Pass it as u8 to nft_supported_family().
- Fix typo: CONIFG_NF_TABLES_BRIDGE -> CONFIG_NF_TABLES_BRIDGE
- Reduce the function to a single statement instead of if/else
  conditional.
- Use 'false' instead of '0' for the standard term.

Changes since v1:
- Avoid a compiler warning if none of the tested symbols are enabled.
---
 net/netfilter/nf_tables_api.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 5fa16990da951..ac33ca9f8d88b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1072,6 +1072,30 @@ static int nft_objname_hash_cmp(struct rhashtable_compare_arg *arg,
 	return strcmp(obj->key.name, k->name);
 }
 
+static bool nft_supported_family(u8 family)
+{
+	return false
+#ifdef CONFIG_NF_TABLES_INET
+		|| family == NFPROTO_INET
+#endif
+#ifdef CONFIG_NF_TABLES_IPV4
+		|| family == NFPROTO_IPV4
+#endif
+#ifdef CONFIG_NF_TABLES_ARP
+		|| family == NFPROTO_ARP
+#endif
+#ifdef CONFIG_NF_TABLES_NETDEV
+		|| family == NFPROTO_NETDEV
+#endif
+#if IS_ENABLED(CONFIG_NF_TABLES_BRIDGE)
+		|| family == NFPROTO_BRIDGE
+#endif
+#ifdef CONFIG_NF_TABLES_IPV6
+		|| family == NFPROTO_IPV6
+#endif
+		;
+}
+
 static int nf_tables_newtable(struct sk_buff *skb, const struct nfnl_info *info,
 			      const struct nlattr * const nla[])
 {
@@ -1086,6 +1110,9 @@ static int nf_tables_newtable(struct sk_buff *skb, const struct nfnl_info *info,
 	u32 flags = 0;
 	int err;
 
+	if (!nft_supported_family(family))
+		return -EOPNOTSUPP;
+
 	lockdep_assert_held(&nft_net->commit_mutex);
 	attr = nla[NFTA_TABLE_NAME];
 	table = nft_table_lookup(net, attr, family, genmask,
-- 
2.34.1

