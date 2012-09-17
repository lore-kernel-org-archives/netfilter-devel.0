From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 6/7] xt_psd: move ipv4 state locking responsibility to caller
Date: Mon, 17 Sep 2012 14:55:22 +0200
Message-ID: <1347886523-19356-7-git-send-email-fw@strlen.de>
References: <1347886523-19356-1-git-send-email-fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:35822 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752206Ab2IQMxe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Sep 2012 08:53:34 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.72)
	(envelope-from <fw@breakpoint.cc>)
	id 1TDapS-0000LK-0m
	for netfilter-devel@vger.kernel.org; Mon, 17 Sep 2012 14:53:34 +0200
In-Reply-To: <1347886523-19356-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

former psd_match function is now < 72 lines.
---
 extensions/xt_psd.c |   32 +++++++++++++-------------------
 1 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/extensions/xt_psd.c b/extensions/xt_psd.c
index 9c52426..fbb9e22 100644
--- a/extensions/xt_psd.c
+++ b/extensions/xt_psd.c
@@ -232,20 +232,16 @@ get_header_pointer4(const struct sk_buff *skb, unsigned int thoff, void *mem)
 
 static bool
 handle_packet4(const struct iphdr *iph, const struct tcphdr *tcph,
-	   const struct xt_psd_info *psdinfo)
+	       const struct xt_psd_info *psdinfo, unsigned int hash)
 {
 	unsigned long now;
 	struct host *curr, *last = NULL, **head;
 	struct host4 *curr4;
 	int count = 0;
-	unsigned int hash;
 
 	now = jiffies;
-	hash = hashfunc(iph->saddr);
 	head = &state.hash[hash];
 
-	spin_lock(&state.lock);
-
 	/* Do we know this source address already? */
 	curr = *head;
 	while (curr != NULL) {
@@ -258,11 +254,9 @@ handle_packet4(const struct iphdr *iph, const struct tcphdr *tcph,
 
 	if (curr != NULL) {
 		/* We know this address, and the entry isn't too old. Update it. */
-		if (entry_is_recent(curr, psdinfo->delay_threshold, now)) {
-			if (is_portscan(curr, psdinfo, tcph, iph->protocol))
-				goto out_match;
-			goto out_no_match;
-		}
+		if (entry_is_recent(curr, psdinfo->delay_threshold, now))
+			return is_portscan(curr, psdinfo, tcph, iph->protocol);
+
 		/* We know this address, but the entry is outdated. Mark it unused, and
 		 * remove from the hash table. We'll allocate a new entry instead since
 		 * this one might get re-used too soon. */
@@ -274,7 +268,7 @@ handle_packet4(const struct iphdr *iph, const struct tcphdr *tcph,
 
 	/* We don't need an ACK from a new source address */
 	if (iph->protocol == IPPROTO_TCP && tcph->ack)
-		goto out_no_match;
+		return false;
 
 	/* Got too many source addresses with the same hash value? Then remove the
 	 * oldest one from the hash table, so that they can't take too much of our
@@ -307,14 +301,7 @@ handle_packet4(const struct iphdr *iph, const struct tcphdr *tcph,
 	curr->weight = get_port_weight(psdinfo, tcph->dest);
 	curr->ports[0].number = tcph->dest;
 	curr->ports[0].proto = iph->protocol;
-
-out_no_match:
-	spin_unlock(&state.lock);
 	return false;
-
-out_match:
-	spin_unlock(&state.lock);
-	return true;
 }
 
 static bool
@@ -323,6 +310,8 @@ xt_psd_match(const struct sk_buff *pskb, struct xt_action_param *match)
 	struct iphdr *iph = ip_hdr(pskb);
 	struct tcphdr _tcph;
 	struct tcphdr *tcph;
+	bool matched;
+	unsigned int hash;
 	/* Parameters from userspace */
 	const struct xt_psd_info *psdinfo = match->matchinfo;
 
@@ -342,7 +331,12 @@ xt_psd_match(const struct sk_buff *pskb, struct xt_action_param *match)
 	if (tcph == NULL)
 		return false;
 
-	return handle_packet4(iph, tcph, psdinfo);
+	hash = hashfunc(iph->saddr);
+
+	spin_lock(&state.lock);
+	matched = handle_packet4(iph, tcph, psdinfo, hash);
+	spin_unlock(&state.lock);
+	return matched;
 }
 
 static int psd_mt_check(const struct xt_mtchk_param *par)
-- 
1.7.8.6

