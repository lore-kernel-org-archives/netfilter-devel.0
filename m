From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: Re: [PATCH] extensions: libxt_connlabel: Add translation to nft
Date: Mon, 7 Mar 2016 18:55:31 +0530
Message-ID: <CAKHNQQHe7_cRrtd9ChcVyaSmk0GhVUztxQ4Y2wubQsSoFbbmng@mail.gmail.com>
References: <20160305214746.GA16464@gmail.com> <20160306000703.GA31513@breakpoint.cc>
 <20160307130524.GA26624@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Florian Westphal <fw@strlen.de>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:35607 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbcCGN0L (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Mar 2016 08:26:11 -0500
Received: by mail-oi0-f41.google.com with SMTP id c203so78955259oia.2
        for <netfilter-devel@vger.kernel.org>; Mon, 07 Mar 2016 05:26:11 -0800 (PST)
In-Reply-To: <20160307130524.GA26624@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 7, 2016 at 6:35 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sun, Mar 06, 2016 at 01:07:03AM +0100, Florian Westphal wrote:
>> Shivani Bhardwaj <shivanib134@gmail.com> wrote:
>> > Add translation for connlabel to nftables.
>> > Full translation for this match awaits the support for --set option.
>>
>> Hmm, I sent patches for that a while ago, don't know why they were
>> not applied... Pablo?
>
> Please, push the the connlabel support to nft.
>
> We can probably introduce something like:
>
>         ct connlabel bitset bar
>
> instead of:
>
>         ct connlabel set ct connlabel | bar
>
> in a follow up patch, which looks more compact to me. We can accept
> both syntax I'd say so we can introduce this without breaking
> backward.

Should I be waiting for this or send a v2 with the existing options?
Please let me know.
Thanks.
