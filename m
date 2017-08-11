From: Phil Sutter <phil@nwl.cc>
Subject: Re: RFC: Synopsis syntax change in nft.8
Date: Fri, 11 Aug 2017 10:09:11 +0200
Message-ID: <20170811080911.GM16375@orbyte.nwl.cc>
References: <20170810182932.GJ16375@orbyte.nwl.cc>
 <nycvar.YFH.7.76.1708110003470.10879@n3.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:38857 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751370AbdHKIJM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 11 Aug 2017 04:09:12 -0400
Content-Disposition: inline
In-Reply-To: <nycvar.YFH.7.76.1708110003470.10879@n3.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 11, 2017 at 12:44:25AM +0200, Jan Engelhardt wrote:
> On Thursday 2017-08-10 20:29, Phil Sutter wrote:
[...]
> >What do you think?
> 
> The styling _is_ written down: The Linux man-pages project has, since Tue May
> 22 2007, a man-pages.7 file. It says: bold="as-is text", italic="replacable
> arguments", talks about "[" "]" and "...", etc., just like you surmised.

Ah, indeed. Thanks for the reminder, this man page has served as good
guidance for me in the past already.

> Some history for the mail archives: {} is not specified, but follows from
> prominent use of | inside [] and the desire to have some kind of grouping for
> non-optional things. I will — cautiously — claim that {} was an idea of mine
> (barring any fourth party uses in completely unrelated projects elsewhere that
> I do not know of); commit iptables.git#a8ad34cf11540d147b8aded6826a1452841d2aa7
> was the first to use '{}'.

I guess it's just a short-cut and not really required. Obviously it
helps to separate the list of choices from the rest, for instance:

| nft add | delete ...

Which could be interpreted as "nft add" or "delete". But one could just
use a recursive approach instead of curly braces:

| nft COMMAND ...
| COMMAND := add | delete

In case one wonders what happens if that is consequently overdone, I
suggest having a look at ip-route(8) and trying to quickly figure what
options are available when adding a route. :)

[...]
> >Looking at ip.8 and ip-link.8, I notice that italic comes in lower- and
> >uppercase, and it's not clear which is what.
> 
> The iproute manpages could use some cleanup as well. Especially since "ersion"
> is not something one should replace with something else like "abc".

Hehe, yes. I consider iproute2 man pages a moving target in between
syntax fixes and enhancements with broken syntax ...

>  \fIOPTIONS\fP := { \fB-V\fP[\fIersion\fP] ...
> 
> should really be:
> 
>             ...   { \fB-V\fP[\fBe\fP[\fBr\fP[\fBs\fP[\fBi\fP[\fBo\fP[\fBn\fP]]]]]]
> 
> but that's ridiculous - writing
> 
>                   {\fB-V\fP|\fB-Version\fP}
> 
> is probably sufficient to get the idea across.

FWIW, there are cases where it matters: 'ip link s' completes to 'set',
not 'show'. That though is not covered by synopsis section of ip-link(8).

Thanks, Phil
