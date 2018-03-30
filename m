From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 12/47] netfilter: x_tables: limit allocation requests for blob rule heads
Date: Fri, 30 Mar 2018 13:38:39 +0200
Message-ID: <20180330113914.18431-3-pablo@netfilter.org>
References: <20180330113914.18431-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180330113914.18431-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

This is a very conservative limit (134217728 rules), but good
enough to not trigger frequent oom from syzkaller.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/x_tables.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index dc68ac49614a..01f8e122e74e 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -894,6 +894,9 @@ EXPORT_SYMBOL(xt_check_entry_offsets);
  */
 unsigned int *xt_alloc_entry_offsets(unsigned int size)
 {
+	if (size > XT_MAX_TABLE_SIZE / sizeof(unsigned int))
+		return NULL;
+
 	return kvmalloc_array(size, sizeof(unsigned int), GFP_KERNEL | __GFP_ZERO);
 
 }
-- 
2.11.0
