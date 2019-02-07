From: Colin King <colin.king@canonical.com>
Subject: [PATCH] netfilter: conntrack: fix indentation issue
Date: Thu,  7 Feb 2019 13:13:11 +0000
Message-ID: <20190207131311.3725-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

A statement in an if block is not indented correctly. Fix this.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
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
2.20.1
