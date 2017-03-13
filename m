From: Phil Sutter <phil@nwl.cc>
Subject: [iptables PATCH] extensions: libxt_statistic: Complete nft translator
Date: Mon, 13 Mar 2017 17:01:53 +0100
Message-ID: <20170313160153.21120-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:39575 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752132AbdCMQCG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Mar 2017 12:02:06 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This was missing a translation for random mode. The substitute should
mimick what iptables and xt_statistic kernel module do:

- iptables takes p in [0.0; 1.0] as probability of a packet to pass,
  then passes p' = lround(p * 0x80000000) to kernel.
- Kernel takes random r in [0; 0x7FFFFFFF] and matches packet if r < p'.

The nftables numgen expression works differently:

- nft takes 32bit int n (RHS) and 32bit modulo m and passes both to
  kernel.
- Kernel takes random r in [0; m[ and compares it to n to decide if
  packet matches.

So in order to replicate the r < p' condition of xt_statistic, choose
m = 0x80000000, op = OP_LT and n = p'.

In order to not generate unnecessarily big numbers, divide m and n by
gcd(m, n) before printing the nft rule.

Here are a few example translations:

$ iptables-translate -A INPUT -m statistic --mode random --probability 0.25
nft add rule ip filter INPUT numgen random mod 0x4 < 0x1 counter

$ iptables-translate -A INPUT -m statistic --mode random --probability 0.5
nft add rule ip filter INPUT numgen random mod 0x2 < 0x1 counter

$ iptables-translate -A INPUT -m statistic --mode random --probability 0.75
nft add rule ip filter INPUT numgen random mod 0x4 < 0x3 counter

$ iptables-translate -A INPUT -m statistic --mode random --probability 0.33
nft add rule ip filter INPUT numgen random mod 0x20000000 < 0xa8f5c29 counter

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
In general, I don't think the code is correct: To really match the
requested probability, an op of '<=' should be generated instead of '<'.
But if I'm not mistaken, this is actually a problem of xt_statistic and
not the converter's.
---
 extensions/libxt_statistic.c | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/extensions/libxt_statistic.c b/extensions/libxt_statistic.c
index 4f3341a3d1162..9e84374257641 100644
--- a/extensions/libxt_statistic.c
+++ b/extensions/libxt_statistic.c
@@ -133,15 +133,44 @@ static void statistic_save(const void *ip, const struct xt_entry_match *match)
 	print_match(info, "--");
 }
 
+/* divide *a and *b by gcd(*a, *b) */
+static void gcd_div(__u32 *a, __u32 *b)
+{
+	__u32 tmp, nom, denom;
+
+	if (a > b) {
+		nom = *a;
+		denom = *b;
+	} else {
+		nom = *b;
+		denom = *a;
+	}
+
+	while (denom != 0) {
+		tmp = nom % denom;
+		nom = denom;
+		denom = tmp;
+	}
+
+	*a /= nom;
+	*b /= nom;
+}
+
 static int statistic_xlate(struct xt_xlate *xl,
 			   const struct xt_xlate_mt_params *params)
 {
 	const struct xt_statistic_info *info =
 		(struct xt_statistic_info *)params->match->data;
+	__u32 mod = 0x80000000, prob = info->u.random.probability;
 
 	switch (info->mode) {
 	case XT_STATISTIC_MODE_RANDOM:
-		return 0;
+		gcd_div(&prob, &mod);
+		xt_xlate_add(xl, "numgen random mod 0x%x %s 0x%x",
+			     mod,
+			     info->flags & XT_STATISTIC_INVERT ? ">=" : "<",
+			     prob);
+		break;
 	case XT_STATISTIC_MODE_NTH:
 		xt_xlate_add(xl, "numgen inc mod %u %s%u",
 			     info->u.nth.every + 1,
-- 
2.11.0

