From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH][RESEND] netfilter: ipv6: fix afinfo->route refcnt leak
 on error
Date: Thu, 20 Oct 2011 12:28:46 +0200
Message-ID: <20111020102846.GA20625@1984>
References: <20111019112305.GC10691@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42714 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755371Ab1JTK2t (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Oct 2011 06:28:49 -0400
Content-Disposition: inline
In-Reply-To: <20111019112305.GC10691@Chamillionaire.breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Oct 19, 2011 at 01:23:06PM +0200, Florian Westphal wrote:
> Several callers (h323 conntrack, xt_addrtype) assume that the
> returned **dst only needs to be released if the function returns 0.
> 
> This is true for the ipv4 implementation, but not for the ipv6 one.
> 
> Instead of changing the users, change the ipv6 implementation
> to behave like the ipv4 version by only providing the dst_entry result
> in the success case.

Indeed, we're leaking refcounts of template routes defined in
net/ipv6/route.c

I have applied this patch to my nf branch:

http://1984.lsi.us.es/git/?p=net/.git;a=shortlog;h=refs/heads/nf

Thanks Florian.
