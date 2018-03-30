From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 16/47] netfilter: x_tables: make sure compat af mutex is held
Date: Fri, 30 Mar 2018 13:38:43 +0200
Message-ID: <20180330113914.18431-7-pablo@netfilter.org>
References: <20180330113914.18431-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180330113914.18431-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/x_tables.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 33724b08b8f0..7521e8a72c06 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -582,6 +582,8 @@ int xt_compat_add_offset(u_int8_t af, unsigned int offset, int delta)
 {
 	struct xt_af *xp = &xt[af];
 
+	WARN_ON(!mutex_is_locked(&xt[af].compat_mutex));
+
 	if (WARN_ON(!xp->compat_tab))
 		return -ENOMEM;
 
@@ -599,6 +601,8 @@ EXPORT_SYMBOL_GPL(xt_compat_add_offset);
 
 void xt_compat_flush_offsets(u_int8_t af)
 {
+	WARN_ON(!mutex_is_locked(&xt[af].compat_mutex));
+
 	if (xt[af].compat_tab) {
 		vfree(xt[af].compat_tab);
 		xt[af].compat_tab = NULL;
@@ -630,6 +634,8 @@ int xt_compat_init_offsets(u8 af, unsigned int number)
 {
 	size_t mem;
 
+	WARN_ON(!mutex_is_locked(&xt[af].compat_mutex));
+
 	if (!number || number > (INT_MAX / sizeof(struct compat_delta)))
 		return -EINVAL;
 
-- 
2.11.0
