From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [Nftables RFC] High level library proposal
Date: Tue, 23 Apr 2013 01:50:12 +0200
Message-ID: <20130422235012.GA4875@localhost>
References: <516EA684.9040209@linux.intel.com>
 <20130419100531.GA3481@localhost>
 <517129D8.8000006@linux.intel.com>
 <20130419121127.GA29452@localhost>
 <1366671791.15660.36.camel@tiger2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>,
	Julien Vehent <julien@linuxwall.info>
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54599 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674Ab3DVXuR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Apr 2013 19:50:17 -0400
Content-Disposition: inline
In-Reply-To: <1366671791.15660.36.camel@tiger2>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Tue, Apr 23, 2013 at 01:03:11AM +0200, Eric Leblond wrote:
[...]
> > > It's a requirement for me to be able to use another way to discuss
> > > on netlink. Let's say it: something else than libmnl or libnl.
> > > And it's not that complicated anyway to handle, as for the event
> > > loop actually. I am definitely keeping that.
> > 
> > I don't get why you may need something different than libmnl or libnl.
> 
> I don't think Tomasz need it but future application developers will
> really love to avoid to learn how netlink messages are build.

I was referring to the driver switch that he wants to introduce to
select libnl or libmnl in runtime, it makes no sense to me.

[...]
> > > I am fine with that, providing different levels of abstraction. But
> > > I am pretty sure people will prefer using higher level one: see how
> > > applications uses iptables tool for instance?
> > 
> > Don't be so sure about that. People making very simple applications
> > will stick to the simple make-my-life-easy API, yes. But people
> > willing to make more advanced stuff will end up requiring to access
> > details at different levels of the abstraction.
> 
> We definitely need different level of abstractions.

Nobody said here that we don't need high level abstractions.

My point is that the library should provide different level of
abstractions, so you can switch to the level you want. Think of it as
an elevator that takes you to the 1st floor or 9th floor. Depending
where you get, you see more or less details. If designed carefully,
that should be possible.

> At least a high level and a low level. The high level abstraction
> should be almost nftables independent (and netlink independent for
> sure) and the lower level can get into the details.
> 
> I think Jesper's mail has described some features that would be really
> useful in the high level API. Maybe continuing the discussion on these
> type of features will lead to the list of the thing that would be useful
> for most people.

I think you misundertood my use-case request. I'm not asking for more
features or ideas. There are tons of cool things we can do with
nftables, all those mentioned should be possible with some manpower
working on those.

Instead, I'm asking for simple source examples, eg. one to add a rule,
one to dump the entire rule-set, one to listen to events, etc. how the
objects would look like, what workflow is imposed to the programmer,
and so on. All those using the hypothetical new high level API.

Those should example files of the proposed API should help to see how
that looks like, even if there is not real library code available for
those yet.

> <idea type=stupid>Regarding the low level API, I did not yet look a
> libnftables but maybe just keeping it could be ok ?</idea>

Of course it would be good idea to keep it. It does not make any sense
to me to force people to use one single high level API.
