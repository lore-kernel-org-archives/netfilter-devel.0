From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] netfilter: ipt_addrtype: rename to xt_addrtype
Date: Tue, 15 Mar 2011 14:29:32 +0100
Message-ID: <4D7F69BC.2090309@trash.net>
References: <1299341328-4663-1-git-send-email-fw@strlen.de> <4D76471E.8050503@trash.net> <alpine.LNX.2.01.1103092006131.9143@obet.zrqbmnf.qr> <20110309195432.GX8821@Chamillionaire.breakpoint.cc> <alpine.LNX.2.01.1103092120570.22286@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43572 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757786Ab1CON3g (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Mar 2011 09:29:36 -0400
In-Reply-To: <alpine.LNX.2.01.1103092120570.22286@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 09.03.2011 21:21, Jan Engelhardt wrote:
> On Wednesday 2011-03-09 20:54, Florian Westphal wrote:
> 
>> Jan Engelhardt <jengelh@medozas.de> wrote:
>>> On Tuesday 2011-03-08 16:11, Patrick McHardy wrote:
>>>
>>>> Am 05.03.2011 17:08, schrieb Florian Westphal:
>>>>> From: Florian Westphal <fwestphal@astaro.com>
>>>>>
>>>>> followup patch will add ipv6 support.
>>>>>
>>>>> Signed-off-by: Florian Westphal <fwestphal@astaro.com>
>>>>> ---
>>>>>  include/linux/netfilter/Kbuild                     |    1 +
>>>>>  .../ipt_addrtype.h => netfilter/xt_addrtype.h}     |   16 +++++-----
>>>>
>>>> Please keep this file and the original definitions for a while
>>>> (add to feature-removal-schedule) for compatibility. You can
>>>> redefine them to the xt_ values/structures so they can be used
>>>> inside the kernel.
>>>
>>> Just like ipt_realm.h does, yeah.
>>
>> Sorry, redefining structures and enums is really not my cup of tea.
>>
>> If thats really what you would prefer (as opposed to keeping the file
>> as-is) I can send a V3 patch that includes xt_addrtype.h and then
>> re-defines the enums/structures with the ipt_ prefixes.
>>
>> But personally I would prefer to just keep it as-is and then remove it
>> in a year or so.
> 
> I don't mind, t'was just a suggestion because ipt_realm happened to hit 
> my eye.

I don't mind either as long as we keep the old definitions.
