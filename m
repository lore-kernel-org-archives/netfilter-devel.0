From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD 03/15] Replace timer code by working version
Date: Sat, 02 Feb 2008 23:45:03 +0100
Message-ID: <47A4F26F.1090306@netfilter.org>
References: <20080202204826.267107164@astaro.com> <20080202205107.564972039@astaro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, holger@eitzenberger.org
To: heitzenberger@astaro.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42055 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752858AbYBBWpW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2008 17:45:22 -0500
In-Reply-To: <20080202205107.564972039@astaro.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

heitzenberger@astaro.com wrote:
> Replace existing timer code by simple and more importantly working
> version.  Current resolution is one second, which may be easily
> extended if need be.

I want to apply this patch since it fixes the current timer code.
Although I don't like it since setitimer() wakes up the daemon every 1
seconds even if there is nothing to do but OK, we can fix this later.

> @@ -59,6 +60,7 @@
>  {
>  	struct ulogd_fd *ufd;
>  	fd_set readset, writeset, exceptset;
> +	struct timeval tv = { .tv_sec = 1, };
>  	int i;
>  
>  	FD_ZERO(&readset);
> @@ -77,7 +79,13 @@
>  			FD_SET(ufd->fd, &exceptset);
>  	}
>  
> -	i = select(maxfd+1, &readset, &writeset, &exceptset, NULL);
> + again:
> +	i = select(maxfd+1, &readset, &writeset, &exceptset, &tv);
> +	if (i < 0) {
> +		if (errno == EINTR)
> +			goto again;
> +	}
> +

Hm, but why select also wakes up every 1 second? I'll continue applying
your patches when I get a reply on this (I cannot apply anyway since the
others depend on this).

BTW, this patch depends on 5/15. Please, your patches must compile
without dependencies.

$ make
[...]
/home/pablo/SVN-netfilter/branches/ulog/ulogd2/src/ulogd.c:835:
undefined reference to `ulogd_timer_check_n_run'

Holger Heitzenberger wrote:
> One of the changes herein is the usage of the pthread library.  This
> is strictly necessary because some plugins might (and SQLITE3 *does*)
> use pthreads.

I have grep the source code looking for pthread stuff but I didn't find
it, you mean that sqlite3 would need it in the future?

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
