Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 596DAC433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Feb 2022 12:06:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237464AbiBOMGe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Feb 2022 07:06:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234984AbiBOMGb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Feb 2022 07:06:31 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D351D207A
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Feb 2022 04:06:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=MJG+l6wUaRMUBe13SnaC8lPm4LBxCz4RkmiHbzNfbw8=; b=D8uUkiLaHb2CBFIKKppO22xfyT
        vsuMNlR5CoLlvxwylIPvka2joi7J+eBPVhpvx7TKKOy6M4b0RAy+fzmQ/thZKNMFgxKXpwCjU53Mw
        LGPYaOSOIDhw51XLfgUgCvJRokBVlluv1w4jYwdNM9CEN9WLKHKKVXkTIkIH2Yvc0cq3iPDUAKEDZ
        7yQIF2/yDuao//mO7i8nrTIlygpA02R2E3T3VM3+hgWpFGCgQsUmGQfcSYq6OKoyIP73LjmQsEr6L
        GH/oojoLRvzzJlNHWo2oua8Fn788MNK4+p/6UO9NFIILpf9LF8RdaKufuBhWC7m/RwLCi5WvObHPP
        1i8mhIlQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nJwb4-0006hO-0W; Tue, 15 Feb 2022 13:06:18 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: [nf-next PATCH] netfilter: nf_tables: Reject tables of unsupported family
Date:   Tue, 15 Feb 2022 13:06:10 +0100
Message-Id: <20220215120610.20323-1-phil@nwl.cc>
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
 net/netfilter/nf_tables_api.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 5fa16990da951..753114f86e6b1 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1072,6 +1072,33 @@ static int nft_objname_hash_cmp(struct rhashtable_compare_arg *arg,
 	return strcmp(obj->key.name, k->name);
 }
 
+static bool nft_supported_family(int family)
+{
+	switch (family) {
+#ifdef CONFIG_NF_TABLES_INET
+	case NFPROTO_INET:
+#endif
+#ifdef CONFIG_NF_TABLES_IPV4
+	case NFPROTO_IPV4:
+#endif
+#ifdef CONFIG_NF_TABLES_ARP
+	case NFPROTO_ARP:
+#endif
+#ifdef CONFIG_NF_TABLES_NETDEV
+	case NFPROTO_NETDEV:
+#endif
+#if IS_ENABLED(CONIFG_NF_TABLES_BRIDGE)
+	case NFPROTO_BRIDGE:
+#endif
+#ifdef CONFIG_NF_TABLES_IPV6
+	case NFPROTO_IPV6:
+#endif
+		return true;
+	default:
+		return false;
+	}
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

