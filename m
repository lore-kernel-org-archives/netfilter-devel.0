From: Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH 5/5] netfilter: fix error return value of nf_ct_l4proto_pernet_register_one()
Date: Wed,  5 Dec 2018 20:56:30 +0800
Message-ID: <1544014590-14429-5-git-send-email-laoar.shao@gmail.com>
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

If pn is NULL, it will return 0.
That's not proper. We should return an error.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 net/netfilter/nf_conntrack_proto.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 316fef3..3caf137 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -252,6 +252,7 @@ int nf_ct_l4proto_pernet_register_one(struct net *net,
 			goto out;
 	}
 
+	ret = -EINVAL;
 	pn = nf_ct_l4proto_net(net, l4proto);
 	if (pn == NULL)
 		goto out;
-- 
1.8.3.1
