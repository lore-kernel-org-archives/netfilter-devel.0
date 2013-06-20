From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: remove redundant skb check in
 nf_conntrack_put_reasm
Date: Thu, 20 Jun 2013 11:58:46 +0200
Message-ID: <20130620095846.GA19504@localhost>
References: <20130619142735.GA2758@gmail.com>
 <20130620092259.GD2124@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Phil Oester <kernel@linuxace.com>, netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36494 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754243Ab3FTJ6v (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Jun 2013 05:58:51 -0400
Content-Disposition: inline
In-Reply-To: <20130620092259.GD2124@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 20, 2013 at 11:22:59AM +0200, Florian Westphal wrote:
> Phil Oester <kernel@linuxace.com> wrote:
> > kfree_skb already checks for skb existence - remove redundant check from
> > nf_conntrack_put_reasm.
> 
> This is called for every free'd skb, in almost all cases
> the condition will be false.
> 
> So I think its ok to keep this check.

I see, we'll hit branch mispredictions most of the time. I have kept
this back. Thanks Florian.
