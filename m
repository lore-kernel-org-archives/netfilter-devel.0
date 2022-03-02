Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ED9EC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Mar 2022 21:03:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236496AbiCBVDn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Mar 2022 16:03:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242007AbiCBVDm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Mar 2022 16:03:42 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C887614094
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2022 13:02:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Cbt2U0UoprMvcgvfJDlY4d8lRyayQfqiLUhCCbDerew=; b=iY5/nmCiig8916AH+mLhgkLhcW
        MleDk8+zG2yJZ/drKuR95xJxvls7lRB03Y7pMr4QHHDhjLGYL/LSGeUAGmgO8JCOEt0DLjO/qRtLJ
        y7q9ZR4IJFsRXalgio0HkdtfzOlWww6QwbQh+re1jlCz3exwdVOTLLOf7COOcELvv21eWaHNrKLHT
        dx8W5efIJ0CUOGxjUlS+KS6MgQ6v446oP3rjxDDPlfVwRE70G4DithXR8XV99puLmn7NoNiT4yZfU
        4OKK6QD6soYS9oa5cylUocMe7qpQ1ZnqyLyOtJE2QIYp0kobfxnkZCJk3VhA0yz2bMtfQO4Ape3ls
        SYNWxUjQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nPW7c-0006hF-Up; Wed, 02 Mar 2022 22:02:56 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: [nf-next PATCH] netfilter: conntrack: Add and use nf_ct_set_auto_assign_helper_warned()
Date:   Wed,  2 Mar 2022 22:02:55 +0100
Message-Id: <20220302210255.10177-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The function sets the pernet boolean to avoid the spurious warning from
nf_ct_lookup_helper() when assigning conntrack helpers via nftables.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/net/netfilter/nf_conntrack_helper.h | 1 +
 net/netfilter/nf_conntrack_helper.c         | 6 ++++++
 net/netfilter/nft_ct.c                      | 3 +++
 3 files changed, 10 insertions(+)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index 37f0fbefb060f..9939c366f720d 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -177,4 +177,5 @@ void nf_nat_helper_unregister(struct nf_conntrack_nat_helper *nat);
 int nf_nat_helper_try_module_get(const char *name, u16 l3num,
 				 u8 protonum);
 void nf_nat_helper_put(struct nf_conntrack_helper *helper);
+void nf_ct_set_auto_assign_helper_warned(struct net *net);
 #endif /*_NF_CONNTRACK_HELPER_H*/
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index a97ddb1497aa5..8dec42ec603ef 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -550,6 +550,12 @@ void nf_nat_helper_unregister(struct nf_conntrack_nat_helper *nat)
 }
 EXPORT_SYMBOL_GPL(nf_nat_helper_unregister);
 
+void nf_ct_set_auto_assign_helper_warned(struct net *net)
+{
+	nf_ct_pernet(net)->auto_assign_helper_warned = true;
+}
+EXPORT_SYMBOL_GPL(nf_ct_set_auto_assign_helper_warned);
+
 void nf_conntrack_helper_pernet_init(struct net *net)
 {
 	struct nf_conntrack_net *cnet = nf_ct_pernet(net);
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 5adf8bb628a80..9c7472af9e4a1 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -1041,6 +1041,9 @@ static int nft_ct_helper_obj_init(const struct nft_ctx *ctx,
 	if (err < 0)
 		goto err_put_helper;
 
+	/* Avoid the bogus warning, helper will be assigned after CT init */
+	nf_ct_set_auto_assign_helper_warned(ctx->net);
+
 	return 0;
 
 err_put_helper:
-- 
2.34.1

