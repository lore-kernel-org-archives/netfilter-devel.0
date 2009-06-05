From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: ebtables broken for kernel above 2.6.28
Date: Fri, 5 Jun 2009 15:35:56 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0906051531290.7950@fbirervta.pbzchgretzou.qr>
References: <17923cc80905280124t4ed6cf7m87f91e4444146697@mail.gmail.com>  <4A1EB783.4090801@pandora.be>  <17923cc80905282251s2ddc50a4n1a44a2b1e6b01cc5@mail.gmail.com>  <alpine.LSU.2.00.0905291156060.9095@fbirervta.pbzchgretzou.qr>
 <17923cc80905290414r5caaaec9t8b6c4ce849c66175@mail.gmail.com> <4A200B60.6080804@pandora.be> <alpine.LSU.2.00.0905291915490.12199@fbirervta.pbzchgretzou.qr> <alpine.LSU.2.00.0905291915490.12199@fbirervta.pbzchgretzou.qr> <4A25191D.2030201@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: sachin sanap <sachin.sanap.1gb@gmail.com>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, buytenh@wantstofly.org,
	Bart De Schuymer <bdschuym@pandora.be>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:37928 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbZFENfy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jun 2009 09:35:54 -0400
In-Reply-To: <4A25191D.2030201@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On 2009-06-02 12:20:45, Patrick McHardy wrote:
>On Friday 2009-05-29 19:16, Jan Engelhardt wrote:
>>On Friday 2009-05-29 18:20, Bart De Schuymer wrote:
>>>
>>> I think it's best to fix this in the kernel if it's possible,
>>> since we don't want to break compatibility. If the fix has to be
>>> in userspace, then it must be a fix that still works for older
>>> kernels.
>>>
>>> -#define EBT_MIN_ALIGN (__alignof__(struct ebt_entry_target))
>>> +#define EBT_MIN_ALIGN (__alignof__(struct _xt_align))
>>
>>Since the kernel uses xt_align already, it's best for userspace to
>>do the same.
>
>But that doesn't work for older kernels. Please don't dismiss
>compatibility issues that easily. Sometimes things unfortunately do
>slip through, but I expect people to do their best to fix the
>problem properly when this happens.

But if it gets changed back again to ebt_entry_target, it might
stop working for the combinations it currently works on. :/
