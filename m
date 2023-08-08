Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 817EFC04FE1
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Aug 2023 17:50:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235065AbjHHRup (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Aug 2023 13:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234898AbjHHRuR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Aug 2023 13:50:17 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5863527561;
        Tue,  8 Aug 2023 09:22:24 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qTM2S-0000Kx-Rm; Tue, 08 Aug 2023 14:42:16 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>,
        Yue Haibing <yuehaibing@huawei.com>,
        Simon Horman <horms@kernel.org>
Subject: [PATCH next-next 3/5] netfilter: conntrack: Remove unused function declarations
Date:   Tue,  8 Aug 2023 14:41:46 +0200
Message-ID: <20230808124159.19046-4-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230808124159.19046-1-fw@strlen.de>
References: <20230808124159.19046-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Yue Haibing <yuehaibing@huawei.com>

Commit 1015c3de23ee ("netfilter: conntrack: remove extension register api")
leave nf_conntrack_acct_fini() and nf_conntrack_labels_init() unused, remove it.
And commit a0ae2562c6c4 ("netfilter: conntrack: remove l3proto abstraction")
leave behind nf_ct_l3proto_try_module_get() and nf_ct_l3proto_module_put().

Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack.h        | 4 ----
 include/net/netfilter/nf_conntrack_acct.h   | 2 --
 include/net/netfilter/nf_conntrack_labels.h | 1 -
 3 files changed, 7 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index a72028dbef0c..4085765c3370 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -190,10 +190,6 @@ static inline void nf_ct_put(struct nf_conn *ct)
 		nf_ct_destroy(&ct->ct_general);
 }
 
-/* Protocol module loading */
-int nf_ct_l3proto_try_module_get(unsigned short l3proto);
-void nf_ct_l3proto_module_put(unsigned short l3proto);
-
 /* load module; enable/disable conntrack in this namespace */
 int nf_ct_netns_get(struct net *net, u8 nfproto);
 void nf_ct_netns_put(struct net *net, u8 nfproto);
diff --git a/include/net/netfilter/nf_conntrack_acct.h b/include/net/netfilter/nf_conntrack_acct.h
index 4b2b7f8914ea..a120685cac93 100644
--- a/include/net/netfilter/nf_conntrack_acct.h
+++ b/include/net/netfilter/nf_conntrack_acct.h
@@ -78,6 +78,4 @@ static inline void nf_ct_acct_update(struct nf_conn *ct, u32 dir,
 
 void nf_conntrack_acct_pernet_init(struct net *net);
 
-void nf_conntrack_acct_fini(void);
-
 #endif /* _NF_CONNTRACK_ACCT_H */
diff --git a/include/net/netfilter/nf_conntrack_labels.h b/include/net/netfilter/nf_conntrack_labels.h
index 66bab6c60d12..fcb19a4e8f2b 100644
--- a/include/net/netfilter/nf_conntrack_labels.h
+++ b/include/net/netfilter/nf_conntrack_labels.h
@@ -52,7 +52,6 @@ int nf_connlabels_replace(struct nf_conn *ct,
 			  const u32 *data, const u32 *mask, unsigned int words);
 
 #ifdef CONFIG_NF_CONNTRACK_LABELS
-int nf_conntrack_labels_init(void);
 int nf_connlabels_get(struct net *net, unsigned int bit);
 void nf_connlabels_put(struct net *net);
 #else
-- 
2.41.0

