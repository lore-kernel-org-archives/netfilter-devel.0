From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH net-next,RFC 00/13] New fast forwarding path
Date: Sun, 17 Jun 2018 11:23:04 +0200
Message-ID: <20180617092304.fviy36bvgnhexwtb@gauss3.secunet.de>
References: <20180614141947.3580-1-pablo@netfilter.org>
 <20180614.101831.465275975690050595.davem@davemloft.net>
 <20180615061740.eqgr2iv722oydheb@gauss3.secunet.de>
 <8fd4ce02-6bf0-6bee-f8de-92c551881465@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: David Miller <davem@davemloft.net>, <pablo@netfilter.org>,
        <netfilter-devel@vger.kernel.org>, <netdev@vger.kernel.org>
To: Daniel Borkmann <daniel@iogearbox.net>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8fd4ce02-6bf0-6bee-f8de-92c551881465@iogearbox.net>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Daniel,

On Fri, Jun 15, 2018 at 03:22:24PM +0200, Daniel Borkmann wrote:
> Hi Steffen,
> 
> On 06/15/2018 08:17 AM, Steffen Klassert wrote:
> > 
> > I started with this last year because I wanted to improve
> > the IPsec (and UDP) forwarding path. Batching packets
> > at layer2  and send them directly to the output path
> > seemed to be a good method to improve this.
> > 
> > In particular, we need to do only one IPsec lookup
> > for the whole packet chain. So it relaxes the pain
> > from reomoving the IPsec flowcache a bit. It can be
> > only a first step, but we need some improvements here
> > as people start to complain about that.
> 
> But did you also experiment with XDP on this? 

I've already tried to figure out what I have to to
do to get XDP with forwarding, but still don't realy
know how to set this up.

Maybe it is time to have a deeper look into BPF/XDP,
but for now I feel a bit lost with this.

> Would be curious about
> the numbers. You'd get implicit batching for the forwarding via devmap
> as well if you're required to flush it out via different device with
> XDP_REDIRECT; otherwise XDP_TX of course. Given we have recently
> integrated helpers for XDP to do a FIB and neighbor lookup from the
> kernel tables, where it's thus shared and integrated with the rest of
> the stack and tooling, it would be awesome to get to the same point
> with xfrm as well. Eyal recently did a start on that for xfrm for tc
> progs; would be nice to have integration on XDP as well, potentially
> it might also result in a bigger plus on the forwarding numbers.

It might make sense to intrgrate XDP with xfrm to
be able to compare numbers etc. But I need a working
XDP setup and some understanding about it first, what
could take some time.
