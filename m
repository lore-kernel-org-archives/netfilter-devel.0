Return-Path: <SRS0=37vH=RQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF3E0C43381
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Mar 2019 14:15:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F40F214AE
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Mar 2019 14:15:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="Us5JOME2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbfCMOPr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Mar 2019 10:15:47 -0400
Received: from mx1.riseup.net ([198.252.153.129]:39422 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725895AbfCMOPq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Mar 2019 10:15:46 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id E7C5F1A03FC;
        Wed, 13 Mar 2019 07:15:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1552486546; bh=0WNy7z2xHsWTOeJ2TNtFlV1CacvQHyrKC6Vv4EnrhbE=;
        h=Subject:To:References:Cc:From:Date:In-Reply-To:From;
        b=Us5JOME2dlNxb+zY4vfm7jtnGKz9s8gs41tntmKGVeXVl1Aj9b7pt3sqzOeKOhcTj
         vS9vgsWZwXqdX8gtgAtENnYOcWWmiR5JNk98MGnJLeuea/dDRAGysu5BxJ+ZJfHzhz
         8NzEuG5S9Mz0TxBuU3H1KGCKWnKhQiDpSdzrs0T4=
X-Riseup-User-ID: 545CDC9AA2D78B1C05074210AFD2E92F34D74203280DBB3D538EE2EA682FC67E
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 7C145221BB0;
        Wed, 13 Mar 2019 07:15:44 -0700 (PDT)
Subject: Re: [PATCH nft v2 1/6] osf: add version fingerprint support
To:     Phil Sutter <phil@nwl.cc>
References: <20190311151417.17772-1-ffmancera@riseup.net>
 <20190313094424.GA11433@orbyte.nwl.cc>
 <b1d98d09-3cf7-3de1-1fb3-479244da560b@riseup.net>
 <20190313112733.GL4851@orbyte.nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
Openpgp: preference=signencrypt
Message-ID: <d71d6bf0-6371-8198-e07a-e454d27c6928@riseup.net>
Date:   Wed, 13 Mar 2019 15:15:51 +0100
MIME-Version: 1.0
In-Reply-To: <20190313112733.GL4851@orbyte.nwl.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



On 3/13/19 12:27 PM, Phil Sutter wrote:
> On Wed, Mar 13, 2019 at 11:14:04AM +0100, Fernando Fernandez Mancera wrote:
>> Hi Phil,
>>
>> On 3/13/19 10:44 AM, Phil Sutter wrote:
>>> Hi Fernando,
>>>
>>> On Mon, Mar 11, 2019 at 04:14:12PM +0100, Fernando Fernandez Mancera wrote:
>>>> Add support for version fingerprint in "osf" expression. Example:
>>>>
>>>> table ip foo {
>>>> 	chain bar {
>>>> 		type filter hook input priority filter; policy accept;
>>>> 		osf ttl skip name "Linux"
>>>> 		osf ttl skip name version "Linux:4.20"
>>>> 	}
>>>> }
>>>
>>> The syntax seems overly complicated to me, although I'm not really
>>> familiar with OSF so may lack background knowledge. Any reason why you
>>> didn't go with 'osf ttl skip name "Linux" version "4.20"' instead?
>>>
>>
>> You are right, 'osf ttl skip name "Linux" version "4.20"' was my first
>> thought but in compilation time the parser applies shift-reduce to the
>> expression.. I decided 'osf ttl skip name version "Linux:4.20"' to avoid
>> a complex workaround in the parser.
> 
> Shift/reduce warnings often require voodoo to fix, but it's not
> impossible. :)
> 
> Regarding my suggestion, I see that this string is actually the
> right-hand-side of a relational expression. To implement what I had in
> mind you would have to turn osf expression into a statement.
> 
>> The fingerprints database syntax is "genre:version:subtype:details" so
>> the nft 'osf' expression syntax is like the original one.
> 
> Can we deduce required flags from the given string on RHS? I.e. by
> looking at the amount of semi-colons and the number of characters
> between them? I'm assuming the syntax works like "genre::subtype" and
> "genre:::details" to omit certain parts, is that correct?
> 

Yes that is correct. We can do that if you think it is more suitable. Do
we all agree then?

>>> Also with regards to your patch to json_parser, I guess you should
>>> introduce an enum for flag values, something like:
>>>
>>> | enum osf_flags {
>>> | 	OSF_FLAG_INVALID = 0x0,
>>> | 	OSF_FLAG_VERSION = 0x1
>>> | };
>>> | 
>>> | const char *osf_flag_names[] = {
>>> | 	[OSF_VERSION] = "version"
>>> | };
>>>
>>> What do you think?
>>>
>>
>> This patch already introduces an enum for flags values, you can find it
>> below. Do you think we need another one? Sorry if I am misunderstanding
>> you. Thanks!
> 
> Oh, I missed that one. My concern is how the index of values in
> osf_flags array defined in osf_expr_json() and osf_flag_parse() is
> relevant although it doesn't seem so when only looking at the array
> definition.
> 

Yes, we can use it in osf_expr_json(). I am going to work in a v3 patch
series if it looks fine to you. Thanks!

> Cheers, Phil
> 
