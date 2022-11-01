Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32522FA3743
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Nov 2022 11:56:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbiKAL4R (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Nov 2022 07:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbiKAL4N (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Nov 2022 07:56:13 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3173D6242;
        Tue,  1 Nov 2022 04:56:12 -0700 (PDT)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4N1pLj3y16zJnLQ;
        Tue,  1 Nov 2022 19:53:17 +0800 (CST)
Received: from dggpemm500013.china.huawei.com (7.185.36.172) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 1 Nov 2022 19:56:10 +0800
Received: from ubuntu1804.huawei.com (10.67.175.36) by
 dggpemm500013.china.huawei.com (7.185.36.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 1 Nov 2022 19:56:10 +0800
From:   Chen Zhongjin <chenzhongjin@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <coreteam@netfilter.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ast@kernel.org>, <lorenzo@kernel.org>,
        <john.fastabend@gmail.com>, <chenzhongjin@huawei.com>
Subject: [PATCH net v2] netfilter: nf_nat: Fix possible memory leak in nf_nat_init()
Date:   Tue, 1 Nov 2022 19:52:52 +0800
Message-ID: <20221101115252.17340-1-chenzhongjin@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.175.36]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500013.china.huawei.com (7.185.36.172)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In nf_nat_init(), register_nf_nat_bpf() can fail and return directly
without any error handling.
Then nf_nat_bysource will leak and registering of &nat_net_ops,
&follow_master_nat and nf_nat_hook won't be reverted.

This leaves wild ops in linkedlists and when another module tries to
call register_pernet_operations() or nf_ct_helper_expectfn_register()
it triggers page fault:

 BUG: unable to handle page fault for address: fffffbfff81b964c
 RIP: 0010:register_pernet_operations+0x1b9/0x5f0
 Call Trace:
 <TASK>
  register_pernet_subsys+0x29/0x40
  ebtables_init+0x58/0x1000 [ebtables]
  ...

Fixes: 820dc0523e05 ("net: netfilter: move bpf_ct_set_nat_info kfunc in nf_nat_bpf.c")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
---
Also revert the operation for &follow_master_nat and nf_nat_hook,
then slightly fix commit msg for it.
---
 net/netfilter/nf_nat_core.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 18319a6e6806..47aa67abd531 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -1152,7 +1152,15 @@ static int __init nf_nat_init(void)
 	WARN_ON(nf_nat_hook != NULL);
 	RCU_INIT_POINTER(nf_nat_hook, &nat_hook);
 
-	return register_nf_nat_bpf();
+	ret = register_nf_nat_bpf();
+	if (ret < 0) {
+		RCU_INIT_POINTER(nf_nat_hook, NULL);
+		nf_ct_helper_expectfn_unregister(&follow_master_nat);
+		synchronize_net();
+		unregister_pernet_subsys(&nat_net_ops);
+		kvfree(nf_nat_bysource);
+	}
+	return ret;
 }
 
 static void __exit nf_nat_cleanup(void)
-- 
2.17.1

