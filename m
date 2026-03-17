Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91BD33E866C
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Mar 2026 14:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773756262; cv=none; b=pVrdmee5sE7zXdXhwx6/UvhX3/Ng+iEAVeWCIjCRSLCTjLn8C2dYC8LMDOR4NRhExssQcTwZ0fytwV7agb0rt1BYxhnYCWrXMgvEJEF2zIYMUhn50x5K82Fw/YLhP+c0ZtbfJhaO5DDnqthToD4vAZj83W2Y0kL225OLEWYN5ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773756262; c=relaxed/simple;
	bh=f+GDNcSUStXGIn4wg5mFi4Tfes17h8SsuyaWtRUsTWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TUPBxbWzeSLH9wlqbuxUzYVyruVwHI777COAE3FYS8Yz9/rA/0OnF4J0T+taa+mcjrOgLaCdtAD4PNNiS1UfJNj3r694+EqOaI7uxXd1i1h5Y/TS9vVkUG37VUW0v8MFL9A0jO3NvFnDn4EKH3I+x3SYlB7YML0/VZhQ9wM4Pdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ZiZitdjI; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ogC0PSYs; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Bmo3E/RE; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=T7o2Ooaj; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ZiZitdjI";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ogC0PSYs";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Bmo3E/RE";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="T7o2Ooaj"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DB2B74D2B2;
	Tue, 17 Mar 2026 14:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773756259; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z7JPRMc8Ci3PGSq32TTfjunwbbQOsAtAnFSWWqn0ocY=;
	b=ZiZitdjICpz15CWQDPMbwJbWnLJiMlQ0nzgJ1yaKTdKze1kR+TghjLroPEk4+0oI/jyu9Z
	jnF7E8GYlLdFz/8aIUBmgr3m0PzEtxIjyPsdA8z4dqWZeLcVGgzQvsy4oPh9Y6u4PeRxnO
	WEKoHHMPcVul1ZrpKWSRBi/sBH51V5E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773756259;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z7JPRMc8Ci3PGSq32TTfjunwbbQOsAtAnFSWWqn0ocY=;
	b=ogC0PSYs/zBskEDJAAd3FGkUuJHjYF6NErZcugVngKMv4Yc4kikfEGj1e3jSDVmDZRRJsF
	UCxsJqgWr70FVkAA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773756257; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z7JPRMc8Ci3PGSq32TTfjunwbbQOsAtAnFSWWqn0ocY=;
	b=Bmo3E/REE5zrylgY+/830Va6slHksBNq+lnJnP7ruSuLUKLiLqvvQW2jvU7bk41pAr0mA6
	ZW+m2SKxSpW3kRTnQxCE8xaoTZ5GMLyrvgZXvP3LhgkxGZHfGXzdiG0nuWEJz5ZocAGJgV
	s6YTkwbu3S/pOc0wGp/1Had8DjMeFRc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773756257;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z7JPRMc8Ci3PGSq32TTfjunwbbQOsAtAnFSWWqn0ocY=;
	b=T7o2OoajQcVYkhe88dUL52uX9c74i6/Hg4KIqMIJM6cpSU2Jm3VLpLZU2+uw4BOuh1huqV
	k94nXGKUlJrTWsCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D11784273B;
	Tue, 17 Mar 2026 14:04:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IHz8L2BfuWmpYwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 17 Mar 2026 14:04:16 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netdev@vger.kernel.org
Cc: Fernando Fernandez Mancera <fmancera@suse.de>,
	=?UTF-8?q?Ricardo=20B=2E=20Marli=C3=A8re?= <rbm@suse.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org,
	bridge@lists.linux.dev
Subject: [PATCH 10/10 net-next v3] netfilter: remove nf_ipv6_ops and use direct function calls
Date: Tue, 17 Mar 2026 15:01:06 +0100
Message-ID: <20260317140141.5723-11-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260317140141.5723-1-fmancera@suse.de>
References: <20260317140141.5723-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-7.30 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -7.30
X-Spam-Level: 

As IPv6 is built-in only, nf_ipv6_ops can be removed completely as it is
not longer necessary.

