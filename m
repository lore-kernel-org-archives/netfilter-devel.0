From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH] netfilter: x_tables: xt_free_table_info() cleanup
Date: Tue, 24 Jun 2014 02:15:35 -0700
Message-ID: <1403601335.3796.2.camel@edumazet-glaptop2.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:61060 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbaFXJPk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Jun 2014 05:15:40 -0400
Received: by mail-wi0-f181.google.com with SMTP id n3so205693wiv.2
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Jun 2014 02:15:38 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Eric Dumazet <edumazet@google.com>

kvfree() helper can make xt_free_table_info() much cleaner.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/netfilter/x_tables.c |   23 +++++------------------
 1 file changed, 5 insertions(+), 18 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 227aa11e8409..47b978bc3100 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -711,28 +711,15 @@ void xt_free_table_info(struct xt_table_info *info)
 {
 	int cpu;
 
-	for_each_possible_cpu(cpu) {
-		if (info->size <= PAGE_SIZE)
-			kfree(info->entries[cpu]);
-		else
-			vfree(info->entries[cpu]);
-	}
+	for_each_possible_cpu(cpu)
+		kvfree(info->entries[cpu]);
 
 	if (info->jumpstack != NULL) {
-		if (sizeof(void *) * info->stacksize > PAGE_SIZE) {
-			for_each_possible_cpu(cpu)
-				vfree(info->jumpstack[cpu]);
-		} else {
-			for_each_possible_cpu(cpu)
-				kfree(info->jumpstack[cpu]);
-		}
+		for_each_possible_cpu(cpu)
+			kvfree(info->jumpstack[cpu]);
+		kvfree(info->jumpstack);
 	}
 
-	if (sizeof(void **) * nr_cpu_ids > PAGE_SIZE)
-		vfree(info->jumpstack);
-	else
-		kfree(info->jumpstack);
-
 	free_percpu(info->stackptr);
 
 	kfree(info);


