Return-Path: <SRS0=WWTr=RS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1383FC43381
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Mar 2019 20:21:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA2D321871
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Mar 2019 20:21:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="ZpNFOYOH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbfCOUVv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 15 Mar 2019 16:21:51 -0400
Received: from mx1.riseup.net ([198.252.153.129]:58048 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbfCOUVv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 Mar 2019 16:21:51 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 3AAA51A0CF5;
        Fri, 15 Mar 2019 13:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1552681310; bh=CnBYwSdHFqJ8oGDRIagZGmcNivv02cCtM275l3Q+nBA=;
        h=Subject:To:References:Cc:From:Date:In-Reply-To:From;
        b=ZpNFOYOHzVfV7cdPvK4PB4Xvgy53Un+aj9T672d4mYxE5sKJ7tJbuxThtxFMBcOsL
         47UN47sNWyG0LcfFY9qgkAN2R8kIjpkEqDKnfzks4bdzYQfyNBhrswnXHI5ugdqtix
         YVdrUbAWPFe/WlYRX4uehtSbqce4uZC6WvJsVxPw=
X-Riseup-User-ID: CA53BC4E802DBB730737F0F762B8F8DEF53A57EF3D1F3870E68F13798AE2E5F5
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id BAC9B12077A;
        Fri, 15 Mar 2019 13:21:48 -0700 (PDT)
Subject: Re: [PATCH nft v2 1/6] osf: add version fingerprint support
To:     Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>
References: <20190314201309.iqdyb7icreyyhhke@salvia>
 <20190314200737.erhjrhoaciclapsn@salvia>
 <27D82259-F921-48E0-A718-A08E2BCCAACD@riseup.net>
 <20190315100333.GD3511@orbyte.nwl.cc>
 <20190315171328.c5xgazye2hattjxr@salvia>
Cc:     netfilter-devel@vger.kernel.org
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
Openpgp: preference=signencrypt
Message-ID: <1eb195ad-028e-5760-c4c8-1062441231c9@riseup.net>
Date:   Fri, 15 Mar 2019 21:21:56 +0100
MIME-Version: 1.0
In-Reply-To: <20190315171328.c5xgazye2hattjxr@salvia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On 3/15/19 6:13 PM, Pablo Neira Ayuso wrote:
> On Fri, Mar 15, 2019 at 11:03:33AM +0100, Phil Sutter wrote:
> [...]
>> On Thu, Mar 14, 2019 at 09:07:37PM +0100, Pablo Neira Ayuso wrote:
>> [...]
>>> The osf expression returns a string with the OS genre, and if thev
>>> version flag is set on, it appends the version to this string, ie.
>>> genre + version.
>>>
>>> This allows us to build maps, ie.
>>>
>>>         meta mark set osf genre { "linux" : 0x10, "windows" : 0x20, "macos" : 0x40 }
>>>
>>> But, with this new version, you could also do:
>>>
>>>         meta mark set osf genre { "linux::4.0" : 0x11, "linux::3.0" : 0x12, ...}
>>>
>>> and so on.
>>>
>>> So I see this version thing as a extended matching.
>>>
>>> The osf engine actually _already_ finds a precise matching, ie. genre
>>> + version, since the fingerprint is per genre + version. But you can
>>> just decide to match on the genre (eg. linux).
>>
>> The problem we're facing IMO is that nft_cmp is limited to a simple
>> memcmp(). This demands LHS to know what RHS contains. I'm not implying
>> it would be a good idea, but imagine nft_cmp could handle wildcards, we
>> could use "linux:*" to match on genre only, "linux:4.0:*" to match on
>> genre and version and even "linux:4.*" to match genre and major version
>> number.
>>
>> Actually we might be able to implement the above by setting 'len' field
>> correctly.
> 
> The wildcard at the end of the string already works out of the box
> via:
> 
>         iifname eth\*
> 
> The wildcard matching is generic, so it can be used from any string
> datatype, including the osf expression.
> 
>>>> Applying the same logic to osf expression, we would implement 'osf name
>>>> foo osf version 3.141' and add 'osf_try_merge()' routine to
>>>> 'rule_postprocess()' which tries to combine the two statements.
>>>> Obviously, this is quite a bit of extra work, not sure if feasible.
>>>
>>> I think the discussion here is the syntax, ie.
>>>
>>>         osf genre "Linux::4.10"
>>>
>>> vs.
>>>
>>>         osf genre "Linux" version "4.10"
>>>
>>> This only requires changes to the userspace nftables side, if you
>>> prefer this syntax, which is what I understand you would like to see,
>>> right?
>>
>> Not quite. I like how osf is an expression, not a statement. This makes
>> things like 'osf name != "Linux"' possible. What I didn't like was how
>> the proposed extension requires users to input redundant info:
>>
>> | osf name version "Linux:4.20"
>>
>> RHS contains the version number, so LHS should not need to have
>> "version" explicitly stated.
> 
> I see, then part of your discussion is focused on this syntax:
> 
>         osf name version "Linux:4.20"
> 
> in order to remove the "version" keyword there and make it more
> compact.
> 
>> On Thu, Mar 14, 2019 at 09:13:09PM +0100, Pablo Neira Ayuso wrote:
>> [...]
>>> I think we could even extend this later on to match things like:
>>>
>>> # Popular cluster config scripts disable timestamps and
>>> # selective ACK:
>>> S4:64:1:48:M1460,N,W0:          Linux:2.4:cluster:Linux 2.4 in cluster
>>>                                 ^^^^^^^^^^^^^^^^^
>>> Then, do:
>>>
>>>         os gente "Linux:2.4:cluster"
>>>
>>> by adding a new flag to match the "Subtype" field (according to the
>>> file description in pf.os).
>>
>> In an ideal world, we could match on any (combination of) fields in the
>> database. I am aware this is probably over-engineering. :)
> 
> We can probably achieve this with a more advance nft_cmp expression,
> that allows us to do some sort of limited regex matching. But I agree
> in that adding this only for the osf expression is probably too much.
> I don't like regex, they will use it for layer-7, and users do not
> understand the computational complexity of the regular expressions
> (they can easily ruin performance by adding a few expression that need
> to be search all over the packet payload).
> 
> Anyway, this is a different topic :-).

