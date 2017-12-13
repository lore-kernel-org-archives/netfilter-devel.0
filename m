From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 06/12] netfilter: conntrack: clamp timeouts to INT_MAX
Date: Wed, 13 Dec 2017 19:45:14 +0100
Message-ID: <20171213184520.8193-7-pablo@netfilter.org>
References: <20171213184520.8193-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20171213184520.8193-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Jay Elliott <jelliott@arista.com>

When the conntracking code multiplies a timeout by HZ, it can overflow
from positive to negative; this causes it to instantly expire.  To
protect against this the multiplication is done in 64-bit so we can
prevent it from exceeding INT_MAX.

Signed-off-by: Jay Elliott <jelliott@arista.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 59c08997bfdf..66d72a8fa87f 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1566,9 +1566,11 @@ static int ctnetlink_change_helper(struct nf_conn *ct,
 static int ctnetlink_change_timeout(struct nf_conn *ct,
 				    const struct nlattr * const cda[])
 {
-	u_int32_t timeout = ntohl(nla_get_be32(cda[CTA_TIMEOUT]));
+	u64 timeout = (u64)ntohl(nla_get_be32(cda[CTA_TIMEOUT])) * HZ;
 
-	ct->timeout = nfct_time_stamp + timeout * HZ;
+	if (timeout > INT_MAX)
+		timeout = INT_MAX;
+	ct->timeout = nfct_time_stamp + (u32)timeout;
 
 	if (test_bit(IPS_DYING_BIT, &ct->status))
 		return -ETIME;
@@ -1768,6 +1770,7 @@ ctnetlink_create_conntrack(struct net *net,
 	int err = -EINVAL;
 	struct nf_conntrack_helper *helper;
 	struct nf_conn_tstamp *tstamp;
+	u64 timeout;
 
 	ct = nf_conntrack_alloc(net, zone, otuple, rtuple, GFP_ATOMIC);
 	if (IS_ERR(ct))
@@ -1776,7 +1779,10 @@ ctnetlink_create_conntrack(struct net *net,
 	if (!cda[CTA_TIMEOUT])
 		goto err1;
 
-	ct->timeout = nfct_time_stamp + ntohl(nla_get_be32(cda[CTA_TIMEOUT])) * HZ;
+	timeout = (u64)ntohl(nla_get_be32(cda[CTA_TIMEOUT])) * HZ;
+	if (timeout > INT_MAX)
+		timeout = INT_MAX;
+	ct->timeout = (u32)timeout + nfct_time_stamp;
 
 	rcu_read_lock();
  	if (cda[CTA_HELP]) {
-- 
2.11.0
