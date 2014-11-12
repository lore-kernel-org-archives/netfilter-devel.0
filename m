From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 1/2] netfilter: fix unmet dependencies in NETFILTER_XT_TARGET_REDIRECT
Date: Wed, 12 Nov 2014 12:01:35 +0100
Message-ID: <1415790096-6625-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, arturo.borrero.glez@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58449 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850AbaKLK7p (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Nov 2014 05:59:45 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

warning: (NETFILTER_XT_TARGET_REDIRECT) selects NF_NAT_REDIRECT_IPV4 which has unmet direct dependencies (NET && INET && NETFILTER && NF_NAT_IPV4)

warning: (NETFILTER_XT_TARGET_REDIRECT) selects NF_NAT_REDIRECT_IPV6 which has unmet direct dependencies (NET && INET && IPV6 && NETFILTER && NF_NAT_IPV6)

Fixes: 8b13edd ("netfilter: refactor NAT redirect IPv4 to use it from nf_tables")
Fixes: 9de920e ("netfilter: refactor NAT redirect IPv6 code to use it from nf_tables")
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 373486a..57f15a9 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -844,8 +844,8 @@ config NETFILTER_XT_TARGET_RATEEST
 config NETFILTER_XT_TARGET_REDIRECT
 	tristate "REDIRECT target support"
 	depends on NF_NAT
-	select NF_NAT_REDIRECT_IPV4
-	select NF_NAT_REDIRECT_IPV6 if IP6_NF_IPTABLES
+	select NF_NAT_REDIRECT_IPV4 if NF_NAT_IPV4
+	select NF_NAT_REDIRECT_IPV6 if NF_NAT_IPV6
 	---help---
 	REDIRECT is a special case of NAT: all incoming connections are
 	mapped onto the incoming interface's address, causing the packets to
-- 
1.7.10.4

