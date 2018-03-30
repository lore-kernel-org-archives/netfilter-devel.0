From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 15/47] netfilter: compat: reject huge allocation requests
Date: Fri, 30 Mar 2018 13:38:42 +0200
Message-ID: <20180330113914.18431-6-pablo@netfilter.org>
References: <20180330113914.18431-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180330113914.18431-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

no need to bother even trying to allocating huge compat offset arrays,
such ruleset is rejected later on anyway becaus we refuse to allocate
overly large rule blobs.

However, compat translation happens before blob allocation, so we should
add a check there too.

This is supposed to help with fuzzing by avoiding oom-killer.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/x_tables.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index e878c85a9268..33724b08b8f0 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -582,14 +582,8 @@ int xt_compat_add_offset(u_int8_t af, unsigned int offset, int delta)
 {
 	struct xt_af *xp = &xt[af];
 
-	if (!xp->compat_tab) {
-		if (!xp->number)
-			return -EINVAL;
-		xp->compat_tab = vmalloc(sizeof(struct compat_delta) * xp->number);
-		if (!xp->compat_tab)
-			return -ENOMEM;
-		xp->cur = 0;
-	}
+	if (WARN_ON(!xp->compat_tab))
+		return -ENOMEM;
 
 	if (xp->cur >= xp->number)
 		return -EINVAL;
@@ -634,6 +628,22 @@ EXPORT_SYMBOL_GPL(xt_compat_calc_jump);
 
 int xt_compat_init_offsets(u8 af, unsigned int number)
 {
+	size_t mem;
+
+	if (!number || number > (INT_MAX / sizeof(struct compat_delta)))
+		return -EINVAL;
+
+	if (WARN_ON(xt[af].compat_tab))
+		return -EINVAL;
+
+	mem = sizeof(struct compat_delta) * number;
+	if (mem > XT_MAX_TABLE_SIZE)
+		return -ENOMEM;
+
+	xt[af].compat_tab = vmalloc(mem);
+	if (!xt[af].compat_tab)
+		return -ENOMEM;
+
 	xt[af].number = number;
 	xt[af].cur = 0;
 
-- 
2.11.0
