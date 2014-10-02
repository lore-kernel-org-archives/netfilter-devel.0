From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] netfilter: explicit module dependency between
 br_netfilter and physdev
Date: Thu, 2 Oct 2014 12:51:03 +0200
Message-ID: <20141002105103.GF1803@breakpoint.cc>
References: <1412242912-3622-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, stephen@networkplumber.org,
	fw@strlen.de, kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:39332 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750987AbaJBKvH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Oct 2014 06:51:07 -0400
Content-Disposition: inline
In-Reply-To: <1412242912-3622-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> You can use physdev to match the physical interface enslaved to the
> bridge device. This information is stored in skb->nf_bridge and it is
> set up by br_netfilter. So, this is only available when iptables is
> used from the bridge netfilter path.
> 
> Since 34666d4 ("netfilter: bridge: move br_netfilter out of the core"),
> the br_netfilter code is modular. To reduce the impact of this change,
> we can autoload the br_netfilter if the physdev match is used since
> we assume that the users need br_netfilter in place.

Good idea.  I'd suggest to add a dummy dependency and have userspace take
care of this -- just like we do for nf_defrag.
