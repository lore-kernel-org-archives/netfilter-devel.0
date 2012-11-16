From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/3] [-stable] Netfilter updates for stable 3.6
Date: Fri, 16 Nov 2012 15:04:48 +0100
Message-ID: <20121116140448.GA10464@1984>
References: <1353074550-21456-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, stable@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36974 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590Ab2KPOEz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Nov 2012 09:04:55 -0500
Content-Disposition: inline
In-Reply-To: <1353074550-21456-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Nov 16, 2012 at 03:02:27PM +0100, pablo@netfilter.org wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> Hi!
> 
> Please, consider the following Netfilter patches for stable 3.6 and
> onwards inclusion.

The "onwards" is obviously a typo from the template I've used, these
are already in 3.7-rc :-)

> The selected three patches are:
> 
> 2ad5b9e netfilter: xt_TEE: don't use destination address found in header
> bbb5823 netfilter: nf_conntrack: fix rt_gateway checks for H.323 helper
> 0153d5a netfilter: xt_CT: fix timeout setting with IPv6 [REQUIRES: 236df00 netfilter: xt_CT: refactorize xt_ct_tg_check]
> 
> More relevantly, the first patch fix the TEE target, which is broken in 3.6.
> 
> Please, cherry-pick them. Thanks!
> 
> Eric Dumazet (1):
>   netfilter: xt_TEE: don't use destination address found in header
> 
> Julian Anastasov (1):
>   netfilter: nf_conntrack: fix rt_gateway checks for H.323 helper
> 
> Pablo Neira Ayuso (1):
>   netfilter: xt_CT: fix timeout setting with IPv6
> 
> --
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
