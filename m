From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 01/06: ebtables: use nf_register_hooks()
Date: Sun, 27 Jul 2008 01:37:08 +0200 (MEST)
Message-ID: <20080726233707.15283.96360.sendpatchset@localhost.localdomain>
References: <20080726233705.15283.38364.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43529 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821AbYGZXhJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Jul 2008 19:37:09 -0400
In-Reply-To: <20080726233705.15283.38364.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

netfilter: ebtables: use nf_register_hooks()

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 1560ab44b64937c854fedbfedc80a7f2ae491436
tree 530ee8dd17ba9685ab9c9aa8a54ed257e90d233c
parent 7d7e5a60c62e88cb8782760bb6c4d3bd1577a6c6
author Alexey Dobriyan <adobriyan@gmail.com> Sun, 27 Jul 2008 00:37:24 +0200
committer Patrick McHardy <kaber@trash.net> Sun, 27 Jul 2008 00:37:24 +0200

 net/bridge/netfilter/ebtable_filter.c |   18 +++++-------------
 net/bridge/netfilter/ebtable_nat.c    |   18 +++++-------------
 2 files changed, 10 insertions(+), 26 deletions(-)

diff --git a/net/bridge/netfilter/ebtable_filter.c b/net/bridge/netfilter/ebtable_filter.c
index 690bc3a..1a58af5 100644
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
 
diff --git a/net/bridge/netfilter/ebtable_nat.c b/net/bridge/netfilter/ebtable_nat.c
index 5b495fe..f60c1e7 100644
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
 
