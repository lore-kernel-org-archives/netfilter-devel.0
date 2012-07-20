From: Florian Westphal <fw@strlen.de>
Subject: [PATCH][xt-addons] extensions: fix ipv6_find_hdr upstream change fallout
Date: Fri, 20 Jul 2012 17:28:38 +0200
Message-ID: <1342798118-6861-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:42484 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753029Ab2GTP0n (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Jul 2012 11:26:43 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

uptream commit 84018f55ab883f03d41ec3c9ac7f0cc80830b20f
(netfilter: ip6_tables: add flags parameter to ipv6_find_hdr())
changed the offset parameter of ipv6_find_hdr() to be an in-output
value. Moreover, if it is non-zero, it MUST point to a valid
ipv6 header embedded in the packet.

Just set it to 0.
---
 doc/changelog.txt       |    3 ++-
 extensions/xt_RAWNAT.c  |    4 ++--
 extensions/xt_SYSRQ.c   |    2 +-
 extensions/xt_length2.c |    2 +-
 4 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/doc/changelog.txt b/doc/changelog.txt
index b4ec4b7..c0524b4 100644
--- a/doc/changelog.txt
+++ b/doc/changelog.txt
@@ -1,7 +1,8 @@
 
 HEAD
 ====
-
+Fixes:
+- length2, SYSREQ, RAWNAT: fix ipv6 support with Linux 3.5
 
 v1.45 (2012-07-16)
 ==================
diff --git a/extensions/xt_RAWNAT.c b/extensions/xt_RAWNAT.c
index a837276..c15b5e5 100644
--- a/extensions/xt_RAWNAT.c
+++ b/extensions/xt_RAWNAT.c
@@ -244,7 +244,7 @@ static unsigned int
 rawsnat_tg6(struct sk_buff **pskb, const struct xt_action_param *par)
 {
 	const struct xt_rawnat_tginfo *info = par->targinfo;
-	unsigned int l4offset, l4proto;
+	unsigned int l4offset = 0, l4proto;
 	struct ipv6hdr *iph;
 	struct in6_addr new_addr;
 
@@ -265,7 +265,7 @@ static unsigned int
 rawdnat_tg6(struct sk_buff **pskb, const struct xt_action_param *par)
 {
 	const struct xt_rawnat_tginfo *info = par->targinfo;
-	unsigned int l4offset, l4proto;
+	unsigned int l4offset = 0, l4proto;
 	struct ipv6hdr *iph;
 	struct in6_addr new_addr;
 
diff --git a/extensions/xt_SYSRQ.c b/extensions/xt_SYSRQ.c
index 35502ef..9b59313 100644
--- a/extensions/xt_SYSRQ.c
+++ b/extensions/xt_SYSRQ.c
@@ -240,7 +240,7 @@ sysrq_tg6(struct sk_buff **pskb, const struct xt_action_param *par)
 	const struct ipv6hdr *iph;
 	const struct udphdr *udph;
 	unsigned short frag_off;
-	unsigned int th_off;
+	unsigned int th_off = 0;
 	uint16_t len;
 
 	if (skb_linearize(skb) < 0)
diff --git a/extensions/xt_length2.c b/extensions/xt_length2.c
index 2755e2f..75d3325 100644
--- a/extensions/xt_length2.c
+++ b/extensions/xt_length2.c
@@ -203,7 +203,7 @@ length2_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 	const struct xt_length_mtinfo2 *info = par->matchinfo;
 	const struct ipv6hdr *iph = ipv6_hdr(skb);
 	unsigned int len = 0, l4proto;
-	unsigned int thoff = par->thoff;
+	unsigned int thoff = 0;
 	bool hit = true;
 
 	if (info->flags & XT_LENGTH_LAYER3) {
-- 
1.7.8.6

