From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: Re: [PATCH v2] extensions: libxt_mark: Add translation to nft
Date: Sat, 19 Dec 2015 23:41:01 +0530
Message-ID: <CAKHNQQGddf+RKXceY6X_wWHv5Nok10FRw2bZUA044kaOyt15RQ@mail.gmail.com>
References: <20151206033214.GA5939@gmail.com> <20151209132600.GA29450@salvia>
 <CAKHNQQF3XFhMJaoi8gBLOeGTLJjxncPQ-s9Tke3nC0FNoGVJjg@mail.gmail.com>
 <CAKHNQQEtTZ0Hg57VcgrOTaFZww-3T8nc8+P1WFq5Ms4Ap2qmbg@mail.gmail.com>
 <CAKHNQQGSbN8QQru8PB9GntbGGBKLT7v3VRYnjhEObshs7qKPcg@mail.gmail.com>
 <20151218214013.GA26438@salvia> <CAKHNQQGcET7S+RJENLs+p5zwCe4Xd8FdmJTCT5E-16zjD_PNqw@mail.gmail.com>
 <20151219174720.GA1421@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:35973 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932876AbbLSSLW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 19 Dec 2015 13:11:22 -0500
Received: by mail-wm0-f50.google.com with SMTP id p187so22566527wmp.1
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Dec 2015 10:11:21 -0800 (PST)
In-Reply-To: <20151219174720.GA1421@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Dec 19, 2015 at 11:17 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sat, Dec 19, 2015 at 07:56:56PM +0530, Shivani Bhardwaj wrote:
>> On Sat, Dec 19, 2015 at 3:10 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> > But, anyway after applying you patch I can see:
>> >
>> > # iptables-translate -I INPUT -m mark --mark 10
>> > nft insert rule ip filter INPUT ct mark  & xa counter
>> >
>> > So this kind of work already.
>> >
>>
>> Hi,
>>
>> I just tried adding this rule to nft. It does not work. It only works
>> for integer values of mark. nft shows syntax error for ampersand and
>> hex values.
>>
>> Isn't there something wrong? Please let me know.
>
> The line above should be:
>
> nft insert rule ip filter INPUT ct mark & 0xa counter
>

One more question. Why ct mark when we have no conntrack information
in this module? Shouldn't ct mark be a complete module of conntrack?

> You have to add a simple table and chain configuration to test it:
>
> nft add table filter
> nft add chain filter INPUT { type filter hook input priority 0\; }
>
> The two lines above create a filter table, then it adds an INPUT chain
> to that table.
>
> The correct translation for:
>
> iptables-translate -I INPUT -m mark --mark 10
>
> is:
>
> nft insert rule ip filter INPUT ct mark 0xa counter
>
> Then for:
>
> iptables-translate -I INPUT -m mark --mark 10/10
>
> is:
>
> nft insert rule ip filter INPUT ct mark and 0xa == 0xa counter
>
> You have to take the time to find the right translation too and make
> sure they work.
>
> Thanks.
