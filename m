From: Neutron Soutmun <neo.neutron@gmail.com>
Subject: Re: [PATCH] ipset: Fix syntax error of bash completion in Debian environment
Date: Thu, 16 May 2013 16:46:06 +0700
Message-ID: <CAMQP0sn0iURTbktGGn1YjAS0s2+fkenXaZZK4rKGDpUHR6VsLA@mail.gmail.com>
References: <20130512092829.GA9286@nitrogen.neutroncom.local>
	<CAMQP0s=EsD4+k-WV6hf=0P13Bpcbg_hYVw4cPWys9srCW4NGFA@mail.gmail.com>
	<5193E0DB.3040700@airpost.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: kadlec@blackhole.kfki.hu, netfilter-devel@vger.kernel.org
To: blackhole@airpost.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-da0-f44.google.com ([209.85.210.44]:35009 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab3EPJqI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 May 2013 05:46:08 -0400
Received: by mail-da0-f44.google.com with SMTP id z8so1562065daj.3
        for <netfilter-devel@vger.kernel.org>; Thu, 16 May 2013 02:46:06 -0700 (PDT)
In-Reply-To: <5193E0DB.3040700@airpost.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

On Thu, May 16, 2013 at 2:24 AM, Bourne Without <blackhole@airpost.net> wrote:
> On 12.05.2013 14:07, Neutron Soutmun wrote:
>>
>> Cc-d script's author
>>
>
> Hello,
>
> thanks for reporting.
>
>
>> On Sun, May 12, 2013 at 4:28 PM, Neutron Soutmun <neo.neutron@gmail.com>
>> wrote:
>>>
>>> Debian packaging tool (lintian) warns the syntax error of bash completion
>>> as it uses the extglob shell option that should be run in
>>> the ** #!/usr/bin/env bash ** and the shell option set should be moved to
>>> global scope.
>>>
>>> Signed-off-by: Neutron Soutmun <neo.neutron@gmail.com>
>>> ---
>>>   utils/ipset_bash_completion/ipset_bash_completion |    5 +++--
>>>   1 file changed, 3 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/utils/ipset_bash_completion/ipset_bash_completion
>>> b/utils/ipset_bash_completion/ipset_bash_completion
>>> index cc7ea7b..8a0b91d 100644
>>> --- a/utils/ipset_bash_completion/ipset_bash_completion
>>> +++ b/utils/ipset_bash_completion/ipset_bash_completion
>>> @@ -1,4 +1,4 @@
>>> -#!/bin/bash
>>> +#!/usr/bin/env bash
>
>
> Actually I think the shebang isn't required at all.
> Does the debian tool just warn?

Sorry for the noise, I just search the BTS and found this
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=699410

It seems to be the false positive of lintian.
However, the #!/usr/bin/env bash is the workaround for this issue :)

Thanks for your kindness to review it.

Best regards,
Neutron Soutmun
