Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89471C77B7F
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 May 2023 12:38:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbjEQMiC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 May 2023 08:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbjEQMiB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 May 2023 08:38:01 -0400
Received: from mg.ssi.bg (mg.ssi.bg [193.238.174.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE7351BFC;
        Wed, 17 May 2023 05:38:00 -0700 (PDT)
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.bb.i.ssi.bg (Proxmox) with ESMTP id 4F4E019F77;
        Wed, 17 May 2023 15:37:59 +0300 (EEST)
Received: from ink.ssi.bg (ink.ssi.bg [193.238.174.40])
        by mg.bb.i.ssi.bg (Proxmox) with ESMTPS id 2BFF719E58;
        Wed, 17 May 2023 15:37:59 +0300 (EEST)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id EC3E53C0323;
        Wed, 17 May 2023 15:37:58 +0300 (EEST)
Received: from ja.home.ssi.bg (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.17.1/8.16.1) with ESMTP id 34HCbwjO056801;
        Wed, 17 May 2023 15:37:58 +0300
Received: (from root@localhost)
        by ja.home.ssi.bg (8.17.1/8.17.1/Submit) id 34HCbv0o056798;
        Wed, 17 May 2023 15:37:57 +0300
From:   Julian Anastasov <ja@ssi.bg>
To:     Simon Horman <horms@verge.net.au>
Cc:     lvs-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org,
        Abhijeet Rastogi <abhijeet.1989@gmail.com>
Subject: [PATCH net-next] ipvs: dynamically limit the connection hash table
Date:   Wed, 17 May 2023 15:37:31 +0300
Message-Id: <20230517123731.56733-1-ja@ssi.bg>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

As we allow the hash table to be configured to rows above 2^20,
we should limit it depending on the available memory to some
sane values. Switch to kvmalloc allocation to better select
the needed allocation type.

Signed-off-by: Julian Anastasov <ja@ssi.bg>
---
 net/netfilter/ipvs/ip_vs_conn.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

 NOTE: This patch needs to be applied on top of V3 (or above) of patch
 "ipvs: increase ip_vs_conn_tab_bits range for 64BIT" from Abhijeet

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index f4c55e65abd1..79d7ae8e50e5 100644
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
2.40.1


