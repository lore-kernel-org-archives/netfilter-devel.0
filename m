From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 02/10] netfilter: cttimeout: remove set but not used variable 'l3num'
Date: Sat, 20 Oct 2018 11:43:09 +0200
Message-ID: <20181020094317.16011-3-pablo@netfilter.org>
References: <20181020094317.16011-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181020094317.16011-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

Fixes gcc '-Wunused-but-set-variable' warning:

net/netfilter/nfnetlink_cttimeout.c: In function 'cttimeout_default_set':
net/netfilter/nfnetlink_cttimeout.c:353:8: warning:
 variable 'l3num' set but not used [-Wunused-but-set-variable]

It not used any more after
commit dd2934a95701 ("netfilter: conntrack: remove l3->l4 mapping information")

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_cttimeout.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index b48545b84ce8..e7a50af1b3d6 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -350,7 +350,6 @@ static int cttimeout_default_set(struct net *net, struct sock *ctnl,
 				 struct netlink_ext_ack *extack)
 {
 	const struct nf_conntrack_l4proto *l4proto;
-	__u16 l3num;
 	__u8 l4num;
 	int ret;
 
@@ -359,7 +358,6 @@ static int cttimeout_default_set(struct net *net, struct sock *ctnl,
 	    !cda[CTA_TIMEOUT_DATA])
 		return -EINVAL;
 
-	l3num = ntohs(nla_get_be16(cda[CTA_TIMEOUT_L3PROTO]));
 	l4num = nla_get_u8(cda[CTA_TIMEOUT_L4PROTO]);
 	l4proto = nf_ct_l4proto_find_get(l4num);
 
-- 
2.11.0
