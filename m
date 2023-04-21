Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED352C77B78
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Apr 2023 23:02:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233786AbjDUXCs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 Apr 2023 19:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233731AbjDUXCZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Apr 2023 19:02:25 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D4D6926B2;
        Fri, 21 Apr 2023 16:02:23 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net-next 12/20] ipvs: Consistently use array_size() in ip_vs_conn_init()
Date:   Sat, 22 Apr 2023 01:02:03 +0200
Message-Id: <20230421230211.214635-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230421230211.214635-1-pablo@netfilter.org>
References: <20230421230211.214635-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Simon Horman <horms@kernel.org>

Consistently use array_size() to calculate the size of ip_vs_conn_tab
in bytes.

Flagged by Coccinelle:
 WARNING: array_size is already used (line 1498) to compute the same size

No functional change intended.
Compile tested only.

Signed-off-by: Simon Horman <horms@kernel.org>
Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_conn.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 13534e02346c..928e64653837 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1481,6 +1481,7 @@ void __net_exit ip_vs_conn_net_cleanup(struct netns_ipvs *ipvs)
 
 int __init ip_vs_conn_init(void)
 {
+	size_t tab_array_size;
 	int idx;
 
 	/* Compute size and mask */
@@ -1494,8 +1495,9 @@ int __init ip_vs_conn_init(void)
 	/*
 	 * Allocate the connection hash table and initialize its list heads
 	 */
-	ip_vs_conn_tab = vmalloc(array_size(ip_vs_conn_tab_size,
-					    sizeof(*ip_vs_conn_tab)));
+	tab_array_size = array_size(ip_vs_conn_tab_size,
+				    sizeof(*ip_vs_conn_tab));
+	ip_vs_conn_tab = vmalloc(tab_array_size);
 	if (!ip_vs_conn_tab)
 		return -ENOMEM;
 
@@ -1508,10 +1510,8 @@ int __init ip_vs_conn_init(void)
 		return -ENOMEM;
 	}
 
-	pr_info("Connection hash table configured "
-		"(size=%d, memory=%ldKbytes)\n",
-		ip_vs_conn_tab_size,
-		(long)(ip_vs_conn_tab_size*sizeof(*ip_vs_conn_tab))/1024);
+	pr_info("Connection hash table configured (size=%d, memory=%zdKbytes)\n",
+		ip_vs_conn_tab_size, tab_array_size / 1024);
 	IP_VS_DBG(0, "Each connection entry needs %zd bytes at least\n",
 		  sizeof(struct ip_vs_conn));
 
-- 
2.30.2

