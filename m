From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] netfilter: make net/stat/nf_conntrack procfs
 available again
Date: Wed, 27 Jun 2012 17:23:41 +0200
Message-ID: <20120627152341.GA10048@1984>
References: <1340632925-4153-1-git-send-email-fw@strlen.de>
 <20120627110147.GA25605@1984>
 <20120627112049.GA2939@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54613 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757724Ab2F0PYc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Jun 2012 11:24:32 -0400
Content-Disposition: inline
In-Reply-To: <20120627112049.GA2939@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 27, 2012 at 01:20:49PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Mon, Jun 25, 2012 at 04:02:05PM +0200, Florian Westphal wrote:
> > > partially reverts commit 54b07dca68557b0952585b5f4834cd0dd86eba35
> > > (netfilter: provide config option to disable ancient procfs parts).
> > > 
> > > Problem is that this also disabled net/stat/nf_conntrack, which
> > > is useful for diagnosing certain conntrack-related issues; and there
> > > are currently no other means to obtain these statistics from userspace.
> > >
> > > (conntrack-tools "conntrack -S" uses the proc interface, too...)
> > 
> > I can pass the following patch to David. It implements the missing
> > code in ctnetlink to dump the statistics. Thus, conntrack doesn't use
> > any /proc interface anymore (the changes to conntrack still pending).
> 
> Thanks, that would be fine, too.
> 
> > If you're OK with it, I'll integrate this in a backward compatible way
> > (first try to use netlink, if not available, use /proc).
> 
> Sounds good.

JFYI:

http://git.netfilter.org/cgi-bin/gitweb.cgi?p=conntrack-tools.git;a=commit;h=8062d7fa6e0744a47c33ef0d3e17cc80ed005486

http://git.netfilter.org/cgi-bin/gitweb.cgi?p=conntrack-tools.git;a=commit;h=d3fa4f391fb40414a5c1cea16faac65d2c66a75c

I've pushed those two patches to the ct-stats branch to support
dumping statistics via ctnetlink. I'll merge them once we hit 3.6-rc1.

Part of that code can be moved to the libraries, we can do that later.

BTW, you require git tree snapshot from libnetfilter_conntrack for this.

And the -S output format is not backward compatible to previous:

cpu=0         searched=9367 found=428234 new=287508 invalid=1 ignore=4 delete=291546 delete_list=6045 insert=2007 insert_failed=0 drop=0 early_drop=0 error=0 search_restart=0
cpu=1         searched=394 found=40745 new=1667 invalid=0 ignore=0 delete=378 delete_list=378 insert=1667 insert_failed=0 drop=0 early_drop=0 error=0 search_restart=0
cpu=2         searched=336 found=77297 new=2127 invalid=0 ignore=1 delete=661 delete_list=661 insert=2128 insert_failed=0 drop=0 early_drop=0 error=0 search_restart=0
cpu=3         searched=71 found=15016 new=1391 invalid=0 ignore=0 delete=87 delete_list=87 insert=1391 insert_failed=0 drop=0 early_drop=0 error=0 search_restart=0

> > Still, I think that passing this to current may be useful. Although
> > you can workaround this by enable that option. What do you prefer?
> 
> Ignore my patch.  In the meantime people can NF_CONNTRACK_PROCFS=y;
> we just have to wait a bit (e.g. a year) before killing the nfct
> proc code completely.

Makes sense. I'll pass my patch to David, drop this and extend the
time to kill that /proc code for some time.
