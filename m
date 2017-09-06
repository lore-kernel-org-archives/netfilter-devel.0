From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH RFC] Convert man page source to asciidoc
Date: Wed, 6 Sep 2017 16:02:33 +0200
Message-ID: <20170906140233.GD2399@orbyte.nwl.cc>
References: <20170906084105.10915-1-phil@nwl.cc>
 <CAOkSjBhAxw8KxyQrBbCfBE9kQb--4HY39Qoi0jvf-ybwc1y=8Q@mail.gmail.com>
 <20170906115856.GC2399@orbyte.nwl.cc>
 <nycvar.YFH.7.76.1709061456340.3249@n3.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo@netfilter.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:60244 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932308AbdIFOCg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2017 10:02:36 -0400
Content-Disposition: inline
In-Reply-To: <nycvar.YFH.7.76.1709061456340.3249@n3.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Wed, Sep 06, 2017 at 03:25:51PM +0200, Jan Engelhardt wrote:
> On Wednesday 2017-09-06 13:58, Phil Sutter wrote:
> >
> >Regarding reStructuredText, did you look at how tables are written
> >there? If not, see here[2]. I really think that speaks for itself.
> 
> Markup is the least problem. Tables, when rendered, have a tendency to quickly
> grow too large for the display container because there is just so much data to
> show.

It really matters if the markup specs suggest to draw ASCII art
pictures. The real problem though is that reStructuredText is meant to
be read as is and that is not required nor wanted in our case since we
generate a man page anyway.

> Knowing that, people just avoid them most of the time for groff - and if I may
> say so, it has not reduced the document quality.

Right now, nft.8 makes extensive use of tables which is why I considered
proper table support an important feature. OTOH I didn't experience
rendering issues with them in nft.8, did you?

> >> There are many markup languages, it reminds me to xkcd #927 [0].
> >
> >Well, the difference here is that I'm not inventing anything new but
> >search for better options amongst the existing solutions. :P
> 
> That would be to stay with docbook then, because RST/MD/A2 do not seem to have
> left themselves a lot of room for later extension.

What extensions do you have in mind?

> >> I would prefer if we stick to groff, which seems to be the standard in Linux.
> >
> >Yes, this is the very basic alternative but as said I think providing
> >users with an easier to use markup makes sense.
> 
> Users read the rendered text, not the markup.

Yes, you are right of course. I mixed up users with contributors again.

> All of the glorious old markups are "unreadable" enough to be fed through a
> program to give a visually-cooked, markup-free rendering (browser,
> /usr/bin/man, evince, etc.) MediaWiki, RST, MD and asciidoc on the other hand
> however seem to propagate the use of just cat/less with very short markup,
> which, to a user, is not too bad to look at, but also not too visually pleasing
> either, giving the worst of both worlds :-p

Now you seem to mix up users and contributors: I never suggested to
provide documentation to users in a different format than roff (rendered
by 'man'), but to provide people editing the documentation with
something more intuitive than docbook or roff.

Cheers, Phil
