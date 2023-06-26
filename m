Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DD02EB64D7
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Jun 2023 06:48:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbjFZGsA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 26 Jun 2023 02:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjFZGr7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Jun 2023 02:47:59 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4D10CE48;
        Sun, 25 Jun 2023 23:47:56 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net-next 2/8] ipvs: dynamically limit the connection hash table
Date:   Mon, 26 Jun 2023 08:47:43 +0200
Message-Id: <20230626064749.75525-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230626064749.75525-1-pablo@netfilter.org>
References: <20230626064749.75525-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Julian Anastasov <ja@ssi.bg>

As we allow the hash table to be configured to rows above 2^20,
we should limit it depending on the available memory to some
sane values. Switch to kvmalloc allocation to better select
the needed allocation type.

Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_conn.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index f4c55e65abd1..9065da3cdd12 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -26,7 +26,6 @@
 #include <linux/net.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/vmalloc.h>
 #include <linux/proc_fs.h>		/* for proc_net_* */
 #include <linux/slab.h>
 #include <linux/seq_file.h>
@@ -1482,13 +1481,21 @@ void __net_exit ip_vs_conn_net_cleanup(struct netns_ipvs *ipvs)
 int __init ip_vs_conn_init(void)
 {
 	size_t tab_array_size;
+	int max_avail;
+#if BITS_PER_LONG > 32
+	int max = 27;
+#else
+	int max = 20;
+#endif
+	int min = 8;
 	int idx;
 
-	/* Compute size and mask */
-	if (ip_vs_conn_tab_bits < 8 || ip_vs_conn_tab_bits > 27) {
-		pr_info("conn_tab_bits not in [8, 27]. Using default value\n");
-		ip_vs_conn_tab_bits = CONFIG_IP_VS_TAB_BITS;
-	}
+	max_avail = order_base_2(totalram_pages()) + PAGE_SHIFT;
+	max_avail -= 2;		/* ~4 in hash row */
+	max_avail -= 1;		/* IPVS up to 1/2 of mem */
+	max_avail -= order_base_2(sizeof(struct ip_vs_conn));
+	max = clamp(max, min, max_avail);
+	ip_vs_conn_tab_bits = clamp_val(ip_vs_conn_tab_bits, min, max);
 	ip_vs_conn_tab_size = 1 << ip_vs_conn_tab_bits;
 	ip_vs_conn_tab_mask = ip_vs_conn_tab_size - 1;
 
@@ -1497,7 +1504,8 @@ int __init ip_vs_conn_init(void)
 	 */
 	tab_array_size = array_size(ip_vs_conn_tab_size,
 				    sizeof(*ip_vs_conn_tab));
-	ip_vs_conn_tab = vmalloc(tab_array_size);
+	ip_vs_conn_tab = kvmalloc_array(ip_vs_conn_tab_size,
+					sizeof(*ip_vs_conn_tab), GFP_KERNEL);
 	if (!ip_vs_conn_tab)
 		return -ENOMEM;
 
@@ -1506,7 +1514,7 @@ int __init ip_vs_conn_init(void)
 					      sizeof(struct ip_vs_conn), 0,
 					      SLAB_HWCACHE_ALIGN, NULL);
 	if (!ip_vs_conn_cachep) {
-		vfree(ip_vs_conn_tab);
+		kvfree(ip_vs_conn_tab);
 		return -ENOMEM;
 	}
 
@@ -1534,5 +1542,5 @@ void ip_vs_conn_cleanup(void)
 	rcu_barrier();
 	/* Release the empty cache */
 	kmem_cache_destroy(ip_vs_conn_cachep);
-	vfree(ip_vs_conn_tab);
+	kvfree(ip_vs_conn_tab);
 }
-- 
2.30.2

