From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH] expr: queue: Use snprintf and
 SNPRINTF_BUFFER_SIZE in snprintf_default functions.
Date: Mon, 16 Jun 2014 12:15:53 +0200
Message-ID: <20140616101553.GA10598@localhost>
References: <1402909598-24943-1-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, arturo.borrero.glez@gmail.com
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49483 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755071AbaFPKP6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Jun 2014 06:15:58 -0400
Content-Disposition: inline
In-Reply-To: <1402909598-24943-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 16, 2014 at 11:06:37AM +0200, Ana Rey wrote:
> Code refactoring to use snprintf and SNPRINTF_BUFFER_SIZE in
> snprintf_default functions. Also, It adapts to the next syntax in queue
> (Added in
> http://git.netfilter.org/nftables/commit/?id=27619ffbe503ed4d9e59a02e81db9a7ac49d37af)
> 
> Here, some examples:
> 
> ip test input 31
>   [ queue num 3-5 bypass fanout]
> 
> ip test input 32 31
>   [ queue num 0]
> 
> ip test input 33 32
>   [ queue num 4]
> 
> ip test input 34 33
>   [ queue num 2-6 bypass]
> 
> table ip test {
> 	chain input {
> 		 type filter hook input priority 0;
> 		 queue num 3-5 bypass fanout
> 		 queue num 0
> 		 queue num 4
> 		 queue num 2-6 bypass
> 	}
> }

Applied, thanks Ana.
