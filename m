From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] ebtables: use nf_register_hooks()
Date: Mon, 21 Jul 2008 20:23:49 +0400
Message-ID: <20080721162349.GA13264@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:5275 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbYGUQZl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jul 2008 12:25:41 -0400
Received: by ug-out-1314.google.com with SMTP id h2so272765ugf.16
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Jul 2008 09:25:36 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 net/bridge/netfilter/ebtable_filter.c |   18 +++++-------------
 net/bridge/netfilter/ebtable_nat.c    |   18 +++++-------------
 2 files changed, 10 insertions(+), 26 deletions(-)

--- a/net/bridge/netfilter/ebtable_filter.c
+++ b/net/bridge/netfilter/ebtable_filter.c
@@ -93,28 +93,20 @@ static struct nf_hook_ops ebt_ops_filter[] __read_mostly = {
 
 static int __init ebtable_filter_init(void)
 {
-	int i, j, ret;
+	int ret;
 
 	ret = ebt_register_table(&frame_filter);
 	if (ret < 0)
 		return ret;
-	for (i = 0; i < ARRAY_SIZE(ebt_ops_filter); i++)
-		if ((ret = nf_register_hook(&ebt_ops_filter[i])) < 0)
-			goto cleanup;
-	return ret;
-cleanup:
-	for (j = 0; j < i; j++)
-		nf_unregister_hook(&ebt_ops_filter[j]);
-	ebt_unregister_table(&frame_filter);
+	ret = nf_register_hooks(ebt_ops_filter, ARRAY_SIZE(ebt_ops_filter));
+	if (ret < 0)
+		ebt_unregister_table(&frame_filter);
 	return ret;
 }
 
 static void __exit ebtable_filter_fini(void)
 {
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(ebt_ops_filter); i++)
-		nf_unregister_hook(&ebt_ops_filter[i]);
+	nf_unregister_hooks(ebt_ops_filter, ARRAY_SIZE(ebt_ops_filter));
 	ebt_unregister_table(&frame_filter);
 }
 
--- a/net/bridge/netfilter/ebtable_nat.c
+++ b/net/bridge/netfilter/ebtable_nat.c
@@ -100,28 +100,20 @@ static struct nf_hook_ops ebt_ops_nat[] __read_mostly = {
 
 static int __init ebtable_nat_init(void)
 {
-	int i, ret, j;
+	int ret;
 
 	ret = ebt_register_table(&frame_nat);
 	if (ret < 0)
 		return ret;
-	for (i = 0; i < ARRAY_SIZE(ebt_ops_nat); i++)
-		if ((ret = nf_register_hook(&ebt_ops_nat[i])) < 0)
-			goto cleanup;
-	return ret;
-cleanup:
-	for (j = 0; j < i; j++)
-		nf_unregister_hook(&ebt_ops_nat[j]);
-	ebt_unregister_table(&frame_nat);
+	ret = nf_register_hooks(ebt_ops_nat, ARRAY_SIZE(ebt_ops_nat));
+	if (ret < 0)
+		ebt_unregister_table(&frame_nat);
 	return ret;
 }
 
 static void __exit ebtable_nat_fini(void)
 {
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(ebt_ops_nat); i++)
-		nf_unregister_hook(&ebt_ops_nat[i]);
+	nf_unregister_hooks(ebt_ops_nat, ARRAY_SIZE(ebt_ops_nat));
 	ebt_unregister_table(&frame_nat);
 }
 
-- 
1.5.4.5


