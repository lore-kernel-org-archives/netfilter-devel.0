From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 4/7] xt_psd: use tcph->dest directly
Date: Mon, 17 Sep 2012 14:55:20 +0200
Message-ID: <1347886523-19356-5-git-send-email-fw@strlen.de>
References: <1347886523-19356-1-git-send-email-fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:35818 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752206Ab2IQMxc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Sep 2012 08:53:32 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.72)
	(envelope-from <fw@breakpoint.cc>)
	id 1TDapP-0000KN-HI
	for netfilter-devel@vger.kernel.org; Mon, 17 Sep 2012 14:53:31 +0200
In-Reply-To: <1347886523-19356-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

allows us to move more code away from the main match function.
---
 extensions/xt_psd.c |   35 +++++++++++++++--------------------
 1 files changed, 15 insertions(+), 20 deletions(-)

diff --git a/extensions/xt_psd.c b/extensions/xt_psd.c
index 352c11a..09251e7 100644
--- a/extensions/xt_psd.c
+++ b/extensions/xt_psd.c
@@ -137,15 +137,22 @@ static uint16_t get_port_weight(const struct xt_psd_info *psd, __be16 port)
 
 static bool
 is_portscan(struct host *host, const struct xt_psd_info *psdinfo,
-            uint8_t proto, __be16 dest_port)
+            const struct tcphdr *tcph, uint8_t proto)
 {
+	if (port_in_list(host, proto, tcph->dest))
+		return false;
+
+	/* TCP/ACK and/or TCP/RST to a new port? This could be an outgoing connection. */
+	if (proto == IPPROTO_TCP && (tcph->ack || tcph->rst))
+		return false;
+
 	host->timestamp = jiffies;
 
 	if (host->weight >= psdinfo->weight_threshold) /* already matched */
 		return true;
 
 	/* Update the total weight */
-	host->weight += get_port_weight(psdinfo, dest_port);
+	host->weight += get_port_weight(psdinfo, tcph->dest);
 
 	/* Got enough destination ports to decide that this is a scan? */
 	if (host->weight >= psdinfo->weight_threshold)
@@ -153,7 +160,7 @@ is_portscan(struct host *host, const struct xt_psd_info *psdinfo,
 
 	/* Remember the new port */
 	if (host->count < ARRAY_SIZE(host->ports)) {
-		host->ports[host->count].number = dest_port;
+		host->ports[host->count].number = tcph->dest;
 		host->ports[host->count].proto = proto;
 		host->count++;
 	}
@@ -207,12 +214,10 @@ xt_psd_match(const struct sk_buff *pskb, struct xt_action_param *match)
 {
 	const struct iphdr *iph;
 	const struct tcphdr *tcph = NULL;
-	const struct udphdr *udph;
 	union {
 		struct tcphdr tcph;
 		struct udphdr udph;
 	} _buf;
-	u_int16_t dest_port;
 	u_int8_t proto;
 	unsigned long now;
 	struct host *curr, *last = NULL, **head;
@@ -241,15 +246,11 @@ xt_psd_match(const struct sk_buff *pskb, struct xt_action_param *match)
 		       sizeof(_buf.tcph), &_buf.tcph);
 		if (tcph == NULL)
 			return false;
-
-		/* Yep, it's dirty */
-		dest_port = tcph->dest;
 	} else if (proto == IPPROTO_UDP || proto == IPPROTO_UDPLITE) {
-		udph = skb_header_pointer(pskb, match->thoff,
+		tcph = skb_header_pointer(pskb, match->thoff,
 		       sizeof(_buf.udph), &_buf.udph);
-		if (udph == NULL)
+		if (tcph == NULL)
 			return false;
-		dest_port = udph->dest;
 	} else {
 		pr_debug("protocol not supported\n");
 		return false;
@@ -274,13 +275,7 @@ xt_psd_match(const struct sk_buff *pskb, struct xt_action_param *match)
 	if (curr != NULL) {
 		/* We know this address, and the entry isn't too old. Update it. */
 		if (entry_is_recent(curr, psdinfo->delay_threshold, now)) {
-			if (port_in_list(curr, proto, dest_port))
-				goto out_no_match;
-			/* TCP/ACK and/or TCP/RST to a new port? This could be an outgoing connection. */
-			if (proto == IPPROTO_TCP && (tcph->ack || tcph->rst))
-				goto out_no_match;
-
-			if (is_portscan(curr, psdinfo, proto, dest_port))
+			if (is_portscan(curr, psdinfo, tcph, proto))
 				goto out_match;
 			goto out_no_match;
 		}
@@ -325,8 +320,8 @@ xt_psd_match(const struct sk_buff *pskb, struct xt_action_param *match)
 	curr4->saddr = iph->saddr;
 	curr->timestamp = now;
 	curr->count = 1;
-	curr->weight = get_port_weight(psdinfo, dest_port);
-	curr->ports[0].number = dest_port;
+	curr->weight = get_port_weight(psdinfo, tcph->dest);
+	curr->ports[0].number = tcph->dest;
 	curr->ports[0].proto = proto;
 
 out_no_match:
-- 
1.7.8.6

