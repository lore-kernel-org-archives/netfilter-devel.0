Return-Path: <SRS0=aW9c=VA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69E99C46478
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jul 2019 00:43:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D1DB218AD
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jul 2019 00:43:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbfGCAno (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Jul 2019 20:43:44 -0400
Received: from mail.us.es ([193.147.175.20]:43628 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726736AbfGCAnn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Jul 2019 20:43:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C42948077C
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Jul 2019 01:26:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B2907DA4CA
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Jul 2019 01:26:51 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A7EDCDA732; Wed,  3 Jul 2019 01:26:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 97DDADA7B6;
        Wed,  3 Jul 2019 01:26:49 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 03 Jul 2019 01:26:49 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 6B0184265A31;
        Wed,  3 Jul 2019 01:26:49 +0200 (CEST)
Date:   Wed, 3 Jul 2019 01:26:49 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Ander Juaristi <a@juaristi.eus>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v4 1/4] meta: Introduce new conditions 'time', 'day' and
 'hour'
Message-ID: <20190702232649.tfpuy2pkrotxtkfm@salvia>
References: <20190701201646.7040-1-a@juaristi.eus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190701201646.7040-1-a@juaristi.eus>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jul 01, 2019 at 10:16:43PM +0200, Ander Juaristi wrote:
> diff --git a/include/nftables/libnftables.h b/include/nftables/libnftables.h
> index e39c588..87d4ff5 100644
> --- a/include/nftables/libnftables.h
> +++ b/include/nftables/libnftables.h
> @@ -52,6 +52,7 @@ enum {
>  	NFT_CTX_OUTPUT_NUMERIC_PROTO	= (1 << 7),
>  	NFT_CTX_OUTPUT_NUMERIC_PRIO     = (1 << 8),
>  	NFT_CTX_OUTPUT_NUMERIC_SYMBOL	= (1 << 9),
> +	NFT_CTX_OUTPUT_SECONDS          = (1 << 10),

I'd rename this to:

        NFT_CTX_OUTPUT_NUMERIC_TIME

>  	NFT_CTX_OUTPUT_NUMERIC_ALL	= (NFT_CTX_OUTPUT_NUMERIC_PROTO |
>  					   NFT_CTX_OUTPUT_NUMERIC_PRIO |
>  					   NFT_CTX_OUTPUT_NUMERIC_SYMBOL),

You have to update NFT_CTX_OUTPUT_NUMERIC_ALL.

> +static void day_type_print(const struct expr *expr, struct output_ctx *octx)
> +{
> +	const char *days[] = {
> +		"Sunday",
> +		"Monday",
> +		"Tuesday",
> +		"Wednesday",
> +		"Thursday",
> +		"Friday",
> +		"Saturday"

Probably print in short format?

        Sun
        Mon
        Tue
        Wed
        Thu
        Fri
        Sat

like 'date'.

> +	};
> +	uint8_t daynum = mpz_get_uint8(expr->value),

missing line break between variable definition and code.

> +		 numdays = array_size(days);
        ^^^^^^^^^

Unnecessary indentation.

> +
> +	if (daynum >= 0 && daynum < numdays)
> +		nft_print(octx, "\"%s\"", days[daynum]);
> +	else
> +		nft_print(octx, "Unknown day");
> +}
> +
> +static int parse_day_type_numeric(const char *sym)
> +{
> +	char c = *sym;
> +	return (c >= '0' && c <= '6') ?
> +		(c - '0') :
> +		-1;

Oh, I'd suggest:

        if (c >= '0' && c <= '6')
                return (c - '0');

        return -1;

> +}
> +
> +static struct error_record *day_type_parse(const struct expr *sym,
> +					   struct expr **res)
> +{
> +	const char *days[] = {
> +		"Sunday",
> +		"Monday",
> +		"Tuesday",
> +		"Wednesday",
> +		"Thursday",
> +		"Friday",
> +		"Saturday"
> +	};

Can you add a helper function to translate numeric day to literal? So
you don't need to define this again, probably:

        day_str = nft_day_str(day_num);

> +	int daynum = -1, numdays = array_size(days);
> +	int symlen = strlen(sym->identifier), daylen;
> +
> +	if (symlen < 3) {
> +		if (symlen == 1)
> +			daynum = parse_day_type_numeric(sym->identifier);
> +
> +		if (daynum >= 0)
> +			goto success;

goto for success path is discouraged.

Better if you use 'goto' to deal with error path.

> +
> +		return error(&sym->location, "Day name must be at least three characters long");
> +	}
> +
> +	for (int i = 0; i < numdays && daynum == -1; i++) {
> +		daylen = strlen(days[i]);
> +
> +		if (strncasecmp(sym->identifier,
> +				days[i],
> +				min(symlen, daylen)) == 0)
> +			daynum = i;
> +	}

Introduce a helper function to do this literal to numeric lookup?
