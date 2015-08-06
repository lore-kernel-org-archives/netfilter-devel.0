From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 6/6] netfilter: nft_limit: add per-byte limiting
Date: Thu, 6 Aug 2015 11:01:09 +0200
Message-ID: <20150806090109.GA3843@salvia>
References: <1438771124-3650-1-git-send-email-pablo@netfilter.org>
 <1438771124-3650-6-git-send-email-pablo@netfilter.org>
 <20150805104353.GA23224@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44345 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752956AbbHFIzH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Aug 2015 04:55:07 -0400
Content-Disposition: inline
In-Reply-To: <20150805104353.GA23224@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 05, 2015 at 12:43:54PM +0200, Patrick McHardy wrote:
> On 05.08, Pablo Neira Ayuso wrote:
> > This patch adds a new NFTA_LIMIT_TYPE netlink attribute to indicate the type of
> > limiting.
> > 
> > Contrary to per-packet limiting, the cost is calculated from the packet path
> > since this depends on the packet length.
> > 
> > The burst attribute indicates the number of bytes in which the rate can be
> > exceeded.
> 
> Thanks Pablo, I appreciate this rework. Just a suggestion, I'd propose to
> use NFT_LIMIT_PKT_LENGTH instead of LIMIT_BYTES. I expect we might want to
> add other limit types like connection rates etc in the future.

Thanks Patrick. I'll rename this to a mixture of both: PKT_BYTES :)
