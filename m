From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 2/4] ipset: add "inner" flag implementation
Date: Sun, 9 Jun 2013 10:54:20 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1306091010210.6943@blackhole.kfki.hu>
References: <51A54267.8050402-git-send-email-mr.dash.four@googlemail.com> <51A5482C.9020603@googlemail.com> <alpine.DEB.2.00.1306011129590.30306@blackhole.kfki.hu> <51B133C5.5020303@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Core Team <netfilter-devel@vger.kernel.org>
To: Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:44832 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165Ab3FIIyX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Jun 2013 04:54:23 -0400
In-Reply-To: <51B133C5.5020303@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 7 Jun 2013, Dash Four wrote:

> Jozsef Kadlecsik wrote:
> >  Also, I'd prefer a single new function (or two inline functions if their
> > size permits), which'd return the success code and in pointers the inner IP
> > header and
> > the offset to the header (for proto/ports). Read my comments below.
> >   
> It has to be 2 functions - one dealing with ipv4 headers and another
> implementing ipv6 header handling. Further comments and questions follow
> below.

I meant, similarly to ip_set_get_ip_port, which wraps around the two 
functions. So one exported function suffices.
 
> > > +static inline void
> > > +ip4inneraddrptr(const struct sk_buff *skb, bool src, __be32 *addr)
> > > +{
> > > +	struct iphdr _iph;
> > > +	struct icmphdr _icmph;
> > > +	u8 type;
> > > +	const struct iphdr *ih;
> > > +	const struct icmphdr *ich;
> > > +	static const size_t len = 8 + sizeof(struct iphdr);
> > >     
> > 
> > I don't like bare numbers as magic constants.
> >   
> That's the size of a "standard" header (the "magic" number 8 is also 
> used in ipv6_skip_exthdr as well). I can use some more meaningful 
> constant if you wish - let me know.

If it's the size of a structure, use a sizeof. (I don't like the number in 
ipv6_skip_exthdr either, but that's another thing.)
 
