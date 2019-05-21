Return-Path: <SRS0=lkya=TV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39956C04AAF
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 May 2019 19:38:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 09DA321019
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 May 2019 19:38:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="ffwEEF8F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727697AbfEUTiL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 May 2019 15:38:11 -0400
Received: from mx1.riseup.net ([198.252.153.129]:58408 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726771AbfEUTiL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 May 2019 15:38:11 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 677781A0681;
        Tue, 21 May 2019 12:38:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1558467490; bh=h8NDYgjitu3hI6eSjprCc0dh2mG8jm1qzPRh2ebRUbg=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=ffwEEF8Fb/YEeseJVuqfVbBQJ/5n8QI3tUitw7frg1QKulaF38YyIAWu41uiLEdRx
         lzHrxQTVv2I1Ccwelq4elvw3Cqv12kkc4tq/bNVRgGemcBrqhdTy/0yKEqUtZcHvga
         EQYpsBo53cCWav4uFr/NjSAvsuxyM0BuPkGz5S4g=
X-Riseup-User-ID: 973CF9478F48916BDCB54D8CCC25C8174F78F7F35FF68E501F476E3DC3434C92
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id A7C9512056F;
        Tue, 21 May 2019 12:38:09 -0700 (PDT)
Subject: Re: [PATCH nft v3 1/2] jump: Introduce chain_expr in jump and goto
 statements
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <20190516204559.28910-1-ffmancera@riseup.net>
 <20190521092837.vd3egt54lvdhynqi@salvia>
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
Openpgp: preference=signencrypt
Message-ID: <1ff8b9ea-ce19-301f-e683-790417a179a7@riseup.net>
Date:   Tue, 21 May 2019 21:38:16 +0200
MIME-Version: 1.0
In-Reply-To: <20190521092837.vd3egt54lvdhynqi@salvia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On 5/21/19 11:28 AM, Pablo Neira Ayuso wrote:
> On Thu, May 16, 2019 at 10:45:58PM +0200, Fernando Fernandez Mancera wrote:
>> Now we can introduce expressions as a chain in jump and goto statements. This
>> is going to be used to support variables as a chain in the following patches.
> 
> Something is wrong with json:
> 
> json.c: In function ‘verdict_expr_json’:
> json.c:683:11: warning: assignment from incompatible pointer type
> [-Wincompatible-pointer-types]
>      chain = expr->chain;
>            ^
> parser_json.c: In function ‘json_parse_verdict_expr’:
> parser_json.c:1086:8: warning: passing argument 3 of
> ‘verdict_expr_alloc’ from incompatible pointer type
> [-Wincompatible-pointer-types]
>         chain ? xstrdup(chain) : NULL);
>         ^~~~~
> 
> Most likely --enable-json missing there.
> 

Sorry, I am going to fix that.

>  diff --git a/src/datatype.c b/src/datatype.c
>> index ac9f2af..10f185b 100644
>> --- a/src/datatype.c
>> +++ b/src/datatype.c
>> @@ -254,6 +254,8 @@ const struct datatype invalid_type = {
>>  
>>  static void verdict_type_print(const struct expr *expr, struct output_ctx *octx)
>>  {
>> +	char chain[NFT_CHAIN_MAXNAMELEN];
>> +
>>  	switch (expr->verdict) {
>>  	case NFT_CONTINUE:
>>  		nft_print(octx, "continue");
>> @@ -262,10 +264,26 @@ static void verdict_type_print(const struct expr *expr, struct output_ctx *octx)
>>  		nft_print(octx, "break");
>>  		break;
>>  	case NFT_JUMP:
>> -		nft_print(octx, "jump %s", expr->chain);
>> +		if (expr->chain->etype == EXPR_VALUE) {
>> +			mpz_export_data(chain, expr->chain->value,
>> +					BYTEORDER_HOST_ENDIAN,
>> +					NFT_CHAIN_MAXNAMELEN);
>> +			nft_print(octx, "jump %s", chain);
>> +		} else {
>> +			nft_print(octx, "jump ");
>> +			expr_print(expr->chain, octx);
>> +		}
> 
> I think this should be fine:
> 
>         case NFT_JUMP:
> 		nft_print(octx, "jump ");
> 		expr_print(expr->chain, octx);
>                 break;
> 
> Any reason to have the 'if (expr->chain->etype == EXPR_VALUE) {'
> check?
> 

Yes, without this check the list ruleset is slightly different when
using variables.

table ip foo {
	chain bar {
		type filter hook input priority filter; policy accept;
		jump "ber"
	}

	chain ber {
		counter packets 45 bytes 3132
	}
}

Please, note the quote marks in the jump statement. If we don't want to
check that, we need to change all the tests that involve jumps (about 12).

Thanks!

>>  		break;
>>  	case NFT_GOTO:
>> -		nft_print(octx, "goto %s", expr->chain);
>> +		if (expr->chain->etype == EXPR_VALUE) {
>> +			mpz_export_data(chain, expr->chain->value,
>> +					BYTEORDER_HOST_ENDIAN,
>> +					NFT_CHAIN_MAXNAMELEN);
>> +			nft_print(octx, "goto %s", chain);
>> +		} else {
>> +			nft_print(octx, "goto ");
>> +			expr_print(expr->chain, octx);
> 
> Same thing here.
> 
> Apart from those nitpicks, this looks good :)
> 
