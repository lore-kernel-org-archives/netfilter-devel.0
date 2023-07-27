Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1902FC001DC
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jul 2023 13:36:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbjG0NgW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 Jul 2023 09:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbjG0NgV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jul 2023 09:36:21 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1972272C;
        Thu, 27 Jul 2023 06:36:20 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qP1A4-0003De-Kf; Thu, 27 Jul 2023 15:36:12 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>, Zhu Wang <wangzhu9@huawei.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 1/5] nf_conntrack: fix -Wunused-const-variable=
Date:   Thu, 27 Jul 2023 15:35:56 +0200
Message-ID: <20230727133604.8275-2-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230727133604.8275-1-fw@strlen.de>
References: <20230727133604.8275-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Zhu Wang <wangzhu9@huawei.com>

When building with W=1, the following warning occurs.

net/netfilter/nf_conntrack_proto_dccp.c:72:27: warning: ‘dccp_state_names’ defined but not used [-Wunused-const-variable=]
 static const char * const dccp_state_names[] = {

We include dccp_state_names in the macro
CONFIG_NF_CONNTRACK_PROCFS, since it is only used in the place
which is included in the macro CONFIG_NF_CONNTRACK_PROCFS.

Fixes: 2bc780499aa3 ("[NETFILTER]: nf_conntrack: add DCCP protocol support")
Signed-off-by: Zhu Wang <wangzhu9@huawei.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
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
2.41.0

