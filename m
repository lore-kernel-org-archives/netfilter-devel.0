Return-Path: <SRS0=MMpb=TO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BECEBC04AB4
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 May 2019 20:34:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8ABB320873
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 May 2019 20:34:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="PRMv7Idv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbfENUeK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 May 2019 16:34:10 -0400
Received: from mx1.riseup.net ([198.252.153.129]:60732 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726554AbfENUeJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 May 2019 16:34:09 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id BA5EF1A33B3;
        Tue, 14 May 2019 13:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1557866049; bh=jrtzb4HXMF/2k1YokU8I7zSrtuYKUhRmi8MVuAGettM=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=PRMv7IdvvEfUjywuO9DgIEJ1qt34UWjqSIDjiHUkWPh04N8EJiTj7MIhME66giGaK
         n4d/wTkfJzQXuYU6KP+a1HcK2VPaf869J42f1+x8cUS7FqVa0ywyw/Z2NHUxgVZjm5
         ssf4fU8+5/VESoTDLGi1yhp+g1teC/qenFXIfR9M=
X-Riseup-User-ID: 53CEE1D8ADA84B24A3DFB77ADB34F96B239901622936528017302E7ECB32305B
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 9E1B91207C9;
        Tue, 14 May 2019 13:34:07 -0700 (PDT)
Subject: Re: [PATCH 2/2 nft WIP v2] jump: Allow jump to a variable when using
 nft input files
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
References: <20190514152542.23406-1-ffmancera@riseup.net>
 <20190514152542.23406-2-ffmancera@riseup.net>
 <1772a0cf-6cd0-171f-8db0-038cd823ac9c@riseup.net>
 <20190514161719.GX4851@orbyte.nwl.cc>
 <f39036b3-e82f-f0e7-369f-472c9935849f@riseup.net>
 <20190514193154.GY4851@orbyte.nwl.cc>
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
Openpgp: preference=signencrypt
Message-ID: <0b32345d-f75e-f693-36c6-3d47f66c83f2@riseup.net>
Date:   Tue, 14 May 2019 22:34:20 +0200
MIME-Version: 1.0
In-Reply-To: <20190514193154.GY4851@orbyte.nwl.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



On 5/14/19 9:31 PM, Phil Sutter wrote:
> Hi Fernando,
> 
> On Tue, May 14, 2019 at 06:24:48PM +0200, Fernando Fernandez Mancera wrote:
>> Hi Phil,
>>
>> On 5/14/19 6:17 PM, Phil Sutter wrote:
>>> Hi Fernando,
>>>
>>> On Tue, May 14, 2019 at 05:43:39PM +0200, Fernando Fernandez Mancera wrote:
>>>> This last patch does not work. The first one works fine with a string as
>>>> chain name.
>>>>
>>> [...]
>>>> [...]
>>>> This error comes from symbol_parse() at expr_evaluate_symbol() after the
>>>> expr_evaluate() call added in the first patch.
>>>
>>> Yes, symbol_expr is used only for symbolic constants, therefore
>>> symbol_parse() is very restrictive.
>>>
>>> [...]>>> diff --git a/src/parser_bison.y b/src/parser_bison.y
>>>>> index 69b5773..42fd71f 100644
>>>>> --- a/src/parser_bison.y
>>>>> +++ b/src/parser_bison.y
>>>>> @@ -3841,7 +3841,13 @@ verdict_expr		:	ACCEPT
>>>>>  			}
>>>>>  			;
>>>>>  
>>>>> -chain_expr		:	identifier
>>>>> +chain_expr		:	variable_expr
>>>>> +			{
>>>>> +				$$ = symbol_expr_alloc(&@$, SYMBOL_VALUE,
>>>>> +						       current_scope(state),
>>>>> +						       $1->sym->identifier);
>>>>> +			}
>>>
>>> I didn't test it, but you can probably just drop the curly braces and
>>> everything inside here. 'variable_expr' already turns into an
>>> expression (a variable_expr, not symbol_expr), which is probably what
>>> you want.
>>>
>>
>> I tried that first and I got the same error. I have tried it again.. and
>> I am getting the same error.
>>
>> file.nft:1:15-17: Error: Can't parse symbolic netfilter verdict expressions
>> define dest = ber
>>               ^^^
> 
> OK, at least it didn't get worse. :)
> 
> I looked at the code and it seems you need to implement a 'parse'
> callback for struct verdict_type. I guess existing 'parse' callback in
> struct integer_type is a good example of how to do it - basically you
> need to convert the symbol expression into a constant expression.
> 
> Sorry if that's not much help, I'm not really familiar with these
> details. :)
> 

That is very useful! I can continue with this information, thanks! :-)

> Cheers, Phil
> 
