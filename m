From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH -nf] Revert "netfilter: bridge: query conntrack about skb
 dnat"
Date: Thu, 21 May 2015 13:26:03 +0200
Message-ID: <20150521112603.GA5315@salvia>
References: <1432122145-20527-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58674 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754060AbbEULVM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 May 2015 07:21:12 -0400
Content-Disposition: inline
In-Reply-To: <1432122145-20527-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 20, 2015 at 01:42:25PM +0200, Florian Westphal wrote:
> This reverts commit c055d5b03bb4cb69d349d787c9787c0383abd8b2.
> 
> There are two issues:
> 'dnat_took_place' made me think that this is related to
> -j DNAT/MASQUERADE.
> 
> But thats only one part of the story.  This is also relevant for SNAT
> when we undo snat translation in reverse/reply direction.
> 
> Furthermore, I originally wanted to do this mainly to avoid
> storing ipv6 addresses once we make DNAT/REDIRECT work
> for ipv6 on bridges.
> 
> However, I forgot about SNPT/DNPT which is stateless.
> 
> So we can't escape storing address for ipv6 anyway. Might as
> well do it for ipv4 too.

Applied this revert to nf, thanks.
