From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH RFC] monitor: Support printing processes which caused
 the event
Date: Thu, 11 May 2017 11:58:57 +0200
Message-ID: <20170511095857.GB1249@salvia>
References: <20170510112724.GD16263@breakpoint.cc>
 <20170510113855.GD29824@salvia>
 <20170510115748.GE16263@breakpoint.cc>
 <20170510143946.GX20805@orbyte.nwl.cc>
 <20170510145437.GA17305@breakpoint.cc>
 <20170510151131.GY20805@orbyte.nwl.cc>
 <20170510175920.GG16263@breakpoint.cc>
 <20170511064131.GB1682@salvia>
 <20170511065927.GI16263@breakpoint.cc>
 <20170511082746.GA20805@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:45338 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754911AbdEKJ7F (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 May 2017 05:59:05 -0400
Content-Disposition: inline
In-Reply-To: <20170511082746.GA20805@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, May 11, 2017 at 10:27:46AM +0200, Phil Sutter wrote:
> On Thu, May 11, 2017 at 08:59:27AM +0200, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > What is the usecase for this? Please don't tell me the obvious the
> > > answer: I just want to know what process has modified what.
> > > 
> > > If the point is to know if someone else, not myself as a process, has
> > > modified the ruleset, that is very easy to know with the netlink
> > > infrastructure.
> > 
> > Yes, thats in fact more important than 'know what process has modified
> > what', although I think it would be nice from a debug-point of view,
> > i.e.
> > 
> > $self adds a rule
> > something else adds a rule at same time
> > 
> > How can $self learn/know the handle assigned by kernel?
> > 
> > The larger picture is to start thinking in direction of libnft,
> > i.e. get the groundwork going so we don't have to tell 3rd party tools
> > like firewalld to parse nft text output.
> 
> Which is a rather pointless argument regarding the monitor changes -
> neither parsing 'nft monitor' nor 'nft -a list ruleset' output is a
> particularly good option. Assuming that there will be at least optional
> NLM_F_ECHO in libnftables[1], programs will receive the handles for the
> rules they add, probably even along with the full rule depending on the
> yet to define API.
> 
> > Ideally, I'd like to see a mechanism where the 3rd party tool can:
> > 1. queue an arbitrary amount of updates (add/delete of rules, set
> >    elements etc.)
> > 2. learn the unique handles assigned to these rules
> >    so that it can identifiy/remove each one of these rules.
> > 
> > Thomas Woerner suggested a way where userspace can assign unique handles
> > instead of the kernel but I don't like it because i found no way how the
> > kernel could enforce that such user-handles are unique without walking
> > all rules of a table for every transaction.
> > 
> > But currently its impossible to delete a rule again without parsing
> > 'nft -a list table'.  'delete-by-name' is good of course, but, has
> > the same problems we have with iptables.  I like that we have unique
> > handles that would allow to 1:1 map every rule to a uniqeue identifier.
> 
> My point with all this is that delete-by-name simply doesn't exist yet,
> and given the obstacles it will face I guess it will take a little while
> until it's there. My synchronous handle output patch and these 'nft
> monitor' enhancements will provide an alternative at least until
> delete-by-name is there and actually usable. Also I don't know of a
> single point why not both ways should be made available - it only
> increases acceptance in users, which is a good thing per se.

Add a --echo option to nft that emerges the NLM_F_ECHO flag, so
basically this prints the result of what you added into the kernel.
This will also work with nft -i. No value returned via variable
though.

> > But right now its more of a guessing game as the inserting program
> > doesn't see the handle(s) synchronously, just via monitor.
> 
> This is only reliable if a project uses libnftnl directly and hence
> knows it's own portid.
> 
> Cheers, Phil
> 
> [1] I prefer the longer name just because it's more different to
> libnftnl than just 'libnft'.

We can start a poll with a bunch pre-selected choices, actually I only
see two at this moment.
