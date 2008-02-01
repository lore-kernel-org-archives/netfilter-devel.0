From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD RFC 05/30] Add signalling subsystem
Date: Fri, 01 Feb 2008 04:46:02 +0100
Message-ID: <47A295FA.2040709@netfilter.org>
References: <20080130185847.693274384@kruemel.intranet.astaro.de> <20080130190127.013311819@kruemel.intranet.astaro.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, holger@eitzenberger.org
To: heitzenberger@astaro.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40625 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753903AbYBADqJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jan 2008 22:46:09 -0500
In-Reply-To: <20080130190127.013311819@kruemel.intranet.astaro.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

heitzenberger@astaro.com wrote:
> This patch adds the concept of synchronous and asynchronous signal
> handlers to ulogd, where 'synchronous' just means to be synchronous to
> the underlying IO multiplexer.

Interesting.

> Will later be used by plugins like SQLITE3 and NFCT.
> 
> One of the changes herein is the usage of the pthread library.  This
> is strictly necessary because some plugins might (and SQLITE3 *does*)
> use pthreads.
> Index: ulogd-netfilter/src/select.c
> ===================================================================
> --- ulogd-netfilter.orig/src/select.c
> +++ ulogd-netfilter/src/select.c
> @@ -23,6 +23,7 @@
>  
>  #include <fcntl.h>
>  #include <ulogd/ulogd.h>
> +#include <ulogd/common.h>
>  #include <ulogd/linuxlist.h>
>  
>  static int maxfd = 0;
> @@ -59,6 +60,7 @@ int ulogd_select_main()
>  {
>  	struct ulogd_fd *ufd;
>  	fd_set readset, writeset, exceptset;
> +	struct timeval tv = { .tv_sec = 1, };
>  	int i;
>  
>  	FD_ZERO(&readset);
> @@ -77,7 +79,13 @@ int ulogd_select_main()
>  			FD_SET(ufd->fd, &exceptset);
>  	}
>  
> -	i = select(maxfd+1, &readset, &writeset, &exceptset, NULL);
> + again:
> +	i = select(maxfd+1, &readset, &writeset, &exceptset, &tv);

Hm, why do we poll now every 1 second event even if there's nothing to do?

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
