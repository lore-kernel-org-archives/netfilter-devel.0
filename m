From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATH 01/16] libnftables: introduce library
Date: Mon, 21 Aug 2017 10:19:17 +0200
Message-ID: <20170821081917.GD2982@salvia>
References: <20170816204310.3371-1-eric@regit.org>
 <20170816204310.3371-2-eric@regit.org>
 <20170817085750.GS16375@orbyte.nwl.cc>
 <1502989742.31564.5.camel@regit.org>
 <20170817171350.GD10864@orbyte.nwl.cc>
 <1503132192.31564.17.camel@regit.org>
 <nycvar.YFH.7.76.1708192106560.32657@n3.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Leblond <eric@regit.org>, Phil Sutter <phil@nwl.cc>,
        netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:53114 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751895AbdHUITp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Aug 2017 04:19:45 -0400
Content-Disposition: inline
In-Reply-To: <nycvar.YFH.7.76.1708192106560.32657@n3.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Aug 19, 2017 at 09:07:55PM +0200, Jan Engelhardt wrote:
> 
> On Saturday 2017-08-19 10:43, Eric Leblond wrote:
> 
> >>> Hence I defined a global init and deinit. But maybe it does not
> >>> really make sense and could be attached to each context or init
> >>> could be done at first usage.
> >> 
> >> My idea was to implement simple reference counting to see whether
> >> the library was already initialized and whether it is safe to
> >> deinit. Of course this needs some serialization for thread-safety.
> >> 
> >> Or maybe the deinit can be ignored completely and
> >> nft_global_init() just has to check whether data is already
> >> initialized or not.
> >
> >I have used numerous libraries providing a global init or deinit.
> >For now we could easily skip it with your approach or another but I
> >prefer we have it existing so it is available later in case of
> >needs.
> 
> If a global init - more correctly, a singleton init - is needed,
> can't it just implicitly be called from make_me_a_new_context()?

I would advocate for placing the nft_global_init() and deinit() code
into the ctx object too.

Those _init() and _deinit() are indeed initializing context
information, such as iproute/ct label maps.

So they are context after all.
