From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH v2 2/2] src: get rid of printf
Date: Thu, 21 Sep 2017 17:37:45 +0200
Message-ID: <20170921153745.GX30364@orbyte.nwl.cc>
References: <20170903223441.GB12383@salvia>
 <20170904075558.10129-1-eric@regit.org>
 <20170904075558.10129-3-eric@regit.org>
 <20170904204348.GB14434@salvia>
 <20170904205304.GA14816@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Leblond <eric@regit.org>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:44250 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751704AbdIUPhr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Sep 2017 11:37:47 -0400
Content-Disposition: inline
In-Reply-To: <20170904205304.GA14816@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Mon, Sep 04, 2017 at 10:53:04PM +0200, Pablo Neira Ayuso wrote:
> On Mon, Sep 04, 2017 at 10:43:48PM +0200, Pablo Neira Ayuso wrote:
> > On Mon, Sep 04, 2017 at 09:55:58AM +0200, Eric Leblond wrote:
> > > This patch introduces the nft_print function that has to be used
> > > instead of printf to output information that were previously send
> > > to stdout. This function accumulate the output in a buffer that can
> > > be fetched by the user with the nft_ctx_get_output() function.
> > > 
> > > This modification will allow the libnftables library to provide an
> > > easy way to the users to get the output data and display them like
> > > they want.
> > 
> > tests/shell/./run-tests
> > 
> > is reporting problems with this :-(
> 
> Eric, I can also see there are missing printf() to nft_print()
> conversion on the monitor side.
> 
> I would expect the simple API works like this: if you pass the
> "monitor" command, it justs prints events to whatever destination you
> have specified.
> 
> This is the most simple integration that makes sense to me.
> 
> Therefore, I think it would be good to convert those too to use
> nft_print().
> 
> Let me know, thanks.

With the proposed implementation of nft_print(), this will be
problematic: nft_run_cmd_from_buffer() waits for the command to finish
before printing all the output at once. This obviously breaks monitor
which runs endlessly.

Maybe we should reference nft_print via a function pointer in
output_ctx? This would allow to configure a different nft_print
implementation which flushes the buffer to stdout immediately.

What do you think?

Cheers, Phil
