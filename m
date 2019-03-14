Return-Path: <SRS0=rsEJ=RR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95EC7C43381
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Mar 2019 11:14:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5540C2087C
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Mar 2019 11:14:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="LFm9JSoP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727425AbfCNLOT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 14 Mar 2019 07:14:19 -0400
Received: from mx1.riseup.net ([198.252.153.129]:37298 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727420AbfCNLOT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 Mar 2019 07:14:19 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 4D83F1A16A7;
        Thu, 14 Mar 2019 04:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1552562058; bh=gmIV2DqaJYELE6fF0EpmEgKxWhbCNQlHjCo0tjmDLYA=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To:From;
        b=LFm9JSoPkeD+DSYA4jQD2bFm57ucLp605V1m1U52bp1Wu32roqBU/uv6/XbraDUp7
         zvGFVZVMHZXd/wYDE/O6/YQjJqcxJnHHf61POdCJkmqd5hawJXSEo46iJtItmFaSSf
         RAH7TCyr56A5rD1ua37/UZh8fg3dsQEE8fRH2xSc=
X-Riseup-User-ID: A3037F7AF2358D2C58F7BA0C7FF1A10C78B57D363163C2E90BA12AA4BC52250E
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id F3F3E224379;
        Thu, 14 Mar 2019 04:14:16 -0700 (PDT)
Subject: Re: [PATCH nft v2 1/6] osf: add version fingerprint support
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <20190311151417.17772-1-ffmancera@riseup.net>
 <20190313094424.GA11433@orbyte.nwl.cc>
 <b1d98d09-3cf7-3de1-1fb3-479244da560b@riseup.net>
 <20190313112733.GL4851@orbyte.nwl.cc>
 <d71d6bf0-6371-8198-e07a-e454d27c6928@riseup.net>
 <20190313150634.GM4851@orbyte.nwl.cc>
 <2b070950-1441-ae1b-fe52-72dc7bc4455e@riseup.net>
 <20190313153455.GN4851@orbyte.nwl.cc>
 <fa72537e-adf8-29fb-6b8b-ebe30cd9bfc6@riseup.net>
Openpgp: preference=signencrypt
Message-ID: <e61257f6-4281-d450-0f41-6891a8744e96@riseup.net>
Date:   Thu, 14 Mar 2019 12:14:23 +0100
MIME-Version: 1.0
In-Reply-To: <fa72537e-adf8-29fb-6b8b-ebe30cd9bfc6@riseup.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

I have been thinking more about this today. I don't know how access to
the right-hand-side string from the kernel if it is possible. Sorry if
the question is very dumb, but I may lack experience with the nft
registers and RHS data of an expression.

Thanks!

On 3/13/19 5:46 PM, Fernando Fernandez Mancera wrote:
> On 3/13/19 4:34 PM, Phil Sutter wrote:
>> On Wed, Mar 13, 2019 at 04:22:27PM +0100, Fernando Fernandez Mancera wrote:
>>> On 3/13/19 4:06 PM, Phil Sutter wrote:
>>>> Hi Fernando,
>>>>
>>>> On Wed, Mar 13, 2019 at 03:15:51PM +0100, Fernando Fernandez Mancera wrote:
>>>>> On 3/13/19 12:27 PM, Phil Sutter wrote:
>>>>>> On Wed, Mar 13, 2019 at 11:14:04AM +0100, Fernando Fernandez Mancera wrote:
>>>>>>> Hi Phil,
>>>>>>>
>>>>>>> On 3/13/19 10:44 AM, Phil Sutter wrote:
>>>>>>>> Hi Fernando,
>>>>>>>>
>>>>>>>> On Mon, Mar 11, 2019 at 04:14:12PM +0100, Fernando Fernandez Mancera wrote:
>>>>>>>>> Add support for version fingerprint in "osf" expression. Example:
>>>>>>>>>
>>>>>>>>> table ip foo {
>>>>>>>>> 	chain bar {
>>>>>>>>> 		type filter hook input priority filter; policy accept;
>>>>>>>>> 		osf ttl skip name "Linux"
>>>>>>>>> 		osf ttl skip name version "Linux:4.20"
>>>>>>>>> 	}
>>>>>>>>> }
>>>>>>>>
>>>>>>>> The syntax seems overly complicated to me, although I'm not really
>>>>>>>> familiar with OSF so may lack background knowledge. Any reason why you
>>>>>>>> didn't go with 'osf ttl skip name "Linux" version "4.20"' instead?
>>>>>>>>
>>>>>>>
>>>>>>> You are right, 'osf ttl skip name "Linux" version "4.20"' was my first
>>>>>>> thought but in compilation time the parser applies shift-reduce to the
>>>>>>> expression.. I decided 'osf ttl skip name version "Linux:4.20"' to avoid
>>>>>>> a complex workaround in the parser.
>>>>>>
>>>>>> Shift/reduce warnings often require voodoo to fix, but it's not
>>>>>> impossible. :)
>>>>>>
>>>>>> Regarding my suggestion, I see that this string is actually the
>>>>>> right-hand-side of a relational expression. To implement what I had in
>>>>>> mind you would have to turn osf expression into a statement.
>>>>>>
>>>>>>> The fingerprints database syntax is "genre:version:subtype:details" so
>>>>>>> the nft 'osf' expression syntax is like the original one.
>>>>>>
>>>>>> Can we deduce required flags from the given string on RHS? I.e. by
>>>>>> looking at the amount of semi-colons and the number of characters
>>>>>> between them? I'm assuming the syntax works like "genre::subtype" and
>>>>>> "genre:::details" to omit certain parts, is that correct?
>>>>>>
>>>>>
>>>>> Yes that is correct. We can do that if you think it is more suitable. Do
>>>>> we all agree then?
>>>>
>>>> I think reducing redundancy is always a good thing. Only having to
>>>> specify the string and extracting the required info from it would make
>>>> it easier for users I guess.
>>>>
>>>> That whole string is sent to the kernel, right? So it wouldn't make
>>>> sense to split the fields it is made up from into separate properties in
>>>> JSON, correct?
>>>>
>>>> Thanks, Phil
>>>>
>>>
>>> Yes, that makes sense. In this case, we don't need flags support anymore
>>> so it reduces the patch series. Should we continue with the
>>> implementation of the flags support or just forget about it until needed
>>> again?
>>
>> What other flags do you have in mind?
>>
>> Cheers, Phil
>>
> 
> Maybe in the future we could need them for logging. But we can ignore it
> right now.
> 
