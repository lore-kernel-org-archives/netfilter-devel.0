From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] arptables: disable dlfcn.h include
Date: Mon, 10 Nov 2014 18:41:28 +0100
Message-ID: <20141110174128.GA30063@salvia>
References: <1415452779-11721-1-git-send-email-gustavo@zacarias.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Gustavo Zacarias <gustavo@zacarias.com.ar>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46514 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753798AbaKJRjh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Nov 2014 12:39:37 -0500
Content-Disposition: inline
In-Reply-To: <1415452779-11721-1-git-send-email-gustavo@zacarias.com.ar>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Nov 08, 2014 at 10:19:39AM -0300, Gustavo Zacarias wrote:
> The relevant code is disabled in libarptc_incl.c so it's not required
> and breaks the ability to build it in a pure-static toolchain.
> 
> Signed-off-by: Gustavo Zacarias <gustavo@zacarias.com.ar>
> ---
>  arptables.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arptables.c b/arptables.c
> index 64ac3aa..fe270bc 100644
> --- a/arptables.c
> +++ b/arptables.c
> @@ -35,7 +35,9 @@
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <inttypes.h>
> +#if 0
>  #include <dlfcn.h>
> +#endif

Then please, remove it. Thanks.
