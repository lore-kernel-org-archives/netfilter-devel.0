From: Florian Westphal <fw@strlen.de>
Subject: [PATCH -next] netfilter: tproxy: fix build with IP6_NF_IPTABLES=n
Date: Sun,  4 Aug 2013 11:37:29 +0200
Message-ID: <1375609049-28517-1-git-send-email-fw@strlen.de>
References: <51fd4909.9l/Oq5RafYHkZm62%fengguang.wu@intel.com>
Cc: pablo@netfilter.org, kbuild-all@01.org, fengguang.wu@intel.com,
	Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:50733 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753196Ab3HDJiH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 4 Aug 2013 05:38:07 -0400
In-Reply-To: <51fd4909.9l/Oq5RafYHkZm62%fengguang.wu@intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

after commit 93742cf8af9dd3b053242b273040aa35fcbf93b3
(netfilter: tproxy: remove nf_tproxy_core.h)
CONFIG_IPV6=y
CONFIG_IP6_NF_IPTABLES=n
gives us:

net/netfilter/xt_TPROXY.c: In function 'nf_tproxy_get_sock_v6':
net/netfilter/xt_TPROXY.c:178:4: error: implicit declaration of function 'inet6_lookup_listener'

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
diff --git a/net/netfilter/xt_TPROXY.c b/net/netfilter/xt_TPROXY.c
index 851383a..5d8a3a3 100644
--- a/net/netfilter/xt_TPROXY.c
+++ b/net/netfilter/xt_TPROXY.c
@@ -161,7 +161,7 @@ nf_tproxy_get_sock_v4(struct net *net, const u8 protocol,
 	return sk;
 }
 
-#if IS_ENABLED(CONFIG_IPV6)
+#ifdef XT_TPROXY_HAVE_IPV6
 static inline struct sock *
 nf_tproxy_get_sock_v6(struct net *net, const u8 protocol,
 		      const struct in6_addr *saddr, const struct in6_addr *daddr,
-- 
1.8.1.5

