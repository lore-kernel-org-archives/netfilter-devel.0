From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 21/38]: ipt_REJECT: properly handle IP options
Date: Tue, 15 Jan 2008 07:19:40 +0100 (MET)
Message-ID: <20080115061935.3184.95392.sendpatchset@localhost.localdomain>
References: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62219 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332AbYAOGTm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 01:19:42 -0500
In-Reply-To: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: ipt_REJECT: properly handle IP options

The current TCP RST construction reuses the old packet and can't
deal with IP options as a consequence of that. Construct the
RST from scratch instead.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit e98b968b91b444bb9af1547818b9601419150dba
tree ce141bf2b369601e6160e59b9adae3449887ee34
parent 672b1bb962284718abf7cc88055ca2bb4378c7bc
author Patrick McHardy <kaber@trash.net> Tue, 15 Jan 2008 06:53:24 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 15 Jan 2008 06:53:24 +0100

 net/ipv4/netfilter/ipt_REJECT.c |  102 ++++++++++++++-------------------------
 1 files changed, 37 insertions(+), 65 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_REJECT.c b/net/ipv4/netfilter/ipt_REJECT.c
index e3c2ecc..22606e2 100644
--- a/net/ipv4/netfilter/ipt_REJECT.c
+++ b/net/ipv4/netfilter/ipt_REJECT.c
@@ -35,11 +35,8 @@ MODULE_DESCRIPTION("Xtables: packet \"rejection\" target for IPv4");
 static void send_reset(struct sk_buff *oldskb, int hook)
 {
 	struct sk_buff *nskb;
-	struct iphdr *niph;
+	struct iphdr *oiph, *niph;
 	struct tcphdr _otcph, *oth, *tcph;
-	__be16 tmp_port;
-	__be32 tmp_addr;
-	int needs_ack;
 	unsigned int addr_type;
 
 	/* IP header checks: fragment. */
@@ -58,69 +55,47 @@ static void send_reset(struct sk_buff *oldskb, int hook)
 	/* Check checksum */
 	if (nf_ip_checksum(oldskb, hook, ip_hdrlen(oldskb), IPPROTO_TCP))
 		return;
+	oiph = ip_hdr(oldskb);
 
-	/* We need a linear, writeable skb.  We also need to expand
-	   headroom in case hh_len of incoming interface < hh_len of
-	   outgoing interface */
-	nskb = skb_copy_expand(oldskb, LL_MAX_HEADER, skb_tailroom(oldskb),
-			       GFP_ATOMIC);
+	nskb = alloc_skb(sizeof(struct iphdr) + sizeof(struct tcphdr) +
+			 LL_MAX_HEADER, GFP_ATOMIC);
 	if (!nskb)
 		return;
 
-	/* This packet will not be the same as the other: clear nf fields */
-	nf_reset(nskb);
-	nskb->mark = 0;
-	skb_init_secmark(nskb);
-
-	skb_shinfo(nskb)->gso_size = 0;
-	skb_shinfo(nskb)->gso_segs = 0;
-	skb_shinfo(nskb)->gso_type = 0;
-
-	tcph = (struct tcphdr *)(skb_network_header(nskb) + ip_hdrlen(nskb));
-
-	/* Swap source and dest */
-	niph = ip_hdr(nskb);
-	tmp_addr = niph->saddr;
-	niph->saddr = niph->daddr;
-	niph->daddr = tmp_addr;
-	tmp_port = tcph->source;
-	tcph->source = tcph->dest;
-	tcph->dest = tmp_port;
-
-	/* Truncate to length (no data) */
-	tcph->doff = sizeof(struct tcphdr)/4;
-	skb_trim(nskb, ip_hdrlen(nskb) + sizeof(struct tcphdr));
-
-	if (tcph->ack) {
-		needs_ack = 0;
+	skb_reserve(nskb, LL_MAX_HEADER);
+
+	skb_reset_network_header(nskb);
+	niph = (struct iphdr *)skb_put(nskb, sizeof(struct iphdr));
+	niph->version	= 4;
+	niph->ihl	= sizeof(struct iphdr) / 4;
+	niph->tos	= 0;
+	niph->id	= 0;
+	niph->frag_off	= htons(IP_DF);
+	niph->protocol	= IPPROTO_TCP;
+	niph->check	= 0;
+	niph->saddr	= oiph->daddr;
+	niph->daddr	= oiph->saddr;
+
+	tcph = (struct tcphdr *)skb_put(nskb, sizeof(struct tcphdr));
+	memset(tcph, 0, sizeof(*tcph));
+	tcph->source	= oth->dest;
+	tcph->dest	= oth->source;
+	tcph->doff	= sizeof(struct tcphdr) / 4;
+
+	if (oth->ack)
 		tcph->seq = oth->ack_seq;
-		tcph->ack_seq = 0;
-	} else {
-		needs_ack = 1;
+	else {
 		tcph->ack_seq = htonl(ntohl(oth->seq) + oth->syn + oth->fin +
 				      oldskb->len - ip_hdrlen(oldskb) -
 				      (oth->doff << 2));
-		tcph->seq = 0;
+		tcph->ack = 1;
 	}
 
-	/* Reset flags */
-	((u_int8_t *)tcph)[13] = 0;
-	tcph->rst = 1;
-	tcph->ack = needs_ack;
-
-	tcph->window = 0;
-	tcph->urg_ptr = 0;
-
-	/* Adjust TCP checksum */
-	tcph->check = 0;
-	tcph->check = tcp_v4_check(sizeof(struct tcphdr),
-				   niph->saddr, niph->daddr,
-				   csum_partial(tcph,
-						sizeof(struct tcphdr), 0));
-
-	/* Set DF, id = 0 */
-	niph->frag_off = htons(IP_DF);
-	niph->id = 0;
+	tcph->rst	= 1;
+	tcph->check	= tcp_v4_check(sizeof(struct tcphdr),
+				       niph->saddr, niph->daddr,
+				       csum_partial(tcph,
+						    sizeof(struct tcphdr), 0));
 
 	addr_type = RTN_UNSPEC;
 	if (hook != NF_INET_FORWARD
@@ -130,14 +105,16 @@ static void send_reset(struct sk_buff *oldskb, int hook)
 	   )
 		addr_type = RTN_LOCAL;
 
+	/* ip_route_me_harder expects skb->dst to be set */
+	dst_hold(oldskb->dst);
+	nskb->dst = oldskb->dst;
+
 	if (ip_route_me_harder(nskb, addr_type))
 		goto free_nskb;
 
+	niph->ttl	= dst_metric(nskb->dst, RTAX_HOPLIMIT);
 	nskb->ip_summed = CHECKSUM_NONE;
 
-	/* Adjust IP TTL */
-	niph->ttl = dst_metric(nskb->dst, RTAX_HOPLIMIT);
-
 	/* "Never happens" */
 	if (nskb->len > dst_mtu(nskb->dst))
 		goto free_nskb;
@@ -163,11 +140,6 @@ reject_tg(struct sk_buff *skb, const struct net_device *in,
 {
 	const struct ipt_reject_info *reject = targinfo;
 
-	/* Our naive response construction doesn't deal with IP
-	   options, and probably shouldn't try. */
-	if (ip_hdrlen(skb) != sizeof(struct iphdr))
-		return NF_DROP;
-
 	/* WARNING: This code causes reentry within iptables.
 	   This means that the iptables jump stack is now crap.  We
 	   must return an absolute verdict. --RR */
