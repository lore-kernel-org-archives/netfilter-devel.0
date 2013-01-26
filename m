From: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Subject: [RFC PATCH 3/4] netfilter ip6t_NPT: Ensure to check lower part of
 prefixes are zero.
Date: Sun, 27 Jan 2013 03:38:23 +0900
Message-ID: <5104229F.9000501@linux-ipv6.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: jm@dilly.me, fw@strlen.de, yoshfuji@linux-ipv6.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 94.43.138.210.xn.2iij.net ([210.138.43.94]:57823 "EHLO
	mail.st-paulia.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752343Ab3AZSiZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Jan 2013 13:38:25 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
---
 net/ipv6/netfilter/ip6t_NPT.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/ipv6/netfilter/ip6t_NPT.c b/net/ipv6/netfilter/ip6t_NPT.c
index b1bf3ed..7d23d22 100644
--- a/net/ipv6/netfilter/ip6t_NPT.c
+++ b/net/ipv6/netfilter/ip6t_NPT.c
@@ -9,6 +9,7 @@
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/ipv6.h>
+#include <net/ipv6.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter_ipv6.h>
 #include <linux/netfilter_ipv6/ip6t_NPT.h>
@@ -18,10 +19,19 @@ static int ip6t_npt_checkentry(const struct xt_tgchk_param *par)
 {
 	struct ip6t_npt_tginfo *npt = par->targinfo;
 	__wsum src_sum, dst_sum;
+	struct in6_addr pfx;
 
 	if (npt->src_pfx_len > 64 || npt->dst_pfx_len > 64)
 		return -EINVAL;
 
+	/* Ensure that LSB of prefix is zero */
+	ipv6_addr_prefix(&pfx, &npt->src_pfx.in6, npt->src_pfx_len);
+	if (!ipv6_addr_equal(&pfx, &npt->src_pfx.in6))
+		return -EINVAL;
+	ipv6_addr_prefix(&pfx, &npt->dst_pfx.in6, npt->dst_pfx_len);
+	if (!ipv6_addr_equal(&pfx, &npt->dst_pfx.in6))
+		return -EINVAL;
+
 	src_sum = csum_partial(&npt->src_pfx.in6, sizeof(npt->src_pfx.in6), 0);
 	dst_sum = csum_partial(&npt->dst_pfx.in6, sizeof(npt->dst_pfx.in6), 0);
 
-- 
1.7.9.5


