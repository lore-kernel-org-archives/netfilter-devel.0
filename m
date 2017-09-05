From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH v2 2/2] src: get rid of printf
Date: Tue, 5 Sep 2017 19:33:31 +0200
Message-ID: <20170905173331.GA16559@salvia>
References: <20170903223441.GB12383@salvia>
 <20170904075558.10129-1-eric@regit.org>
 <20170904075558.10129-3-eric@regit.org>
 <20170904204348.GB14434@salvia>
 <20170904205304.GA14816@salvia>
 <1504560220.15611.32.camel@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:57908 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751959AbdIEReA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Sep 2017 13:34:00 -0400
Content-Disposition: inline
In-Reply-To: <1504560220.15611.32.camel@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 04, 2017 at 11:23:40PM +0200, Eric Leblond wrote:
> Hi,
> 
> On Mon, 2017-09-04 at 22:53 +0200, Pablo Neira Ayuso wrote:
> > On Mon, Sep 04, 2017 at 10:43:48PM +0200, Pablo Neira Ayuso wrote:
> > > On Mon, Sep 04, 2017 at 09:55:58AM +0200, Eric Leblond wrote:
> > > > This patch introduces the nft_print function that has to be used
> > > > instead of printf to output information that were previously send
> > > > to stdout. This function accumulate the output in a buffer that
> > > > can
> > > > be fetched by the user with the nft_ctx_get_output() function.
> > > > 
> > > > This modification will allow the libnftables library to provide
> > > > an
> > > > easy way to the users to get the output data and display them
> > > > like
> > > > they want.
> > > 
> > > tests/shell/./run-tests
> > > 
> > > is reporting problems with this :-(
> > 
> > Eric, I can also see there are missing printf() to nft_print()
> > conversion on the monitor side.
> > 
> > I would expect the simple API works like this: if you pass the
> > "monitor" command, it justs prints events to whatever destination you
> > have specified.
> > 
> > This is the most simple integration that makes sense to me.
> > 
> > Therefore, I think it would be good to convert those too to use
> > nft_print().
> 
> Yes indeed, that make sense. For each message, the user get the human
> formatted version of the event.

Yes. Once we have json support for this - in the high level
representation - we could add a function to specify the print mode.
But that is something we can of course later on, just thinking aloud.

> Do you want me to cook that based on the previously attached patch ?

Please do. Thanks!
