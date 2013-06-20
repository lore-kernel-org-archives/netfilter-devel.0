From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH] netfilter: remove redundant skb check in
 nf_conntrack_put_reasm
Date: Wed, 19 Jun 2013 20:01:35 -0400
Message-ID: <20130620000135.GB819@gmail.com>
References: <20130619142735.GA2758@gmail.com>
 <20130620092259.GD2124@breakpoint.cc>
 <20130620095846.GA19504@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:57406 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965039Ab3FTNEU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Jun 2013 09:04:20 -0400
Received: by mail-pd0-f173.google.com with SMTP id v14so6223826pde.32
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Jun 2013 06:04:20 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130620095846.GA19504@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 20, 2013 at 11:58:46AM +0200, Pablo Neira Ayuso wrote:
> On Thu, Jun 20, 2013 at 11:22:59AM +0200, Florian Westphal wrote:
> > Phil Oester <kernel@linuxace.com> wrote:
> > > kfree_skb already checks for skb existence - remove redundant check from
> > > nf_conntrack_put_reasm.
> > 
> > This is called for every free'd skb, in almost all cases
> > the condition will be false.
> > 
> > So I think its ok to keep this check.
> 
> I see, we'll hit branch mispredictions most of the time. I have kept
> this back. Thanks Florian.

If we're concerned about branch mispredictions, we should change the check to
match the one at the top of kfree_skb:

        if (unlikely(!skb))
                return;

However nf_conntrack_put_reasm is only used in 3 places in the entire tree.
Unclear why we don't just call kfree_skb directly in these 3 places.

Phil
