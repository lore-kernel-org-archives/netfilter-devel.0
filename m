From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH -next] netfilter: reduce sparse warnings
Date: Sat, 29 Aug 2015 00:37:59 +0200
Message-ID: <20150828223759.GA3609@salvia>
References: <1440713781-18260-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41617 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752852AbbH1Wbg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Aug 2015 18:31:36 -0400
Content-Disposition: inline
In-Reply-To: <1440713781-18260-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 28, 2015 at 12:16:21AM +0200, Florian Westphal wrote:
> bridge/netfilter/ebtables.c:290:26: warning: incorrect type in assignment (different modifiers)
> -> remove __pure annotation.
> 
> ipv6/netfilter/ip6t_SYNPROXY.c:240:27: warning: cast from restricted __be16
> -> switch ntohs to htons and vice versa.
> 
> netfilter/core.c:391:30: warning: symbol 'nfq_ct_nat_hook' was not declared. Should it be static?
> -> delete it, got removed
> 
> net/netfilter/nf_synproxy_core.c:221:48: warning: cast to restricted __be32
> -> Use __be32 instead of u32.
> 
> Tested with objdiff that these changes do not affect generated code.

Also applied, thanks.
