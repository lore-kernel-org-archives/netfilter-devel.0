From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 8/8] netfilter: nfnetlink_osf: fix using plain integer as NULL warning
Date: Fri, 10 Aug 2018 13:16:22 +0200
Message-ID: <20180810111622.3981-9-pablo@netfilter.org>
References: <20180810111622.3981-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180810111622.3981-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

Fixes the following sparse warning:

net/netfilter/nfnetlink_osf.c:274:24: warning:
 Using plain integer as NULL pointer

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_osf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
index f9dba62c450f..00db27dfd2ff 100644
--- a/net/netfilter/nfnetlink_osf.c
+++ b/net/netfilter/nfnetlink_osf.c
@@ -271,7 +271,7 @@ const char *nf_osf_find(const struct sk_buff *skb,
 
 	tcp = nf_osf_hdr_ctx_init(&ctx, skb, ip, opts);
 	if (!tcp)
-		return false;
+		return NULL;
 
 	list_for_each_entry_rcu(kf, &nf_osf_fingers[ctx.df], finger_entry) {
 		f = &kf->finger;
-- 
2.11.0
