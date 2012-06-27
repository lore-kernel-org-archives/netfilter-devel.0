From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 1/1] netfilter: make net/stat/nf_conntrack procfs
 available again
Date: Wed, 27 Jun 2012 13:20:49 +0200
Message-ID: <20120627112049.GA2939@breakpoint.cc>
References: <1340632925-4153-1-git-send-email-fw@strlen.de>
 <20120627110147.GA25605@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:34781 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753025Ab2F0LUu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Jun 2012 07:20:50 -0400
Content-Disposition: inline
In-Reply-To: <20120627110147.GA25605@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, Jun 25, 2012 at 04:02:05PM +0200, Florian Westphal wrote:
> > partially reverts commit 54b07dca68557b0952585b5f4834cd0dd86eba35
> > (netfilter: provide config option to disable ancient procfs parts).
> > 
> > Problem is that this also disabled net/stat/nf_conntrack, which
> > is useful for diagnosing certain conntrack-related issues; and there
> > are currently no other means to obtain these statistics from userspace.
> >
> > (conntrack-tools "conntrack -S" uses the proc interface, too...)
> 
> I can pass the following patch to David. It implements the missing
> code in ctnetlink to dump the statistics. Thus, conntrack doesn't use
> any /proc interface anymore (the changes to conntrack still pending).

Thanks, that would be fine, too.

> If you're OK with it, I'll integrate this in a backward compatible way
> (first try to use netlink, if not available, use /proc).

Sounds good.

> Still, I think that passing this to current may be useful. Although
> you can workaround this by enable that option. What do you prefer?

Ignore my patch.  In the meantime people can NF_CONNTRACK_PROCFS=y;
we just have to wait a bit (e.g. a year) before killing the nfct
proc code completely.
