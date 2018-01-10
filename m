From: Wei Yongjun <weiyongjun1@huawei.com>
Subject: [PATCH net-next] netfilter: nf_tables: fix a typo in nf_tables_getflowtable()
Date: Wed, 10 Jan 2018 07:04:54 +0000
Message-ID: <1515567894-188104-1-git-send-email-weiyongjun1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Wei Yongjun <weiyongjun1@huawei.com>,
        <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
        <netdev@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Fix a typo, we should check 'flowtable' instead of 'table'.

Fixes: 3b49e2e94e6e ("netfilter: nf_tables: add flow table netlink frontend")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 336b816..40594bb 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5420,7 +5420,7 @@ static int nf_tables_getflowtable(struct net *net, struct sock *nlsk,
 
 	flowtable = nf_tables_flowtable_lookup(table, nla[NFTA_FLOWTABLE_NAME],
 					       genmask);
-	if (IS_ERR(table))
+	if (IS_ERR(flowtable))
 		return PTR_ERR(flowtable);
 
 	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
