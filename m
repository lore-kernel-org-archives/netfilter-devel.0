From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v2] netfilter: explicit module dependency between
 br_netfilter and physdev
Date: Thu, 2 Oct 2014 14:32:49 +0200
Message-ID: <20141002123249.GI1803@breakpoint.cc>
References: <1412253147-10025-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net, fw@strlen.de,
	stephen@networkplumber.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:39533 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752166AbaJBMcv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Oct 2014 08:32:51 -0400
Content-Disposition: inline
In-Reply-To: <1412253147-10025-1-git-send-email-pablo@netfilter.org>
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
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> Changes in v2: Remove module refcount, we don't need this. Suggested by Florian
> and Patrick.

Looks good, thanks Pablo!
