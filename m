From: mark diener <rpzrpzrpz@gmail.com>
Subject: Re: RFC: nft.8 review
Date: Tue, 20 Dec 2016 10:27:45 -0600
Message-ID: <CAChgv6pVKFz3fH5yGCA+8av84=c_2Ob25hy5AcTL=YLzw+n7Aw@mail.gmail.com>
References: <20161210102715.GA2955@orbyte.nwl.cc> <20161219235330.GA7565@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:32973 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933840AbcLTQ1r (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Dec 2016 11:27:47 -0500
Received: by mail-oi0-f46.google.com with SMTP id w63so183024507oiw.0
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Dec 2016 08:27:47 -0800 (PST)
In-Reply-To: <20161219235330.GA7565@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Will the V8 NFT have byte level protocol compatibility with current
linux kernel versions?

I am deployed on kernel  4.4.0-53-generic and would like to know when
structural defines like RTM_NEWADDR,NLM_F_REQUEST, etc become updated
or obsoleted.

As you can likely tell, I am not using libmnl or libnft but using
direct NETFILTER kernel calls.

What a challenge to scan the code and reverse-engineer the byte
sequences and understand the way the NFT virtual machine works in the
kernel.
















On Mon, Dec 19, 2016 at 5:53 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Hi Phil,
>
> On Sat, Dec 10, 2016 at 11:27:16AM +0100, Phil Sutter wrote:
>> Hi,
>>
>> I skimmed through nft man page and noted down problems I discovered.
>> While doing so, I got the idea to restructure the whole document for
>> better organization and comprehensibility but wanted to hear your
>> thoughts first before creating a ticket in netfilter BZ:
>>
>>
>> * Use BNF in synopses
>>
>> This is rudimentally used in the SYNOPSIS section already, but just
>> lists _cmd_ without explanation - although the fun is only about to
>> start at this point. :)
>>
>> What I really don't like is the syntax used in e.g. CHAINS section: it
>> is not only imprecise (nothing says you have to use 'priority <prio>'
>> but may not use 'table <table>', but also plain wrong when it comes to
>> the mandatory braces around the chain_block.
>
> Right, that needs a fix.
>
>> * Organize entity descriptions BNF-style
>>
>> In my opinion the order of (sub-)sections is a bit chaotic at times.
>> E.g. RULES section synopsis tries to explain how a rule is made up from
>> statements, but these are not explained before five sections later (not
>> counting the bogus BLA section ;).
>>
>> The idea here is to go from most generic to most specific, like things
>> are defined in yacc - just not as explicit, since if I want to know the
>> relation between concat_rhs_expr and shift_rhs_expr, I can just as well
>> read the code itself.
>>
>> * What about sub-pages?
>>
>> Looking at some expressions' descriptions, it seems like these might
>> grow exponentially with the documentation improving. So maybe it makes
>> sense to follow iptables' advice and have 'nft-extensions.8'? I would
>> have called it 'nft-statements.8' or 'nft-expressions.8' but the two are
>> too much intertwined to keep them separate.
>>
>> OK, maybe this can wait until nft.8 really has become awfully long.
>
> Yes, let's wait a bit for the split.
>
>> Comments, flame, donations highly appreciated, of course!
>
> Patches are very welcome!
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
