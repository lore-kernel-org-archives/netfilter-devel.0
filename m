From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [PATCH] Add bridged IPv6 packet filtering
Date: Thu, 2 Sep 2004 23:46:13 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <200409022346.13288.bdschuym@pandora.be>
References: <200409012234.26310.bdschuym@pandora.be>
	<Pine.LNX.4.61.0409021029460.17962@filer.marasystems.com>
	<200409021523.i82FNdsY015603@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: davem@redhat.com, netfilter-devel@lists.netfilter.org,
	usagi-core@linux-ipv6.org, yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>,
	hno@marasystems.com
In-Reply-To: <200409021523.i82FNdsY015603@toshiba.co.jp>
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Thursday 02 September 2004 17:23, Yasuyuki Kozakai wrote:
> > On Thu, 2 Sep 2004, Yasuyuki Kozakai wrote:
> > > You forgot to find "Jumbo Payload Option" in Hop-by-Hop Options header.
> > > Other options may exist in this header.
> > >
> > > And please truncate packet if actual packet length is greater than
> > > Jumbo Payload Length + IPv6 header length.

The incremental patch below introduces this.

> > Hmm.. a bridge should not touch the packet content unless absolutely
> > needed to fulfill the Ethernet requirements. Why should it do this on
> > IPv6?
>
> Hmm... Indeed, I don't want br_netfilter to change the packet size when
> just loading it...

I'd prefer just doing the truncate. bridge-nf has been doing it for IPv4
for almost 2 years now in the 2.5/2.6 kernel.

> Maybe alternatives are as follows.
>
> 	1. drop such packets. This approach is not different with truncating
> 	   in that output is not same as input when loading it.

Easily done if this is preferred over the truncate.

> 	2. change netfilter modules to use payload length in
> 	   IPv4 header/IPv6 header/Jumbogram option. Maybe many changes are
> 	   necessary...

I don't like this approach and I think the netfilter guys will agree.

> 	3. Just trust skb->len even if it doesn't consist with payload length
> 	   in the headers. I'm not sure what happens in this case. At least,
> 	   we have to be careful not to bring kernel panic and so on.
> 	   The advantage of this case is that user can select to drop/truncate
> 	   by inserting filtering rule.

I'm not in the mood to go through all the ip6tables modules :)

Dave, unless someone complains, please apply.

cheers,
Bart

PS: I noticed ipv6_hop_jumbo() doesn't check the return value
of __pskb_trim().

--- linux-2.6.8.1/net/bridge/br_netfilter.c.older	2004-09-02 22:07:36.000000000 +0200
+++ linux-2.6.8.1/net/bridge/br_netfilter.c	2004-09-02 23:26:11.000000000 +0200
@@ -290,6 +290,62 @@ static void setup_pre_routing(struct sk_
 	skb->dev = bridge_parent(skb->dev);
 }
 
+/* We only check the length. A bridge shouldn't do any hop-by-hop stuff anyway */
+static int check_hbh_len(struct sk_buff *skb)
+{
+	unsigned char *raw = (u8*)(skb->nh.ipv6h+1);
+	u32 pkt_len;
+	int off = raw - skb->nh.raw;
+	int len = (raw[1]+1)<<3;
+
+	if ((raw + len) - skb->data > skb_headlen(skb))
+		goto bad;
+
+	off += 2;
+	len -= 2;
+
+	while (len > 0) {
+		int optlen = raw[off+1]+2;
+
+		switch (skb->nh.raw[off]) {
+		case IPV6_TLV_PAD0:
+			optlen = 1;
+			break;
+
+		case IPV6_TLV_PADN:
+			break;
+
+		case IPV6_TLV_JUMBO:
+			if (skb->nh.raw[off+1] != 4 || (off&3) != 2)
+				goto bad;
+
+			pkt_len = ntohl(*(u32*)(skb->nh.raw+off+2));
+
+			if (pkt_len > skb->len - sizeof(struct ipv6hdr))
+				goto bad;
+			if (pkt_len + sizeof(struct ipv6hdr) < skb->len) {
+				if (__pskb_trim(skb,
+				    pkt_len + sizeof(struct ipv6hdr)))
+					goto bad;
+				if (skb->ip_summed == CHECKSUM_HW)
+					skb->ip_summed = CHECKSUM_NONE;
+			}
+			break;
+		default:
+			if (optlen > len)
+				goto bad;
+			break;
+		}
+		off += optlen;
+		len -= optlen;
+	}
+	if (len == 0)
+		return 0;
+bad:
+	return -1;
+
+}
+
 /* Replicate the checks that IPv6 does on packet reception and pass the packet
  * to ip6tables, which doesn't support NAT, so things are fairly simple. */
 static unsigned int br_nf_pre_routing_ipv6(unsigned int hook,
@@ -316,18 +372,16 @@ static unsigned int br_nf_pre_routing_ip
 	if (pkt_len || hdr->nexthdr != NEXTHDR_HOP) {
 		if (pkt_len + sizeof(struct ipv6hdr) > skb->len)
 			goto inhdr_error;
-		if (pkt_len + sizeof(struct ipv6hdr) < skb->len &&
-		    __pskb_trim(skb, pkt_len + sizeof(struct ipv6hdr)))
-			goto inhdr_error;
+		if (pkt_len + sizeof(struct ipv6hdr) < skb->len) {
+			if (__pskb_trim(skb, pkt_len + sizeof(struct ipv6hdr)))
+				goto inhdr_error;
+			if (skb->ip_summed == CHECKSUM_HW)
+				skb->ip_summed = CHECKSUM_NONE;
+		}
 	}
-	if (hdr->nexthdr == NEXTHDR_HOP) {
-		/* We only check the length. A bridge shouldn't do any
-		 * hop-by-hop stuff anyway. */
-		unsigned char *raw = (u8*)(skb->nh.ipv6h+1);
-
-		if ((raw + ((int)(raw[1]+1)<<3)) - skb->data > skb_headlen(skb))
+	if (hdr->nexthdr == NEXTHDR_HOP && check_hbh_len(skb))
 			goto inhdr_error;
-	}
+
 #ifdef CONFIG_NETFILTER_DEBUG
 	skb->nf_debug ^= (1 << NF_IP6_PRE_ROUTING);
 #endif
