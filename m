From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 04/11] xt_psd: move match functionality to helpers
Date: Sun, 16 Sep 2012 23:29:48 +0200
Message-ID: <1347830995-19226-5-git-send-email-fw@strlen.de>
References: <1347830995-19226-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:33805 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751658Ab2IPVci (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Sep 2012 17:32:38 -0400
In-Reply-To: <1347830995-19226-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

... reduce line count and to allow code reuse when ipv6 support is introduced.
---
 extensions/xt_psd.c |   36 ++++++++++++++++++++++++++----------
 1 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/extensions/xt_psd.c b/extensions/xt_psd.c
index e803052..df04277 100644
--- a/extensions/xt_psd.c
+++ b/extensions/xt_psd.c
@@ -148,6 +148,29 @@ is_portscan(struct host *host, const struct xt_psd_info *psdinfo,
 	return false;
 }
 
+static struct host *host_get_next(struct host *h, struct host **last)
+{
+	if (h->next)
+		*last = h;
+	return h->next;
+}
+
+static void ht_unlink(struct host **head, struct host *last)
+{
+	if (last)
+		last->next = last->next->next;
+	else if (*head)
+		*head = (*head)->next;
+}
+
+static bool
+entry_is_recent(const struct host *h, unsigned long delay_threshold,
+		unsigned long now)
+{
+	return now - h->timestamp <= (delay_threshold*HZ)/100 &&
+				time_after_eq(now, h->timestamp);
+}
+
 static bool
 xt_psd_match(const struct sk_buff *pskb, struct xt_action_param *match)
 {
@@ -215,16 +238,12 @@ xt_psd_match(const struct sk_buff *pskb, struct xt_action_param *match)
 		if (curr->src_addr.s_addr == addr.s_addr)
 			break;
 		count++;
-		if (curr->next != NULL)
-			last = curr;
-		curr = curr->next;
+		curr = host_get_next(curr, &last);
 	}
 
 	if (curr != NULL) {
 		/* We know this address, and the entry isn't too old. Update it. */
-		if (now - curr->timestamp <= (psdinfo->delay_threshold*HZ)/100 &&
-		    time_after_eq(now, curr->timestamp)) {
-
+		if (entry_is_recent(curr, psdinfo->delay_threshold, now)) {
 			if (port_in_list(curr, proto, dest_port))
 				goto out_no_match;
 			/* TCP/ACK and/or TCP/RST to a new port? This could be an outgoing connection. */
@@ -239,10 +258,7 @@ xt_psd_match(const struct sk_buff *pskb, struct xt_action_param *match)
 		 * remove from the hash table. We'll allocate a new entry instead since
 		 * this one might get re-used too soon. */
 		curr->src_addr.s_addr = 0;
-		if (last != NULL)
-			last->next = last->next->next;
-		else if (*head != NULL)
-			*head = (*head)->next;
+		ht_unlink(head, last);
 		last = NULL;
 	}
 
-- 
1.7.8.6

