From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [nft PATCH RFC] Convert man page source to asciidoc
Date: Wed, 6 Sep 2017 16:29:00 +0200 (CEST)
Message-ID: <nycvar.YFH.7.76.1709061608280.4856@n3.vanv.qr>
References: <20170906084105.10915-1-phil@nwl.cc> <CAOkSjBhAxw8KxyQrBbCfBE9kQb--4HY39Qoi0jvf-ybwc1y=8Q@mail.gmail.com> <20170906115856.GC2399@orbyte.nwl.cc> <nycvar.YFH.7.76.1709061456340.3249@n3.vanv.qr> <20170906140233.GD2399@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Cc: Arturo Borrero Gonzalez <arturo@netfilter.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a3.inai.de ([88.198.180.161]:40702 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932260AbdIFO3C (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2017 10:29:02 -0400
In-Reply-To: <20170906140233.GD2399@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2017-09-06 16:02, Phil Sutter wrote:
>> Knowing that, people just avoid them most of the time for groff - and if I may
>> say so, it has not reduced the document quality.
>
>Right now, nft.8 makes extensive use of tables which is why I considered
>proper table support an important feature. OTOH I didn't experience
>rendering issues with them in nft.8, did you?

I do. For some reason, the right margin of the table is 60% of the
terminal width. (width 120 => table up to col #63, terminal 80 cols
=> table up to col #50).

       ┌────────────┬─────────────────────────────────────────┐
       │Hook        │ Description                             │
       ├────────────┼─────────────────────────────────────────┤
       │prerouting  │ All  packets  entering  the  system are │
       │            │ processed by the prerouting hook. It is │
       │            │ invoked  before the routing process and │
       │            │ is used for early filtering or changing │
       │            │ packet attributes that affect routing.  │
       ├────────────┼─────────────────────────────────────────┤
       │input       │ Packets  delivered  to the local system │
       │            │ are processed by the input hook.        │
       ├────────────┼─────────────────────────────────────────┤
       │forward     │ Packets forwarded to a  different  host │
       │            │ are processed by the forward hook.      │
       ├────────────┼─────────────────────────────────────────┤
       │output      │ Packets  sent  by  local  processes are │
       │            │ processed by the output hook.           │
       ├────────────┼─────────────────────────────────────────┤
       │postrouting │ All packets leaving the system are pro- │
       │            │ cessed by the postrouting hook.         │
       └────────────┴─────────────────────────────────────────┘

However, what I tried to express is the problem with tables is that
one column has almost no text and another has a lot of it, like this
one. This causes large amounts of whitespace in column 1 in this
case. Personally, I would have placed the hooks and their
explanations as (the equivalent of)

.TP
\fBprerouting\fP
All packets enter ...
.TP
\fBinput\fP
Packets delivered ...

Or if the source material was HTML, perhaps just

<ul>
<li><b>prerouting</b>: All packets enter...</li>
<li><b>input</b>: Packets delivered...</li>
</ul>


The rectangular grid is overkill, because you are not trying to do
a figurative police lineup (leave tables for e.g.
https://en.wikipedia.org/wiki/Comparison_of_Linux_distributions#Instruction_set_architecture_support
)


In another way, I could also ask why hooks are in tables, and commands 
("add", "flush", etc.) are in TP-style. What makes hooks so special that 
they deserve a table, despite their keyword being the same short length 
as the commands.



>> >> There are many markup languages, it reminds me to xkcd #927 [0].
>> >
>> >Well, the difference here is that I'm not inventing anything new but
>> >search for better options amongst the existing solutions. :P
>> 
>> That would be to stay with docbook then, because RST/MD/A2 do not seem to have
>> left themselves a lot of room for later extension.
>
>What extensions do you have in mind?

I kind of left that open; it seemed you implied there is something
(the "better option") that MD couldn't do that asciidoc could. That
thing, docbook should already have.
