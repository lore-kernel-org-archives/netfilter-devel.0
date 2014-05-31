From: Robin Schroer <sulamiification@gmail.com>
Subject: [PATCH] driver/netfilter/nfnetlink: removed unused variable
Date: Sat, 31 May 2014 13:06:28 +0200
Message-ID: <20140531110628.GA30443@shodan.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	coreteam@netfilter.org, linux-kernel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Removes the unused struct net *net = sock_net(skb->sk);

Signed-off-by: Robin Schroer <sulamiification@gmail.com>
---
 net/netfilter/nfnetlink.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index c138b8f..5cc9db2 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -226,7 +226,6 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 				u_int16_t subsys_id)
 {
 	struct sk_buff *nskb, *oskb = skb;
-	struct net *net = sock_net(skb->sk);
 	const struct nfnetlink_subsystem *ss;
 	const struct nfnl_callback *nc;
 	bool success = true, done = false;
-- 
1.9.3


-- 

Robin Schroer
