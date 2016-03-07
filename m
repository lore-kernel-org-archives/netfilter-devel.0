From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: Re: [PATCH] extensions: libxt_connlabel: Add translation to nft
Date: Mon, 7 Mar 2016 19:03:46 +0530
Message-ID: <CAKHNQQHoMCy79sGPXjgYpxVBz0hz-2+hrnuOWiSdRpXY+eXQOA@mail.gmail.com>
References: <20160305214746.GA16464@gmail.com> <20160306000703.GA31513@breakpoint.cc>
 <20160307130524.GA26624@salvia> <CAKHNQQHe7_cRrtd9ChcVyaSmk0GhVUztxQ4Y2wubQsSoFbbmng@mail.gmail.com>
 <20160307133214.GA27010@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Florian Westphal <fw@strlen.de>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:33014 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbcCGNe0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Mar 2016 08:34:26 -0500
Received: by mail-ob0-f172.google.com with SMTP id fz5so105272277obc.0
        for <netfilter-devel@vger.kernel.org>; Mon, 07 Mar 2016 05:34:26 -0800 (PST)
In-Reply-To: <20160307133214.GA27010@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 7, 2016 at 7:02 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, Mar 07, 2016 at 06:55:31PM +0530, Shivani Bhardwaj wrote:
>> On Mon, Mar 7, 2016 at 6:35 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> > On Sun, Mar 06, 2016 at 01:07:03AM +0100, Florian Westphal wrote:
>> >> Shivani Bhardwaj <shivanib134@gmail.com> wrote:
>> >> > Add translation for connlabel to nftables.
>> >> > Full translation for this match awaits the support for --set option.
>> >>
>> >> Hmm, I sent patches for that a while ago, don't know why they were
>> >> not applied... Pablo?
>> >
>> > Please, push the the connlabel support to nft.
>> >
>> > We can probably introduce something like:
>> >
>> >         ct connlabel bitset bar
>> >
>> > instead of:
>> >
>> >         ct connlabel set ct connlabel | bar
>> >
>> > in a follow up patch, which looks more compact to me. We can accept
>> > both syntax I'd say so we can introduce this without breaking
>> > backward.
>>
>> Should I be waiting for this or send a v2 with the existing options?
>
> The current translation seems fine (unless Florian indicates
> otherwise). We can incrementally improve this.

Yes, Florian pointed that the translation corresponding to inversion
is incorrect. So, I already need to fix that.
