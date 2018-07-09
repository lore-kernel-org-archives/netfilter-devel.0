From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6/6] netfilter: ipv6: nf_defrag: drop skb dst before queueing
Date: Mon,  9 Jul 2018 19:19:04 +0200
Message-ID: <20180709171904.2460-7-pablo@netfilter.org>
References: <20180709171904.2460-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180709171904.2460-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Eric Dumazet reports:
 Here is a reproducer of an annoying bug detected by syzkaller on our production kernel
 [..]
 ./b78305423 enable_conntrack
 Then :
 sleep 60
 dmesg | tail -10
 [  171.599093] unregister_netdevice: waiting for lo to become free. Usage count = 2
 [  181.631024] unregister_netdevice: waiting for lo to become free. Usage count = 2
 [  191.687076] unregister_netdevice: waiting for lo to become free. Usage count = 2
 [  201.703037] unregister_netdevice: waiting for lo to become free. Usage count = 2
 [  211.711072] unregister_netdevice: waiting for lo to become free. Usage count = 2
 [  221.959070] unregister_netdevice: waiting for lo to become free. Usage count = 2

Reproducer sends ipv6 fragment that hits nfct defrag via LOCAL_OUT hook.
skb gets queued until frag timer expiry -- 1 minute.

Normally nf_conntrack_reasm gets called during prerouting, so skb has
no dst yet which might explain why this wasn't spotted earlier.

Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Reported-by: John Sperbeck <jsperbeck@google.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Tested-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv6/netfilter/nf_conntrack_reasm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index a452d99c9f52..e4d9e6976d3c 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -585,6 +585,8 @@ int nf_ct_frag6_gather(struct net *net, struct sk_buff *skb, u32 user)
 	    fq->q.meat == fq->q.len &&
 	    nf_ct_frag6_reasm(fq, skb, dev))
 		ret = 0;
+	else
+		skb_dst_drop(skb);
 
 out_unlock:
 	spin_unlock_bh(&fq->q.lock);
-- 
2.11.0
