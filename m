From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: How to access conntrack connection expiration in a netfilter
 module?
Date: Wed, 3 Oct 2012 10:25:36 +0200
Message-ID: <20121003082535.GA26812@1984>
References: <506A084E.5060505@wildgooses.com>
 <20121002181747.GB2397@1984>
 <506BEAC3.30103@wildgooses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ed W <lists@wildgooses.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40295 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466Ab2JCIZp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Oct 2012 04:25:45 -0400
Content-Disposition: inline
In-Reply-To: <506BEAC3.30103@wildgooses.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Oct 03, 2012 at 08:35:31AM +0100, Ed W wrote:
> On 02/10/2012 19:17, Pablo Neira Ayuso wrote:
> 
> >We used to have notifier call chains to deliver in-kernel
> >nofitications to events. However, since it was overkill for just one
> >single client (ctnetlink), we removed it and use a single hook
> >function.
> >
> >The workaround is to dig into the history, find that code and forward
> >port it.
> >
> >But I have to warn you that I won't take that patch into mainstream
> >since there's only one single client in the official Linux kernel
> >code, and external clients like that ndpi thing do not justify such
> >change. Sorry.
> 
> Understood.  I have temporarily hacked in a crude second notifier
> variable, just about to test it.
> 
> However, it seems like a common requirement to want to be able to do
> some housekeeping in netfilter modules - what am I missing, how are
> other modules doing stuff like this?  Is there another technique
> which might be used?  Any other modules which do something similar
> that I could crib from, ie with some internal state augmenting a
> flow and then needing to cleanup sometime after the flow has gone
> away?

I guess your modules are not using conntrack extensions:

See net/netfilter/nf_conntrack_extend.c and
net/netfilter/nf_conntrack_acct.c for instance.
