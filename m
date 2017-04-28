From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH 2/2] masquerade: Complain if no prerouting chain
 exists
Date: Fri, 28 Apr 2017 17:59:29 +0200
Message-ID: <20170428155929.GO20805@orbyte.nwl.cc>
References: <20170427132439.9443-1-phil@nwl.cc>
 <20170427132439.9443-2-phil@nwl.cc>
 <CAOkSjBjdnywsFENgBLQfQr2aXMTDpU9ztXm_Y4V1==E61hH05g@mail.gmail.com>
 <20170428080523.GI20805@orbyte.nwl.cc>
 <CAOkSjBjtJ0_xymJ_iMuKwxtqArEh_dHs=Tgjo271PnLy4K84ng@mail.gmail.com>
 <20170428082824.GJ20805@orbyte.nwl.cc>
 <CAOkSjBi=oYsB2wDxq0-1ejaUrwrt+vRcAjCKO8f4RXv2=cqq=Q@mail.gmail.com>
 <20170428145801.GA10616@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo@debian.org>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:39291 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1163916AbdD1P7a (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Apr 2017 11:59:30 -0400
Content-Disposition: inline
In-Reply-To: <20170428145801.GA10616@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 28, 2017 at 04:58:01PM +0200, Pablo Neira Ayuso wrote:
> On Fri, Apr 28, 2017 at 11:02:53AM +0200, Arturo Borrero Gonzalez wrote:
> > On 28 April 2017 at 10:28, Phil Sutter <phil@nwl.cc> wrote:
> [...]
> > > Ah, thanks for the pointer! I tend to ignore anything that's not in the
> > > man page. :)
> > 
> > Well, I guess adding more info to the man page won't hurt.
> > 
> > Things I would add:
> >  * some bits about NAT chains configuration (this issue)
> >  * info about base chains priorities
> >  * some bits about atomic operations
> 
> Either we update the existing documentation (manpage and wiki) as
> Arturo suggest or we add some sort of transparent automatic NAT chain
> registration in the kernel.

I had considered that already, but didn't see an easy way to do it in
kernel space. Also, in order to do it properly, one would have to remove
it again if it's counterpart is removed, which further complicates
things. Hence my poor man's approach of just warning about it.

For the time being, I'll add a note to the man page pointing this out.
If it will become unnecessary in the future, it can still be removed.

Cheers, Phil
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
