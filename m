From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH -next] netfilter: bridge: rework reject handling
Date: Tue, 3 Mar 2015 02:12:40 +0100
Message-ID: <20150303011240.GB4286@salvia>
References: <1424109473-24078-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60321 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755104AbbCCBJM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Mar 2015 20:09:12 -0500
Content-Disposition: inline
In-Reply-To: <1424109473-24078-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 16, 2015 at 06:57:53PM +0100, Florian Westphal wrote:
> bridge reject handling is not straightforward, there are many subtle
> differences depending on configuration.
> 
> skb->dev is either the bridge port (PRE_ROUTING) or the bridge
> itself (INPUT), so we need to use indev instead.
> 
> Also, checksum validation will only work reliably if we trim skb
> according to the l3 header size.
> 
> While at it, add csum validation for ipv6 and skip existing tests
> if skb was already checked e.g. by GRO.

Also applied, thanks Florian.
