From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 05/11] netfilter: conntrack: fix indentation issue
Date: Mon, 18 Feb 2019 00:23:51 +0100
Message-ID: <20190217232357.29858-6-pablo@netfilter.org>
References: <20190217232357.29858-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190217232357.29858-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

A statement in an if block is not indented correctly. Fix this.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 8071bb04a849..349b42a65c8a 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2675,7 +2675,7 @@ static int ctnetlink_exp_dump_mask(struct sk_buff *skb,
 	ret = ctnetlink_dump_tuples_ip(skb, &m);
 	if (ret >= 0) {
 		l4proto = nf_ct_l4proto_find(tuple->dst.protonum);
-	ret = ctnetlink_dump_tuples_proto(skb, &m, l4proto);
+		ret = ctnetlink_dump_tuples_proto(skb, &m, l4proto);
 	}
 	rcu_read_unlock();
 
-- 
2.11.0
