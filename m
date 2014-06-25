From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3] netfilter: conntrack: remove timer from ecache
 extension
Date: Wed, 25 Jun 2014 19:22:15 +0200
Message-ID: <20140625172215.GA13362@localhost>
References: <1402434776-23461-1-git-send-email-fw@strlen.de>
 <20140611085547.GA4131@localhost>
 <20140611092015.GA12405@breakpoint.cc>
 <20140625170636.GA16571@localhost>
 <20140625171327.GE6328@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57278 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757311AbaFYRWX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Jun 2014 13:22:23 -0400
Content-Disposition: inline
In-Reply-To: <20140625171327.GE6328@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 25, 2014 at 07:13:27PM +0200, Florian Westphal wrote:
> > However, perhaps the per-second watch is not enough to get
> > a real evolution on how the dying list population evolves along time.
> 
> Yes, you might be right.
> IFF you think its useful, we could add a counter to keep track of the
> maximum length of entries that the ecache worker has seen and
> export that via ctnetlink (like we do for number of conntracks, search
> list restarts, etc etc).

We can revisit this later to see if we can get some extra tuning. But
I'm quite happy with the current results.

> > Anyway, I think this is good enough to get rid of the extra timer. We
> > can enqueue this patch to 3.17, unless you have any objection.
> 
> No objections from me, thanks Pablo!

Thanks, I'll enqueue this.
