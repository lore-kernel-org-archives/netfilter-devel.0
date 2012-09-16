From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 05/11] xt_psd: remove unneeded variables
Date: Sun, 16 Sep 2012 23:29:49 +0200
Message-ID: <1347830995-19226-6-git-send-email-fw@strlen.de>
References: <1347830995-19226-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:33806 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751684Ab2IPVcl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Sep 2012 17:32:41 -0400
In-Reply-To: <1347830995-19226-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

- dest port and dest address were only written, never read
- struct inaddr isn't needed either, just look at iph->saddr
---
 extensions/xt_psd.c |   23 ++++++++---------------
 1 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/extensions/xt_psd.c b/extensions/xt_psd.c
index df04277..e66ea56 100644
--- a/extensions/xt_psd.c
+++ b/extensions/xt_psd.c
@@ -69,7 +69,6 @@ struct host {
 	struct host *next;
 	unsigned long timestamp;
 	struct in_addr src_addr;
-	struct in_addr dest_addr;
 	__be16 src_port;
 	uint16_t count;
 	uint8_t weight;
@@ -92,12 +91,12 @@ static struct {
 /*
  * Convert an IP address into a hash table index.
  */
-static inline int hashfunc(struct in_addr addr)
+static unsigned int hashfunc(__be32 addr)
 {
 	unsigned int value;
 	int hash;
 
-	value = addr.s_addr;
+	value = (unsigned int) addr;
 	hash = 0;
 	do {
 		hash ^= value;
@@ -181,8 +180,7 @@ xt_psd_match(const struct sk_buff *pskb, struct xt_action_param *match)
 		struct tcphdr tcph;
 		struct udphdr udph;
 	} _buf;
-	struct in_addr addr;
-	u_int16_t src_port,dest_port;
+	u_int16_t dest_port;
 	u_int8_t proto;
 	unsigned long now;
 	struct host *curr, *last = NULL, **head;
@@ -197,10 +195,9 @@ xt_psd_match(const struct sk_buff *pskb, struct xt_action_param *match)
 	}
 
 	proto = iph->protocol;
-	addr.s_addr = iph->saddr;
 	/* We're using IP address 0.0.0.0 for a special purpose here, so don't let
 	 * them spoof us. [DHCP needs this feature - HW] */
-	if (addr.s_addr == 0) {
+	if (iph->saddr == 0) {
 		pr_debug("spoofed source address (0.0.0.0)\n");
 		return false;
 	}
@@ -212,14 +209,12 @@ xt_psd_match(const struct sk_buff *pskb, struct xt_action_param *match)
 			return false;
 
 		/* Yep, it's dirty */
-		src_port = tcph->source;
 		dest_port = tcph->dest;
 	} else if (proto == IPPROTO_UDP || proto == IPPROTO_UDPLITE) {
 		udph = skb_header_pointer(pskb, match->thoff,
 		       sizeof(_buf.udph), &_buf.udph);
 		if (udph == NULL)
 			return false;
-		src_port  = udph->source;
 		dest_port = udph->dest;
 	} else {
 		pr_debug("protocol not supported\n");
@@ -227,7 +222,7 @@ xt_psd_match(const struct sk_buff *pskb, struct xt_action_param *match)
 	}
 
 	now = jiffies;
-	hash = hashfunc(addr);
+	hash = hashfunc(iph->saddr);
 	head = &state.hash[hash];
 
 	spin_lock(&state.lock);
@@ -235,7 +230,7 @@ xt_psd_match(const struct sk_buff *pskb, struct xt_action_param *match)
 	/* Do we know this source address already? */
 	curr = *head;
 	while (curr != NULL) {
-		if (curr->src_addr.s_addr == addr.s_addr)
+		if (curr->src_addr.s_addr == iph->saddr)
 			break;
 		count++;
 		curr = host_get_next(curr, &last);
@@ -278,7 +273,7 @@ xt_psd_match(const struct sk_buff *pskb, struct xt_action_param *match)
 
 	/* First, find it */
 	if (state.list[state.index].src_addr.s_addr != 0)
-		head = &state.hash[hashfunc(state.list[state.index].src_addr)];
+		head = &state.hash[hashfunc(state.list[state.index].src_addr.s_addr)];
 	else
 		head = &last;
 	last = NULL;
@@ -309,10 +304,8 @@ xt_psd_match(const struct sk_buff *pskb, struct xt_action_param *match)
 	*head = curr;
 
 	/* And fill in the fields */
+	curr->src_addr.s_addr = iph->saddr;
 	curr->timestamp = now;
-	curr->src_addr = addr;
-	curr->dest_addr.s_addr = iph->daddr;
-	curr->src_port = src_port;
 	curr->count = 1;
 	curr->weight = get_port_weight(psdinfo, dest_port);
 	curr->ports[0].number = dest_port;
-- 
1.7.8.6

