From: Florian Westphal <fw@strlen.de>
Subject: Re: nftables rules not matching after upgrading from 0.7 to 0.8
Date: Thu, 26 Oct 2017 00:45:36 +0200
Message-ID: <20171025224536.GK19457@breakpoint.cc>
References: <1508949114.1154.14.camel@cohaesio.com>
 <20171025175725.GJ19457@breakpoint.cc>
 <1508955630.25035.13.camel@cohaesio.com>
 <1508970133.25035.24.camel@cohaesio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "fw@strlen.de" <fw@strlen.de>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: "Anders K. Pedersen | Cohaesio" <akp@cohaesio.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:55580 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751753AbdJYWpv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Oct 2017 18:45:51 -0400
Content-Disposition: inline
In-Reply-To: <1508970133.25035.24.camel@cohaesio.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Anders K. Pedersen | Cohaesio <akp@cohaesio.com> wrote:
> On ons, 2017-10-25 at 20:20 +0200, Anders K. Pedersen | Cohaesio wrote:
> > On ons, 2017-10-25 at 19:57 +0200, Florian Westphal wrote:
> > > Anders K. Pedersen | Cohaesio <akp@cohaesio.com> wrote:
> > > > After upgrading to nftables 0.8 (from 0.7) on one of my systems,
> > > > I've
> > > > experiences several cases where rules that used to work fine with
> > > > 0.7
> > > > sometimes doesn't match anymore with 0.8 (it's not consistent -
> > > > sometimes the rules do match with 0.8).
> > > > 
> > > > The rule chains end with a log statement before rejecting or
> > > > dropping
> > > > the packets, and I can see in the log that everything is as
> > > > expected
> > > > and the rules should match. After downgrading to nftables 0.7
> > > > everything works again.
> > > 
> > > Are those errors restricted to a particular table family, chain or
> > > protocol?
> > 
> > So far I've only registered it for IPv4 input filtering for TCP, but
> > that's also most of the traffic on this system, so I'm not sure that
> > it's limited to that.
> > 
> > As mentioned, it's not consistent. A rule that has worked fine could
> > suddenly stop working without any rule set changes for days. Some
> > times
> > it has helped to just reload the exact same rule set. Other times
> > changing
> > 
> > tcp dport { imap2, imaps } flow table imap \
> >                 { ip saddr & 255.255.255.240 \
> >                   timeout 5m limit rate 10/minute } \
> >         counter accept
> > 
> > to
> > 
> > tcp dport { imap2, imaps } flow table imap \
> >         counter accept
> > 
> > or
> > 
> > tcp dport { domain, http, https, 8080, 8443, 9091 } \
> >         meta iif eth1 accept
> > 
> > to
> > 
> > tcp dport { domain, http, https, 8080, 8443, 9091 } \
> >         meta iif eth1 counter accept
> > 
> > has resolved it, but it feels like it wasn't really due to the
> > changes,
> > but more random luck.

note that sets are broken with 16bit elements at the moment in 4.13, see

https://patchwork.ozlabs.org/patch/821080/
or
https://patchwork.ozlabs.org/patch/830236/

> One more thing, I just noticed is that if I try to use nftables 0.7 to
> dump the rule set that was loaded with 0.7, I get the following error:
> 
> # nft list ruleset
> nft: payload.c:550: payload_expr_expand: Assertion `desc->base == expr->payload.base' failed.
> Aborted

Crap, I'll fix this, thanks for reporting.

> If I use 0.8 to dump the rule set that was loaded with 0.7, I get the
> correct rule set except for a difference with regards to sets and maps
> that use interfaces like:
> 
> --- nft-0.7-0.8 rule set loaded with 0.7 and dumped with 0.8
> +++ nft-0.8     same rule set loaded and dumped with 0.8
> @@ -9,12 +9,12 @@
>         chain prerouting {
>                 type filter hook prerouting priority -100; policy accept;
>                 iif "lo" accept
> -               ct mark set iif map { 33554432 : 0x00000001, 67108864 : 0x00000002 }
> +               ct mark set iif map { "eth0" : 0x00000001, "eth2" : 0x00000002 }
>                 iif "eth1" jump prerouting_internal
> -               iif { 33554432, 67108864 } ip saddr { 0.0.0.0/8, 10.0.0.0/8, 127.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16, 224.0.0.0-255.255.255.255 } counter packets 6 bytes 705 drop
> +               iif { "eth0", "eth2" } ip saddr { 0.0.0.0/8, 10.0.0.0/8, 127.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16, 224.0.0.0-255.255.255.255 } counter packets 0 bytes 0 drop

I will look at this too.
