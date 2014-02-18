From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH V2] netfilter: ctnetlink: force null nat binding on insert
Date: Tue, 18 Feb 2014 02:14:07 +0100
Message-ID: <20140218011406.GA4527@localhost>
References: <1392549343-7145-1-git-send-email-fw@strlen.de>
 <20140217103750.GA22363@localhost>
 <20140217104511.GB31125@breakpoint.cc>
 <20140217105856.GA16361@localhost>
 <20140217111519.GC31125@breakpoint.cc>
 <20140217132435.GA4083@localhost>
 <20140217133224.GD31125@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51344 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbaBRBON (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Feb 2014 20:14:13 -0500
Content-Disposition: inline
In-Reply-To: <20140217133224.GD31125@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 17, 2014 at 02:32:24PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > I think we can simplify this, the nfnetlink_parse_nat_setup() hook
> > function is always called under rcu_read_lock. See patch attached.
> 
> Right.  The patch looks good to me.
> 
> Acked-by: Florian Westphal <fw@strlen.de>

I have enqueued this patch to David, thanks.
