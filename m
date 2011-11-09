From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: fix ->nfnl NULL oops
Date: Wed, 9 Nov 2011 15:35:10 +0100
Message-ID: <20111109143510.GB24158@1984>
References: <20111108221634.GA13261@p183.telecom.by>
 <32FF200DF1281ACA19CF3807@nimrod.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alexey Dobriyan <adobriyan@gmail.com>, kaber@trash.net,
	netfilter-devel@vger.kernel.org
To: Alex Bligh <alex@alex.org.uk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50916 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752746Ab1KIOfM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Nov 2011 09:35:12 -0500
Content-Disposition: inline
In-Reply-To: <32FF200DF1281ACA19CF3807@nimrod.local>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 08, 2011 at 10:50:05PM +0000, Alex Bligh wrote:
> --On 9 November 2011 01:16:35 +0300 Alexey Dobriyan
> <adobriyan@gmail.com> wrote:
> 
> >Sorry for delay.
> >
> >I recall myself writing that net->nfnl NULL check is racy or
> >something like that (but I can't find this email in archives).
> >
> >I've read the code once again, and I'm quite sure,
> >NULL ->nfnl check is correct if RCU precautions are made.
> 
> Your patch looks better than mine in this respect (as far as I
> can tell from code reading rather than testing)
> 
> >Regarding ->report check, I think it's bogus.
> 
> All I can tell is that net->nfnl == NULL is a condition that happens
> in practice. If that is read, race free, and treated as something
> that causes nfnetlink_has_listeners to return 0 irrespective of
> item_report, then the oops will not occur. So from my point of view
> it seems right.
> 
> Note that in the mean time I think my patch made -stable.

That's news.

I personally NACKed that patch.

Can you confirm that, please?
