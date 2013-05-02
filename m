From: "Anders K. Pedersen | Surftown" <akp@surftown.com>
Subject: Re: [PATCH V2] netfilter: ipset: support package fragments for
 IPv4 protos without ports
Date: Thu, 02 May 2013 13:48:31 +0200
Message-ID: <1367495311.17468.210.camel@homer.cohaesio.com>
References: <20130428100936.60D0815759E@homer.localdomain>
	 <alpine.DEB.2.00.1304301017430.20765@blackhole.kfki.hu>
	 <1367431355.17468.193.camel@homer.cohaesio.com>
	 <20130501222316.GA4606@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bender.cohaesio.com ([212.97.128.130]:34410 "EHLO
	mail.cohaesio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab3EBLse (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 May 2013 07:48:34 -0400
In-Reply-To: <20130501222316.GA4606@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 2013-05-02 at 00:23 +0200, Pablo Neira Ayuso wrote:
> On Wed, May 01, 2013 at 08:02:35PM +0200, Anders K. Pedersen | Surftown wrote:
> > +	if (ntohs(iph->frag_off) & IP_OFFSET)
> > +		switch (protocol) {
> > +		case IPPROTO_TCP:
> > +		case IPPROTO_SCTP:
> > +		case IPPROTO_UDP:
> > +		case IPPROTO_UDPLITE:
> > +		case IPPROTO_ICMP:
> > +			/* Port info not available for fragment offset > 0 */
> > +			return false;
> 
> You can probably use proto_ports_offset for this?

I'm not sure that is a good idea. The protocols in proto_ports_offset()
doesn't match what ipset supports:

static inline int proto_ports_offset(int proto)
{
	switch (proto) {
	case IPPROTO_TCP:
	case IPPROTO_UDP:
	case IPPROTO_DCCP:
	case IPPROTO_ESP:	/* SPI */
	case IPPROTO_SCTP:
	case IPPROTO_UDPLITE:
		return 0;
	case IPPROTO_AH:	/* SPI */
		return 4;
	default:
		return -EINVAL;
	}
}

Ports for DCCP, ESP, and AH aren't supported by ipset. I could add that
support, but I don't think it makes sense for ipset to match on SPI for
ESP and AH?

-- 
Venlig hilsen / Best Regards 

Anders K. Pedersen 
Surftown A/S

