From: Florian Westphal <fw@strlen.de>
Subject: Re: [nft PATCH RFC] monitor: Support printing processes which caused
 the event
Date: Thu, 11 May 2017 08:59:27 +0200
Message-ID: <20170511065927.GI16263@breakpoint.cc>
References: <20170510105510.891-1-phil@nwl.cc>
 <20170510112724.GD16263@breakpoint.cc>
 <20170510113855.GD29824@salvia>
 <20170510115748.GE16263@breakpoint.cc>
 <20170510143946.GX20805@orbyte.nwl.cc>
 <20170510145437.GA17305@breakpoint.cc>
 <20170510151131.GY20805@orbyte.nwl.cc>
 <20170510175920.GG16263@breakpoint.cc>
 <20170511064131.GB1682@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
        netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:50588 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754731AbdEKG77 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 May 2017 02:59:59 -0400
Content-Disposition: inline
In-Reply-To: <20170511064131.GB1682@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> What is the usecase for this? Please don't tell me the obvious the
> answer: I just want to know what process has modified what.
> 
> If the point is to know if someone else, not myself as a process, has
> modified the ruleset, that is very easy to know with the netlink
> infrastructure.

Yes, thats in fact more important than 'know what process has modified
what', although I think it would be nice from a debug-point of view,
i.e.

$self adds a rule
something else adds a rule at same time

How can $self learn/know the handle assigned by kernel?

The larger picture is to start thinking in direction of libnft,
i.e. get the groundwork going so we don't have to tell 3rd party tools
like firewalld to parse nft text output.

Ideally, I'd like to see a mechanism where the 3rd party tool can:
1. queue an arbitrary amount of updates (add/delete of rules, set
   elements etc.)
2. learn the unique handles assigned to these rules
   so that it can identifiy/remove each one of these rules.

Thomas Woerner suggested a way where userspace can assign unique handles
instead of the kernel but I don't like it because i found no way how the
kernel could enforce that such user-handles are unique without walking
all rules of a table for every transaction.

But currently its impossible to delete a rule again without parsing
'nft -a list table'.  'delete-by-name' is good of course, but, has
the same problems we have with iptables.  I like that we have unique
handles that would allow to 1:1 map every rule to a uniqeue identifier.

But right now its more of a guessing game as the inserting program
doesn't see the handle(s) synchronously, just via monitor.

[ I suspect I now see where you're going with this as the notifications
  contain the nlportid so at least a tool that inserts + listens for
  updates will know if a notification is due to changes by someone else
  or not ...].

Do all of these patches make more sense now?

But, ideally, I'd like to see traction in direction of libnft (I'd
prefer to split nft for this, i.e. gplv2-licensed library).
