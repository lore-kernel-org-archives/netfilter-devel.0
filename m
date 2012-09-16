From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 10/11] xt_psd: move ipv4 state locking responsibility to caller
Date: Sun, 16 Sep 2012 23:29:54 +0200
Message-ID: <1347830995-19226-11-git-send-email-fw@strlen.de>
References: <1347830995-19226-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:33811 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751911Ab2IPVcw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Sep 2012 17:32:52 -0400
In-Reply-To: <1347830995-19226-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

former psd_match function is now < 72 lines.
---
 extensions/xt_psd.c |   33 ++++++++++++++-------------------
 1 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/extensions/xt_psd.c b/extensions/xt_psd.c
index 6ca1bd6..a5729e1 100644
--- a/extensions/xt_psd.c
+++ b/extensions/xt_psd.c
@@ -231,19 +231,16 @@ get_header_pointer4(const struct sk_buff *skb, unsigned int thoff, void *mem)
 
 static bool
 handle_packet4(const struct iphdr *iph, const struct tcphdr *tcph,
-	   const struct xt_psd_info *psdinfo)
+	   const struct xt_psd_info *psdinfo, int hash)
 {
 	unsigned long now;
 	struct host *curr, *last = NULL, **head;
 	struct host4 *curr4;
-	int hash, count = 0;
+	int count = 0;
 
 	now = jiffies;
-	hash = hashfunc(iph->saddr);
 	head = &state.hash[hash];
 
-	spin_lock(&state.lock);
-
 	/* Do we know this source address already? */
 	curr = *head;
 	while (curr != NULL) {
@@ -256,11 +253,9 @@ handle_packet4(const struct iphdr *iph, const struct tcphdr *tcph,
 
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
@@ -272,7 +267,7 @@ handle_packet4(const struct iphdr *iph, const struct tcphdr *tcph,
 
 	/* We don't need an ACK from a new source address */
 	if (iph->protocol == IPPROTO_TCP && tcph->ack)
-		goto out_no_match;
+		return false;
 
 	/* Got too many source addresses with the same hash value? Then remove the
 	 * oldest one from the hash table, so that they can't take too much of our
@@ -305,14 +300,7 @@ handle_packet4(const struct iphdr *iph, const struct tcphdr *tcph,
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
@@ -321,6 +309,8 @@ xt_psd_match(const struct sk_buff *pskb, struct xt_action_param *match)
 	struct iphdr *iph = ip_hdr(pskb);
 	struct tcphdr _tcph;
 	struct tcphdr *tcph;
+	bool matched;
+	int hash;
 	/* Parameters from userspace */
 	const struct xt_psd_info *psdinfo = match->matchinfo;
 
@@ -340,7 +330,12 @@ xt_psd_match(const struct sk_buff *pskb, struct xt_action_param *match)
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

