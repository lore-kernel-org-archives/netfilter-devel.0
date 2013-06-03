From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 2/2] include: kill unused PLD_* macros
Date: Mon,  3 Jun 2013 11:18:25 +0200
Message-ID: <1370251105-12450-2-git-send-email-fw@strlen.de>
References: <1370251105-12450-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:59030 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751728Ab3FCJQY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Jun 2013 05:16:24 -0400
In-Reply-To: <1370251105-12450-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/network.h |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/include/network.h b/include/network.h
index 41c35af..79745f3 100644
--- a/include/network.h
+++ b/include/network.h
@@ -173,18 +173,6 @@ static inline int between(uint32_t seq1, uint32_t seq2, uint32_t seq3)
 	return seq3 - seq2 >= seq1 - seq2;
 }
 
-#define PLD_NETWORK2HOST(x)						 \
-({									 \
-	x->len = ntohs(x->len);						 \
-	x->query = ntohs(x->query);					 \
-})
-
-#define PLD_HOST2NETWORK(x)						 \
-({									 \
-	x->len = htons(x->len);						 \
-	x->query = htons(x->query);					 \
-})
-
 struct netattr {
 	uint16_t nta_len;
 	uint16_t nta_attr;
-- 
1.7.8.6

