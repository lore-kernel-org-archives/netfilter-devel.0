From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf-failover] [conntrack-utils PATCH r7254 02/14] remove duplicate
 init_alarm()	invocations
Date: Mon, 21 Jan 2008 00:57:45 +0100
Message-ID: <4793DFF9.1030103@netfilter.org>
References: <20080118104935.4444.26673.stgit@woodpecker.roonstrasse.net> <20080118105309.4444.74440.stgit@woodpecker.roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-failover@lists.netfilter.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Max Kellermann <max@duempel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42317 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754199AbYATX57 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jan 2008 18:57:59 -0500
In-Reply-To: <20080118105309.4444.74440.stgit@woodpecker.roonstrasse.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Max Kellermann wrote:
> diff --git a/src/sync-alarm.c b/src/sync-alarm.c
> index f605586..062c0b4 100644
> --- a/src/sync-alarm.c
> +++ b/src/sync-alarm.c
> @@ -49,7 +49,6 @@ static void cache_alarm_add(struct us_conntrack *u, void *data)
>  {
>  	struct alarm_list *alarm = data;
>  
> -	init_alarm(alarm, u, refresher);

I guess that you wanted to remove init_alarm() from refresher() instead.
Fixed and applied. Thanks.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
