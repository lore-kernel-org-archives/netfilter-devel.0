From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH -next] nftables: nft_payload: work around vlan header
 stripping
Date: Wed, 19 Aug 2015 20:43:48 +0200
Message-ID: <20150819184348.GA3746@salvia>
References: <1439827795-7195-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41744 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbbHSShp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Aug 2015 14:37:45 -0400
Content-Disposition: inline
In-Reply-To: <1439827795-7195-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 17, 2015 at 06:09:55PM +0200, Florian Westphal wrote:
> make payload expression aware of the fact that VLAN offload may have
> removed a vlan header.
> 
> When we encounter tagged skb, transparently insert the tag into the
> register so that vlan header matching can work without userspace being
> aware of offload features.

Applied, thanks Florian.
