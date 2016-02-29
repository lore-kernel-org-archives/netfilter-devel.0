From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: Re: [PATCH] src: netlink_delinearize: Fix datatype for len
Date: Mon, 29 Feb 2016 15:58:45 +0530
Message-ID: <CAKHNQQGJ3qS=gVHpoQCr+w7K9+FU7sypVOBS07KNFg=z9UAt8A@mail.gmail.com>
References: <20160228194043.GA15021@gmail.com> <20160229100632.GA7277@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:36508 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbcB2K30 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Feb 2016 05:29:26 -0500
Received: by mail-wm0-f41.google.com with SMTP id n186so42049822wmn.1
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Feb 2016 02:29:25 -0800 (PST)
In-Reply-To: <20160229100632.GA7277@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 29, 2016 at 3:36 PM, Florian Westphal <fw@strlen.de> wrote:
> Shivani Bhardwaj <shivanib134@gmail.com> wrote:
>> Change the data type of len from unsigned int to int in order to make
>> it valid for checks like
>>
>> if (len < 0)
>>
>> The issue was brought into attention by the unexplained behavior of
>> frag with frag-off. Bugzilla entry:
>> https://bugzilla.netfilter.org/show_bug.cgi?id=935
>>
>> This patch fixes this bug, however there are still issues with frag
>> that need to be fixed.
>
> exthdr (frag) seems to have several issues:
>
> - we should reject exthdr and only allow it with ipv6.
> - for inet/bridge, we should also inject ipv6 dependency
> - some exthdrs (frag for instance) have odd bit lengths
>   and need mask/shift instructions.
>
> For example, in your example rule we generate:
>    [ exthdr load 1b @ 44 + 2 => reg 1 ]
>    [ cmp eq reg 1 0x00002100 ]
>
> But thats not correct -- we truncated the load to one byte.
> Instead we should have loaded 2 bytes and then masked off the extra 3bits.
>
> I'll work on this.

In the chain this rule shows up as

chain input {
        type filter hook input priority 0; policy accept;
        frag unknown 0x0 [invalid type]
    }

This is also the case with some icmpv6 options (id and max-delay),
please take a note of this too.
Thanks.
