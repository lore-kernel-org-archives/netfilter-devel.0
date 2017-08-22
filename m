From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATH nft v2 05/18] libnftables: add nft_run_command_from_buffer
Date: Tue, 22 Aug 2017 14:37:37 +0200
Message-ID: <20170822123737.GA3775@salvia>
References: <20170819152420.22563-1-eric@regit.org>
 <20170819152420.22563-6-eric@regit.org>
 <20170821082344.GE2982@salvia>
 <20170821084520.GA3433@salvia>
 <1503306379.17531.3.camel@regit.org>
 <20170821094432.GA3932@salvia>
 <1503343266.9868.11.camel@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:36675 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932609AbdHVMiE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Aug 2017 08:38:04 -0400
Content-Disposition: inline
In-Reply-To: <1503343266.9868.11.camel@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 21, 2017 at 09:21:06PM +0200, Eric Leblond wrote:
> On Mon, 2017-08-21 at 11:44 +0200, Pablo Neira Ayuso wrote:
> > On Mon, Aug 21, 2017 at 11:06:19AM +0200, Eric Leblond wrote:
[...]
> > In a nutshell: we provide a simple API for people that don't want to
> > deal with IO at all, that's good. Then, an API that allows people to
> > deal with IO themselves - advanced stuff. Simple API functions would
> > be made of composites of the advance ones.
> 
> OK, I'm good with this approach and it will please the "I'm afraid of
> netlink" club ;)

OK, so we agree on the API policy then.

[...]
> I think we can all have as a guideline for libnftables that all
> advanced things are going to the advanced functions. The simple
> functions must provide something appealing in term of features but have
> to remain really simple.

Fine with it.

> This make me think I still don't know how to deal with sets. I'm not
> planning to work on it but I think it is a feature that should be
> available in the simple functions. But we are dealing with possibly
> complex object so this can be really messy.

What's your concern with sets?
