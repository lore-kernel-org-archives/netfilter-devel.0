From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf-next 3/6] netfilter: nf_tables: disable old tracing if
 listener is present
Date: Wed, 25 Nov 2015 16:34:58 +0000
Message-ID: <20151125163457.GA30712@macbook.localdomain>
References: <20151124103938.GB3014@salvia>
 <20151124105300.GK2310@macbook.localdomain>
 <20151124111029.GH1740@breakpoint.cc>
 <20151124113341.GO2310@macbook.localdomain>
 <20151124151542.GA20972@breakpoint.cc>
 <20151124152649.GK14478@macbook.localdomain>
 <20151124153550.GC20972@breakpoint.cc>
 <20151124154241.GL14478@macbook.localdomain>
 <20151125150640.GE18449@macbook.localdomain>
 <20151125162342.GA4051@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:58693 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752503AbbKYQfD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Nov 2015 11:35:03 -0500
Content-Disposition: inline
In-Reply-To: <20151125162342.GA4051@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 25.11, Pablo Neira Ayuso wrote:
> On Wed, Nov 25, 2015 at 03:06:40PM +0000, Patrick McHardy wrote:
> > @@ -698,6 +703,10 @@ const struct proto_desc proto_arp = {
> >  		[ARPHDR_HLN]		= ARPHDR_FIELD("hlen", ar_hln),
> >  		[ARPHDR_PLN]		= ARPHDR_FIELD("plen", ar_pln),
> >  		[ARPHDR_OP]		= ARPHDR_TYPE("operation", &arpop_type, ar_op),
> > +		[ARPHDR_SHA]		= PROTO_HDR_TEMPLATE("sha", &etheraddr_type, BYTEORDER_BIG_ENDIAN, 8 * BITS_PER_BYTE, 6 * BITS_PER_BYTE),
> > +		[ARPHDR_SPA]		= PROTO_HDR_TEMPLATE("sip", &ipaddr_type, BYTEORDER_BIG_ENDIAN, 14 * BITS_PER_BYTE, 4 * BITS_PER_BYTE),
> > +		[ARPHDR_THA]		= PROTO_HDR_TEMPLATE("tha", &etheraddr_type, BYTEORDER_BIG_ENDIAN, 18 * BITS_PER_BYTE, 6 * BITS_PER_BYTE),
> > +		[ARPHDR_TPA]		= PROTO_HDR_TEMPLATE("tip", &ipaddr_type, BYTEORDER_BIG_ENDIAN, 24 * BITS_PER_BYTE, 4 * BITS_PER_BYTE),
> >  	},
> >  };
> >  
> 
> Could you also push this chunk into the repository?
> 
> I have a similar patch here for this. Given that we only support ARP
> for IPv4, we don't have to worry about the variable length offset in
> this case.

Sure. So far I've only added the decoding part, so the parser has no way
to support this yet. The symbol names are quite ugly, any ideas for nicer
ones?

Cheers,
Patrick
