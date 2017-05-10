From: Florian Westphal <fw@strlen.de>
Subject: Re: [nft PATCH RFC] monitor: Support printing processes which caused
 the event
Date: Wed, 10 May 2017 13:57:48 +0200
Message-ID: <20170510115748.GE16263@breakpoint.cc>
References: <20170510105510.891-1-phil@nwl.cc>
 <20170510112724.GD16263@breakpoint.cc>
 <20170510113855.GD29824@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
        netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:47692 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752285AbdEJL6T (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 May 2017 07:58:19 -0400
Content-Disposition: inline
In-Reply-To: <20170510113855.GD29824@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, May 10, 2017 at 01:27:24PM +0200, Florian Westphal wrote:
> > While most programs set it to their process id there is no guarantee.
> > Its just a (unique) 32 bit identifier.
> 
> It's actually the kernel that decides what portID the socket gets
> IIRC. For the first socket it uses the process ID, then for follow up
> sockets, it just looks for a spare ID in the negative range of the 32
> bit, if my memory serves well.

Argh, yes, of course...

> > Afaics one has to use /proc/net/netlink to map the portid to the inode
> > and then walk /proc/*/fd/* to find the socket with that inode.
> > 
> > Perhaps there is a simpler way, maybe you can check what ss is doing
> > and what info can be obtained via netlink diag.
> 
> I wouldn't be surprise if we need more kernel infrastructure to deal
> with this. Parsing /proc for a netlink thing is definitely not ideal.

Yes.  From nft monitor point of view the most easy solution would be
if the process id (or even the name?) would be sent back to userspace in a netlink
attribute.  Do you think we can extend nf_tables to include
get_task_comm() name and/or pid when/if we send update notifications?

(The pid is actually not that useful as process might have exited
already).
