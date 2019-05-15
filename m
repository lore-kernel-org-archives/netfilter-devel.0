Return-Path: <SRS0=H0Uh=TP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CBA0C04E53
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 May 2019 11:01:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5835216FD
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 May 2019 11:01:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="A4S/8h2i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbfEOLBy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 May 2019 07:01:54 -0400
Received: from mx1.riseup.net ([198.252.153.129]:34534 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727788AbfEOLBx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 May 2019 07:01:53 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 2DABA1A33BB;
        Wed, 15 May 2019 04:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1557918113; bh=5iNfO5BCbbWNwWPCxu6vw75oqCusV1+DMzSO/CkCchA=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=A4S/8h2iM5TMMqAYKIroJe2AK/zVorLLgqlkRF2zdUfarM+kBnnyJxKaW1IOfTl2J
         NNtqPB1xx89DbX+NrXq/Nbx5lU3HboXlwmMsxlPCZHNC7qc/2zUL9JhyT5kqWwFZQ+
         geJmSQptovxXoDEATEYQN9vQOtsrewmLdfGmqCLg=
X-Riseup-User-ID: 3A96ADDB5F6FF8D84CAEB9767B9D58C5F6AC1BBC23D1C93720A559119C05626A
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 79EF21207C9;
        Wed, 15 May 2019 04:01:52 -0700 (PDT)
Subject: Re: [PATCH 2/2 nft] jump: Allow goto and jump to a variable using nft
 input files
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
References: <20190514211340.913-1-ffmancera@riseup.net>
 <20190514211340.913-2-ffmancera@riseup.net>
 <20190515105850.GA4851@orbyte.nwl.cc>
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
Openpgp: preference=signencrypt
Message-ID: <347917dc-086b-998c-dd2f-b5e4a87b38b1@riseup.net>
Date:   Wed, 15 May 2019 13:02:05 +0200
MIME-Version: 1.0
In-Reply-To: <20190515105850.GA4851@orbyte.nwl.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



On 5/15/19 12:58 PM, Phil Sutter wrote:
> Hey,
> 
> On Tue, May 14, 2019 at 11:13:40PM +0200, Fernando Fernandez Mancera wrote:
> [...]
>> diff --git a/src/datatype.c b/src/datatype.c
>> index 6aaf9ea..7e9ec5e 100644
>> --- a/src/datatype.c
>> +++ b/src/datatype.c
>> @@ -297,11 +297,22 @@ static void verdict_type_print(const struct expr *expr, struct output_ctx *octx)
>>  	}
>>  }
>>  
>> +static struct error_record *verdict_type_parse(const struct expr *sym,
>> +					       struct expr **res)
>> +{
>> +	*res = constant_expr_alloc(&sym->location, &string_type,
>> +				   BYTEORDER_HOST_ENDIAN,
>> +				   (strlen(sym->identifier) + 1) * BITS_PER_BYTE,
>> +				   sym->identifier);
>> +	return NULL;
>> +}
> 
> One more thing: The above lacks error checking of any kind. I *think*
> this is the place where one should make sure the symbol expression is
> actually a string (but I'm not quite sure how you do that).
> 
> In any case, please try to exploit that variable support in the testcase
> (or maybe a separate one), just to make sure we don't allow weird
> things.
> 

I think I can get the symbol type and check if it is a string. I will
check this on the testcase as you said. Thanks!

> Thanks, Phil
> 
