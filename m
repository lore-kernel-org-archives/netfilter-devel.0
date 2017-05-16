From: Phil Sutter <phil@nwl.cc>
Subject: Re: [Bug 1145] nft 0.7: expression.c:966: range_expr_value_low:
 Assertion '0' failed.
Date: Tue, 16 May 2017 13:34:52 +0200
Message-ID: <20170516113452.GQ20805@orbyte.nwl.cc>
References: <bug-1145-20@https.bugzilla.netfilter.org/>
 <bug-1145-20-O7t1kbwESB@https.bugzilla.netfilter.org/>
 <20170515120357.GA32767@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, ian.kumlien@gmail.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:55351 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752186AbdEPLey (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 May 2017 07:34:54 -0400
Content-Disposition: inline
In-Reply-To: <20170515120357.GA32767@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Mon, May 15, 2017 at 02:03:57PM +0200, Florian Westphal wrote:
> bugzilla-daemon@netfilter.org <bugzilla-daemon@netfilter.org> wrote:
> 
> [ Switching to email ]
> 
> > https://bugzilla.netfilter.org/show_bug.cgi?id=1145
> > 
> > --- Comment #1 from Ian Kumlien <ian.kumlien@gmail.com> ---
> > Is there anything obvious that i'm doing wrong? Is there something else i could
> > try?
> 
> This boils down to nested sets:
> 
> define dnat_host        = 10.1.2.3
> define dnat_ports       = { 1234-1567 }
> 
> define port_allow = {
>         53,             # dns
>         $dnat_ports,    # dnat
> }
> define port_allow_tcp = {
>         80,
>         443,
>         $port_allow
> }
> define port_allow_udp = {
>         67, 68,         # dhcp
>         123, 1027,      # ntp
>         $port_allow
> }
> 
> ... which we don't support at the moment.

Actually, we do support this kind of nesting: Back in March I sent a
number of patches to fix for nested sets constructed via defines like
above, see a6b75b837f5e8 ("evaluate: set: Allow for set elems to be
sets") and the following two for details.

The reason why above fails though is the use of a range in
dnat_ports. If I drop it from the port_allow define, the above is
accepted and appears correct.

> So, should we
> a). expand/'inline' the sets?
> 
> (i.e. port_allow_tcp would contain
>  1234-1567, 53, 80, 443)

This is what I would expect the above to turn into.

> b) support lookups within lookups?
> 
> This would be needed to support non-anonymous sets within sets.

Sounds like a nice project, but for the issue at hand I don't think it's
necessary. So maybe get this issue (range in set not allowed) fixed and
postpone the named set in set thing for later? :)

Cheers, Phil
