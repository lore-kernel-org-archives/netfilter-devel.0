From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 11/47] netfilter: x_tables: cap allocations at 512 mbyte
Date: Fri, 30 Mar 2018 13:38:38 +0200
Message-ID: <20180330113914.18431-2-pablo@netfilter.org>
References: <20180330113914.18431-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180330113914.18431-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Arbitrary limit, however, this still allows huge rulesets
(> 1 million rules).  This helps with automated fuzzer as it prevents
oom-killer invocation.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/x_tables.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 4e6cbb38e616..dc68ac49614a 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -40,6 +40,7 @@ MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
 MODULE_DESCRIPTION("{ip,ip6,arp,eb}_tables backend module");
 
 #define XT_PCPU_BLOCK_SIZE 4096
+#define XT_MAX_TABLE_SIZE	(512 * 1024 * 1024)
 
 struct compat_delta {
 	unsigned int offset; /* offset in kernel */
@@ -1117,7 +1118,7 @@ struct xt_table_info *xt_alloc_table_info(unsigned int size)
 	struct xt_table_info *info = NULL;
 	size_t sz = sizeof(*info) + size;
 
-	if (sz < sizeof(*info))
+	if (sz < sizeof(*info) || sz >= XT_MAX_TABLE_SIZE)
 		return NULL;
 
 	/* __GFP_NORETRY is not fully supported by kvmalloc but it should
-- 
2.11.0
