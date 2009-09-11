From: Florian Westphal <fw@strlen.de>
Subject: [PATCH xt-addons 2/2] xt_psd: byteswap constant value instead
Date: Fri, 11 Sep 2009 11:05:55 +0200
Message-ID: <1252659955-13181-2-git-send-email-fw@strlen.de>
References: <1252659955-13181-1-git-send-email-fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:38187 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754271AbZIKJFx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Sep 2009 05:05:53 -0400
In-Reply-To: <1252659955-13181-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Florian Westphal <fwestphal@astaro.com>

htons(CONSTANT) is computed at compile time.
reduces .text by 4 bytes on x86.

Signed-off-by: Florian Westphal <fwestphal@astaro.com>
---
 extensions/xt_psd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/extensions/xt_psd.c b/extensions/xt_psd.c
index b3de7e2..03e81e2 100644
--- a/extensions/xt_psd.c
+++ b/extensions/xt_psd.c
@@ -118,7 +118,7 @@ xt_psd_match(const struct sk_buff *pskb, const struct xt_match_param *match)
 	iph = ip_hdr(pskb);
 
 	/* Sanity check */
-	if (ntohs(iph->frag_off) & IP_OFFSET) {
+	if (iph->frag_off & htons(IP_OFFSET)) {
 		pr_debug("sanity check failed\n");
 		return false;
 	}
-- 
1.6.3.3

