Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A6F4C433FE
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Feb 2022 12:14:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233081AbiBPMOl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Feb 2022 07:14:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233068AbiBPMOl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Feb 2022 07:14:41 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E76FF2A229B
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Feb 2022 04:14:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=RxGtVe4uMu4/cAGHS6RdUCaXNs+VeR3Ap4Ar8uRS8AY=; b=fOuIuCCHVhbSaY3MibutZzl/A3
        YcTksnbWDO16bBdO9k/QzT4dKnDz04lqrO/TD2jE7AC69/8H16hEw6Xwjcn+I5Rlib4hRC5i2Ln3s
        MURaT5/AUnvPVo+yoyJelw5DpCF0wuA+R0l79iA2bnEYwgYfAankuSfInykqY3hlI3irjV5ySt8yA
        beV9OTli3dNjLOe6RcTPAnquIGCZtoi4A8MeLJTgjDpMfKwhAqeQHoM5IYiASxPQ66eduQfBDKU0u
        O7yv2cGxUpYwasU8qQLeFuMmdWMcNNxhB5nSb0vsJIB3WtLtugkHTxiSlt1DXg7LZOw6iXfqgnsto
        ZH6XwrCw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nKJCT-0005UA-1N; Wed, 16 Feb 2022 13:14:25 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: [nf-next PATCH v2] netfilter: nf_tables: Reject tables of unsupported family
Date:   Wed, 16 Feb 2022 13:14:17 +0100
Message-Id: <20220216121417.9542-1-phil@nwl.cc>
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
Changes since v1:
- Avoid a compiler warning if none of the tested symbols are enabled.
---
 net/netfilter/nf_tables_api.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 5fa16990da951..85e74e165fc14 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1072,6 +1072,33 @@ static int nft_objname_hash_cmp(struct rhashtable_compare_arg *arg,
 	return strcmp(obj->key.name, k->name);
 }
 
+static bool nft_supported_family(int family)
+{
+	if (0
+#ifdef CONFIG_NF_TABLES_INET
+	    || family == NFPROTO_INET
+#endif
+#ifdef CONFIG_NF_TABLES_IPV4
+	    || family == NFPROTO_IPV4
+#endif
+#ifdef CONFIG_NF_TABLES_ARP
+	    || family == NFPROTO_ARP
+#endif
+#ifdef CONFIG_NF_TABLES_NETDEV
+	    || family == NFPROTO_NETDEV
+#endif
+#if IS_ENABLED(CONIFG_NF_TABLES_BRIDGE)
+	    || family == NFPROTO_BRIDGE
+#endif
+#ifdef CONFIG_NF_TABLES_IPV6
+	    || family == NFPROTO_IPV6
+#endif
+	   )
+		return true;
+
+	return false;
+}
+
 static int nf_tables_newtable(struct sk_buff *skb, const struct nfnl_info *info,
 			      const struct nlattr * const nla[])
 {
@@ -1086,6 +1113,9 @@ static int nf_tables_newtable(struct sk_buff *skb, const struct nfnl_info *info,
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

