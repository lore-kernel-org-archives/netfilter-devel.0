From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv2 lnf-log] utils: nf-log: attaching a conntrack
 information
Date: Fri, 16 Oct 2015 18:59:08 +0200
Message-ID: <20151016165908.GA5588@salvia>
References: <1441731291-21342-1-git-send-email-pablo@netfilter.org>
 <20150909095042.GA11843@gmail.com>
 <20150910000615.GB5734@salvia>
 <20150911030530.GA7380@gmail.com>
 <20150911031535.GG7380@gmail.com>
 <20151012152630.GC21781@salvia>
 <20151015043544.GA18814@gmail.com>
 <20151015043925.GB18814@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37013 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932554AbbJPQwG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Oct 2015 12:52:06 -0400
Content-Disposition: inline
In-Reply-To: <20151015043925.GB18814@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 15, 2015 at 01:39:25PM +0900, Ken-ichirou MATSUZAWA wrote:
> diff --git a/utils/nf-log.c b/utils/nf-log.c
> index 5f2a192..006d4b0 100644
> --- a/utils/nf-log.c
> +++ b/utils/nf-log.c
> @@ -3,15 +3,109 @@
>  #include <stdlib.h>
>  #include <arpa/inet.h>
>  
> -#include <linux/netfilter/nfnetlink_log.h>
> +#include <libnetfilter_log/linux_nfnetlink_log.h>
>  
>  #include <libmnl/libmnl.h>
>  #include <libnetfilter_log/libnetfilter_log.h>
>  
> +#include "../config.h"

I think you can update configure.ac to update CFLAGS, like this:

        CFLAGS="$CFLAGS -DBUILD_NFCT"

so we can skip this include.

I think it would be good if people can take the examples out of the
tree and compile them by hand through, eg.

        gcc -lnetfilter_log -lnetfilter_conntrack -lmnl -DBUILD_NFCT nf-log.c -o nf-log

Thanks.
