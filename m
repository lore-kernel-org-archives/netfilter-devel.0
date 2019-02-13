From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 56/83] netfilter: nft_flow_offload: fix checking method of conntrack helper
Date: Tue, 12 Feb 2019 21:36:34 -0500
Message-ID: <20190213023701.20286-56-sashal@kernel.org>
References: <20190213023701.20286-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: Henry Yen <henry.yen@mediatek.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190213023701.20286-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Henry Yen <henry.yen@mediatek.com>

[ Upstream commit 2314e879747e82896f51cce4488f6a00f3e1af7b ]

This patch uses nfct_help() to detect whether an established connection
needs conntrack helper instead of using test_bit(IPS_HELPER_BIT,
&ct->status).

The reason is that IPS_HELPER_BIT is only set when using explicit CT
target.

However, in the case that a device enables conntrack helper via command
"echo 1 > /proc/sys/net/netfilter/nf_conntrack_helper", the status of
IPS_HELPER_BIT will not present any change, and consequently it loses
the checking ability in the context.

Signed-off-by: Henry Yen <henry.yen@mediatek.com>
Reviewed-by: Ryder Lee <ryder.lee@mediatek.com>
Tested-by: John Crispin <john@phrozen.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_flow_offload.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 4d7cf943fff2..436cc14cfc59 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -12,6 +12,7 @@
 #include <net/netfilter/nf_conntrack_core.h>
 #include <linux/netfilter/nf_conntrack_common.h>
 #include <net/netfilter/nf_flow_table.h>
+#include <net/netfilter/nf_conntrack_helper.h>
 
 struct nft_flow_offload {
 	struct nft_flowtable	*flowtable;
@@ -66,6 +67,7 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 {
 	struct nft_flow_offload *priv = nft_expr_priv(expr);
 	struct nf_flowtable *flowtable = &priv->flowtable->data;
+	const struct nf_conn_help *help;
 	enum ip_conntrack_info ctinfo;
 	struct nf_flow_route route;
 	struct flow_offload *flow;
@@ -88,7 +90,8 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 		goto out;
 	}
 
-	if (test_bit(IPS_HELPER_BIT, &ct->status))
+	help = nfct_help(ct);
+	if (help)
 		goto out;
 
 	if (ctinfo == IP_CT_NEW ||
-- 
2.19.1
