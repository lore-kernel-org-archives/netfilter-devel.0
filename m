Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D70AC4332F
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Nov 2023 12:19:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344588AbjKHMTH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Nov 2023 07:19:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344296AbjKHMTF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Nov 2023 07:19:05 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C821BD7
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Nov 2023 04:19:03 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1r0hWP-0006p0-BJ; Wed, 08 Nov 2023 13:19:01 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Daniel Huhardeaux <tech@tootai.net>
Subject: [PATCH nf] netfilter: nat: fix ipv6 nat redirect with mapped and scoped addresses
Date:   Wed,  8 Nov 2023 13:18:53 +0100
Message-ID: <20231108121856.23809-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The ipv6 redirect target was derived from the ipv4 one, i.e. its
identical to a 'dnat' with the first (primary) address assigned to the
network interface.  The code has been moved around to make it usable
from nf_tables too, but its still the same as it was back when this
was added in 2012.

IPv6, however, has different types of addresses, if the 'wrong' address
comes first the redirection does not work.

In Daniels case, the addresses are:
  inet6 ::ffff:192 ...
  inet6 2a01: ...

... so the function attempts to redirect to the mapped address.

Add more checks before the address is deemed correct:
1. If the packets' daddr is scoped, search for a scoped address too
2. skip tentative addresses
3. skip mapped addresses

Use the first address that appears to match our needs.

Reported-by: Daniel Huhardeaux <tech@tootai.net>
Closes: https://lore.kernel.org/netfilter/71be06b8-6aa0-4cf9-9e0b-e2839b01b22f@tootai.net/
Fixes: 115e23ac78f8 ("netfilter: ip6tables: add REDIRECT target")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 This bug is very old, we could also route this fix via nf-next
 if you think its too intrusive.

 net/netfilter/nf_nat_redirect.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_nat_redirect.c b/net/netfilter/nf_nat_redirect.c
index 6616ba5d0b04..5b37487d9d11 100644
--- a/net/netfilter/nf_nat_redirect.c
+++ b/net/netfilter/nf_nat_redirect.c
@@ -80,6 +80,26 @@ EXPORT_SYMBOL_GPL(nf_nat_redirect_ipv4);
 
 static const struct in6_addr loopback_addr = IN6ADDR_LOOPBACK_INIT;
 
+static bool nf_nat_redirect_ipv6_usable(const struct inet6_ifaddr *ifa, unsigned int scope)
+{
+	unsigned int ifa_addr_type = ipv6_addr_type(&ifa->addr);
+
+	if (ifa_addr_type & IPV6_ADDR_MAPPED)
+		return false;
+
+	if ((ifa->flags & IFA_F_TENTATIVE) && (!(ifa->flags & IFA_F_OPTIMISTIC)))
+		return false;
+
+	if (scope) {
+		unsigned int ifa_scope = ifa_addr_type & IPV6_ADDR_SCOPE_MASK;
+
+		if (!(scope & ifa_scope))
+			return false;
+	}
+
+	return true;
+}
+
 unsigned int
 nf_nat_redirect_ipv6(struct sk_buff *skb, const struct nf_nat_range2 *range,
 		     unsigned int hooknum)
@@ -89,14 +109,19 @@ nf_nat_redirect_ipv6(struct sk_buff *skb, const struct nf_nat_range2 *range,
 	if (hooknum == NF_INET_LOCAL_OUT) {
 		newdst.in6 = loopback_addr;
 	} else {
+		unsigned int scope = ipv6_addr_scope(&ipv6_hdr(skb)->daddr);
 		struct inet6_dev *idev;
-		struct inet6_ifaddr *ifa;
 		bool addr = false;
 
 		idev = __in6_dev_get(skb->dev);
 		if (idev != NULL) {
+			const struct inet6_ifaddr *ifa;
+
 			read_lock_bh(&idev->lock);
 			list_for_each_entry(ifa, &idev->addr_list, if_list) {
+				if (!nf_nat_redirect_ipv6_usable(ifa, scope))
+					continue;
+
 				newdst.in6 = ifa->addr;
 				addr = true;
 				break;
-- 
2.41.0

