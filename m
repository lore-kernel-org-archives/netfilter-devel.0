From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: fix ->nfnl NULL oops
Date: Wed, 9 Nov 2011 15:34:23 +0100
Message-ID: <20111109143423.GA24158@1984>
References: <20111108221634.GA13261@p183.telecom.by>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: alex@alex.org.uk, kaber@trash.net, netfilter-devel@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50801 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483Ab1KIOe3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Nov 2011 09:34:29 -0500
Content-Disposition: inline
In-Reply-To: <20111108221634.GA13261@p183.telecom.by>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 09, 2011 at 01:16:35AM +0300, Alexey Dobriyan wrote:
> Sorry for delay.
> 
> I recall myself writing that net->nfnl NULL check is racy or
> something like that (but I can't find this email in archives).
> 
> I've read the code once again, and I'm quite sure,
> NULL ->nfnl check is correct if RCU precautions are made.
> 
> Regarding ->report check, I think it's bogus.
> 
> If there are no listeners, there are NO listeners
> and whether to report back to userspace doesn't matter.
> 
> I'm sure I'm missing something obvious here.
> 
> Please, review.

Alexey. This is a workaround. We have to make ctnl_notifier
container-aware which is the real problem.
