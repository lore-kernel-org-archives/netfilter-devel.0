From: Taehee Yoo <ap420073@gmail.com>
Subject: Re: [PATCH 1/2] netfilter: helper: Fix incorrect helper name.
Date: Mon, 30 May 2016 00:29:06 +0900
Message-ID: <CAMArcTVLKyO81_WG-T0v4M1JgPSyjNR79HkbLGy12zd-ho_DXQ@mail.gmail.com>
References: <1463231956-26867-1-git-send-email-ap420073@gmail.com>
	<20160517103842.GA3324@salvia>
	<CAMArcTUm9PeVD3+Vq7g0OffqxUZQJYRJs304jAF90LXH1Xj1YA@mail.gmail.com>
	<CA+6hz4r2KFBgBqA2sYKZAUO2ZUFNSnywEc7f24Y9VyZVbbULBA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>, kadlec@blackhole.kfki.hu,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Feng Gao <gfree.wind@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35342 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbcE2P3I (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 29 May 2016 11:29:08 -0400
Received: by mail-wm0-f66.google.com with SMTP id e3so14991169wme.2
        for <netfilter-devel@vger.kernel.org>; Sun, 29 May 2016 08:29:07 -0700 (PDT)
In-Reply-To: <CA+6hz4r2KFBgBqA2sYKZAUO2ZUFNSnywEc7f24Y9VyZVbbULBA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2016-05-24 13:33 GMT+09:00 Feng Gao <gfree.wind@gmail.com>:
> Hi Pablo,
>
> I committed the similar fix long ago, about some month ago.
> I have changed the codes according to your advice.
> The links are http://patchwork.ozlabs.org/patch/565169/,
> http://patchwork.ozlabs.org/patch/565170,
> http://patchwork.ozlabs.org/patch/565171
>
> But they are not accepted until now.
> Is there any problem now?
>
> Best Regards
> Feng
>
> On Sun, May 22, 2016 at 11:03 PM, Taehee Yoo <ap420073@gmail.com> wrote:
>>
>> 2016-05-17 19:38 GMT+09:00 Pablo Neira Ayuso <pablo@netfilter.org>:
>> > On Sat, May 14, 2016 at 10:19:16PM +0900, Taehee Yoo wrote:
>> >> when register to helper, each helper adds port to name.
>> >> correct form is 'protocol name-port' but irc, sip and tftp adds
>> >> a iterator value. so it fix it.
>> >
>> > Could you track since when this works in this way?
>> >
>> > This inconsistency has been probably there since long time ago, and we
>> > expose this names through iptables -m helper.
>> >
>> > What I mean is: I understand this is inconsistent, but if we change
>> > this now, we may break existing rulesets.
>>
>>
>> Thank you for your review.
>> And Apologize for late reply.
>>
>> I agree that patch destroys so much rulesets.
>> but I want to solve the issue that is helper cannot check duplicated
>> helper rules.
>> nf_conntrack_helper_register() checks name && l3num && protonum to
>> check duplicated rules.
>> but tftp, sip and irc helper always have unique helper name because
>> that includes iterator value.
>> (tftp-1, tftp-2, tftp-3 ...)
>> helper-name is good method to check duplicated rules.
>> but we need another check method to solve this issue and keep rulsets.
>> so far, my idea is that using help callback function's pointer address.
>> pseudo code is : "if (port && l3num && protonum && help)"
>>
>> Do you have any advice?
>>
>> Taehee Yoo
>> --
>> To unsubscribe from this list: send the line "unsubscribe netfilter-devel"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


Hi,

I Apologize for my mistake.
I didn't check patchwork before sending this patch.

Also thank you for much friendly advice

Taehee Yoo
