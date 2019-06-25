Return-Path: <SRS0=l45K=UY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C406DC4646B
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jun 2019 00:21:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2EB120644
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jun 2019 00:21:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbfFYAVa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 Jun 2019 20:21:30 -0400
Received: from mail.us.es ([193.147.175.20]:39326 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726395AbfFYAVa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Jun 2019 20:21:30 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 656DEC04A8
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jun 2019 02:21:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 558E6DA702
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jun 2019 02:21:28 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4B607DA703; Tue, 25 Jun 2019 02:21:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 20002DA702;
        Tue, 25 Jun 2019 02:21:26 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 25 Jun 2019 02:21:26 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id F0DB54265A2F;
        Tue, 25 Jun 2019 02:21:25 +0200 (CEST)
Date:   Tue, 25 Jun 2019 02:21:25 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Ander Juaristi <a@juaristi.eus>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 2/2] meta: hour: Fix integer overflow error
Message-ID: <20190625002125.k6yphdm2l3ne4k2u@salvia>
References: <20190623162544.11604-1-a@juaristi.eus>
 <20190623162544.11604-2-a@juaristi.eus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190623162544.11604-2-a@juaristi.eus>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Jun 23, 2019 at 06:25:44PM +0200, Ander Juaristi wrote:
> This patch fixes an overflow error that would happen when introducing edge times
> whose second representation is smaller than the value of the tm_gmtoff field, such
> as 00:00.

Please, send a v2 that includes a test for this to tests/py/

Thanks.

> Signed-off-by: Ander Juaristi <a@juaristi.eus>
> ---
>  src/meta.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/src/meta.c b/src/meta.c
> index 31a86b2..39e551c 100644
> --- a/src/meta.c
> +++ b/src/meta.c
> @@ -565,7 +565,7 @@ static void hour_type_print(const struct expr *expr, struct output_ctx *octx)
>  		cur_tm = localtime(&ts);
>  
>  		if (cur_tm)
> -			seconds += cur_tm->tm_gmtoff;
> +			seconds = (seconds + cur_tm->tm_gmtoff) % 86400;
>  
>  		__hour_type_print_r(0, 0, seconds, out);
>  		nft_print(octx, "\"%s\"", out);
> @@ -616,8 +616,12 @@ convert:
>  		result = tm.tm_hour * 3600 + tm.tm_min * 60 + tm.tm_sec;
>  
>  	/* Substract tm_gmtoff to get the current time */
> -	if (cur_tm)
> -		result -= cur_tm->tm_gmtoff;
> +	if (cur_tm) {
> +		if (result >= cur_tm->tm_gmtoff)
> +			result -= cur_tm->tm_gmtoff;
> +		else
> +			result = 86400 - cur_tm->tm_gmtoff + result;
> +	}
>  
>  success:
>  	*res = constant_expr_alloc(&sym->location, sym->dtype,
> -- 
> 2.17.1
> 
