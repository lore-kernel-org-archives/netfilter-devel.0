From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH] remove overzealous checks in REJECT target
Date: Thu, 02 Dec 2004 15:17:06 +0900 (JST)
Message-ID: <200412020617.iB26H6ut018405@toshiba.co.jp>
References: <41AD67A3.6090608@gmx.net>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Thu_Dec__2_15:17:06_2004_044)--"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: c-d.hailfinger.kernel.2004@gmx.net
In-Reply-To: <41AD67A3.6090608@gmx.net>
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

----Next_Part(Thu_Dec__2_15:17:06_2004_044)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Hi,

I think so. This check isn't needed.

And I found strange codes after this check: directly access to the data
in skb.h and overwriting ICMP header with same data.

I think we should use skb_header_pointer() to get UDP/ICMP header.

Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

From: Carl-Daniel Hailfinger <c-d.hailfinger.kernel.2004@gmx.net>
Date: Wed, 01 Dec 2004 07:41:39 +0100

> Hi,
> 
> after wondering why the REJECT target didn't work as expected
> when scanned with nmap -sO, I found a check in ipt_REJECT.c
> for 8 or more bytes of proto header which caused all packets
> gernated by nmap to be dropped although they were sent to the
> REJECT target. Since I could not see any use for the proto
> header length check, I replaced it with a warning.
> Now the REJECT target works as expected for all packets I
> could thow at it.
> 
> Regards,
> Carl-Daniel
> -- 
> http://www.hailfinger.org/
> 
> Signed-off-by Carl-Daniel Hailfinger <c-d.hailfinger.kernel.2004@gmx.net>
> --- linux-2.6.9/net/ipv4/netfilter/ipt_REJECT.c~	Wed Dec  1 06:38:06 2004
> +++ linux-2.6.9/net/ipv4/netfilter/ipt_REJECT.c	Wed Dec  1 06:41:04 2004
> @@ -255,7 +255,7 @@ static void send_unreach(struct sk_buff
> 
>  	/* Ensure we have at least 8 bytes of proto header. */
>  	if (skb_in->len < skb_in->nh.iph->ihl*4 + 8)
> -		return;
> +		printk("REJECT: we have less than 8 bytes of proto header.\n");
> 
>  	/* if UDP checksum is set, verify it's correct */
>  	if (iph->protocol == IPPROTO_UDP
> 
> 
> 

----Next_Part(Thu_Dec__2_15:17:06_2004_044)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="ipt_reject.patch"

--- linux-2.6.10-rc2-rc2-bk13/net/ipv4/netfilter/ipt_REJECT.c	2004-12-02 11:45:28.000000000 +0900
+++ linux-2.6.10-rc2-rc2-bk13-reject/net/ipv4/netfilter/ipt_REJECT.c	2004-12-02 14:47:17.245615416 +0900
@@ -223,8 +223,8 @@
 static void send_unreach(struct sk_buff *skb_in, int code)
 {
 	struct iphdr *iph;
-	struct udphdr *udph;
-	struct icmphdr *icmph;
+	struct udphdr *udph, _udph;
+	struct icmphdr *icmph, _icmph;
 	struct sk_buff *nskb;
 	u32 saddr;
 	u8 tos;
@@ -253,40 +253,37 @@
 	if (iph->frag_off&htons(IP_OFFSET))
 		return;
 
-	/* Ensure we have at least 8 bytes of proto header. */
-	if (skb_in->len < skb_in->nh.iph->ihl*4 + 8)
-		return;
-
 	/* if UDP checksum is set, verify it's correct */
-	if (iph->protocol == IPPROTO_UDP
-	    && skb_in->tail-(u8*)iph >= sizeof(struct udphdr)) {
-		int datalen = skb_in->len - (iph->ihl<<2);
-		udph = (struct udphdr *)((char *)iph + (iph->ihl<<2));
-		if (udph->check
+	if (iph->protocol == IPPROTO_UDP) {
+		int udphoff = ((u8*)iph - skb_in->data) + (iph->ihl << 2);
+		int datalen = skb_in->len - udphoff;
+
+		udph = skb_header_pointer(skb_in, udphoff,
+					  sizeof(struct udphdr), &_udph);
+
+		if (udph && udph->check
 		    && csum_tcpudp_magic(iph->saddr, iph->daddr,
 		                         datalen, IPPROTO_UDP,
-		                         csum_partial((char *)udph, datalen,
-		                                      0)) != 0)
+					 skb_checksum(skb_in, udphoff, datalen,
+						      0)) != 0)
 			return;
 	}
 
 	/* If we send an ICMP error to an ICMP error a mess would result.. */
-	if (iph->protocol == IPPROTO_ICMP
-	    && skb_in->tail-(u8*)iph >= sizeof(struct icmphdr)) {
-		icmph = (struct icmphdr *)((char *)iph + (iph->ihl<<2));
-
-		if (skb_copy_bits(skb_in, skb_in->nh.iph->ihl*4,
-				  icmph, sizeof(*icmph)) < 0)
-			return;
+	if (iph->protocol == IPPROTO_ICMP) {
+		icmph = skb_header_pointer(skb_in, iph->ihl<<2,
+					   sizeof(struct icmphdr),
+					   &_icmph);
 
 		/* Between echo-reply (0) and timestamp (13),
 		   everything except echo-request (8) is an error.
 		   Also, anything greater than NR_ICMP_TYPES is
 		   unknown, and hence should be treated as an error... */
-		if ((icmph->type < ICMP_TIMESTAMP
-		     && icmph->type != ICMP_ECHOREPLY
-		     && icmph->type != ICMP_ECHO)
-		    || icmph->type > NR_ICMP_TYPES)
+		if (icmph &&
+		    ((icmph->type < ICMP_TIMESTAMP
+		      && icmph->type != ICMP_ECHOREPLY
+		      && icmph->type != ICMP_ECHO)
+		     || icmph->type > NR_ICMP_TYPES))
 			return;
 	}
 

----Next_Part(Thu_Dec__2_15:17:06_2004_044)----
