From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 1/4] Revert: add new libnetfilter_queue API for libmnl
Date: Fri, 26 Apr 2013 12:02:47 +0200
Message-ID: <20130426100247.GE32324@breakpoint.cc>
References: <1366886611-21666-1-git-send-email-fw@strlen.de>
 <1366886611-21666-2-git-send-email-fw@strlen.de>
 <20130426013601.GA4510@localhost>
 <20130426073239.GD32324@breakpoint.cc>
 <20130426093708.GA3757@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:48888 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932637Ab3DZKCu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Apr 2013 06:02:50 -0400
Content-Disposition: inline
In-Reply-To: <20130426093708.GA3757@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Yes, but at this time the system-wide header is used, and not this copy.
> > Compile of libnetfilter_queue breaks with the other patches applied
> > because the new attribute is missing from the system header.
> 
> Hm, it's using the local cache copy here.

You're right.

> > Hrm, yes.  I thought that was intentional.
> > Or are you saying that you basically just want to rename
> > linux_nfnetlink_queue.h and carry a copy of nfnetlink_queue.h instead?
> 
> We cannot rename that header. Some people are including it into it
> into their source code and that will break their compilation.

Yes, I meant "in the long run, when old API is removed".
I got rid of the revert and it works for me after refreshing
with a copy from net-next.

I hope the V2 i posted is in the direction you had in mind.
