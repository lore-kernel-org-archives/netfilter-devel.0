From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 1/18] netfilter: ipt_REJECT Target nonlinear fixes
Date: Wed, 05 Jan 2005 14:05:57 +1100
Message-ID: <1104894357.20582.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Linus Torvalds <torvalds@osdl.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[ Dave is away, but I want these to get a reasonable amount of testing
before 2.6.11, so sent straight to Linus ]

Name: ipt_REJECT Target nonlinear fixes
Status: Tested under valgrind
Signed-off-by: Rusty Russell

nfsim now generates non-linear packets: when run under valgrind it
finds linear assumptions very nicely.  This is the second thing I
tried, and it found a real bug.

In this case, checking the UDP checksum is correct, but overkill, and
like the ICMP header handling, does not handle non-linear packets.  Remove UDP
checksum, fix ICMP error.

Index: linux-2.6.10-bk1-Netfilter/net/ipv4/netfilter/ipt_REJECT.c
===================================================================
--- linux-2.6.10-bk1-Netfilter.orig/net/ipv4/netfilter/ipt_REJECT.c	2005-01-04 14:55:59.721943664 +1100
+++ linux-2.6.10-bk1-Netfilter/net/ipv4/netfilter/ipt_REJECT.c	2005-01-04 14:56:44.538130568 +1100
@@ -223,7 +223,6 @@
 static void send_unreach(struct sk_buff *skb_in, int code)
 {
 	struct iphdr *iph;
-	struct udphdr *udph;
 	struct icmphdr *icmph;
 	struct sk_buff *nskb;
 	u32 saddr;
@@ -257,26 +256,13 @@
 	if (skb_in->len < skb_in->nh.iph->ihl*4 + 8)
 		return;
 
-	/* if UDP checksum is set, verify it's correct */
-	if (iph->protocol == IPPROTO_UDP
-	    && skb_in->tail-(u8*)iph >= sizeof(struct udphdr)) {
-		int datalen = skb_in->len - (iph->ihl<<2);
-		udph = (struct udphdr *)((char *)iph + (iph->ihl<<2));
-		if (udph->check
-		    && csum_tcpudp_magic(iph->saddr, iph->daddr,
-		                         datalen, IPPROTO_UDP,
-		                         csum_partial((char *)udph, datalen,
-		                                      0)) != 0)
-			return;
-	}
-
 	/* If we send an ICMP error to an ICMP error a mess would result.. */
-	if (iph->protocol == IPPROTO_ICMP
-	    && skb_in->tail-(u8*)iph >= sizeof(struct icmphdr)) {
-		icmph = (struct icmphdr *)((char *)iph + (iph->ihl<<2));
+	if (iph->protocol == IPPROTO_ICMP) {
+		struct icmphdr ihdr;
 
-		if (skb_copy_bits(skb_in, skb_in->nh.iph->ihl*4,
-				  icmph, sizeof(*icmph)) < 0)
+		icmph = skb_header_pointer(skb_in, skb_in->nh.iph->ihl*4,
+					   sizeof(ihdr), &ihdr);
+		if (!icmph)
 			return;
 
 		/* Between echo-reply (0) and timestamp (13),

-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
