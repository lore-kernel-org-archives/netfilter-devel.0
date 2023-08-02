Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07B87C001DF
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Aug 2023 13:16:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233889AbjHBNQ1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Aug 2023 09:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbjHBNQ1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Aug 2023 09:16:27 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5934C268F;
        Wed,  2 Aug 2023 06:16:26 -0700 (PDT)
Received: from canpemm500007.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4RGCBw5Qm5z1GDJ7;
        Wed,  2 Aug 2023 21:15:20 +0800 (CST)
Received: from localhost (10.174.179.215) by canpemm500007.china.huawei.com
 (7.192.104.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Wed, 2 Aug
 2023 21:16:22 +0800
From:   Yue Haibing <yuehaibing@huawei.com>
To:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <lucien.xin@gmail.com>,
        <yuehaibing@huawei.com>
CC:     <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
        <netdev@vger.kernel.org>
Subject: [PATCH net-next] netfilter: helper: Remove unused function declarations
Date:   Wed, 2 Aug 2023 21:15:49 +0800
Message-ID: <20230802131549.332-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500007.china.huawei.com (7.192.104.62)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Commit b118509076b3 ("netfilter: remove nf_conntrack_helper sysctl and modparam toggles")
leave these unused declarations.

Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
---
 include/net/netfilter/nf_conntrack_helper.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index f30b1694b690..de2f956abf34 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -136,8 +136,6 @@ static inline void *nfct_help_data(const struct nf_conn *ct)
 	return (void *)help->data;
 }
 
-void nf_conntrack_helper_pernet_init(struct net *net);
-
 int nf_conntrack_helper_init(void);
 void nf_conntrack_helper_fini(void);
 
@@ -182,5 +180,4 @@ void nf_nat_helper_unregister(struct nf_conntrack_nat_helper *nat);
 int nf_nat_helper_try_module_get(const char *name, u16 l3num,
 				 u8 protonum);
 void nf_nat_helper_put(struct nf_conntrack_helper *helper);
-void nf_ct_set_auto_assign_helper_warned(struct net *net);
 #endif /*_NF_CONNTRACK_HELPER_H*/
-- 
2.34.1

