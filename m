From: Josh Hunt <johunt@akamai.com>
Subject: [PATCH 1/3] xtables: tarpit: Make tarpit code generic
Date: Sat,  7 Jul 2012 14:20:59 -0700
Message-ID: <1341696061-21863-2-git-send-email-johunt@akamai.com>
References: <1341696061-21863-1-git-send-email-johunt@akamai.com>
Cc: Josh Hunt <johunt@akamai.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay05.akamai.com ([96.6.114.97]:56572 "EHLO
	prod-mail-xrelay05.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751687Ab2GGVVD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 7 Jul 2012 17:21:03 -0400
Received: from prod-mail-xrelay05.akamai.com (localhost.localdomain [127.0.0.1])
	by postfix.imss70 (Postfix) with ESMTP id 9CEEC1C490F
	for <netfilter-devel@vger.kernel.org>; Sat,  7 Jul 2012 21:21:01 +0000 (GMT)
Received: from prod-mail-relay04.akamai.com (prod-mail-relay04.akamai.com [172.27.8.27])
	by prod-mail-xrelay05.akamai.com (Postfix) with ESMTP id 909251C487F
	for <netfilter-devel@vger.kernel.org>; Sat,  7 Jul 2012 21:21:01 +0000 (GMT)
In-Reply-To: <1341696061-21863-1-git-send-email-johunt@akamai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Moves TCP header manipulation into a separate function to allow code-sharing for
IPv6 support.

Signed-off-by: Josh Hunt <johunt@akamai.com>
---
 extensions/xt_TARPIT.c |  133 +++++++++++++++++++++++++-----------------------
 1 files changed, 69 insertions(+), 64 deletions(-)

diff --git a/extensions/xt_TARPIT.c b/extensions/xt_TARPIT.c
index db24f90..9a09e75 100644
--- a/extensions/xt_TARPIT.c
+++ b/extensions/xt_TARPIT.c
@@ -51,70 +51,7 @@
 #include "compat_xtables.h"
 #include "xt_TARPIT.h"
 
-static void tarpit_tcp(struct sk_buff *oldskb, unsigned int hook,
-    unsigned int mode)
-{
-	struct tcphdr _otcph, *oth, *tcph;
-	unsigned int addr_type = RTN_UNSPEC;
-	struct sk_buff *nskb;
-	const struct iphdr *oldhdr;
-	struct iphdr *niph;
-	uint16_t tmp, payload;
-
-	/* A truncated TCP header is not going to be useful */
-	if (oldskb->len < ip_hdrlen(oldskb) + sizeof(struct tcphdr))
-		return;
-
-	oth = skb_header_pointer(oldskb, ip_hdrlen(oldskb),
-	                         sizeof(_otcph), &_otcph);
-	if (oth == NULL)
-		return;
-
-	/* Check checksum. */
-	if (nf_ip_checksum(oldskb, hook, ip_hdrlen(oldskb), IPPROTO_TCP))
-		return;
-
-	/*
-	 * Copy skb (even if skb is about to be dropped, we cannot just
-	 * clone it because there may be other things, such as tcpdump,
-	 * interested in it)
-	 */
-	nskb = skb_copy_expand(oldskb, LL_MAX_HEADER,
-	                       skb_tailroom(oldskb), GFP_ATOMIC);
-	if (nskb == NULL)
-		return;
-
-	/* This packet will not be the same as the other: clear nf fields */
-	nf_reset(nskb);
-	skb_nfmark(nskb) = 0;
-	skb_init_secmark(nskb);
-
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 18)
-	skb_shinfo(nskb)->gso_size = 0;
-	skb_shinfo(nskb)->gso_segs = 0;
-	skb_shinfo(nskb)->gso_type = 0;
-#endif
-
-	oldhdr = ip_hdr(oldskb);
-	tcph = (struct tcphdr *)(skb_network_header(nskb) + ip_hdrlen(nskb));
-
-	/* Swap source and dest */
-	niph         = ip_hdr(nskb);
-	niph->daddr  = xchg(&niph->saddr, niph->daddr);
-	tmp          = tcph->source;
-	tcph->source = tcph->dest;
-	tcph->dest   = tmp;
-
-	/* Calculate payload size?? */
-	payload = nskb->len - ip_hdrlen(nskb) - sizeof(struct tcphdr);
-
-	/* Truncate to length (no data) */
-	tcph->doff    = sizeof(struct tcphdr) / 4;
-	skb_trim(nskb, ip_hdrlen(nskb) + sizeof(struct tcphdr));
-	niph->tot_len = htons(nskb->len);
-	tcph->urg_ptr = 0;
-	/* Reset flags */
-	((u_int8_t *)tcph)[13] = 0;
+static void tarpit_generic(struct tcphdr *oth, struct tcphdr *tcph, uint16_t payload, unsigned int mode) {
 
 	if (mode == XTTARPIT_TARPIT) {
 		/* No replies for RST, FIN or !SYN,!ACK */
@@ -194,6 +131,74 @@ static void tarpit_tcp(struct sk_buff *oldskb, unsigned int hook,
 		tcph->seq     = oth->ack_seq;
 		tcph->ack_seq = oth->seq;
 	}
+}
+
+static void tarpit_tcp(struct sk_buff *oldskb, unsigned int hook,
+    unsigned int mode)
+{
+	struct tcphdr _otcph, *oth, *tcph;
+	unsigned int addr_type = RTN_UNSPEC;
+	struct sk_buff *nskb;
+	const struct iphdr *oldhdr;
+	struct iphdr *niph;
+	uint16_t tmp, payload;
+
+	/* A truncated TCP header is not going to be useful */
+	if (oldskb->len < ip_hdrlen(oldskb) + sizeof(struct tcphdr))
+		return;
+
+	oth = skb_header_pointer(oldskb, ip_hdrlen(oldskb),
+	                         sizeof(_otcph), &_otcph);
+	if (oth == NULL)
+		return;
+
+	/* Check checksum. */
+	if (nf_ip_checksum(oldskb, hook, ip_hdrlen(oldskb), IPPROTO_TCP))
+		return;
+
+	/*
+	 * Copy skb (even if skb is about to be dropped, we cannot just
+	 * clone it because there may be other things, such as tcpdump,
+	 * interested in it)
+	 */
+	nskb = skb_copy_expand(oldskb, LL_MAX_HEADER,
+	                       skb_tailroom(oldskb), GFP_ATOMIC);
+	if (nskb == NULL)
+		return;
+
+	/* This packet will not be the same as the other: clear nf fields */
+	nf_reset(nskb);
+	skb_nfmark(nskb) = 0;
+	skb_init_secmark(nskb);
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 18)
+	skb_shinfo(nskb)->gso_size = 0;
+	skb_shinfo(nskb)->gso_segs = 0;
+	skb_shinfo(nskb)->gso_type = 0;
+#endif
+
+	oldhdr = ip_hdr(oldskb);
+	tcph = (struct tcphdr *)(skb_network_header(nskb) + ip_hdrlen(nskb));
+
+	/* Swap source and dest */
+	niph         = ip_hdr(nskb);
+	niph->daddr  = xchg(&niph->saddr, niph->daddr);
+	tmp          = tcph->source;
+	tcph->source = tcph->dest;
+	tcph->dest   = tmp;
+
+	/* Calculate payload size?? */
+	payload = nskb->len - ip_hdrlen(nskb) - sizeof(struct tcphdr);
+
+	/* Truncate to length (no data) */
+	tcph->doff    = sizeof(struct tcphdr) / 4;
+	skb_trim(nskb, ip_hdrlen(nskb) + sizeof(struct tcphdr));
+	niph->tot_len = htons(nskb->len);
+	tcph->urg_ptr = 0;
+	/* Reset flags */
+	((u_int8_t *)tcph)[13] = 0;
+
+	tarpit_generic(oth, tcph, payload, mode);
 
 	/* Adjust TCP checksum */
 	tcph->check = 0;
-- 
1.7.0.4

