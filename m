From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next] netfilter: nft_fib: store loopback interface to dreg when rt is local
Date: Thu, 24 Nov 2016 21:28:48 +0800
Message-ID: <1479994128-16654-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de,
        Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-11.163.com ([220.181.12.11]:43451 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965321AbcKXNaD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Nov 2016 08:30:03 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

In general, we haven't do routing lookup in PREROUTING hook, so it's
very likely that fib4/6_is_local will not be met. Then the *dest will
be set to 0 because we do nothing when the fib result is RTN_LOCAL.

So if the user want to drop all packets which cannot be routed,
and input the following nft rule:
  # nft add rule filter prerouting fib daddr oif eq 0 drop

Then all the packets which destinate to local will be dropped
incorrectly.

Fixes: f6d0cbcf09c5 ("netfilter: nf_tables: add fib expression")
Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 net/ipv4/netfilter/nft_fib_ipv4.c | 3 ++-
 net/ipv6/netfilter/nft_fib_ipv6.c | 8 ++++++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib_ipv4.c
index 2581363..2107775 100644
--- a/net/ipv4/netfilter/nft_fib_ipv4.c
+++ b/net/ipv4/netfilter/nft_fib_ipv4.c
@@ -130,7 +130,8 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	switch (res.type) {
 	case RTN_UNICAST:
 		break;
-	case RTN_LOCAL:	/* should not appear here, see fib4_is_local() above */
+	case RTN_LOCAL:
+		nft_fib_store_result(dest, priv->result, pkt, LOOPBACK_IFINDEX);
 		return;
 	default:
 		break;
diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
index c947aad..5e2de1b 100644
--- a/net/ipv6/netfilter/nft_fib_ipv6.c
+++ b/net/ipv6/netfilter/nft_fib_ipv6.c
@@ -175,8 +175,12 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	if (rt->dst.error)
 		goto put_rt_err;
 
-	/* Should not see RTF_LOCAL here */
-	if (rt->rt6i_flags & (RTF_REJECT | RTF_ANYCAST | RTF_LOCAL))
+	if (rt->rt6i_flags & RTF_LOCAL) {
+		nft_fib_store_result(dest, priv->result, pkt, LOOPBACK_IFINDEX);
+		goto put_rt_err;
+	}
+
+	if (rt->rt6i_flags & (RTF_REJECT | RTF_ANYCAST))
 		goto put_rt_err;
 
 	if (oif && oif != rt->rt6i_idev->dev) {
-- 
2.5.5


