From: Patrick McHardy <kaber@trash.net>
Subject: Re: skb_ip_make_writable and skbs not owned by a socket
Date: Mon, 03 Jan 2005 02:53:13 +0100
Message-ID: <41D8A589.9090802@trash.net>
References: <41D86571.6070501@trash.net>	<20050102235757.GA26856@postel.suug.ch>
	<41D8A1A3.3060308@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040207050508030705000500"
Cc: "David S. Miller" <davem@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
	Jamal Hadi Salim <hadi@cyberus.ca>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Thomas Graf <tgraf@suug.ch>
In-Reply-To: <41D8A1A3.3060308@trash.net>
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
--------------040207050508030705000500
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:

> A different question is why we can't simply do this:
>
> (cut-n-paste, I would cut at least one goto in a patch)
>
> int skb_ip_make_writable(struct sk_buff **pskb, unsigned int 
> writable_len)
> {
>        struct sk_buff *nskb;
>
>        if (writable_len > (*pskb)->len)
>                return 0;
>
>        /* Not exclusive use of packet?  Must copy. */
>        if (skb_shared(*pskb) || skb_cloned(*pskb))
>                goto copy_skb;
>
>        if (skb_headlen(skb) <= writable_len)
>                return 1;

This should have been >=, but is not necessary anyway, pskb_may_pull
already does the same test. Real patch attached.



--------------040207050508030705000500
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

--------------040207050508030705000500--
