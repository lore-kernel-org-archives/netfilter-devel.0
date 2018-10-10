From: YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] netfilter: cttimeout: remove set but not used variable 'l3num'
Date: Wed, 10 Oct 2018 02:14:12 +0000
Message-ID: <1539137652-64831-1-git-send-email-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: YueHaibing <yuehaibing@huawei.com>,
        <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
        <netdev@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

net/netfilter/nfnetlink_cttimeout.c: In function 'cttimeout_default_set':
net/netfilter/nfnetlink_cttimeout.c:353:8: warning:
 variable 'l3num' set but not used [-Wunused-but-set-variable]

It not used any more after
commit dd2934a95701 ("netfilter: conntrack: remove l3->l4 mapping information")

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/netfilter/nfnetlink_cttimeout.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index b48545b..e7a50af 100644
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
