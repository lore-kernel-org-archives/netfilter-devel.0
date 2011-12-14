From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: [PATCH 1/2] netfilter: add extended accounting infrastructure
 over nfnetlink
Date: Wed, 14 Dec 2011 15:06:24 -0800
Message-ID: <CAHo-OowrLG9Pij-66=5P4Tgrpcxc-hv9TzPyeTJL=qLL6g8TWQ@mail.gmail.com>
References: <1323860443-7129-1-git-send-email-pablo@netfilter.org>
	<1323860443-7129-2-git-send-email-pablo@netfilter.org>
	<alpine.LNX.2.01.1112141439180.16886@frira.zrqbmnf.qr>
	<20111214165007.GA4765@1984>
	<alpine.DEB.2.00.1112141926580.7277@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org, kaber@trash.net,
	thomas.jarosch@intra2net.com
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35644 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932199Ab1LNXGZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Dec 2011 18:06:25 -0500
Received: by ggdk6 with SMTP id k6so1221749ggd.19
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Dec 2011 15:06:24 -0800 (PST)
In-Reply-To: <alpine.DEB.2.00.1112141926580.7277@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>> > I suggest to turn -j NFACCT into -m nfacct instead, so that we can add
>> > counting-down mode and matching capabilities, so as to replace
>> > xt_quota*.
>>
>> This makes sense.
>>
>> My only concern is that -m nfacct will not really match anything (not
>> by default at least).
>>
>> But with -m nfacct, we can use it in one single multi-match rule, which
>> comes in handy.
>
> I second that turning it into a "match" makes it more flexible.

I've often wished I could apply multiple targets to a single rule, ie.
mangle like so, and then ACCEPT, instead of having to create a
separate chain...
It sounds like there should be matches, targets, and non-decisive
actions, which happen after the matches, don't affect matching, and
before the targets...
