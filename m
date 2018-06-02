From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 06/20] netfilter: nat: make symbol nat_hook static
Date: Sat,  2 Jun 2018 02:22:45 +0200
Message-ID: <20180602002259.4024-7-pablo@netfilter.org>
References: <20180602002259.4024-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180602002259.4024-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

Fixes the following sparse warning:

net/netfilter/nf_nat_core.c:1039:20: warning:
 symbol 'nat_hook' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_nat_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 821f8d835f7a..b7df32a56e7e 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -1036,7 +1036,7 @@ static struct pernet_operations nat_net_ops = {
 	.size = sizeof(struct nat_net),
 };
 
-struct nf_nat_hook nat_hook = {
+static struct nf_nat_hook nat_hook = {
 	.parse_nat_setup	= nfnetlink_parse_nat_setup,
 #ifdef CONFIG_XFRM
 	.decode_session		= __nf_nat_decode_session,
-- 
2.11.0
