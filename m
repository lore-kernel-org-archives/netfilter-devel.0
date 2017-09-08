From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH RFC] Convert man page source to asciidoc
Date: Fri, 8 Sep 2017 10:53:21 +0200
Message-ID: <20170908085321.GJ2399@orbyte.nwl.cc>
References: <20170906084105.10915-1-phil@nwl.cc>
 <CAOkSjBhAxw8KxyQrBbCfBE9kQb--4HY39Qoi0jvf-ybwc1y=8Q@mail.gmail.com>
 <20170906115856.GC2399@orbyte.nwl.cc>
 <nycvar.YFH.7.76.1709061456340.3249@n3.vanv.qr>
 <20170906140233.GD2399@orbyte.nwl.cc>
 <nycvar.YFH.7.76.1709061608280.4856@n3.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo@netfilter.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:36662 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754751AbdIHIxY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Sep 2017 04:53:24 -0400
Content-Disposition: inline
In-Reply-To: <nycvar.YFH.7.76.1709061608280.4856@n3.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Sep 06, 2017 at 04:29:00PM +0200, Jan Engelhardt wrote:
> 
> On Wednesday 2017-09-06 16:02, Phil Sutter wrote:
> >> Knowing that, people just avoid them most of the time for groff - and if I may
> >> say so, it has not reduced the document quality.
> >
> >Right now, nft.8 makes extensive use of tables which is why I considered
> >proper table support an important feature. OTOH I didn't experience
> >rendering issues with them in nft.8, did you?
> 
> I do. For some reason, the right margin of the table is 60% of the
> terminal width. (width 120 => table up to col #63, terminal 80 cols
> => table up to col #50).

Oh, I see that too, also in my asciidoc PoC. Explicitly setting the
table width to 100% doesn't help either. Maybe this is a problem in
groff? The tables span the whole page in asciidoc's PDF output at least.

[...]
> However, what I tried to express is the problem with tables is that
> one column has almost no text and another has a lot of it, like this
> one. This causes large amounts of whitespace in column 1 in this
> case. Personally, I would have placed the hooks and their
> explanations as (the equivalent of)
> 
> .TP
> \fBprerouting\fP
> All packets enter ...
> .TP
> \fBinput\fP
> Packets delivered ...
> 
> Or if the source material was HTML, perhaps just
> 
> <ul>
> <li><b>prerouting</b>: All packets enter...</li>
> <li><b>input</b>: Packets delivered...</li>
> </ul>

Yes, we should indeed convert two-column tables to these labeled lists
if they are merely keyword descriptions. I'm not sure about other cases,
sometimes having the table headings allows to provide information in a
more compact form than embedding everything into a paragraph of text.

[...]
> In another way, I could also ask why hooks are in tables, and commands 
> ("add", "flush", etc.) are in TP-style. What makes hooks so special that 
> they deserve a table, despite their keyword being the same short length 
> as the commands.

Many of the tables seem to be there for reasons of document structure,
e.g. those below DATA TYPES. I don't think that is a bad thing per se.

> >> >> There are many markup languages, it reminds me to xkcd #927 [0].
> >> >
> >> >Well, the difference here is that I'm not inventing anything new but
> >> >search for better options amongst the existing solutions. :P
> >> 
> >> That would be to stay with docbook then, because RST/MD/A2 do not seem to have
> >> left themselves a lot of room for later extension.
> >
> >What extensions do you have in mind?
> 
> I kind of left that open; it seemed you implied there is something
> (the "better option") that MD couldn't do that asciidoc could. That
> thing, docbook should already have.

I think docbook is the most "feature complete" solution amongst those
mentioned. My personal motivation to replace it is basically founded by
two things:

1) XML is not quite editor-friendly. I found myself spending way more
   time opening and closing tags than I had anticipated for whenever I
   worked on content.

2) I didn't like how docbook formats synopfragment/synopfragmentref
   constructs. Maybe this could be changed by using some customization
   though. Also I didn't see an equivalent to it in asciidoc - BNF-style
   referencing is done manually there.

Cheers, Phil
