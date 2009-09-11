From: Florian Westphal <fw@strlen.de>
Subject: [PATCH xt-addons 1/2] xt_psd: use skb_header_pointer
Date: Fri, 11 Sep 2009 11:05:54 +0200
Message-ID: <1252659955-13181-1-git-send-email-fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:38186 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754270AbZIKJFx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Sep 2009 05:05:53 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Florian Westphal <fwestphal@astaro.com>

Don't rely on tcphdr being in the linear area.

Signed-off-by: Florian Westphal <fwestphal@astaro.com>
---
 extensions/xt_psd.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/extensions/xt_psd.c b/extensions/xt_psd.c
index f12e5cf..b3de7e2 100644
--- a/extensions/xt_psd.c
+++ b/extensions/xt_psd.c
@@ -102,11 +102,12 @@ static inline int hashfunc(struct in_addr addr)
 static bool
 xt_psd_match(const struct sk_buff *pskb, const struct xt_match_param *match)
 {
-	struct iphdr *iph;
-	struct tcphdr *tcph;
+	const struct iphdr *iph;
+	const struct tcphdr *tcph;
+	struct tcphdr _tcph;
 	struct in_addr addr;
 	u_int16_t src_port,dest_port;
-  	u_int8_t tcp_flags, proto;
+	u_int8_t tcp_flags, proto;
 	unsigned long now;
 	struct host *curr, *last, **head;
 	int hash, index, count;
@@ -134,7 +135,9 @@ xt_psd_match(const struct sk_buff *pskb, const struct xt_match_param *match)
 
 	addr.s_addr = iph->saddr;
 
-	tcph = (void *)iph + ip_hdrlen(pskb);
+	tcph = skb_header_pointer(pskb, match->thoff, sizeof(_tcph), &_tcph);
+	if (tcph == NULL)
+		return false;
 
 	/* Yep, it's dirty */
 	src_port = tcph->source;
-- 
1.6.3.3

