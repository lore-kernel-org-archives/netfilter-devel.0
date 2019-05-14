Return-Path: <SRS0=MMpb=TO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74C3AC04AB4
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 May 2019 16:24:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2BBCF2085A
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 May 2019 16:24:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="Qg0iXOTl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726025AbfENQYg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 May 2019 12:24:36 -0400
Received: from mx1.riseup.net ([198.252.153.129]:41508 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725980AbfENQYg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 May 2019 12:24:36 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 188671A3467;
        Tue, 14 May 2019 09:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1557851076; bh=w/Rl8P6U72dn1/bcIlASHizcB0OownkotW7JDz+hZ0Y=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=Qg0iXOTli4j4YPERwtkc7fmoI99iD7TLLjs6FQDX4QGKwW7EF7Ekp6KFCuwYzYXNW
         BgbwGbWYP+KCfZUtFSswMcZZD3x45WKJPM5PkKyOtWamWM3vb95UtBdQV0buJ/g63r
         rQqkXrZcrhZR8vWmwhnMAMbMQfcYC6RVbmr+J6bc=
X-Riseup-User-ID: 0F2C1FE95DDB47855B59929B2B9A5EF271837F3A61394392AA73E690D7E548FB
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 42B6F221C17;
        Tue, 14 May 2019 09:24:35 -0700 (PDT)
Subject: Re: [PATCH 2/2 nft WIP v2] jump: Allow jump to a variable when using
 nft input files
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
References: <20190514152542.23406-1-ffmancera@riseup.net>
 <20190514152542.23406-2-ffmancera@riseup.net>
 <1772a0cf-6cd0-171f-8db0-038cd823ac9c@riseup.net>
 <20190514161719.GX4851@orbyte.nwl.cc>
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
Openpgp: preference=signencrypt
Message-ID: <f39036b3-e82f-f0e7-369f-472c9935849f@riseup.net>
Date:   Tue, 14 May 2019 18:24:48 +0200
MIME-Version: 1.0
In-Reply-To: <20190514161719.GX4851@orbyte.nwl.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

On 5/14/19 6:17 PM, Phil Sutter wrote:
> Hi Fernando,
> 
> On Tue, May 14, 2019 at 05:43:39PM +0200, Fernando Fernandez Mancera wrote:
>> This last patch does not work. The first one works fine with a string as
>> chain name.
>>
> [...]
>> [...]
>> This error comes from symbol_parse() at expr_evaluate_symbol() after the
>> expr_evaluate() call added in the first patch.
> 
> Yes, symbol_expr is used only for symbolic constants, therefore
> symbol_parse() is very restrictive.
> 
> [...]>>> diff --git a/src/parser_bison.y b/src/parser_bison.y
>>> index 69b5773..42fd71f 100644
>>> --- a/src/parser_bison.y
>>> +++ b/src/parser_bison.y
>>> @@ -3841,7 +3841,13 @@ verdict_expr		:	ACCEPT
>>>  			}
>>>  			;
>>>  
>>> -chain_expr		:	identifier
>>> +chain_expr		:	variable_expr
>>> +			{
>>> +				$$ = symbol_expr_alloc(&@$, SYMBOL_VALUE,
>>> +						       current_scope(state),
>>> +						       $1->sym->identifier);
>>> +			}
> 
> I didn't test it, but you can probably just drop the curly braces and
> everything inside here. 'variable_expr' already turns into an
> expression (a variable_expr, not symbol_expr), which is probably what
> you want.
> 

I tried that first and I got the same error. I have tried it again.. and
I am getting the same error.

file.nft:1:15-17: Error: Can't parse symbolic netfilter verdict expressions
define dest = ber
              ^^^

Thanks! :-)
>>> +			|	identifier
>>>  			{
>>>  				$$ = constant_expr_alloc(&@$, &string_type,
>>>  							 BYTEORDER_HOST_ENDIAN,
>>>
>>
> 
> Cheers, Phil
> 
