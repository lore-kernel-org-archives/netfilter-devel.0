From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 07/11] xt_psd: move table cleanup into helper
Date: Sun, 16 Sep 2012 23:29:51 +0200
Message-ID: <1347830995-19226-8-git-send-email-fw@strlen.de>
References: <1347830995-19226-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:33808 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751875Ab2IPVcp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Sep 2012 17:32:45 -0400
In-Reply-To: <1347830995-19226-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 extensions/xt_psd.c |   42 ++++++++++++++++++++----------------------
 1 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/extensions/xt_psd.c b/extensions/xt_psd.c
index 2baec8e..a3f1168 100644
--- a/extensions/xt_psd.c
+++ b/extensions/xt_psd.c
@@ -182,6 +182,25 @@ entry_is_recent(const struct host *h, unsigned long delay_threshold,
 				time_after_eq(now, h->timestamp);
 }
 
+static void remove_oldest(struct host **head, struct host *curr)
+{
+	struct host *h, *last = NULL;
+
+	/* We're going to re-use the oldest list entry, so remove it from the hash
+	 * table first if it is really already in use */
+	h = *head;
+	while (h != NULL) {
+		if (curr == h)
+			break;
+		last = h;
+		h = h->next;
+	}
+
+	/* Then, remove it */
+	if (h != NULL)
+		ht_unlink(head, last);
+}
+
 static bool
 xt_psd_match(const struct sk_buff *pskb, struct xt_action_param *match)
 {
@@ -282,36 +301,15 @@ xt_psd_match(const struct sk_buff *pskb, struct xt_action_param *match)
 	if (count >= HASH_MAX && last != NULL)
 		last->next = NULL;
 
-	/* We're going to re-use the oldest list entry, so remove it from the hash
-	 * table first (if it is really already in use, and isn't removed from the
-	 * hash table already because of the HASH_MAX check above). */
-
-	/* First, find it */
 	if (state.list[state.index].saddr != 0)
 		head = &state.hash[hashfunc(state.list[state.index].saddr)];
 	else
 		head = &last;
-	last = NULL;
-	curr = *head;
-	while (curr != NULL) {
-		curr4 = host_to_host4(curr);
-		if (curr4 == &state.list[state.index])
-			break;
-		last = curr;
-		curr = curr->next;
-	}
-
-	/* Then, remove it */
-	if (curr != NULL) {
-		if (last != NULL)
-			last->next = last->next->next;
-		else if (*head != NULL)
-			*head = (*head)->next;
-	}
 
 	/* Get our list entry */
 	curr4 = &state.list[state.index++];
 	curr = &curr4->host;
+	remove_oldest(head, curr);
 	if (state.index >= LIST_SIZE)
 		state.index = 0;
 
-- 
1.7.8.6

