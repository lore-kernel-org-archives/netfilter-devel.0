From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 03/11] xt_psd: avoid if (c=h) do {..} while (c = c->next)
Date: Sun, 16 Sep 2012 23:29:47 +0200
Message-ID: <1347830995-19226-4-git-send-email-fw@strlen.de>
References: <1347830995-19226-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:33804 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751601Ab2IPVcg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Sep 2012 17:32:36 -0400
In-Reply-To: <1347830995-19226-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

its aquivalent to c=h; while (c) { ..; c = c->next; }

which is a bit easier to read.
---
 extensions/xt_psd.c |   38 ++++++++++++++++++++------------------
 1 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/extensions/xt_psd.c b/extensions/xt_psd.c
index 442c05a..e803052 100644
--- a/extensions/xt_psd.c
+++ b/extensions/xt_psd.c
@@ -162,8 +162,8 @@ xt_psd_match(const struct sk_buff *pskb, struct xt_action_param *match)
 	u_int16_t src_port,dest_port;
 	u_int8_t proto;
 	unsigned long now;
-	struct host *curr, *last, **head;
-	int hash, count;
+	struct host *curr, *last = NULL, **head;
+	int hash, count = 0;
 	/* Parameters from userspace */
 	const struct xt_psd_info *psdinfo = match->matchinfo;
 
@@ -204,20 +204,21 @@ xt_psd_match(const struct sk_buff *pskb, struct xt_action_param *match)
 	}
 
 	now = jiffies;
+	hash = hashfunc(addr);
+	head = &state.hash[hash];
 
 	spin_lock(&state.lock);
 
 	/* Do we know this source address already? */
-	count = 0;
-	last = NULL;
-	if ((curr = *(head = &state.hash[hash = hashfunc(addr)])) != NULL)
-		do {
-			if (curr->src_addr.s_addr == addr.s_addr)
-				break;
-			count++;
-			if (curr->next != NULL)
-				last = curr;
-		} while ((curr = curr->next) != NULL);
+	curr = *head;
+	while (curr != NULL) {
+		if (curr->src_addr.s_addr == addr.s_addr)
+			break;
+		count++;
+		if (curr->next != NULL)
+			last = curr;
+		curr = curr->next;
+	}
 
 	if (curr != NULL) {
 		/* We know this address, and the entry isn't too old. Update it. */
@@ -265,12 +266,13 @@ xt_psd_match(const struct sk_buff *pskb, struct xt_action_param *match)
 	else
 		head = &last;
 	last = NULL;
-	if ((curr = *head) != NULL)
-		do {
-			if (curr == &state.list[state.index])
-				break;
-			last = curr;
-		} while ((curr = curr->next) != NULL);
+	curr = *head;
+	while (curr != NULL) {
+		if (curr == &state.list[state.index])
+			break;
+		last = curr;
+		curr = curr->next;
+	}
 
 	/* Then, remove it */
 	if (curr != NULL) {
-- 
1.7.8.6

