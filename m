From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: [PATCH iptables] libxt_length: update to revision 1
Date: Mon, 26 Jul 2010 08:21:13 +0800
Message-ID: <AANLkTikwWu28DuNMgngoSeaSgHL21-cU+zB2XgMJONp-@mail.gmail.com>
References: <1279945746-24034-1-git-send-email-xiaosuo@gmail.com>
	<alpine.LSU.2.01.1007241055320.9867@obet.zrqbmnf.qr> <AANLkTi=NwJkK1sRb+mNjNO8nr3AA5dymyZ1pTc0dgt_q@mail.gmail.com>
	<alpine.LSU.2.01.1007251827200.14790@obet.zrqbmnf.qr> <AANLkTimH8Cd7NooRxNMLSH5aGWVMsCD6MdSrd4mB5A6d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49963 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625Ab0GZAVe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 25 Jul 2010 20:21:34 -0400
Received: by vws3 with SMTP id 3so1892310vws.19
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Jul 2010 17:21:33 -0700 (PDT)
In-Reply-To: <AANLkTimH8Cd7NooRxNMLSH5aGWVMsCD6MdSrd4mB5A6d@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 26, 2010 at 8:07 AM, Changli Gao <xiaosuo@gmail.com> wrote:
> On Mon, Jul 26, 2010 at 12:28 AM, Jan Engelhardt <jengelh@medozas.de> wrote:
>> On Saturday 2010-07-24 13:47, Changli Gao wrote:
>>
>>>On Sat, Jul 24, 2010 at 4:55 PM, Jan Engelhardt <jengelh@medozas.de> wrote:
>>>> On Saturday 2010-07-24 06:29, Changli Gao wrote:
>>>>
>>>>>update libxt_length to revision 1 to support ipv6 jumbo frames.
>>>>
>>>> You can't just go and change these things, would break xt_length v0.
>>>>
>>>
>>>Hmm. I have updated the patch(attached), but the v0 handlers are not
>>>called. Is there anything I missed? Or Is there a bug in iptables?
>>
>> Probably because you are still breaking the compatibility by editing
>> struct xt_length_info.
>
> I am sure it isn't the problem. The kernel module can work with the
> old iptables binary. However after I committed the rules with the
> revision 1, I can't get the correct output with the command
> 'iptables-save' or 'iptables -nvL'.

Sorry. I made a mistake. I committed the rules(revision 0) with the
old iptables, but I could not get the correct output with the new
iptables or iptables-save.

> I checked the code of iptables,
> and found it doesn't check the revision when founding matches and
> targets, and even the kernel seems doesn't transfer the revision info
> to user space.
>
>> I'd say let's concentrate on rev 2 that I
>> submitted.
>>
>
> I have seen it. Thanks.
>
> --
> Regards,
> Changli Gao(xiaosuo@gmail.com)
>



-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