Convert all nf_ipv6_ops usage to direct function calls instead. In
addition, remove the ipv6_netfilter_init/fini() functions as they are
not necessary any longer.

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Tested-by: Ricardo B. Marlière <rbm@suse.com>
---
 include/linux/netfilter_ipv6.h    | 102 ++----------------------------
 include/net/ip.h                  |   5 --
 net/bridge/br_netfilter_hooks.c   |  12 +---
 net/bridge/br_netfilter_ipv6.c    |   7 +-
 net/ipv6/af_inet6.c               |   6 --
 net/ipv6/netfilter.c              |  48 --------------
 net/netfilter/core.c              |   3 -
 net/netfilter/nf_nat_masquerade.c |  21 +-----
 net/netfilter/nfnetlink_queue.c   |  22 +++++--
 net/netfilter/utils.c             |   1 -
 10 files changed, 32 insertions(+), 195 deletions(-)

diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index 61aa48f46dd7..5ce45b6d890f 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -34,59 +34,13 @@ struct ip6_rt_info {
 struct nf_queue_entry;
 struct nf_bridge_frag_data;
 
-/*
- * Hook functions for ipv6 to allow xt_* modules to be built-in even
- * if IPv6 is a module.
- */
-struct nf_ipv6_ops {
-#if IS_MODULE(CONFIG_IPV6)
-	int (*chk_addr)(struct net *net, const struct in6_addr *addr,
-			const struct net_device *dev, int strict);
-	int (*route_me_harder)(struct net *net, struct sock *sk, struct sk_buff *skb);
-	int (*dev_get_saddr)(struct net *net, const struct net_device *dev,
-		       const struct in6_addr *daddr, unsigned int srcprefs,
-		       struct in6_addr *saddr);
-	int (*route)(struct net *net, struct dst_entry **dst, struct flowi *fl,
-		     bool strict);
-	u32 (*cookie_init_sequence)(const struct ipv6hdr *iph,
-				    const struct tcphdr *th, u16 *mssp);
-	int (*cookie_v6_check)(const struct ipv6hdr *iph,
-			       const struct tcphdr *th);
-#endif
-	void (*route_input)(struct sk_buff *skb);
-	int (*fragment)(struct net *net, struct sock *sk, struct sk_buff *skb,
-			int (*output)(struct net *, struct sock *, struct sk_buff *));
-	int (*reroute)(struct sk_buff *skb, const struct nf_queue_entry *entry);
-#if IS_MODULE(CONFIG_IPV6)
-	int (*br_fragment)(struct net *net, struct sock *sk,
-			   struct sk_buff *skb,
-			   struct nf_bridge_frag_data *data,
-			   int (*output)(struct net *, struct sock *sk,
-					 const struct nf_bridge_frag_data *data,
-					 struct sk_buff *));
-#endif
-};
-
 #ifdef CONFIG_NETFILTER
 #include <net/addrconf.h>
 
-extern const struct nf_ipv6_ops __rcu *nf_ipv6_ops;
-static inline const struct nf_ipv6_ops *nf_get_ipv6_ops(void)
-{
-	return rcu_dereference(nf_ipv6_ops);
-}
-
 static inline int nf_ipv6_chk_addr(struct net *net, const struct in6_addr *addr,
 				   const struct net_device *dev, int strict)
 {
-#if IS_MODULE(CONFIG_IPV6)
-	const struct nf_ipv6_ops *v6_ops = nf_get_ipv6_ops();
-
-	if (!v6_ops)
-		return 1;
-
-	return v6_ops->chk_addr(net, addr, dev, strict);
-#elif IS_BUILTIN(CONFIG_IPV6)
+#if IS_ENABLED(CONFIG_IPV6)
 	return ipv6_chk_addr(net, addr, dev, strict);
 #else
 	return 1;
@@ -99,15 +53,7 @@ int __nf_ip6_route(struct net *net, struct dst_entry **dst,
 static inline int nf_ip6_route(struct net *net, struct dst_entry **dst,
 			       struct flowi *fl, bool strict)
 {
-#if IS_MODULE(CONFIG_IPV6)
-	const struct nf_ipv6_ops *v6ops = nf_get_ipv6_ops();
-
-	if (v6ops)
-		return v6ops->route(net, dst, fl, strict);
-
-	return -EHOSTUNREACH;
-#endif
-#if IS_BUILTIN(CONFIG_IPV6)
+#if IS_ENABLED(CONFIG_IPV6)
 	return __nf_ip6_route(net, dst, fl, strict);
 #else
 	return -EHOSTUNREACH;
@@ -129,14 +75,7 @@ static inline int nf_br_ip6_fragment(struct net *net, struct sock *sk,
 						   const struct nf_bridge_frag_data *data,
 						   struct sk_buff *))
 {
-#if IS_MODULE(CONFIG_IPV6)
-	const struct nf_ipv6_ops *v6_ops = nf_get_ipv6_ops();
-
-	if (!v6_ops)
-		return 1;
-
-	return v6_ops->br_fragment(net, sk, skb, data, output);
-#elif IS_BUILTIN(CONFIG_IPV6)
+#if IS_ENABLED(CONFIG_IPV6)
 	return br_ip6_fragment(net, sk, skb, data, output);
 #else
 	return 1;
@@ -147,14 +86,7 @@ int ip6_route_me_harder(struct net *net, struct sock *sk, struct sk_buff *skb);
 
 static inline int nf_ip6_route_me_harder(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
-#if IS_MODULE(CONFIG_IPV6)
-	const struct nf_ipv6_ops *v6_ops = nf_get_ipv6_ops();
-
-	if (!v6_ops)
-		return -EHOSTUNREACH;
-
-	return v6_ops->route_me_harder(net, sk, skb);
-#elif IS_BUILTIN(CONFIG_IPV6)
+#if IS_ENABLED(CONFIG_IPV6)
 	return ip6_route_me_harder(net, sk, skb);
 #else
 	return -EHOSTUNREACH;
@@ -165,15 +97,8 @@ static inline u32 nf_ipv6_cookie_init_sequence(const struct ipv6hdr *iph,
 					       const struct tcphdr *th,
 					       u16 *mssp)
 {
-#if IS_ENABLED(CONFIG_SYN_COOKIES)
-#if IS_MODULE(CONFIG_IPV6)
-	const struct nf_ipv6_ops *v6_ops = nf_get_ipv6_ops();
-
-	if (v6_ops)
-		return v6_ops->cookie_init_sequence(iph, th, mssp);
-#elif IS_BUILTIN(CONFIG_IPV6)
+#if IS_ENABLED(CONFIG_IPV6) && IS_ENABLED(CONFIG_SYN_COOKIES)
 	return __cookie_v6_init_sequence(iph, th, mssp);
-#endif
 #endif
 	return 0;
 }
@@ -181,15 +106,8 @@ static inline u32 nf_ipv6_cookie_init_sequence(const struct ipv6hdr *iph,
 static inline int nf_cookie_v6_check(const struct ipv6hdr *iph,
 				     const struct tcphdr *th)
 {
-#if IS_ENABLED(CONFIG_SYN_COOKIES)
-#if IS_MODULE(CONFIG_IPV6)
-	const struct nf_ipv6_ops *v6_ops = nf_get_ipv6_ops();
-
-	if (v6_ops)
-		return v6_ops->cookie_v6_check(iph, th);
-#elif IS_BUILTIN(CONFIG_IPV6)
+#if IS_ENABLED(CONFIG_IPV6) && IS_ENABLED(CONFIG_SYN_COOKIES)
 	return __cookie_v6_check(iph, th);
-#endif
 #endif
 	return 0;
 }
@@ -198,14 +116,6 @@ __sum16 nf_ip6_checksum(struct sk_buff *skb, unsigned int hook,
 			unsigned int dataoff, u_int8_t protocol);
 
 int nf_ip6_check_hbh_len(struct sk_buff *skb, u32 *plen);
-
-int ipv6_netfilter_init(void);
-void ipv6_netfilter_fini(void);
-
-#else /* CONFIG_NETFILTER */
-static inline int ipv6_netfilter_init(void) { return 0; }
-static inline void ipv6_netfilter_fini(void) { return; }
-static inline const struct nf_ipv6_ops *nf_get_ipv6_ops(void) { return NULL; }
 #endif /* CONFIG_NETFILTER */
 
 #endif /*__LINUX_IP6_NETFILTER_H*/
diff --git a/include/net/ip.h b/include/net/ip.h
index f39a3787fedd..40aac82ea212 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -692,13 +692,8 @@ static __inline__ void inet_reset_saddr(struct sock *sk)
 
 #endif
 
-#if IS_MODULE(CONFIG_IPV6)
-#define EXPORT_IPV6_MOD(X) EXPORT_SYMBOL(X)
-#define EXPORT_IPV6_MOD_GPL(X) EXPORT_SYMBOL_GPL(X)
-#else
 #define EXPORT_IPV6_MOD(X)
 #define EXPORT_IPV6_MOD_GPL(X)
-#endif
 
 static inline unsigned int ipv4_addr_hash(__be32 ip)
 {
diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 083e2fe96441..0ab1c94db4b9 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -32,6 +32,7 @@
 
 #include <net/ip.h>
 #include <net/ipv6.h>
+#include <net/ip6_route.h>
 #include <net/addrconf.h>
 #include <net/dst_metadata.h>
 #include <net/route.h>
@@ -890,7 +891,6 @@ static int br_nf_dev_queue_xmit(struct net *net, struct sock *sk, struct sk_buff
 	}
 	if (IS_ENABLED(CONFIG_NF_DEFRAG_IPV6) &&
 	    skb->protocol == htons(ETH_P_IPV6)) {
-		const struct nf_ipv6_ops *v6ops = nf_get_ipv6_ops();
 		struct brnf_frag_data *data;
 
 		if (br_validate_ipv6(net, skb))
@@ -906,15 +906,9 @@ static int br_nf_dev_queue_xmit(struct net *net, struct sock *sk, struct sk_buff
 		skb_copy_from_linear_data_offset(skb, -data->size, data->mac,
 						 data->size);
 
-		if (v6ops) {
-			ret = v6ops->fragment(net, sk, skb, br_nf_push_frag_xmit);
-			local_unlock_nested_bh(&brnf_frag_data_storage.bh_lock);
-			return ret;
-		}
+		ret = ip6_fragment(net, sk, skb, br_nf_push_frag_xmit);
 		local_unlock_nested_bh(&brnf_frag_data_storage.bh_lock);
-
-		kfree_skb(skb);
-		return -EMSGSIZE;
+		return ret;
 	}
 	nf_bridge_info_free(skb);
 	return br_dev_queue_push_xmit(net, sk, skb);
diff --git a/net/bridge/br_netfilter_ipv6.c b/net/bridge/br_netfilter_ipv6.c
index 76ce70b4e7f3..d8548428929e 100644
--- a/net/bridge/br_netfilter_ipv6.c
+++ b/net/bridge/br_netfilter_ipv6.c
@@ -30,6 +30,7 @@
 
 #include <net/ip.h>
 #include <net/ipv6.h>
+#include <net/ip6_route.h>
 #include <net/addrconf.h>
 #include <net/route.h>
 #include <net/netfilter/br_netfilter.h>
@@ -95,15 +96,13 @@ br_nf_ipv6_daddr_was_changed(const struct sk_buff *skb,
 
 /* PF_BRIDGE/PRE_ROUTING: Undo the changes made for ip6tables
  * PREROUTING and continue the bridge PRE_ROUTING hook. See comment
- * for br_nf_pre_routing_finish(), same logic is used here but
- * equivalent IPv6 function ip6_route_input() called indirectly.
+ * for br_nf_pre_routing_finish(), same logic is used here.
  */
 static int br_nf_pre_routing_finish_ipv6(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
 	struct nf_bridge_info *nf_bridge = nf_bridge_info_get(skb);
 	struct rtable *rt;
 	struct net_device *dev = skb->dev, *br_indev;
-	const struct nf_ipv6_ops *v6ops = nf_get_ipv6_ops();
 
 	br_indev = nf_bridge_get_physindev(skb, net);
 	if (!br_indev) {
@@ -120,7 +119,7 @@ static int br_nf_pre_routing_finish_ipv6(struct net *net, struct sock *sk, struc
 	nf_bridge->in_prerouting = 0;
 	if (br_nf_ipv6_daddr_was_changed(skb, nf_bridge)) {
 		skb_dst_drop(skb);
-		v6ops->route_input(skb);
+		ip6_route_input(skb);
 
 		if (skb_dst(skb)->error) {
 			kfree_skb(skb);
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 33abd8d8cd7d..ee341a8254bf 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -38,7 +38,6 @@
 #include <linux/inet.h>
 #include <linux/netdevice.h>
 #include <linux/icmpv6.h>
-#include <linux/netfilter_ipv6.h>
 
 #include <net/ip.h>
 #include <net/ipv6.h>
@@ -1066,9 +1065,6 @@ static int __init inet6_init(void)
 	if (err)
 		goto igmp_fail;
 
-	err = ipv6_netfilter_init();
-	if (err)
-		goto netfilter_fail;
 	/* Create /proc/foo6 entries. */
 #ifdef CONFIG_PROC_FS
 	err = -ENOMEM;
@@ -1199,8 +1195,6 @@ static int __init inet6_init(void)
 	raw6_proc_exit();
 proc_raw6_fail:
 #endif
-	ipv6_netfilter_fini();
-netfilter_fail:
 	igmp6_cleanup();
 igmp_fail:
 	ndisc_cleanup();
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index c3dc90dfab80..6d80f85e55fa 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -86,21 +86,6 @@ int ip6_route_me_harder(struct net *net, struct sock *sk_partial, struct sk_buff
 }
 EXPORT_SYMBOL(ip6_route_me_harder);
 
-static int nf_ip6_reroute(struct sk_buff *skb,
-			  const struct nf_queue_entry *entry)
-{
-	struct ip6_rt_info *rt_info = nf_queue_entry_reroute(entry);
-
-	if (entry->state.hook == NF_INET_LOCAL_OUT) {
-		const struct ipv6hdr *iph = ipv6_hdr(skb);
-		if (!ipv6_addr_equal(&iph->daddr, &rt_info->daddr) ||
-		    !ipv6_addr_equal(&iph->saddr, &rt_info->saddr) ||
-		    skb->mark != rt_info->mark)
-			return ip6_route_me_harder(entry->state.net, entry->state.sk, skb);
-	}
-	return 0;
-}
-
 int __nf_ip6_route(struct net *net, struct dst_entry **dst,
 		   struct flowi *fl, bool strict)
 {
@@ -243,36 +228,3 @@ int br_ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 	return 0;
 }
 EXPORT_SYMBOL_GPL(br_ip6_fragment);
-
-static const struct nf_ipv6_ops ipv6ops = {
-#if IS_MODULE(CONFIG_IPV6)
-	.chk_addr		= ipv6_chk_addr,
-	.route_me_harder	= ip6_route_me_harder,
-	.dev_get_saddr		= ipv6_dev_get_saddr,
-	.route			= __nf_ip6_route,
-#if IS_ENABLED(CONFIG_SYN_COOKIES)
-	.cookie_init_sequence	= __cookie_v6_init_sequence,
-	.cookie_v6_check	= __cookie_v6_check,
-#endif
-#endif
-	.route_input		= ip6_route_input,
-	.fragment		= ip6_fragment,
-	.reroute		= nf_ip6_reroute,
-#if IS_MODULE(CONFIG_IPV6)
-	.br_fragment		= br_ip6_fragment,
-#endif
-};
-
-int __init ipv6_netfilter_init(void)
-{
-	RCU_INIT_POINTER(nf_ipv6_ops, &ipv6ops);
-	return 0;
-}
-
-/* This can be called from inet6_init() on errors, so it cannot
- * be marked __exit. -DaveM
- */
-void ipv6_netfilter_fini(void)
-{
-	RCU_INIT_POINTER(nf_ipv6_ops, NULL);
-}
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index d5df44ea9e7b..675a1034b340 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -27,9 +27,6 @@
 
 #include "nf_internals.h"
 
-const struct nf_ipv6_ops __rcu *nf_ipv6_ops __read_mostly;
-EXPORT_SYMBOL_GPL(nf_ipv6_ops);
-
 #ifdef CONFIG_JUMP_LABEL
 struct static_key nf_hooks_needed[NFPROTO_NUMPROTO][NF_MAX_HOOKS];
 EXPORT_SYMBOL(nf_hooks_needed);
diff --git a/net/netfilter/nf_nat_masquerade.c b/net/netfilter/nf_nat_masquerade.c
index a5a23c03fda9..4de6e0a51701 100644
--- a/net/netfilter/nf_nat_masquerade.c
+++ b/net/netfilter/nf_nat_masquerade.c
@@ -220,23 +220,6 @@ static struct notifier_block masq_inet_notifier = {
 };
 
 #if IS_ENABLED(CONFIG_IPV6)
-static int
-nat_ipv6_dev_get_saddr(struct net *net, const struct net_device *dev,
-		       const struct in6_addr *daddr, unsigned int srcprefs,
-		       struct in6_addr *saddr)
-{
-#ifdef CONFIG_IPV6_MODULE
-	const struct nf_ipv6_ops *v6_ops = nf_get_ipv6_ops();
-
-	if (!v6_ops)
-		return -EHOSTUNREACH;
-
-	return v6_ops->dev_get_saddr(net, dev, daddr, srcprefs, saddr);
-#else
-	return ipv6_dev_get_saddr(net, dev, daddr, srcprefs, saddr);
-#endif
-}
-
 unsigned int
 nf_nat_masquerade_ipv6(struct sk_buff *skb, const struct nf_nat_range2 *range,
 		       const struct net_device *out)
@@ -251,8 +234,8 @@ nf_nat_masquerade_ipv6(struct sk_buff *skb, const struct nf_nat_range2 *range,
 	WARN_ON(!(ct && (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED ||
 			 ctinfo == IP_CT_RELATED_REPLY)));
 
-	if (nat_ipv6_dev_get_saddr(nf_ct_net(ct), out,
-				   &ipv6_hdr(skb)->daddr, 0, &src) < 0)
+	if (ipv6_dev_get_saddr(nf_ct_net(ct), out,
+			       &ipv6_hdr(skb)->daddr, 0, &src) < 0)
 		return NF_DROP;
 
 	nat = nf_ct_nat_ext_add(ct);
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index a91ae07db059..2aa2380d976a 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -356,9 +356,25 @@ static int nf_ip_reroute(struct sk_buff *skb, const struct nf_queue_entry *entry
 	return 0;
 }
 
+static int nf_ip6_reroute(struct sk_buff *skb,
+			  const struct nf_queue_entry *entry)
+{
+	struct ip6_rt_info *rt_info = nf_queue_entry_reroute(entry);
+
+	if (entry->state.hook == NF_INET_LOCAL_OUT) {
+		const struct ipv6hdr *iph = ipv6_hdr(skb);
+
+		if (!ipv6_addr_equal(&iph->daddr, &rt_info->daddr) ||
+		    !ipv6_addr_equal(&iph->saddr, &rt_info->saddr) ||
+		    skb->mark != rt_info->mark)
+			return nf_ip6_route_me_harder(entry->state.net,
+						      entry->state.sk, skb);
+	}
+	return 0;
+}
+
 static int nf_reroute(struct sk_buff *skb, struct nf_queue_entry *entry)
 {
-	const struct nf_ipv6_ops *v6ops;
 	int ret = 0;
 
 	switch (entry->state.pf) {
@@ -366,9 +382,7 @@ static int nf_reroute(struct sk_buff *skb, struct nf_queue_entry *entry)
 		ret = nf_ip_reroute(skb, entry);
 		break;
 	case AF_INET6:
-		v6ops = rcu_dereference(nf_ipv6_ops);
-		if (v6ops)
-			ret = v6ops->reroute(skb, entry);
+		ret = nf_ip6_reroute(skb, entry);
 		break;
 	}
 	return ret;
diff --git a/net/netfilter/utils.c b/net/netfilter/utils.c
index 008419db815a..29c4dcc362c7 100644
--- a/net/netfilter/utils.c
+++ b/net/netfilter/utils.c
@@ -163,7 +163,6 @@ EXPORT_SYMBOL_GPL(nf_checksum_partial);
 int nf_route(struct net *net, struct dst_entry **dst, struct flowi *fl,
 	     bool strict, unsigned short family)
 {
-	const struct nf_ipv6_ops *v6ops __maybe_unused;
 	int ret = 0;
 
 	switch (family) {
-- 
2.53.0

