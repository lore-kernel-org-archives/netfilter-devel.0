From: Wei Yongjun <weiyongjun1@huawei.com>
Subject: [PATCH net-next] netfilter: nfnetlink_osf: fix using plain integer as NULL warning
Date: Wed, 8 Aug 2018 03:23:44 +0000
Message-ID: <1533698624-107304-1-git-send-email-weiyongjun1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Wei Yongjun <weiyongjun1@huawei.com>,
        <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
        <netdev@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Fixes the following sparse warning:

net/netfilter/nfnetlink_osf.c:274:24: warning:
 Using plain integer as NULL pointer

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 net/netfilter/nfnetlink_osf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
index f9dba62..00db27d 100644
--- a/net/netfilter/nfnetlink_osf.c
+++ b/net/netfilter/nfnetlink_osf.c
@@ -271,7 +271,7 @@ const char *nf_osf_find(const struct sk_buff *skb,
 
 	tcp = nf_osf_hdr_ctx_init(&ctx, skb, ip, opts);
 	if (!tcp)
-		return false;
+		return NULL;
 
 	list_for_each_entry_rcu(kf, &nf_osf_fingers[ctx.df], finger_entry) {
 		f = &kf->finger;
