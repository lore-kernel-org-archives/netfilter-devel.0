From: Josh Hunt <johunt@akamai.com>
Subject: [PATCH] TARPIT: fix memory leak when tarpit_generic() fails
Date: Wed,  1 Aug 2012 15:07:42 -0700
Message-ID: <1343858862-32366-1-git-send-email-johunt@akamai.com>
Cc: netfilter-devel@vger.kernel.org, Josh Hunt <johunt@akamai.com>
To: jengelh@inai.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay06.akamai.com ([96.6.114.98]:51685 "EHLO
	prod-mail-xrelay06.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752371Ab2HAWHn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Aug 2012 18:07:43 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently tarpit_generic() just returns on failure, but this does
not free nskb.

Signed-off-by: Josh Hunt <johunt@akamai.com>
---
 extensions/xt_TARPIT.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/xt_TARPIT.c b/extensions/xt_TARPIT.c
index 58f12e4..0e66279 100644
--- a/extensions/xt_TARPIT.c
+++ b/extensions/xt_TARPIT.c
@@ -237,7 +237,7 @@ static void tarpit_tcp4(struct sk_buff *oldskb, unsigned int hook,
 	((u_int8_t *)tcph)[13] = 0;
 
 	if (!tarpit_generic(tcph, oth, payload, mode))
-		return;
+		goto free_nskb;
 
 	/* Adjust TCP checksum */
 	tcph->check = 0;
@@ -398,7 +398,7 @@ static void tarpit_tcp6(struct sk_buff *oldskb, unsigned int hook,
 
 	payload = nskb->len - sizeof(struct ipv6hdr) - sizeof(struct tcphdr);
 	if (!tarpit_generic(&oth, tcph, payload, mode))
-		return;
+		goto free_nskb;
 
 	ip6h->payload_len = htons(sizeof(struct tcphdr));
 	tcph->check = 0;
-- 
1.7.0.4

