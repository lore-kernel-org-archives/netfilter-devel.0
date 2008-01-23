From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrack-utils PATCH r7285 04/11] added alarm_pending()
Date: Wed, 23 Jan 2008 12:50:05 +0100
Message-ID: <479729ED.6070904@netfilter.org>
References: <20080122141034.30077.12083.stgit@rabbit.intern.cm-ag> <20080122141051.30077.28791.stgit@rabbit.intern.cm-ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Max Kellermann <max@duempel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36743 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751071AbYAWLuT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jan 2008 06:50:19 -0500
In-Reply-To: <20080122141051.30077.28791.stgit@rabbit.intern.cm-ag>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Max Kellermann wrote:
> +int alarm_pending(struct alarm_list *alarm, struct timeval *tv)
> +{
> +	if (list_empty(&alarm->head))
> +		return 0;
> +
> +	if (tv != NULL)
> +		*tv = alarm->tv;

This introduces an extra copy.

> diff --git a/src/cache_timer.c b/src/cache_timer.c
> index 86bb8fc..a7afbe2 100644
> --- a/src/cache_timer.c
> +++ b/src/cache_timer.c
> @@ -60,8 +60,11 @@ static int timer_dump(struct us_conntrack *u, void *data, char *buf, int type)
>  	if (type == NFCT_O_XML)
>  		return 0;
>  
> +	if (!alarm_pending(alarm, &tmp))
> +		return 0;

I cannot think of a situation where alarm_pending returns true at the
moment.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
