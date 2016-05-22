From: Taehee Yoo <ap420073@gmail.com>
Subject: Re: [PATCH 1/2] netfilter: helper: Fix incorrect helper name.
Date: Mon, 23 May 2016 00:03:55 +0900
Message-ID: <CAMArcTUm9PeVD3+Vq7g0OffqxUZQJYRJs304jAF90LXH1Xj1YA@mail.gmail.com>
References: <1463231956-26867-1-git-send-email-ap420073@gmail.com>
	<20160517103842.GA3324@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Patrick McHardy <kaber@trash.net>, kadlec@blackhole.kfki.hu,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35499 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbcEVPD5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 22 May 2016 11:03:57 -0400
Received: by mail-wm0-f65.google.com with SMTP id f75so2275202wmf.2
        for <netfilter-devel@vger.kernel.org>; Sun, 22 May 2016 08:03:56 -0700 (PDT)
In-Reply-To: <20160517103842.GA3324@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2016-05-17 19:38 GMT+09:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> On Sat, May 14, 2016 at 10:19:16PM +0900, Taehee Yoo wrote:
>> when register to helper, each helper adds port to name.
>> correct form is 'protocol name-port' but irc, sip and tftp adds
>> a iterator value. so it fix it.
>
> Could you track since when this works in this way?
>
> This inconsistency has been probably there since long time ago, and we
> expose this names through iptables -m helper.
>
> What I mean is: I understand this is inconsistent, but if we change
> this now, we may break existing rulesets.


Thank you for your review.
And Apologize for late reply.

I agree that patch destroys so much rulesets.
but I want to solve the issue that is helper cannot check duplicated
helper rules.
nf_conntrack_helper_register() checks name && l3num && protonum to
check duplicated rules.
but tftp, sip and irc helper always have unique helper name because
that includes iterator value.
(tftp-1, tftp-2, tftp-3 ...)
helper-name is good method to check duplicated rules.
but we need another check method to solve this issue and keep rulsets.
so far, my idea is that using help callback function's pointer address.
pseudo code is : "if (port && l3num && protonum && help)"

Do you have any advice?

Taehee Yoo
