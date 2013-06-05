From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH -next 1/2] netfilter: nf_queue: cleanup copy_range usage
Date: Wed, 5 Jun 2013 12:42:38 +0200
Message-ID: <20130605104238.GA5796@localhost>
References: <1370420536-9626-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52829 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754118Ab3FEKmr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Jun 2013 06:42:47 -0400
Content-Disposition: inline
In-Reply-To: <1370420536-9626-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 05, 2013 at 10:22:15AM +0200, Florian Westphal wrote:
> For every packet queued, we check if configured copy_range
> is 0, and treat that as 'copy entire packet'.
> 
> We can move this check to the queue configuration, and can
> set copy_range appropriately.
> 
> Also, convert repetitive '0xffff - NLA_HDRLEN' to a macro.
> 
> [ queue initialization still used 0xffff, although its harmless
>   since the initial setting is overwritten on queue config ]

Applied, thanks Florian.
