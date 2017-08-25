From: Eric Leblond <eric@regit.org>
Subject: Re: [PATH nft v2 05/18] libnftables: add nft_run_command_from_buffer
Date: Fri, 25 Aug 2017 13:16:41 +0200
Message-ID: <1503659801.31357.13.camel@regit.org>
References: <20170819152420.22563-1-eric@regit.org>
         <20170819152420.22563-6-eric@regit.org> <20170821082344.GE2982@salvia>
         <20170821084520.GA3433@salvia> <1503306379.17531.3.camel@regit.org>
         <20170821094432.GA3932@salvia> <1503343266.9868.11.camel@regit.org>
         <20170822123737.GA3775@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:41680 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755878AbdHYLQq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Aug 2017 07:16:46 -0400
In-Reply-To: <20170822123737.GA3775@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Tue, 2017-08-22 at 14:37 +0200, Pablo Neira Ayuso wrote:
> On Mon, Aug 21, 2017 at 09:21:06PM +0200, Eric Leblond wrote:
> > On Mon, 2017-08-21 at 11:44 +0200, Pablo Neira Ayuso wrote:
> > > On Mon, Aug 21, 2017 at 11:06:19AM +0200, Eric Leblond wrote:
> 
> [...]
> > > In a nutshell: we provide a simple API for people that don't want
> > > to
> > > deal with IO at all, that's good. Then, an API that allows people
> > > to
> > > deal with IO themselves - advanced stuff. Simple API functions
> > > would
> > > be made of composites of the advance ones.
> > 
> > OK, I'm good with this approach and it will please the "I'm afraid
> > of
> > netlink" club ;)
> 
> OK, so we agree on the API policy then.
> 
> [...]
> > I think we can all have as a guideline for libnftables that all
> > advanced things are going to the advanced functions. The simple
> > functions must provide something appealing in term of features but
> > have
> > to remain really simple.
> 
> Fine with it.
> 
> > This make me think I still don't know how to deal with sets. I'm
> > not
> > planning to work on it but I think it is a feature that should be
> > available in the simple functions. But we are dealing with possibly
> > complex object so this can be really messy.
> 
> What's your concern with sets?

None fundamental really. It is just I don't see how we can build an
easy API with set that can looks like "ipv4_addr . ipv4addr .
inet_service". The use needs to be able to build the set object (could
be a string) AND to parse it. This last part is the most complex I
think. Maybe the JSON formatting could help here.

++
-- 
Eric Leblond <eric@regit.org>
