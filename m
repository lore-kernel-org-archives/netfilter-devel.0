Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59DB1C00A5A
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Jan 2023 07:33:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbjASHdi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Jan 2023 02:33:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbjASHdd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Jan 2023 02:33:33 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37AA2193DA;
        Wed, 18 Jan 2023 23:33:27 -0800 (PST)
Received: from dggpemm100007.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4NyDlT1jsjzJqLM;
        Thu, 19 Jan 2023 15:29:09 +0800 (CST)
Received: from huawei.com (10.175.103.91) by dggpemm100007.china.huawei.com
 (7.185.36.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 19 Jan
 2023 15:33:24 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
        <netdev@vger.kernel.org>
CC:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ffmancera@riseup.net>
Subject: [PATCH net-next] netfilter: nf_tables: fix wrong pointer passed to PTR_ERR()
Date:   Thu, 19 Jan 2023 15:51:25 +0800
Message-ID: <20230119075125.3598627-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm100007.china.huawei.com (7.185.36.116)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It should be 'chain' passed to PTR_ERR() in the error path
after calling nft_chain_lookup() in nf_tables_delrule().

Fixes: f80a612dd77c ("netfilter: nf_tables: add support to destroy operation")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 974b95dece1d..10264e98978b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3724,7 +3724,7 @@ static int nf_tables_delrule(struct sk_buff *skb, const struct nfnl_info *info,
 		chain = nft_chain_lookup(net, table, nla[NFTA_RULE_CHAIN],
 					 genmask);
 		if (IS_ERR(chain)) {
-			if (PTR_ERR(rule) == -ENOENT &&
+			if (PTR_ERR(chain) == -ENOENT &&
 			    NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_DESTROYRULE)
 				return 0;
 
-- 
2.25.1

