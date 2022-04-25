Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D4C3C433FE
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Apr 2022 09:18:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233722AbiDYJVI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Apr 2022 05:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241597AbiDYJTm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Apr 2022 05:19:42 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CB9EA22520;
        Mon, 25 Apr 2022 02:16:36 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 1/4] ipvs: correctly print the memory size of ip_vs_conn_tab
Date:   Mon, 25 Apr 2022 11:16:28 +0200
Message-Id: <20220425091631.109320-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220425091631.109320-1-pablo@netfilter.org>
References: <20220425091631.109320-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pengcheng Yang <yangpc@wangsu.com>

The memory size of ip_vs_conn_tab changed after we use hlist
instead of list.

Fixes: 731109e78415 ("ipvs: use hlist instead of list")
Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Acked-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_conn.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 2c467c422dc6..fb67f1ca2495 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1495,7 +1495,7 @@ int __init ip_vs_conn_init(void)
 	pr_info("Connection hash table configured "
 		"(size=%d, memory=%ldKbytes)\n",
 		ip_vs_conn_tab_size,
-		(long)(ip_vs_conn_tab_size*sizeof(struct list_head))/1024);
+		(long)(ip_vs_conn_tab_size*sizeof(*ip_vs_conn_tab))/1024);
 	IP_VS_DBG(0, "Each connection entry needs %zd bytes at least\n",
 		  sizeof(struct ip_vs_conn));
 
-- 
2.30.2

