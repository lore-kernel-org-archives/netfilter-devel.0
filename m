From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: Re: [PATCH v2] extensions: libxt_NFQUEUE: Add translation to nft
Date: Tue, 9 Feb 2016 14:21:36 +0530
Message-ID: <CAKHNQQEYd0eGF2NitQna=Mf_6P9vDzednumOuW5u1MUv-6wRQA@mail.gmail.com>
References: <20160207060721.GA11310@gmail.com> <20160207092504.GB32181@breakpoint.cc>
 <CAKHNQQGy8EDrMbPQb2Og_Dk8wf62GaeKq1zO+uz2UB6HbZ9hAQ@mail.gmail.com> <20160208092949.GC32181@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34898 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbcBIIwR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Feb 2016 03:52:17 -0500
Received: by mail-wm0-f68.google.com with SMTP id g62so2068571wme.2
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Feb 2016 00:52:17 -0800 (PST)
In-Reply-To: <20160208092949.GC32181@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 8, 2016 at 2:59 PM, Florian Westphal <fw@strlen.de> wrote:
> Shivani Bhardwaj <shivanib134@gmail.com> wrote:
>> On Sun, Feb 7, 2016 at 2:55 PM, Florian Westphal <fw@strlen.de> wrote:
>
>> > Seems this could be written similar to something like:
>> >
>> > if (info->flags & NFQ_FLAG_CPU_FANOUT) {
>> >         bool sep_needed = info->bypass & NFQ_FLAG_BYPASS;
>> >         xt_xlate_add(xl, "%sfanout ", sep_need ? "," : "");
>> > ...
>>
>> The pointer info used in both the versions (of NFQUEUE_xlate) is for
>> different structures. Sadly, this doesn't work as v3 structure doesn't
>> have a member for bypass field.
>
> Oh, right.  However bypass & flags overlap -- I think you could just use
> info->flags & NFQ_FLAG_BYPASS.
>
> If you look at NFQUEUE_parse_v3() it just calls NFQUEUE_parse_v2() with
> the v3 structure.

Yes, the code looks better now. Thanks a lot, Florian.
