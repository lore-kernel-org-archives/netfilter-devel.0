From: Patrick McHardy <kaber@trash.net>
Subject: Re: skb_ip_make_writable and skbs not owned by a socket
Date: Fri, 14 Jan 2005 06:59:00 +0100
Message-ID: <41E75FA4.907@trash.net>
References: <41D86571.6070501@trash.net>
	<20050113213122.7e70c3c2.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040506090002020209080503"
Cc: rusty@rustcorp.com.au, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20050113213122.7e70c3c2.davem@davemloft.net>
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

This is a multi-part message in MIME format.
--------------040506090002020209080503
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

David S. Miller wrote:

>On Sun, 02 Jan 2005 22:19:45 +0100
>Patrick McHardy <kaber@trash.net> wrote:
>
>  
>
>>skb_ip_make_writable copies the packet as soon as the data area needs
>>to be touched. This is of course necessary for packets generated locally,
>>but can't we mangle the data area of skbs with skb->sk == NULL without
>>copying them ?
>>    
>>
>
>Not if they are cloned.  tcpdump can still share access to the
>packet.
>
>  
>
I wasn't very clear in my question, it only makes sense if you look at
skb_ip_make_writable :) It already checks for skb_shared || skb_cloned
to decide when to copy, but additionally makes some guesses based on the
protocol. I think the checks for skb_shared || skb_clones should already
catch all cases where copying is necessary, and the additional cases
could be removed.

Regards
Patrick


--------------040506090002020209080503
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

===== net/core/netfilter.c 1.37 vs edited =====
--- 1.37/net/core/netfilter.c	2004-11-13 14:41:07 +01:00
+++ edited/net/core/netfilter.c	2005-01-03 02:50:29 +01:00
@@ -678,7 +678,6 @@
 int skb_ip_make_writable(struct sk_buff **pskb, unsigned int writable_len)
 {
 	struct sk_buff *nskb;
-	unsigned int iplen;
 
 	if (writable_len > (*pskb)->len)
 		return 0;
@@ -687,35 +686,7 @@
 	if (skb_shared(*pskb) || skb_cloned(*pskb))
 		goto copy_skb;
 
-	/* Alexey says IP hdr is always modifiable and linear, so ok. */
-	if (writable_len <= (*pskb)->nh.iph->ihl*4)
-		return 1;
-
-	iplen = writable_len - (*pskb)->nh.iph->ihl*4;
-
-	/* DaveM says protocol headers are also modifiable. */
-	switch ((*pskb)->nh.iph->protocol) {
-	case IPPROTO_TCP: {
-		struct tcphdr _hdr, *hp;
-		hp = skb_header_pointer(*pskb, (*pskb)->nh.iph->ihl*4,
-					sizeof(_hdr), &_hdr);
-		if (hp == NULL)
-			goto copy_skb;
-		if (writable_len <= (*pskb)->nh.iph->ihl*4 + hp->doff*4)
-			goto pull_skb;
-		goto copy_skb;
-	}
-	case IPPROTO_UDP:
-		if (writable_len<=(*pskb)->nh.iph->ihl*4+sizeof(struct udphdr))
-			goto pull_skb;
-		goto copy_skb;
-	case IPPROTO_ICMP:
-		if (writable_len
-		    <= (*pskb)->nh.iph->ihl*4 + sizeof(struct icmphdr))
-			goto pull_skb;
-		goto copy_skb;
-	/* Insert other cases here as desired */
-	}
+	return pskb_may_pull(*pskb, writable_len);
 
 copy_skb:
 	nskb = skb_copy(*pskb, GFP_ATOMIC);
@@ -730,9 +701,6 @@
 	kfree_skb(*pskb);
 	*pskb = nskb;
 	return 1;
-
-pull_skb:
-	return pskb_may_pull(*pskb, writable_len);
 }
 EXPORT_SYMBOL(skb_ip_make_writable);
 #endif /*CONFIG_INET*/

--------------040506090002020209080503--
