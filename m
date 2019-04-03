Return-Path: <SRS0=21Bs=SF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09CAAC4360F
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Apr 2019 21:18:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA03D206B8
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Apr 2019 21:18:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbfDCVST (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Apr 2019 17:18:19 -0400
Received: from ja.ssi.bg ([178.16.129.10]:46482 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726167AbfDCVST (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Apr 2019 17:18:19 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id x33LI8WY006133;
        Thu, 4 Apr 2019 00:18:08 +0300
Date:   Thu, 4 Apr 2019 00:18:08 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Simon Horman <horms@verge.net.au>
cc:     lvs-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Jacky Hu <hengqing.hu@gmail.com>,
        jacky.hu@walmart.com, jason.niesz@walmart.com
Subject: Re: [PATCH net-next 3/3] ipvs: strip udp tunnel headers from icmp
 errors
In-Reply-To: <20190403081511.ltjmuudpxdz3xxmf@verge.net.au>
Message-ID: <alpine.LFD.2.21.1904032352530.3584@ja.home.ssi.bg>
References: <20190331102621.7460-1-ja@ssi.bg> <20190331102621.7460-4-ja@ssi.bg> <20190403081511.ltjmuudpxdz3xxmf@verge.net.au>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


	Hello,

On Wed, 3 Apr 2019, Simon Horman wrote:

> On Sun, Mar 31, 2019 at 01:26:21PM +0300, Julian Anastasov wrote:
> > Recognize UDP tunnels in received ICMP errors and
> > properly strip the tunnel headers. GUE is what we
> > have for now.
> > 
> > Signed-off-by: Julian Anastasov <ja@ssi.bg>
> > ---
> >  net/netfilter/ipvs/ip_vs_core.c | 58 +++++++++++++++++++++++++++++++++
> >  1 file changed, 58 insertions(+)
> > 
> > diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
> > index 4447ee512b88..0b624e8e7982 100644
> > --- a/net/netfilter/ipvs/ip_vs_core.c
> > +++ b/net/netfilter/ipvs/ip_vs_core.c
> > @@ -39,6 +39,7 @@
> >  #include <net/tcp.h>
> >  #include <net/udp.h>
> >  #include <net/icmp.h>                   /* for icmp_send */
> > +#include <net/gue.h>
> >  #include <net/route.h>
> >  #include <net/ip6_checksum.h>
> >  #include <net/netns/generic.h>		/* net_generic() */
> > @@ -1579,6 +1580,34 @@ ip_vs_try_to_schedule(struct netns_ipvs *ipvs, int af, struct sk_buff *skb,
> >  	return 1;
> >  }
> >  
> > +/* Check the UDP tunnel and return its header length */
> > +static int ipvs_udp_decap(struct netns_ipvs *ipvs, struct sk_buff *skb,
> > +			  unsigned int offset, __u16 af, __be16 dport,
> > +			  const union nf_inet_addr *daddr, __u8 *proto)
> > +{
> > +	struct ip_vs_dest *dest = ip_vs_find_tunnel(ipvs, af, daddr, dport);
> > +
> > +	if (!dest)
> > +		goto unk;
> > +	if (dest->tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GUE) {
> > +		struct guehdr _gueh, *gueh;
> > +
> > +		gueh = skb_header_pointer(skb, offset, sizeof(_gueh), &_gueh);
> > +		if (!gueh)
> > +			goto unk;
> > +		if (gueh->control != 0 || gueh->version != 0)
> > +			goto unk;
> > +		/* Later we can support also IPPROTO_IPV6 */
> > +		if (gueh->proto_ctype != IPPROTO_IPIP)
> > +			goto unk;
> > +		*proto = gueh->proto_ctype;
> > +		return sizeof(struct guehdr) + (gueh->hlen << 2);
> 
> I think that the gue-specific portions of the above, which is most of
> ipvs_udp_decap() should be a separate helper which is part of net/gue.h or
> net/ipv4/fou.c - this seems to be a subset of the logic in gue_udp_recv().

	Yes but fou.c strips the headers in all cases while
in IPVS we should do it only when connection is found because
we do not want to mess with non-IPVS traffic.

> 
> > +	}
> > +
> > +unk:
> > +	return -1;
> > +}
> > +
> >  /*
> >   *	Handle ICMP messages in the outside-to-inside direction (incoming).
> >   *	Find any that might be relevant, check against existing connections,
> > @@ -1658,8 +1687,37 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
> >  		if (cih == NULL)
> >  			return NF_ACCEPT; /* The packet looks wrong, ignore */
> >  		ipip = true;
> > +	} else if (cih->protocol == IPPROTO_UDP) {	/* Can be UDP encap */
> 
> Can we consider factoring out the logic in this else-if clause
> out into a function to avoid the use of goto?

	We can even safely return NF_ACCEPT instead of the goto

> 
> > +		struct udphdr _udph, *udph;
> > +		__u8 iproto;
> > +		int ulen;
> > +
> > +		if (unlikely(cih->frag_off & htons(IP_OFFSET)))
> > +			return NF_ACCEPT;
> 
> I think a comment is warranted regarding the behaviour implemented
> for fragments.

	I'll add in v2.

> 
> > +		/* Error for our tunnel must arrive at LOCAL_IN */
> > +		if (!(skb_rtable(skb)->rt_flags & RTCF_LOCAL))
> > +			return NF_ACCEPT;
> > +		offset2 = offset + cih->ihl * 4;
> > +		udph = skb_header_pointer(skb, offset2, sizeof(_udph), &_udph);
> > +		if (!udph)
> > +			goto check;
> 
> > +		offset2 += sizeof(struct udphdr);
> > +		ulen = ipvs_udp_decap(ipvs, skb, offset2, AF_INET, udph->dest,
> > +				      raddr, &iproto);
> > +		if (ulen < 0)
> > +			goto check;
> > +		/* Skip IP + UDP + ulen */
> > +		offset = offset2 + ulen;
> > +		/* Now we should be at the original IP header */
> > +		cih = skb_header_pointer(skb, offset, sizeof(_ciph), &_ciph);
> > +		if (cih && cih->version == 4 && cih->ihl >= 5 &&
> > +		    iproto == IPPROTO_IPIP)
> > +			ipip = true;
> > +		else
> > +			return NF_ACCEPT;
> 
> Skipping over tunnel headers and determining the inner IP protocol really
> feels like something that should be handled code common to other UDP
> encapsulation implementations.

	We can easily add simple FOU in ipvs_udp_decap() by
returning 0 and correct *proto. Or you prefer to use common
code from other files to parse the headers? Currently, there
is no any GUE func that can be used for this.

Regards

--
Julian Anastasov <ja@ssi.bg>
