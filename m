From: Florian Westphal <fw@strlen.de>
Subject: Re: libmnl compile failure.
Date: Wed, 21 Dec 2016 12:28:48 +0100
Message-ID: <20161221112848.GA5346@breakpoint.cc>
References: <1758bff0-40b1-a404-e225-eff504c6a1d7@huawei.com>
 <20161219084921.GV13857@orbyte.nwl.cc>
 <F95AC9340317A84688A5F0DF0246F3F20151E85F@szxeml504-mbs.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Phil Sutter <phil@nwl.cc>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: maowenan <maowenan@huawei.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:40304 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751252AbcLUL3T (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Dec 2016 06:29:19 -0500
Content-Disposition: inline
In-Reply-To: <F95AC9340317A84688A5F0DF0246F3F20151E85F@szxeml504-mbs.china.huawei.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

maowenan <maowenan@huawei.com> wrote:
> 
> 
> > -----Original Message-----
> > From: Phil Sutter [mailto:phil@nwl.cc]
> > Sent: Monday, December 19, 2016 4:49 PM
> > To: maowenan
> > Cc: netfilter-devel@vger.kernel.org
> > Subject: Re: libmnl compile failure.
> > 
> > Hi,
> > 
> > On Fri, Dec 16, 2016 at 08:54:59AM +0800, maowenan wrote:
> > > There is something wrong when I make libmnl, could you please help check?
> > 
> > There is no error message in the output you pasted. Looks like you're calling
> > 'make' in an already built source tree, so nothing needs to be done. Do you see
> > the binaries in src/.libs?
> > 
> > Cheers, Phil
> 
>                                         Local
>                                             process
>                                               ^  |                 .-----------.
>                    .-----------.              |  |                 |  Routing  |
>                    |           |-----> input /    \---> output --->|  Decision |----
> --> prerouting --->|  Routing  |                                   .-----------.    \
>                    | Decision  |                                                     --> postrouting
>                    |           |                                                    /
>                    |           |---------------> forward --------------------------- 
>                    .-----------.
> 
> Is nftables output chain before routing decision? I think output is after routing decision, Is it wrong with above graphic?

Yes, the graph is wrong.

Output is after routing (which is why we need 'mangle' table in iptables
for rerouting and nftables' "route" chain property).
