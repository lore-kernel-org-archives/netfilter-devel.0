From: Patrick McHardy <kaber@trash.net>
Subject: Re: skb_ip_make_writable and skbs not owned by a socket
Date: Thu, 27 Jan 2005 05:10:42 +0100
Message-ID: <41F869C2.5030800@trash.net>
References: <41D86571.6070501@trash.net>	<20050113213122.7e70c3c2.davem@davemloft.net>	<41E75FA4.907@trash.net>
	<20050117135029.04e6580f.davem@davemloft.net>
	<41EC469F.6010605@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090105060008060809000209"
Cc: jamal <hadi@cyberus.ca>, rusty@rustcorp.com.au,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <41EC469F.6010605@trash.net>
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
--------------090105060008060809000209
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Dave, could you please have another look at this ? I think the patch is
correct, and even necessary to make the ipt action work with targets
that mangle the data area. Jamal asked me to put back the pskb_expand_head
call in the ipt action, so iptables won't see cloned skbs and copy them
(actions must not replace the skb), but the protocol-dependant cases
in skb_ip_make_writable can cause copying anyway. I think you missed
my reply to your last mail, please see below.

Thanks,
Patrick

Patrick McHardy wrote:

> David S. Miller wrote:
>
>> This code is doing something different.  Even if we unclone and
>> unshare the SKB, the packet header portion can still be non-linear.
>>
>> It will be possible for devices to create this situation on receive.
>> That's why we have all the pskb_may_pull() checks in all the major
>> ipv4 protocol input paths.
>>
> The patch already calls pskb_may_pull for unshared/uncloned skbs, so it
> linearizes them up to the requested size. It just replaces skb_copy by
> pskb_may_pull when the data area of unshared/uncloned skbs needs to be
> mangled.
>
> Regards
> Patrick
>
>


--------------090105060008060809000209
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

--------------090105060008060809000209--
