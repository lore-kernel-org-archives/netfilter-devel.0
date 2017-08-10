From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: RFC: Synopsis syntax change in nft.8
Date: Fri, 11 Aug 2017 00:44:25 +0200 (CEST)
Message-ID: <nycvar.YFH.7.76.1708110003470.10879@n3.vanv.qr>
References: <20170810182932.GJ16375@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Cc: netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a3.inai.de ([88.198.180.161]:57038 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752135AbdHJWo1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Aug 2017 18:44:27 -0400
In-Reply-To: <20170810182932.GJ16375@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2017-08-10 20:29, Phil Sutter wrote:
>
>With no prior knowlege of how this syntax works, we start parsing the
>line from left to right and find out that something like:
>
>| {foo | bar}
>
>probably means "either 'foo' or 'bar'", no big deal. Next comes 'table' in
>bold font. What does bold mean? Looking at some examples, table seems to be a
>keyword ('terminal' in BNF-speak). But so are 'add', 'delete', 'list' and
>'flush', so why are they in normal font?
>[...]
>
>In iproute2, there is an (unwritten) agreement to use the following
>markups:
>
>normal font: meta info (braces, pipes and the like)
>bold font: things to be used literally ("keywords")
>italic: non-terminals
>[...]
>
>What do you think?

The styling _is_ written down: The Linux man-pages project has, since Tue May
22 2007, a man-pages.7 file. It says: bold="as-is text", italic="replacable
arguments", talks about "[" "]" and "...", etc., just like you surmised.

Some history for the mail archives: {} is not specified, but follows from
prominent use of | inside [] and the desire to have some kind of grouping for
non-optional things. I will — cautiously — claim that {} was an idea of mine
(barring any fourth party uses in completely unrelated projects elsewhere that
I do not know of); commit iptables.git#a8ad34cf11540d147b8aded6826a1452841d2aa7
was the first to use '{}'.


So yes, consider any bugs you find to be unfortunate omissions in the
respective manpages' markup. Few people will probably remember ever having seen
man-pages.7.


>Looking at ip.8 and ip-link.8, I notice that italic comes in lower- and
>uppercase, and it's not clear which is what.

The iproute manpages could use some cleanup as well. Especially since "ersion"
is not something one should replace with something else like "abc".

 \fIOPTIONS\fP := { \fB-V\fP[\fIersion\fP] ...

should really be:

            ...   { \fB-V\fP[\fBe\fP[\fBr\fP[\fBs\fP[\fBi\fP[\fBo\fP[\fBn\fP]]]]]]

but that's ridiculous - writing

                  {\fB-V\fP|\fB-Version\fP}

is probably sufficient to get the idea across.
