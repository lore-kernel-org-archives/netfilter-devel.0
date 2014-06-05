From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables PATCH v3] payload: Update the context only in equality
 relations
Date: Thu, 5 Jun 2014 16:57:08 +0200
Message-ID: <20140605145708.GA25197@localhost>
References: <1401270454-11669-1-git-send-email-alvaroneay@gmail.com>
 <1401720251-9041-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36744 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbaFEO5Q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:57:16 -0400
Content-Disposition: inline
In-Reply-To: <1401720251-9041-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 02, 2014 at 04:44:11PM +0200, Alvaro Neira Ayuso wrote:
> If we add this rule:
> 
> sudo nft add rule ip test input ip protocol != icmp
> 
> and we try to list the rules in the table test, nftables
> show this error:
> 
> nft: src/payload.c:76: payload_expr_pctx_update: Assertion `expr->op
> == OP_EQ' failed.
> 
> This patch change the function payload_match_postprocess for updating
> only the context in equality relations case.

Applied, thanks.
