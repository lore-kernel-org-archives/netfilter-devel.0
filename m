Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64EF2C00528
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Aug 2023 13:42:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbjHDNmI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 4 Aug 2023 09:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231315AbjHDNl6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Aug 2023 09:41:58 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B14A630F3;
        Fri,  4 Aug 2023 06:41:55 -0700 (PDT)
Received: from canpemm500007.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4RHRgL40cKzrS2M;
        Fri,  4 Aug 2023 21:40:46 +0800 (CST)
Received: from localhost (10.174.179.215) by canpemm500007.china.huawei.com
 (7.192.104.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Fri, 4 Aug
 2023 21:41:51 +0800
From:   Yue Haibing <yuehaibing@huawei.com>
To:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <yuehaibing@huawei.com>
CC:     <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
        <netdev@vger.kernel.org>
Subject: [PATCH net-next] netfilter: conntrack: Remove unused function declarations
Date:   Fri, 4 Aug 2023 21:41:49 +0800
Message-ID: <20230804134149.39748-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm500007.china.huawei.com (7.192.104.62)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Commit 1015c3de23ee ("netfilter: conntrack: remove extension register api")
leave nf_conntrack_acct_fini() and nf_conntrack_labels_init() unused, remove it.
And commit a0ae2562c6c4 ("netfilter: conntrack: remove l3proto abstraction")
leave behind nf_ct_l3proto_try_module_get() and nf_ct_l3proto_module_put().

Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
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
2.34.1

