From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnetfilter_queue] libnetfilter_queue.h: Include
 <sys/time.h> for struct timeval
Date: Fri, 19 Jun 2015 12:13:03 +0200
Message-ID: <20150619101303.GA20799@salvia>
References: <20150616192304.GA3247@euler>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Felix Janda <felix.janda@posteo.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60802 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754565AbbFSKHl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Jun 2015 06:07:41 -0400
Content-Disposition: inline
In-Reply-To: <20150616192304.GA3247@euler>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Applied, thanks.

I also got rid of ...

On Tue, Jun 16, 2015 at 09:23:04PM +0200, Felix Janda wrote:
> Signed-off-by: Felix Janda <felix.janda@posteo.de>
> ---
>  include/libnetfilter_queue/libnetfilter_queue.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/libnetfilter_queue/libnetfilter_queue.h b/include/libnetfilter_queue/libnetfilter_queue.h
> index 8194a4f..10e15d8 100644
> --- a/include/libnetfilter_queue/libnetfilter_queue.h
> +++ b/include/libnetfilter_queue/libnetfilter_queue.h
> @@ -13,6 +13,7 @@
>  #ifndef __LIBCTNETLINK_H
>  #define __LIBCTNETLINK_H
>  
> +#include <sys/time.h>
>  #include <libnfnetlink/libnfnetlink.h>
>  // #include <libnfnetlink/liunx_nfnetlink.h>

this line above.
