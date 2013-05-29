From: Aidan McGurn <aidan.mcgurn@openwave.com>
Subject: Re: How to access conntrack connection expiration in a netfilter module?
Date: Wed, 29 May 2013 19:22:45 +0000 (UTC)
Message-ID: <loom.20130529T211519-638@post.gmane.org>
References: <506A084E.5060505@wildgooses.com> <20121002181747.GB2397@1984> <506BEAC3.30103@wildgooses.com> <20121003082535.GA26812@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46394 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965823Ab3E2TZI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 May 2013 15:25:08 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gnnd-netfilter-devel@m.gmane.org>)
	id 1Uhlzb-0003Zf-7f
	for netfilter-devel@vger.kernel.org; Wed, 29 May 2013 21:25:03 +0200
Received: from bfs-sitenat.openwave.com ([80.93.12.4])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Wed, 29 May 2013 21:25:03 +0200
Received: from aidan.mcgurn by bfs-sitenat.openwave.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Wed, 29 May 2013 21:25:03 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo <at> netfilter.org> writes:

> 
> On Wed, Oct 03, 2012 at 08:35:31AM +0100, Ed W wrote:
> > On 02/10/2012 19:17, Pablo Neira Ayuso wrote:
> > 
> > >We used to have notifier call chains to deliver in-kernel
> > >nofitications to events. However, since it was overkill for just one
> > >single client (ctnetlink), we removed it and use a single hook
> > >function.
> > >
> > >The workaround is to dig into the history, find that code and forward
> > >port it.
> > >
> > >But I have to warn you that I won't take that patch into mainstream
> > >since there's only one single client in the official Linux kernel
> > >code, and external clients like that ndpi thing do not justify such
> > >change. Sorry.
> > 
> > Understood.  I have temporarily hacked in a crude second notifier
> > variable, just about to test it.
> > 
> > However, it seems like a common requirement to want to be able to do
> > some housekeeping in netfilter modules - what am I missing, how are
> > other modules doing stuff like this?  Is there another technique
> > which might be used?  Any other modules which do something similar
> > that I could crib from, ie with some internal state augmenting a
> > flow and then needing to cleanup sometime after the flow has gone
> > away?
> 
> I guess your modules are not using conntrack extensions:
> 
> See net/netfilter/nf_conntrack_extend.c and
> net/netfilter/nf_conntrack_acct.c for instance.
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo <at> vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
Hi Pablo,
i share the same head scratching as Ed here -
Currently i was using a Netfilter kernel module which required notification
of a connection been deleted:
e.g. 
if (events & IPCT_DESTROY) { ....
//do houskeeping, cleanups of my own custom connection data/database
}

Now when upgrading to RHEL6.3./6.4, i face a serious issue of not having any
way to get notified of a connection been removed.
I didn't understand how conntrack extensions help me here. Could you please
explain?

thanks








