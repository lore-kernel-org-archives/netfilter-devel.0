From: Nathan Hintz <nlhintz@hotmail.com>
Subject: [PATCH] netfilter: nf_defrag_ipv6.o included twice
Date: Thu, 22 Aug 2013 22:09:12 -0700
Message-ID: <BLU0-SMTP246C0F210C1747FE63C4E97AC4E0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	Nathan Hintz <nlhintz@hotmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from blu0-omc1-s17.blu0.hotmail.com ([65.55.116.28]:32831 "EHLO
	blu0-omc1-s17.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754303Ab3HWFQQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Aug 2013 01:16:16 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

'nf_defrag_ipv6' is built as a separate module; it shouldn't be
included in the 'nf_conntrack_ipv6' module as well.

Signed-off-by: Nathan Hintz <nlhintz@hotmail.com>
---
 net/ipv6/netfilter/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/netfilter/Makefile b/net/ipv6/netfilter/Makefile
index 2d11fcc..ad13bf0 100644
--- a/net/ipv6/netfilter/Makefile
+++ b/net/ipv6/netfilter/Makefile
@@ -14,7 +14,7 @@ obj-$(CONFIG_NF_NAT_IPV6) += ip6table_nat.o
 nf_conntrack_ipv6-y  :=  nf_conntrack_l3proto_ipv6.o nf_conntrack_proto_icmpv6.o
 
 # l3 independent conntrack
-obj-$(CONFIG_NF_CONNTRACK_IPV6) += nf_conntrack_ipv6.o nf_defrag_ipv6.o
+obj-$(CONFIG_NF_CONNTRACK_IPV6) += nf_conntrack_ipv6.o
 
 nf_nat_ipv6-y		:= nf_nat_l3proto_ipv6.o nf_nat_proto_icmpv6.o
 obj-$(CONFIG_NF_NAT_IPV6) += nf_nat_ipv6.o
-- 
1.8.3.1

