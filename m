From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 5/7] xt_psd: move l4 header fetching into helper
Date: Mon, 17 Sep 2012 14:55:21 +0200
Message-ID: <1347886523-19356-6-git-send-email-fw@strlen.de>
References: <1347886523-19356-1-git-send-email-fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:35821 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752206Ab2IQMxd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Sep 2012 08:53:33 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.72)
	(envelope-from <fw@breakpoint.cc>)
	id 1TDapQ-0000Kr-Ov
	for netfilter-devel@vger.kernel.org; Mon, 17 Sep 2012 14:53:32 +0200
In-Reply-To: <1347886523-19356-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

also start splitting psd_match into two functions, one
to do initial sanity checking and header retrieval, one
to do the actual work.
---
 extensions/xt_psd.c |   96 ++++++++++++++++++++++++++++----------------------
 1 files changed, 54 insertions(+), 42 deletions(-)

diff --git a/extensions/xt_psd.c b/extensions/xt_psd.c
index 09251e7..9c52426 100644
--- a/extensions/xt_psd.c
+++ b/extensions/xt_psd.c
@@ -209,52 +209,36 @@ static void remove_oldest(struct host **head, struct host *curr)
 		ht_unlink(head, last);
 }
 
+static void *
+get_header_pointer4(const struct sk_buff *skb, unsigned int thoff, void *mem)
+{
+	const struct iphdr *iph = ip_hdr(skb);
+	int hdrlen;
+
+	switch (iph->protocol) {
+	case IPPROTO_TCP:
+		hdrlen = sizeof(struct tcphdr);
+		break;
+	case IPPROTO_UDP:
+	case IPPROTO_UDPLITE:
+		hdrlen = sizeof(struct udphdr);
+		break;
+	default:
+		return NULL;
+	}
+
+	return skb_header_pointer(skb, thoff, hdrlen, mem);
+}
+
 static bool
-xt_psd_match(const struct sk_buff *pskb, struct xt_action_param *match)
+handle_packet4(const struct iphdr *iph, const struct tcphdr *tcph,
+	   const struct xt_psd_info *psdinfo)
 {
-	const struct iphdr *iph;
-	const struct tcphdr *tcph = NULL;
-	union {
-		struct tcphdr tcph;
-		struct udphdr udph;
-	} _buf;
-	u_int8_t proto;
 	unsigned long now;
 	struct host *curr, *last = NULL, **head;
 	struct host4 *curr4;
 	int count = 0;
 	unsigned int hash;
-	/* Parameters from userspace */
-	const struct xt_psd_info *psdinfo = match->matchinfo;
-
-	iph = ip_hdr(pskb);
-	if (iph->frag_off & htons(IP_OFFSET)) {
-		pr_debug("sanity check failed\n");
-		return false;
-	}
-
-	proto = iph->protocol;
-	/* We're using IP address 0.0.0.0 for a special purpose here, so don't let
-	 * them spoof us. [DHCP needs this feature - HW] */
-	if (iph->saddr == 0) {
-		pr_debug("spoofed source address (0.0.0.0)\n");
-		return false;
-	}
-
-	if (proto == IPPROTO_TCP) {
-		tcph = skb_header_pointer(pskb, match->thoff,
-		       sizeof(_buf.tcph), &_buf.tcph);
-		if (tcph == NULL)
-			return false;
-	} else if (proto == IPPROTO_UDP || proto == IPPROTO_UDPLITE) {
-		tcph = skb_header_pointer(pskb, match->thoff,
-		       sizeof(_buf.udph), &_buf.udph);
-		if (tcph == NULL)
-			return false;
-	} else {
-		pr_debug("protocol not supported\n");
-		return false;
-	}
 
 	now = jiffies;
 	hash = hashfunc(iph->saddr);
@@ -275,7 +259,7 @@ xt_psd_match(const struct sk_buff *pskb, struct xt_action_param *match)
 	if (curr != NULL) {
 		/* We know this address, and the entry isn't too old. Update it. */
 		if (entry_is_recent(curr, psdinfo->delay_threshold, now)) {
-			if (is_portscan(curr, psdinfo, tcph, proto))
+			if (is_portscan(curr, psdinfo, tcph, iph->protocol))
 				goto out_match;
 			goto out_no_match;
 		}
@@ -289,7 +273,7 @@ xt_psd_match(const struct sk_buff *pskb, struct xt_action_param *match)
 	}
 
 	/* We don't need an ACK from a new source address */
-	if (proto == IPPROTO_TCP && tcph->ack)
+	if (iph->protocol == IPPROTO_TCP && tcph->ack)
 		goto out_no_match;
 
 	/* Got too many source addresses with the same hash value? Then remove the
@@ -322,7 +306,7 @@ xt_psd_match(const struct sk_buff *pskb, struct xt_action_param *match)
 	curr->count = 1;
 	curr->weight = get_port_weight(psdinfo, tcph->dest);
 	curr->ports[0].number = tcph->dest;
-	curr->ports[0].proto = proto;
+	curr->ports[0].proto = iph->protocol;
 
 out_no_match:
 	spin_unlock(&state.lock);
@@ -333,6 +317,34 @@ out_match:
 	return true;
 }
 
+static bool
+xt_psd_match(const struct sk_buff *pskb, struct xt_action_param *match)
+{
+	struct iphdr *iph = ip_hdr(pskb);
+	struct tcphdr _tcph;
+	struct tcphdr *tcph;
+	/* Parameters from userspace */
+	const struct xt_psd_info *psdinfo = match->matchinfo;
+
+	if (iph->frag_off & htons(IP_OFFSET)) {
+		pr_debug("sanity check failed\n");
+		return false;
+	}
+
+	/* We're using IP address 0.0.0.0 for a special purpose here, so don't let
+	 * them spoof us. [DHCP needs this feature - HW] */
+	if (iph->saddr == 0) {
+		pr_debug("spoofed source address (0.0.0.0)\n");
+		return false;
+	}
+
+	tcph = get_header_pointer4(pskb, match->thoff, &_tcph);
+	if (tcph == NULL)
+		return false;
+
+	return handle_packet4(iph, tcph, psdinfo);
+}
+
 static int psd_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct xt_psd_info *info = par->matchinfo;
-- 
1.7.8.6

