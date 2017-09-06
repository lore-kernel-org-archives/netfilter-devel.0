From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [nft PATCH RFC] Convert man page source to asciidoc
Date: Wed, 6 Sep 2017 15:25:51 +0200 (CEST)
Message-ID: <nycvar.YFH.7.76.1709061456340.3249@n3.vanv.qr>
References: <20170906084105.10915-1-phil@nwl.cc> <CAOkSjBhAxw8KxyQrBbCfBE9kQb--4HY39Qoi0jvf-ybwc1y=8Q@mail.gmail.com> <20170906115856.GC2399@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Arturo Borrero Gonzalez <arturo@netfilter.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a3.inai.de ([88.198.180.161]:35916 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753775AbdIFNZw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2017 09:25:52 -0400
In-Reply-To: <20170906115856.GC2399@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2017-09-06 13:58, Phil Sutter wrote:
>
>Regarding reStructuredText, did you look at how tables are written
>there? If not, see here[2]. I really think that speaks for itself.

Markup is the least problem. Tables, when rendered, have a tendency to quickly
grow too large for the display container because there is just so much data to
show.

Knowing that, people just avoid them most of the time for groff - and if I may
say so, it has not reduced the document quality.


>> There are many markup languages, it reminds me to xkcd #927 [0].
>
>Well, the difference here is that I'm not inventing anything new but
>search for better options amongst the existing solutions. :P

That would be to stay with docbook then, because RST/MD/A2 do not seem to have
left themselves a lot of room for later extension.


>> I would prefer if we stick to groff, which seems to be the standard in Linux.
>
>Yes, this is the very basic alternative but as said I think providing
>users with an easier to use markup makes sense.

Users read the rendered text, not the markup.

All of the glorious old markups are "unreadable" enough to be fed through a
program to give a visually-cooked, markup-free rendering (browser,
/usr/bin/man, evince, etc.) MediaWiki, RST, MD and asciidoc on the other hand
however seem to propagate the use of just cat/less with very short markup,
which, to a user, is not too bad to look at, but also not too visually pleasing
either, giving the worst of both worlds :-p
