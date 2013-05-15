From: Bourne Without <blackhole@airpost.net>
Subject: Re: [PATCH] ipset: Fix syntax error of bash completion in Debian
 environment
Date: Wed, 15 May 2013 21:24:11 +0200
Message-ID: <5193E0DB.3040700@airpost.net>
References: <20130512092829.GA9286@nitrogen.neutroncom.local> <CAMQP0s=EsD4+k-WV6hf=0P13Bpcbg_hYVw4cPWys9srCW4NGFA@mail.gmail.com>
Reply-To: blackhole@airpost.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: kadlec@blackhole.kfki.hu, netfilter-devel@vger.kernel.org
To: Neutron Soutmun <neo.neutron@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51017 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756698Ab3EOTYm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 May 2013 15:24:42 -0400
In-Reply-To: <CAMQP0s=EsD4+k-WV6hf=0P13Bpcbg_hYVw4cPWys9srCW4NGFA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12.05.2013 14:07, Neutron Soutmun wrote:
> Cc-d script's author
>

Hello,

thanks for reporting.

> On Sun, May 12, 2013 at 4:28 PM, Neutron Soutmun <neo.neutron@gmail.com> wrote:
>> Debian packaging tool (lintian) warns the syntax error of bash completion
>> as it uses the extglob shell option that should be run in
>> the ** #!/usr/bin/env bash ** and the shell option set should be moved to
>> global scope.
>>
>> Signed-off-by: Neutron Soutmun <neo.neutron@gmail.com>
>> ---
>>   utils/ipset_bash_completion/ipset_bash_completion |    5 +++--
>>   1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/utils/ipset_bash_completion/ipset_bash_completion b/utils/ipset_bash_completion/ipset_bash_completion
>> index cc7ea7b..8a0b91d 100644
>> --- a/utils/ipset_bash_completion/ipset_bash_completion
>> +++ b/utils/ipset_bash_completion/ipset_bash_completion
>> @@ -1,4 +1,4 @@
>> -#!/bin/bash
>> +#!/usr/bin/env bash

Actually I think the shebang isn't required at all.
Does the debian tool just warn?

>>
>>   # -----------------------------------------------------------------
>>   # Programmable completion code for ipset (netfilter.org)
>> @@ -47,6 +47,8 @@
>>   #
>>   # -----------------------------------------------------------------
>>
>> +shopt -s extglob
>> +

updated this in the dev branch (github / sourceforge).

[...]

Best regards
