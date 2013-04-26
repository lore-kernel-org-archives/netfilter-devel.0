From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/4] Revert: add new libnetfilter_queue API for libmnl
Date: Fri, 26 Apr 2013 12:12:12 +0200
Message-ID: <20130426101212.GA18251@localhost>
References: <1366886611-21666-1-git-send-email-fw@strlen.de>
 <1366886611-21666-2-git-send-email-fw@strlen.de>
 <20130426013601.GA4510@localhost>
 <20130426073239.GD32324@breakpoint.cc>
 <20130426093708.GA3757@localhost>
 <20130426100247.GE32324@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32775 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758748Ab3DZKM1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Apr 2013 06:12:27 -0400
Content-Disposition: inline
In-Reply-To: <20130426100247.GE32324@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 26, 2013 at 12:02:47PM +0200, Florian Westphal wrote:
[...]
> > We cannot rename that header. Some people are including it into it
> > into their source code and that will break their compilation.
> 
> Yes, I meant "in the long run, when old API is removed".
> I got rid of the revert and it works for me after refreshing
> with a copy from net-next.

Feel free to post a patch for that refresh.

> I hope the V2 i posted is in the direction you had in mind.

Looks good, only missing some explanation in the doxygen documentation
on the "csum not ready" thing.

Thanks.
