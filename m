From: Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH 4/5] netfilter: fix missed NULL check in nf_conntrack_proto_pernet_init()
Date: Wed,  5 Dec 2018 20:56:29 +0800
Message-ID: <1544014590-14429-4-git-send-email-laoar.shao@gmail.com>
References: <1544014590-14429-1-git-send-email-laoar.shao@gmail.com>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
To: pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de,
        davem@davemloft.net, adobriyan@gmail.com, akpm@linux-foundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1544014590-14429-1-git-send-email-laoar.shao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

nf_ct_l4proto_net() may return NULL.
That may happens if some module forget to set both l4proto->get_net_proto
and l4proto->net_id.
We'd check the return value here, in case crash happens.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 net/netfilter/nf_conntrack_proto.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 154e8c0..316fef3 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -946,6 +946,9 @@ int nf_conntrack_proto_pernet_init(struct net *net)
 	struct nf_proto_net *pn = nf_ct_l4proto_net(net,
 					&nf_conntrack_l4proto_generic);
 
+	if (pn == NULL)
+		return -EINVAL;
+
 	err = nf_conntrack_l4proto_generic.init_net(net);
 	if (err < 0)
 		return err;
-- 
1.8.3.1
