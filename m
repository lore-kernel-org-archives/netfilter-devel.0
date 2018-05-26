From: Wei Yongjun <weiyongjun1@huawei.com>
Subject: [PATCH net-next] netfilter: nat: make symbol nat_hook static
Date: Sat, 26 May 2018 09:48:53 +0000
Message-ID: <1527328133-86305-1-git-send-email-weiyongjun1@huawei.com>
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

net/netfilter/nf_nat_core.c:1039:20: warning:
 symbol 'nat_hook' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 net/netfilter/nf_nat_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 821f8d8..b7df32a 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -1036,7 +1036,7 @@ void nf_nat_unregister_fn(struct net *net, const struct nf_hook_ops *ops,
 	.size = sizeof(struct nat_net),
 };
 
-struct nf_nat_hook nat_hook = {
+static struct nf_nat_hook nat_hook = {
 	.parse_nat_setup	= nfnetlink_parse_nat_setup,
 #ifdef CONFIG_XFRM
 	.decode_session		= __nf_nat_decode_session,
