From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 3/4 v2] delinearize: list the icmpx reason with the
 string associated
Date: Fri, 17 Oct 2014 14:58:20 +0200
Message-ID: <20141017125820.GD3644@salvia>
References: <1413548677-10287-1-git-send-email-alvaroneay@gmail.com>
 <1413548677-10287-3-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33872 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939AbaJQM4v (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Oct 2014 08:56:51 -0400
Content-Disposition: inline
In-Reply-To: <1413548677-10287-3-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 17, 2014 at 02:24:36PM +0200, Alvaro Neira Ayuso wrote:
> If you add the rule:
>   nft add rule inet filter input reject with icmpx type host-unreachable
>   nft list table inet filter
> 
> shows:
>   table inet filter {
> 	chain input {
> 		reject with icmpx type 2
> 	}
>   }

Applied, thanks.
