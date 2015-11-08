From: Loganaden Velvindron <loganaden@gmail.com>
Subject: Re: [PATCH 1/1 net-next] net: bridge: netfilter: use vzalloc()
 instead of vmalloc() for counterstmp
Date: Sun, 8 Nov 2015 21:26:36 +0000
Message-ID: <CAOp4FwRj=HVjpLFe2DNUeiy16WLe_XcE6bdTbExDZZu8beRkHA@mail.gmail.com>
References: <20151030123303.GA19481@mx.elandsys.com>
	<20151108204115.GA2629@salvia>
	<CAOp4FwTa91=dHkWmSz7QzojwbTEo97P1HRXqt7EN=FAKgC1Eaw@mail.gmail.com>
	<20151108213045.GA4259@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Loganaden Velvindron <logan@elandsys.com>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:34940 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbbKHV0h (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 8 Nov 2015 16:26:37 -0500
Received: by pasz6 with SMTP id z6so181650105pas.2
        for <netfilter-devel@vger.kernel.org>; Sun, 08 Nov 2015 13:26:36 -0800 (PST)
In-Reply-To: <20151108213045.GA4259@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Nov 8, 2015 at 9:30 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sun, Nov 08, 2015 at 08:52:50PM +0000, Loganaden Velvindron wrote:
>> On Sun, Nov 8, 2015 at 8:41 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> > On Fri, Oct 30, 2015 at 05:33:03AM -0700, Loganaden Velvindron wrote:
>> >> counterstmp is not cleared before it is used in get_counters(). it might be
>> >> leaked partially when it is sent to userland later on.
>> >
>> > get_counters() is memcpy'ing the old counter to the counterstmp area
>> > and updating it.
>> >
>> > Where is there leak?
>> >
>>
>> In this case, none, due to correct memcpy parameters in get_counters().
>>
>> However, as this is exposed later on to userland through:
>>
>>         if (copy_to_user(user, counterstmp,
>>            nentries * sizeof(struct ebt_counter)))
>>
>> zero'ing counterstmp malloc'ed memory, looks like a good idea.
>
> We allocate room for nentries, then we get_counters() those nentries
> that memcpy that area, and we copy back to user nentries.
>
> Where is the problem?

None in this case.
