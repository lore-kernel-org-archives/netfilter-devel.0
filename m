From: Andreas Herz <andi@geekosphere.org>
Subject: Re: [PATCH iptables] fix wrong headername in ipv6header for protocols
Date: Mon, 20 Jul 2015 16:29:34 +0200
Message-ID: <20150720142934.GA21348@kvmbude>
References: <1437054859-15824-1-git-send-email-andi@geekosphere.org>
 <20150720072126.GA4136@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.geekosphere.org ([78.47.150.211]:42620 "EHLO
	mail.geekosphere.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756365AbbGTO3j (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Jul 2015 10:29:39 -0400
Content-Disposition: inline
In-Reply-To: <20150720072126.GA4136@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 20/07/15 at 09:21, Pablo Neira Ayuso wrote:
> On Thu, Jul 16, 2015 at 03:54:19PM +0200, Andreas Herz wrote:
> > In the --help output and manpage for ipv6header the name for upper layer
> > protocol headers was "proto", while in the code itself it's "prot" for
> > the short form. Fixed by changing manpage and help output.
> > 
> > Signed-off-by: Andreas Herz <andi@geekosphere.org>
> > ---
> >  extensions/libip6t_ipv6header.c   | 2 +-
> >  extensions/libip6t_ipv6header.man | 4 ++--
> >  2 files changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/extensions/libip6t_ipv6header.c b/extensions/libip6t_ipv6header.c
> > index 00d5d5b..6f03087 100644
> > --- a/extensions/libip6t_ipv6header.c
> > +++ b/extensions/libip6t_ipv6header.c
> > @@ -127,7 +127,7 @@ static void ipv6header_help(void)
> >  	printf(
> >  "ipv6header match options:\n"
> >  "[!] --header headers     Type of header to match, by name\n"
> > -"                         names: hop,dst,route,frag,auth,esp,none,proto\n"
> > +"                         names: hop,dst,route,frag,auth,esp,none,prot\n"
> >  "                    long names: hop-by-hop,ipv6-opts,ipv6-route,\n"
> >  "                                ipv6-frag,ah,esp,ipv6-nonxt,protocol\n"
> >  "                       numbers: 0,60,43,44,51,50,59\n"
> 
> I can read this from the code:
> 
> static const struct pprot chain_protos[] = {
>         { "protocol", IPPROTO_RAW },
> ...
>         { "prot", IPPROTO_RAW },
> 
> Could you clarify what you're seeing there? Thanks.

It's exactly the issue :) as you can see "protocol" and "prot" (without
_o_ at the end) but the manpage and the help from iptables say
"protocol" and "proto" (with _o_ at the end).

I recognized the issue while playing around with this extension:

 ip6tables -m ipv6header --help
 [snip]
 [!] --header headers     Type of header to match, by name
                          names: hop,dst,route,frag,auth,esp,none,proto

As you can see the output of names with "proto" is not correct.
Same with the manpage. They don't work:

 ip6tables -I INPUT -m ipv6header ! --header proto -j DROP

results in:

 ip6tables v1.4.21: unknown header `proto' specified

It's just "prot" as you found yourself in the code.
Thus i thougt to patch the wrong part in the manpage and help section.

-- 
Andreas Herz
