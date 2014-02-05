From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter: REJECT: separate reusable code
Date: Wed, 5 Feb 2014 12:04:45 +0000
Message-ID: <20140205120445.GC27444@macbook.localnet>
References: <20140205102547.GA20930@macbook.localnet>
 <20140205104247.GA4458@localhost>
 <20140205105348.GB21355@macbook.localnet>
 <20140205111713.GB4660@localhost>
 <CAOkSjBgmrx3tqDxpa0JdW84UvU6QrGe5b2ieT6xuvcW2c+XDqg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Eric Leblond <eric@regit.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56258 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbaBEMEt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Feb 2014 07:04:49 -0500
Content-Disposition: inline
In-Reply-To: <CAOkSjBgmrx3tqDxpa0JdW84UvU6QrGe5b2ieT6xuvcW2c+XDqg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 05, 2014 at 12:49:01PM +0100, Arturo Borrero Gonzalez wrote:
> On 5 February 2014 12:17, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >>
> >> I guess an NFPROTO_INET specific reject module that dispatches to
> >> the IPv4 and IPv6 versions is the only possibility unless we want
> >> to add restrictions (which I don't).
> >
> > I think that, once the infrastructure to provide expressions per
> > family in place, a specific reject for inet is a good idea. It can
> > reply depending on the packet family that it sees at _eval(...). I
> > don't have any better idea on how to handle this case.
> 
> Just wondering if this idea could be reused to allow nft_payload to
> fetch ip src/dst in a family independent way, so we can have dual
> stacked rules of this kind:
> 
> nft add rule inet filter input ip daddr www.example.com accept
> 
> or maybe:
> 
> nft add rule inet filter input ip daddr { 1.1.1.1 : accept , ::1 : accept }

Nope, ip daddr implies meta nfproto == NFPROTO_IPV4. Also we have a length
in the payload instruction. We might be able to do something by mapping
IPv4 addresses into IPv6 address space.
