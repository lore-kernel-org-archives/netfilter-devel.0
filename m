From: Colin King <colin.king@canonical.com>
Subject: [PATCH][netfilter-next] netfilter: conntrack: make struct nf_conntrack_l4proto_gre4 static
Date: Sun, 10 Dec 2017 23:32:55 +0000
Message-ID: <20171210233255.15009-1-colin.king@canonical.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Return-path: <kernel-janitors-owner@vger.kernel.org>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The structure nf_conntrack_l4proto_gre4  is local to the source and does
not need to be in global scope, so make it static.

Cleans up sparse warning:
symbol 'nf_conntrack_l4proto_gre4' was not declared. Should it be static?

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/netfilter/nf_conntrack_proto_gre.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index 6d8d1276cf3a..86c346ea1dd5 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -352,7 +352,7 @@ static int gre_init_net(struct net *net, u_int16_t proto)
 }
 
 /* protocol helper struct */
-struct nf_conntrack_l4proto nf_conntrack_l4proto_gre4 = {
+static struct nf_conntrack_l4proto nf_conntrack_l4proto_gre4 = {
 	.l3proto	 = AF_INET,
 	.l4proto	 = IPPROTO_GRE,
 	.pkt_to_tuple	 = gre_pkt_to_tuple,
-- 
2.14.1

