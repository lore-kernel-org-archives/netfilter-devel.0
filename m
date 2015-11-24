From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH libnftnl 5/6] src: add trace infrastructure support
Date: Tue, 24 Nov 2015 14:53:11 +0000
Message-ID: <20151124145310.GJ14478@macbook.localdomain>
References: <1448359331-12692-1-git-send-email-fw@strlen.de>
 <1448359331-12692-6-git-send-email-fw@strlen.de>
 <20151124121621.GA14478@macbook.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:46509 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753535AbbKXOxP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2015 09:53:15 -0500
Content-Disposition: inline
In-Reply-To: <20151124121621.GA14478@macbook.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 24.11, Patrick McHardy wrote:
> On 24.11, Florian Westphal wrote:
> > +static int
> > +print_th(const struct nftnl_trace *t, char *buf, size_t size)
> > +{
> > +	uint8_t proto = nftnl_trace_get_u8(t, NFTNL_TRACE_TRANSPORT_PROTO);
> > +	int ret, len = size, offset = 0;
> > +	const struct udphdr *uh;
> > +	uint32_t plen;
> > +
> > +	ret = snprintf(buf+offset, len, " protocol %u", proto);
> > +
> > +	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> > +
> > +	switch (proto) {
> > +	case IPPROTO_DCCP:
> > +	case IPPROTO_SCTP:
> > +	case IPPROTO_TCP:
> > +	case IPPROTO_UDP:
> > +	case IPPROTO_UDPLITE:
> > +		break;
> > +	default:
> > +		return 0;
> > +	}
> > +
> > +	/* warning: only sport/dport are valid */
> > +	uh = nftnl_trace_get_data(t, NFTNL_TRACE_TRANSPORT_HEADER, &plen);
> > +	if (!uh)
> > +		return 0;
> > +
> > +	ret = snprintf(buf+offset, len, " sport %"PRIu16 " dport %"PRIu16,
> > +			ntohs(uh->uh_sport), ntohs(uh->uh_dport));
> > +
> > +	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> > +	return offset;
> > +}
> > + ...
> 
> Regarding this header decoding, a further upside of using nft would be that
> we can already fully decode all known headers based on our protocol descriptions
> in a generic fashion.
> 
> Basically we just splice off data from the beginning and feed it to payload
> expression decoding. That should result in a full decode of every protocol
> we support. Every improvement we will make there will automatically apply to
> decoding, like (I talked to Pablo about this for a couple of times) supporing
> encapsulated headers, like GRE/IPIP/... + inner headers.
> 
> Hope I can convince you of the upsides :)

I'm giving this a shot right now. Will let you know the result.
