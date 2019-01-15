From: wenxu@ucloud.cn
Subject: [PATCH] netfilter: nft_meta: Add NFT_META_L3MASTER meta type
Date: Tue, 15 Jan 2019 13:10:39 +0800
Message-ID: <1547529039-26786-1-git-send-email-wenxu@ucloud.cn>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: pablo@netfilter.org, dsahern@gmail.com, fw@strlen.de
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

In the ip_rcv the skb go through the PREROUTING hook first,
Then jump in vrf device go through the same hook again.
When conntrack dnat work with vrf, there will be some conflict for rules.
Because the package go through the hook twice with different nf status

ip link add user1 type vrf table 1
ip link add user2 type vrf table 2
ip l set dev tun1 master user1
ip l set dev tun2 master user2

nft add table firewall
nft add chain firewall zones { type filter hook prerouting  priority - 300 \; }
nft add rule firewall zones counter ct zone set iif map { "tun1" : 1, "tun2" : 2 }
nft add chain firewall rule-1000-ingress
nft add rule firewall rule-1000-ingress ct zone 1 tcp dport 22 ct state new counter accept
nft add rule firewall rule-1000-ingress counter drop
nft add chain firewall rule-1000-egress
nft add rule firewall rule-1000-egress tcp dport 22 ct state new counter drop
nft add rule firewall rule-1000-egress counter accept

nft add chain firewall rules-all { type filter hook prerouting priority - 150 \; }
nft add rule firewall rules-all ip daddr vmap { "2.2.2.11" : jump rule-1000-ingress }
nft add rule firewall rules-all ct zone vmap { 1 : jump rule-1000-egress }

nft add rule firewall dnat-all ct zone vmap { 1 : jump dnat-1000 }
nft add rule firewall dnat-1000 ip daddr 2.2.2.11 counter dnat to 10.0.0.7

For a package with ip daddr 2.2.2.11 and tcp dport 22, first time accept in the
rule-1000-ingress and dnat to 10.0.0.7. Then second time the packet goto the wrong
chain rule-1000-egress which leads the packet drop

so with this patch userspace can add the 'don't re-do entire ruleset for vrf' policy
itself like the following

nft add rule firewall rules-all meta l3master true counter accept

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 include/uapi/linux/netfilter/nf_tables.h | 2 ++
 net/netfilter/nft_meta.c                 | 8 ++++++++
 2 files changed, 10 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 7de4f1b..dc45972 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -789,6 +789,7 @@ enum nft_exthdr_attributes {
  * @NFT_META_CGROUP: socket control group (skb->sk->sk_classid)
  * @NFT_META_PRANDOM: a 32bit pseudo-random number
  * @NFT_META_SECPATH: boolean, secpath_exists (!!skb->sp)
+ * @NFT_META_L3MASTER: boolean, netif_is_l3_master(dev)
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -817,6 +818,7 @@ enum nft_meta_keys {
 	NFT_META_CGROUP,
 	NFT_META_PRANDOM,
 	NFT_META_SECPATH,
+	NFT_META_L3MASTER,
 };
 
 /**
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 6df486c..84c8151 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -244,6 +244,11 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 		strncpy((char *)dest, p->br->dev->name, IFNAMSIZ);
 		return;
 #endif
+	case NFT_META_L3MASTER:
+		if (in == NULL)
+			goto err;
+		nft_reg_store8(dest, netif_is_l3_master(in));
+		break;
 	default:
 		WARN_ON(1);
 		goto err;
@@ -359,6 +364,9 @@ static int nft_meta_get_init(const struct nft_ctx *ctx,
 		len = IFNAMSIZ;
 		break;
 #endif
+	case NFT_META_L3MASTER:
+		len = sizeof(u8);
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
1.8.3.1
