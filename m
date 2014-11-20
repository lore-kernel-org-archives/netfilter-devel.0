From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH] buffer: include stdarg header
Date: Thu, 20 Nov 2014 13:21:51 +0100
Message-ID: <20141120122151.GA11793@salvia>
References: <1416485757-27046-1-git-send-email-giuseppelng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45371 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbaKTMq3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Nov 2014 07:46:29 -0500
Content-Disposition: inline
In-Reply-To: <1416485757-27046-1-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Nov 20, 2014 at 01:15:57PM +0100, Giuseppe Longo wrote:
> This fixes the following warnings:
> 
> buffer.c: In function 'nft_buf_put':
> buffer.c:53:2: warning: implicit declaration of function 'va_start' [-Wimplicit-function-declaration]
>   va_start(ap, fmt);
>   ^
> buffer.c:56:2: warning: implicit declaration of function 'va_end' [-Wimplicit-function-declaration]
>   va_end(ap);
>   ^

Applied, thanks.
