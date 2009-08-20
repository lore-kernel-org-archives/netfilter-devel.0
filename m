From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/4] length: support semi-infinite length description
Date: Thu, 20 Aug 2009 17:12:43 +0200
Message-ID: <4A8D67EB.9080304@trash.net>
References: <1250780978-14013-1-git-send-email-jengelh@medozas.de> <1250780978-14013-2-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48556 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468AbZHTPMp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Aug 2009 11:12:45 -0400
In-Reply-To: <1250780978-14013-2-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> The code is already there, it just was not documented. Also use
> UINT16_MAX instead and pretty-print iptables's -L/-S output.
> 
> @@ -97,9 +97,11 @@ length_print(const void *ip, const struct xt_entry_match *match, int numeric)
>  
>  	printf("length %s", info->invert ? "!" : "");
>  	if (info->min == info->max)
> -		printf("%u ", info->min);
> +		printf("== %u ", info->min);
> +	else if (info->max == UINT16_MAX)
> +		printf(">= %u ", info->min);
>  	else
> -		printf("%u:%u ", info->min, info->max);
> +		printf("%u..%u ", info->min, info->max);

I prefer to keep using ":", this is what we use everywhere else for
ranges.
