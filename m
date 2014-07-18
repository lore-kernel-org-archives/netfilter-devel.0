From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 02/18] netfilter: x_tables: xt_free_table_info() cleanup
Date: Fri, 18 Jul 2014 13:00:56 +0200
Message-ID: <1405681272-4994-3-git-send-email-pablo@netfilter.org>
References: <1405681272-4994-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1405681272-4994-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

kvfree() helper can make xt_free_table_info() much cleaner.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/x_tables.c |   23 +++++------------------
 1 file changed, 5 insertions(+), 18 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 227aa11..47b978b 100644
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
-- 
1.7.10.4
