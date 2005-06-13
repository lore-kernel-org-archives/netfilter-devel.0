From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH NF_CONNTRACK 6/9]: Drop conntrack reference when packet
 leaves IPv6
Date: Mon, 13 Jun 2005 09:58:26 +0900 (JST)
Message-ID: <200506130058.j5D0wRYB007713@toshiba.co.jp>
References: <200505230620.j4N6KAve018200@toshiba.co.jp>
	<42AB0452.3010703@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <42AB0452.3010703@trash.net>
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

From: Patrick McHardy <kaber@trash.net>
Date: Sat, 11 Jun 2005 17:33:38 +0200

> Yasuyuki KOZAKAI wrote:
> > This patch is for IPv6 and same change as follows.
> 
> Why not simply drop the reference earlier in ip6_input_finish()
> before the packet is delivered to raw sockets?

Because IPv6 packets with routing header are forward at ipv6_rthdr_rcv()
called in ip6_input_finish().

Regards,

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

> 
> Regards
> Patrick
> 
> > diff -Nur linux-2.6.12-rc4-nfct-5-drop-ref/net/ipv6/ip6_input.c linux-2.6.12-rc4-nfct-6-drop-ref6/net/ipv6/ip6_input.c
> > --- linux-2.6.12-rc4-nfct-5-drop-ref/net/ipv6/ip6_input.c	2005-05-20 03:29:38.000000000 +0900
> > +++ linux-2.6.12-rc4-nfct-6-drop-ref6/net/ipv6/ip6_input.c	2005-05-19 21:28:26.000000000 +0900
> > @@ -176,6 +176,11 @@
> >  		if (ipprot->flags & INET6_PROTO_FINAL) {
> >  			struct ipv6hdr *hdr;	
> >  
> > +			/* Free reference early: we don't need it any more,
> > +			   and it may hold ip_conntrack module loaded
> > +			   indefinitely. */
> > +			nf_reset(skb);
> > +
> >  			skb_postpull_rcsum(skb, skb->nh.raw,
> >  					   skb->h.raw - skb->nh.raw);
> >  			hdr = skb->nh.ipv6h;
> > diff -Nur linux-2.6.12-rc4-nfct-5-drop-ref/net/ipv6/raw.c linux-2.6.12-rc4-nfct-6-drop-ref6/net/ipv6/raw.c
> > --- linux-2.6.12-rc4-nfct-5-drop-ref/net/ipv6/raw.c	2005-05-20 03:29:46.000000000 +0900
> > +++ linux-2.6.12-rc4-nfct-6-drop-ref6/net/ipv6/raw.c	2005-05-19 21:51:35.000000000 +0900
> > @@ -167,8 +167,10 @@
> >  			struct sk_buff *clone = skb_clone(skb, GFP_ATOMIC);
> >  
> >  			/* Not releasing hash table! */
> > -			if (clone)
> > +			if (clone) {
> > +				nf_reset(clone);
> >  				rawv6_rcv(sk, clone);
> > +			}
> >  		}
> >  		sk = __raw_v6_lookup(sk_next(sk), nexthdr, daddr, saddr);
> >  	}
> 
