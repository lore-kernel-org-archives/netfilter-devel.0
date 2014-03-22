From: Florian Westphal <fw@strlen.de>
Subject: [PATCH] netfilter: disallow builtin socket/tproxy with modular ipv6 defrag
Date: Sat, 22 Mar 2014 23:59:29 +0100
Message-ID: <1395529169-26819-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:49229 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750866AbaCVXDy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 22 Mar 2014 19:03:54 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

xt_socket.c:(.init.text+0x13d2): undefined reference to `nf_defrag_ipv6_enable'
xt_TPROXY.c:(.init.text+0x19b5): undefined reference to `nf_defrag_ipv6_enable'

If DEFRAG_IPV6=m we cannot have SOCKET/TPROXY=y.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
Technically this patch is bogus, but I couldn't figure out
how to express the dependencies in kconfig.

both already have

select NF_DEFRAG_IPV6 if IP6_NF_IPTABLES

But its not enough; its possible to have
CONFIG_NF_DEFRAG_IPV6=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_NETFILTER_XT_TARGET_TPROXY=y
CONFIG_NETFILTER_XT_MATCH_SOCKET=y

Which doesn't work as socket/tproxy references symbols
from ipv6 defrag.

cannot add
depends on (NF_DEFRAG_IPV6 || NF_DEFRAG_IPV6=n)
since thats a recursive dependency.

Adding a dependency to have m/y depend on IP6_NF_IPTABLES
status appears to do the right thing but its not correct
because it also disallows DEFRAG=y, TPROXY=m (which is fine).

AFAICS this dependency issue has always existed since ipv6
support was added to tproxy.

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index e9410d1..faca831 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -834,6 +834,7 @@ config NETFILTER_XT_TARGET_TPROXY
 	depends on NETFILTER_XTABLES
 	depends on NETFILTER_ADVANCED
 	depends on IP_NF_MANGLE
+	depends on (IP6_NF_IPTABLES || IP6_NF_IPTABLES=n)
 	select NF_DEFRAG_IPV4
 	select NF_DEFRAG_IPV6 if IP6_NF_IPTABLES
 	help
@@ -1325,6 +1326,7 @@ config NETFILTER_XT_MATCH_SOCKET
 	depends on NETFILTER_XTABLES
 	depends on NETFILTER_ADVANCED
 	depends on !NF_CONNTRACK || NF_CONNTRACK
+	depends on (IP6_NF_IPTABLES || IP6_NF_IPTABLES=n)
 	depends on (IPV6 || IPV6=n)
 	select NF_DEFRAG_IPV4
 	select NF_DEFRAG_IPV6 if IP6_NF_IPTABLES
-- 
1.8.1.5

