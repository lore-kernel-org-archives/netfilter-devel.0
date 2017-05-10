From: Florian Westphal <fw@strlen.de>
Subject: Re: [nft PATCH RFC] monitor: Support printing processes which caused
 the event
Date: Wed, 10 May 2017 16:54:37 +0200
Message-ID: <20170510145437.GA17305@breakpoint.cc>
References: <20170510105510.891-1-phil@nwl.cc>
 <20170510112724.GD16263@breakpoint.cc>
 <20170510113855.GD29824@salvia>
 <20170510115748.GE16263@breakpoint.cc>
 <20170510143946.GX20805@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:48232 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751955AbdEJOzI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 May 2017 10:55:08 -0400
Content-Disposition: inline
In-Reply-To: <20170510143946.GX20805@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Phil Sutter <phil@nwl.cc> wrote:
> Hi,
> 
> On Wed, May 10, 2017 at 01:57:48PM +0200, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > On Wed, May 10, 2017 at 01:27:24PM +0200, Florian Westphal wrote:
> > > > While most programs set it to their process id there is no guarantee.
> > > > Its just a (unique) 32 bit identifier.
> > > 
> > > It's actually the kernel that decides what portID the socket gets
> > > IIRC. For the first socket it uses the process ID, then for follow up
> > > sockets, it just looks for a spare ID in the negative range of the 32
> > > bit, if my memory serves well.
> > 
> > Argh, yes, of course...
> > 
> > > > Afaics one has to use /proc/net/netlink to map the portid to the inode
> > > > and then walk /proc/*/fd/* to find the socket with that inode.
> > > > 
> > > > Perhaps there is a simpler way, maybe you can check what ss is doing
> > > > and what info can be obtained via netlink diag.
> > > 
> > > I wouldn't be surprise if we need more kernel infrastructure to deal
> > > with this. Parsing /proc for a netlink thing is definitely not ideal.
> > 
> > Yes.  From nft monitor point of view the most easy solution would be
> > if the process id (or even the name?) would be sent back to userspace in a netlink
> > attribute.  Do you think we can extend nf_tables to include
> > get_task_comm() name and/or pid when/if we send update notifications?
> > 
> > (The pid is actually not that useful as process might have exited
> > already).
> 
> The question is where to put it. Looking at the netlink message
> structure, I see two options:
> 
> A) Extend struct nfgenmsg to contain PID and process name (a buffer of
>    length TASK_COMM_LEN).
> B) Add type-specific attributes for each type, like NFTA_RULE_PID and
>    NFTA_RULE_PNAME.
> 
> The problem with A) is that it will break older user space expecting
> sizeof(struct nfgenmsg) to be shorter.

Right, A) is a non-starter.

> Additional attributes should not
> be a problem here, but having to add them for each object type seems to
> be a really ugly solution.

I don't find it ugly, but alternatively we could add a new type of info
sent at the beginning of the commit phase (before all the table/rule etc
updates) and include it there.
