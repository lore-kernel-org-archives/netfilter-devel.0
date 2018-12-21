From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 28/37] netfilter: ipt_CLUSTERIP: check MAC address when duplicate config is set
Date: Fri, 21 Dec 2018 01:28:32 +0100
Message-ID: <20181221002841.28587-29-pablo@netfilter.org>
References: <20181221002841.28587-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181221002841.28587-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

If same destination IP address config is already existing, that config is
just used. MAC address also should be same.
However, there is no MAC address checking routine.
So that MAC address checking routine is added.

test commands:
   %iptables -A INPUT -p tcp -i lo -d 192.168.0.5 --dport 80 \
	   -j CLUSTERIP --new --hashmode sourceip \
	   --clustermac 01:00:5e:00:00:20 --total-nodes 2 --local-node 1
   %iptables -A INPUT -p tcp -i lo -d 192.168.0.5 --dport 80 \
	   -j CLUSTERIP --new --hashmode sourceip \
	   --clustermac 01:00:5e:00:00:21 --total-nodes 2 --local-node 1

After this patch, above commands are disallowed.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/ipt_CLUSTERIP.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index d4d549a46c04..b61977db9b7f 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -509,7 +509,8 @@ static int clusterip_tg_check(const struct xt_tgchk_param *par)
 			if (IS_ERR(config))
 				return PTR_ERR(config);
 		}
-	}
+	} else if (memcmp(&config->clustermac, &cipinfo->clustermac, ETH_ALEN))
+		return -EINVAL;
 
 	ret = nf_ct_netns_get(par->net, par->family);
 	if (ret < 0) {
-- 
2.11.0