> > > +#define ip6_ext_hdr(hdr)  ((hdr == IPPROTO_HOPOPTS) || \
> > > +			   (hdr == IPPROTO_ROUTING) || \
> > > +			   (hdr == IPPROTO_FRAGMENT) || \
> > > +			   (hdr == IPPROTO_ESP) || \
> > > +			   (hdr == IPPROTO_AH) || \
> > > +			   (hdr == IPPROTO_NONE) || \
> > > +			   (hdr == IPPROTO_DSTOPTS))
> > > +static inline void
> > > +ip6inneraddrptr(const struct sk_buff *skb, bool src, struct in6_addr
> > > *addr)
> > > +{
> > > +	u8 type, currenthdr;
> > > +	bool fragment = false;
> > > +	unsigned int ptr, hdrlen = 0;
> > > +	struct ipv6hdr _ip6h;
> > > +	struct icmp6hdr _icmp6h;
> > > +	const struct ipv6hdr *ih;
> > > +	const struct icmp6hdr *ic;
> > > +
> > > +	ih = skb_header_pointer(skb, 0, sizeof(_ip6h), &_ip6h);
> > > +	if (ih == NULL)
> > > +		goto err;
> > > +
> > > +	ptr = sizeof(struct ipv6hdr);
> > > +	currenthdr = ih->nexthdr;
> > > +	while (currenthdr != NEXTHDR_NONE && ip6_ext_hdr(currenthdr)) {
> > > +		struct ipv6_opt_hdr _hdr;
> > > +		const struct ipv6_opt_hdr *hp;
> > > +
> > > +		hp = skb_header_pointer(skb, ptr, sizeof(_hdr), &_hdr);
> > > +		if (hp == NULL)
> > > +			goto err;
> > > +
> > > +		switch (currenthdr) {
> > > +		case IPPROTO_FRAGMENT: {
> > > +			struct frag_hdr _fhdr;
> > > +			const struct frag_hdr *fh;
> > > +
> > > +			fh = skb_header_pointer(skb, ptr, sizeof(_fhdr),
> > > +						&_fhdr);
> > > +			if (fh == NULL)
> > > +				goto err;
> > > +			if (ntohs(fh->frag_off) & 0xFFF8)
> > > +				fragment = true;
> > > +
> > > +			hdrlen = 8;
> > > +			break;
> > > +		}
> > > +		case IPPROTO_DSTOPTS:
> > > +		case IPPROTO_ROUTING:
> > > +		case IPPROTO_HOPOPTS:
> > > +			if (fragment)
> > > +				goto err;
> > > +
> > > +			hdrlen = ipv6_optlen(hp);
> > > +			break;
> > > +		case IPPROTO_AH:
> > > +			hdrlen = (hp->hdrlen+2)<<2;
> > > +			break;
> > > +		case IPPROTO_ESP:
> > > +		default:
> > > +			goto err;
> > > +		} /* switch IPPROTO */
> > > +
> > > +		currenthdr = hp->nexthdr;
> > > +		ptr += hdrlen;
> > > +	}
> > >     
> > 
> > The code segment above is the reimplementation of ipv6_skip_exthdr.
> >   
> No, not really. Even though there are similarities between the two 
> fucntions, there are 2 differences - one is that ipv6_skip_exthdr wasn't 
> dealing properly (from ipset's point of view) with fragments, "frag_off" 
> is not present in kernel versions < 3.3 and the other is that 
> ipv6_skip_exthdr doesn't return an error when either an unknown or ESP 
> header type is encountered ("case IPPROTO_ESP" and "default" above).

ipv6_skip_exthdr handles ESP as a normal protocol, stops processing there, 
so the called deals with it. Also, we must process (ignore) unknown 
extension headers, that's not an error condition.

Kernel versions before 3.3 are supported as is. I don't see the point in 
fixing ipv6_skip_exthdr just for ipset when the same function is used
"unpatched" in the kernel itself before 3.3.
 
> > These all can be replaced by a function which skips the external header and
> > points to the inner one, something like:
> > 
> > int
> > ipset_inner_header(const struct sk_buff *skb, u8 pf, u8 *offset,
> > 		   void *inner)
> > {
> > 	/* IPv4 */
> > 	...
> > 	/* IPv6 */
> > 	nexthdr = ipv6_hdr(skb)->nexthdr;
> > 	*offset = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr),
> > &nexthdr, &frag_off);
> > 	/* Validate offset and frag_off */
> > 	/* Check ICMPv6, update offset */
> > 	/* Copy inner IPv6 header to *inner by skb_header_pointer */
> > 
> > 	return success/error;
> > }
> >   
> IPv4 and IPv6 should be treated as separate cases, so I'll create two 
> separate functions for that.

That'd require two exported functions (check the allowed size for inline 
functions), and I'm unsure two exports will be accepted.

> One other thing - this type of operation is not going to be confined 
> just to ipset (I plan to do the same thing when submit the changes to 
> the AUDIT iptables target, which logs these attributes as well), so I am 
> thinking of offloading these two functions and moving everything to 
> ip[v6].h so that they can be used not just by ipset. What do you think?

You can put inline functions/macros into header files only and 
function size may block using inlined.

> > Current ip[46]addr[ptr] functions of course need to be modified to use the
> > IP header structures instead of the skbuff one.
> >   
> I am not sure there should be one function for this - IPv6 and IPv4 are two
> separate cases (what if I don't have IPv6 - the whole IPv6 code will never be
> executed/needed, so there isn't any reason to be there at all), so I think
> there should be two separate functions for these.

That can be solved by empty function definition. I mean, in the 
ipset_inner_header example above, the IPv4/IPv6 cases are handled in 
independent functions and the one for IPv6 is actually empty when there's 
no IPv6 enabled at all.
 
Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