I agree with you about this. Using regex is too much in this case and
can ruin performance easily.

> 
>> What we could do though with little effort is to make use of the OS info
>> structure in database by making use of nft_cmp comparing only the first
>> 'len' bytes of data in registers. My idea would be that:
>>
>> * 'osf' expression always returns "full" data, i.e.: "OS:VER:SUB"
>> * nft_cmp compares that string to RHS up to RHS length
>>
>> So let's assume DB lookup returns "Windows:2003:AS:", then:
>>
>> osf name "Windows" -> match
>> osf name "Windows:" -> match
>> osf name "Windows:XP:" -> no match
>> osf name "Windows:2000:" -> no match
>> osf name "Windows:200" -> match
>>
>> So we have optional version match and even a poor-man's wildcard
>> functionality. Specifying the trailing semi-colon implicitly causes an
>> exact match on the last field.
>>
>> What do you think?
> 
> Hm, if we follow this path, this would need a bit more work, note
> that:
> 
> * nft userspace currently compares 16 bytes for the string case,
>   according to what I see via --debug=mnl.
> 
> * When the string is less than 16 bytes, it assumes it is a wildcard
>   matching and the end of the string.
> 
> * Kernel would need to inconditionally build the OS:version string.
> 
> * We may need to ask users to break existing osf ruleset so they
>   explicitly add the wildcard at the end, ie.
> 
>         osf name "Windows\*"
>         osf name "Linux:4.\*"
> 
> And the kernel would have no notion of what userspace is willing to
> match.

Following this path, IMO the users could have some problems with always
adding the wildcard at the end. I think that it is not natural to set
the wildcard at the end by default.

> 
> If the problem is the syntax, not the NFT_OSF_F_VERSION flags, we
> could explore this syntax:
> 
>         osf genre "Linux"
>         osf version "Linux:4.20"
> 
> then, in the future (if ever needed) add subtypes:
> 
>         osf subtype "Linux:2.4:cluster"
> 
> With flags in place, we would have a bit of knowledge of what the user
> is doing vs. matching part of a string.
> 
> Note that this would still allow you to do wildcard matching, ie:
> 
>         osf version "Linux:4.\*"
> 
> Thanks!
> 

I like more this solution, we can add an easily understandable
explanation about the usage of 'genre' and 'version' in the manual file.
Furthermore, this syntax is easy to extend if needed in the future as
Pablo said and it seems more natural to me.

We can hide the flags for the json support if needed by counting the
numbers of colons. Thanks! :-)
