Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8C66C001B0
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jul 2023 10:16:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233407AbjGZKQP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Jul 2023 06:16:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233326AbjGZKQM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Jul 2023 06:16:12 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF1C1FEC;
        Wed, 26 Jul 2023 03:16:09 -0700 (PDT)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4R9qXJ2rgLzrRqr;
        Wed, 26 Jul 2023 18:15:12 +0800 (CST)
Received: from ubuntu1804.huawei.com (10.67.174.202) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 26 Jul 2023 18:16:05 +0800
From:   Zhu Wang <wangzhu9@huawei.com>
To:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <kaber@trash.net>,
        <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <wangzhu9@huawei.com>
Subject: [PATCH -next] nf_conntrack: fix -Wunused-const-variable=
Date:   Wed, 26 Jul 2023 18:15:31 +0800
Message-ID: <20230726101531.169376-1-wangzhu9@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.174.202]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When building with W=1, the following warning occurs.

net/netfilter/nf_conntrack_proto_dccp.c:72:27: warning: ‘dccp_state_names’ defined but not used [-Wunused-const-variable=]
 static const char * const dccp_state_names[] = {

We include dccp_state_names in the macro
CONFIG_NF_CONNTRACK_PROCFS, since it is only used in the place
which is included in the macro CONFIG_NF_CONNTRACK_PROCFS.

Fixes: 2bc780499aa3 ("[NETFILTER]: nf_conntrack: add DCCP protocol support")
Signed-off-by: Zhu Wang <wangzhu9@huawei.com>
---
 net/netfilter/nf_conntrack_proto_dccp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index d4fd626d2b8c..e2db1f4ec2df 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -69,6 +69,7 @@
 
 #define DCCP_MSL (2 * 60 * HZ)
 
+#ifdef CONFIG_NF_CONNTRACK_PROCFS
 static const char * const dccp_state_names[] = {
 	[CT_DCCP_NONE]		= "NONE",
 	[CT_DCCP_REQUEST]	= "REQUEST",
@@ -81,6 +82,7 @@ static const char * const dccp_state_names[] = {
 	[CT_DCCP_IGNORE]	= "IGNORE",
 	[CT_DCCP_INVALID]	= "INVALID",
 };
+#endif
 
 #define sNO	CT_DCCP_NONE
 #define sRQ	CT_DCCP_REQUEST
-- 
2.17.1

