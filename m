From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3] netfilter: conntrack: remove timer from ecache
 extension
Date: Wed, 11 Jun 2014 10:55:47 +0200
Message-ID: <20140611085547.GA4131@localhost>
References: <1402434776-23461-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44467 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754230AbaFKIzx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Jun 2014 04:55:53 -0400
Content-Disposition: inline
In-Reply-To: <1402434776-23461-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

Thanks for this new round.

On Tue, Jun 10, 2014 at 11:12:56PM +0200, Florian Westphal wrote:
> This brings the (per-conntrack) ecache extension back to 24 bytes in size
> (was 152 byte on x86_64 with lockdep on).
> 
> When event delivery fails, re-delivery is attempted via work queue.
> 
> Redelivery is attempted at least every 0.1 seconds, but can happen
> more frequently if userspace is not congested.
> 
> The nf_ct_release_dying_list() function is removed.
> With this patch, ownership of the to-be-redelivered conntracks
> (on-dying-list-with-DYING-bit not yet set) is with the work queue,
> which will release the references once event is out.

I think we need to keep the nf_ct_release_dying_list(), otherwise we
will hit problems when destroying the kmem_cache, since the workqueue
may race with that, right?
