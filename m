Return-Path: <SRS0=TDc5=UZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1953C48BD3
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jun 2019 21:11:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C551F2085A
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jun 2019 21:11:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbfFZVLf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Jun 2019 17:11:35 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:43576 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726227AbfFZVLf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Jun 2019 17:11:35 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hgFCX-0006Gn-LC; Wed, 26 Jun 2019 23:11:33 +0200
Date:   Wed, 26 Jun 2019 23:11:33 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Ander Juaristi <a@juaristi.eus>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2 5/7] nftables: meta: Some small style fixes
Message-ID: <20190626211133.ijifvft7hv3ygs64@breakpoint.cc>
References: <20190626204402.5257-1-a@juaristi.eus>
 <20190626204402.5257-5-a@juaristi.eus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190626204402.5257-5-a@juaristi.eus>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Ander Juaristi <a@juaristi.eus> wrote:
>  - Rename constants: TYPE_TIME_DATE, TYPE_TIME_HOUR, TYPE_TIME_DAY
>  - Use array_size()
>  - Rewrite __hour_type_print_r to get buffer size from a parameter

Thanks!  I think this can be squashed too.

> --- a/src/meta.c
> +++ b/src/meta.c
> @@ -475,7 +475,7 @@ static void day_type_print(const struct expr *expr, struct output_ctx *octx)
>  		"Saturday"
>  	};
>  	uint8_t daynum = mpz_get_uint8(expr->value),
> -		 numdays = sizeof(days) / (3 * 3);
> +		 numdays = array_size(days) - 1;
>  
>  	if (daynum >= 0 && daynum <= numdays)

This '- 1' had me confused, but then you use <= numdays.

Perhaps prefer array_size + "<" operator?

> @@ -505,7 +505,7 @@ static struct error_record *day_type_parse(const struct expr *sym,
>  		"Friday",
>  		"Saturday"
>  	};
> -	int daynum = -1, numdays = (sizeof(days) / 7) - 1;
> +	int daynum = -1, numdays = array_size(days);

... because here the - 1 is missing.

>  		if (cur_tm)
>  			seconds = (seconds + cur_tm->tm_gmtoff) % 86400;
>  
> -		__hour_type_print_r(0, 0, seconds, out);
> +		__hour_type_print_r(0, 0, seconds, out, sizeof(out));

Thanks for doing this.  I know its more code to read but it helps
when someone has to review this later as this got rid of magic
bufsize constants in the snprintf() calls.

>  	.byteorder = BYTEORDER_HOST_ENDIAN,
> -	.size = 8 * BITS_PER_BYTE,
> +	.size = sizeof(uint64_t) * BITS_PER_BYTE,

Thanks.
