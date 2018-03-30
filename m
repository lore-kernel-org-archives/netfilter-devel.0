From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 45/47] netfilter: x_tables: Add note about how to free percpu counters
Date: Fri, 30 Mar 2018 13:46:17 +0200
Message-ID: <20180330114619.18797-6-pablo@netfilter.org>
References: <20180330114619.18797-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180330114619.18797-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Ben Hutchings <ben.hutchings@codethink.co.uk>

Due to the way percpu counters are allocated and freed in blocks,
it is not safe to free counters individually.  Currently all callers
do the right thing, but let's note this restriction.

Fixes: ae0ac0ed6fcf ("netfilter: x_tables: pack percpu counter allocations")
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/x_tables.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index bac932f1c582..75cd5196b29b 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1854,7 +1854,9 @@ EXPORT_SYMBOL_GPL(xt_proto_fini);
  * to fetch the real percpu counter.
  *
  * To speed up allocation and improve data locality, a 4kb block is
- * allocated.
+ * allocated.  Freeing any counter may free an entire block, so all
+ * counters allocated using the same state must be freed at the same
+ * time.
  *
  * xt_percpu_counter_alloc_state contains the base address of the
  * allocated page and the current sub-offset.
-- 
2.11.0
