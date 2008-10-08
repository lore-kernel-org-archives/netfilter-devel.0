From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 44/79: enable netfilter in netns
Date: Wed,  8 Oct 2008 12:47:20 +0200 (MEST)
Message-ID: <20081008104720.10423.80912.sendpatchset@x2.localnet>
References: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45992 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664AbYJHKrV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2008 06:47:21 -0400
In-Reply-To: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 4de6f16b9ec2422fa7ef9c22f7b1c8d5a55499b4
Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Wed Oct 8 11:35:11 2008 +0200

    netfilter: enable netfilter in netns
    
    From kernel perspective, allow entrance in nf_hook_slow().
    
    Stuff which uses nf_register_hook/nf_register_hooks, but otherwise not netns-ready:
    
    	DECnet netfilter
    	ipt_CLUSTERIP
    	nf_nat_standalone.c together with XFRM (?)
    	IPVS
    	several individual match modules (like hashlimit)
    	ctnetlink
    	NOTRACK
    	all sorts of queueing and reporting to userspace
    	L3 and L4 protocol sysctls, bridge sysctls
    	probably something else
    
    Anyway critical mass has been achieved, there is no reason to hide netfilter any longer.
    
    From userspace perspective, allow to manipulate all sorts of
    iptables/ip6tables/arptables rules.
    
    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index b16cd79..a90ac83 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -165,14 +165,6 @@ int nf_hook_slow(u_int8_t pf, unsigned int hook, struct sk_buff *skb,
 	unsigned int verdict;
 	int ret = 0;
 
-#ifdef CONFIG_NET_NS
-	struct net *net;
-
-	net = indev == NULL ? dev_net(outdev) : dev_net(indev);
-	if (net != &init_net)
-		return 1;
-#endif
-
 	/* We may already have this, but read-locks nest anyway */
 	rcu_read_lock();
 
diff --git a/net/netfilter/nf_sockopt.c b/net/netfilter/nf_sockopt.c
index f9b46de..8ab829f 100644
--- a/net/netfilter/nf_sockopt.c
+++ b/net/netfilter/nf_sockopt.c
@@ -65,9 +65,6 @@ static struct nf_sockopt_ops *nf_sockopt_find(struct sock *sk, u_int8_t pf,
 {
 	struct nf_sockopt_ops *ops;
 
-	if (!net_eq(sock_net(sk), &init_net))
-		return ERR_PTR(-ENOPROTOOPT);
-
 	if (mutex_lock_interruptible(&nf_sockopt_mutex) != 0)
 		return ERR_PTR(-EINTR);
 
