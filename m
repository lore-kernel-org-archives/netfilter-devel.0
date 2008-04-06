From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 06/24] Fix all remaining warnings (missing declarations,
 missing prototypes)
Date: Sun, 06 Apr 2008 17:41:28 +0200
Message-ID: <47F8EF28.1000801@trash.net>
References: <1207495642-21055-1-git-send-email-jengelh@computergmbh.de> <d9e426312f2513c8d719a8ca65c50d3bde57a10b.1207495183.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37377 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbYDFPlT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Apr 2008 11:41:19 -0400
In-Reply-To: <d9e426312f2513c8d719a8ca65c50d3bde57a10b.1207495183.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> --- a/extensions/libip6t_LOG.c
> +++ b/extensions/libip6t_LOG.c
> @@ -269,6 +269,7 @@ static struct ip6tables_target log_target6 = {
>      .extra_opts    = LOG_opts,
>  };
>  
> +void _init(void);
>  void _init(void)
>  {
>  	register_target6(&log_target6);

I don't like this very much. A global prototype or simply using
__attribute__ ((constructor)) and __attribute__ ((destructor))
would be preferred.

