From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] netfilter: ctnetlink: send event when conntrack
 label was modified
Date: Mon, 24 Jun 2013 17:09:50 +0200
Message-ID: <20130624150950.GA3917@localhost>
References: <y>
 <1371826290-302-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50131 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237Ab3FXPJ5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Jun 2013 11:09:57 -0400
Content-Disposition: inline
In-Reply-To: <1371826290-302-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 21, 2013 at 04:51:30PM +0200, Florian Westphal wrote:
> commit 0ceabd83875b72a29f33db4ab703d6ba40ea4c58
> (netfilter: ctnetlink: deliver labels to userspace) sets the event bit
> when we raced with another packet, instead of raising the event bit
> when the label bit is set for the first time.
> 
> commit 9b21f6a90924dfe8e5e686c314ddb441fb06501e
> (netfilter: ctnetlink: allow userspace to modify labels) forgot to update
> the event mask in the "conntrack already exists" case.
> 
> Both issues result in CTA_LABELS attribute not getting included in the
> conntrack event.

Applied, thanks Florian.
