From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 1/2 v2] evaluate: reject: check the context in reject
 without reason for bridge and inet tables
Date: Fri, 24 Oct 2014 12:04:14 +0200
Message-ID: <20141024100414.GA4806@salvia>
References: <1414085817-9059-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42256 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653AbaJXKCk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Oct 2014 06:02:40 -0400
Content-Disposition: inline
In-Reply-To: <1414085817-9059-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 23, 2014 at 07:36:56PM +0200, Alvaro Neira Ayuso wrote:
> In rules like:
> 
>   nft add rule inet filter input reject
> or
>   nft add rule bridge filter input reject
> 
> we use icmpx to reject it. But if we have network context, we also use type of
> reject. With this patch, we check the network context. If we don't have context,
> we still use icmpx. However, if we have rules with network context like:
> 
>   nft add rule inet meta nfproto ipv4 reject
> or
>   nft add rule bridge ether type ipv6 reject
> 
> We are going to use icmp or icmpv6 to reject it taking into account the network
> context.

Applied, thanks.
