From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables PATCH] listing: only display wanted chain
Date: Tue, 19 Nov 2013 21:32:16 +0100
Message-ID: <20131119203216.GA5118@localhost>
References: <1384760421-4238-1-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45526 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334Ab3KSUcV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Nov 2013 15:32:21 -0500
Content-Disposition: inline
In-Reply-To: <1384760421-4238-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 18, 2013 at 08:40:21AM +0100, Eric Leblond wrote:
> When specifying a chain to list, all created chains were displayed
> with a void content:
> 
>  # nft list chain filter
>  table ip filter {
>   	chain input {
>   	}
> 
>   	chain new {
>   		 counter packets 17971 bytes 2380637 accept
>   		 counter packets 0 bytes 0 accept
>   	}
>   }
> 
> With the attached patch, only the asked chain is displayed:
> 
>   # nft list chain filter
>   table ip filter {
>   	chain new {
>   		 counter packets 17971 bytes 2380637 accept # handle 36
>   		 counter packets 0 bytes 0 accept # handle 40
>   	}
>   }

Also applied, thanks.
