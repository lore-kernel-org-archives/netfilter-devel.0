From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] netfilter: xt_TPROXY: undefined reference to `udp6_lib_lookup'
Date: Sun,  7 Sep 2014 17:26:34 +0200
Message-ID: <1410103594-3988-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39683 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752375AbaIGPZx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Sep 2014 11:25:53 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

CONFIG_IPV6=m
CONFIG_NETFILTER_XT_TARGET_TPROXY=y

   net/built-in.o: In function `nf_tproxy_get_sock_v6.constprop.11':
>> xt_TPROXY.c:(.text+0x583a1): undefined reference to `udp6_lib_lookup'
   net/built-in.o: In function `tproxy_tg_init':
>> xt_TPROXY.c:(.init.text+0x1dc3): undefined reference to `nf_defrag_ipv6_enable'

This fix is similar to 1a5bbfc ("netfilter: Fix build errors with
xt_socket.c").

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 4bef6eb..831f960 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -839,6 +839,7 @@ config NETFILTER_XT_TARGET_TPROXY
 	tristate '"TPROXY" target transparent proxying support'
 	depends on NETFILTER_XTABLES
 	depends on NETFILTER_ADVANCED
+	depends on (IPV6 || IPV6=n)
 	depends on IP_NF_MANGLE
 	select NF_DEFRAG_IPV4
 	select NF_DEFRAG_IPV6 if IP6_NF_IPTABLES
-- 
1.7.10.4

