From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ebtables: Clone xt_AUDIT to ebt_audit to return EBT_CONTINUE
Date: Wed, 16 Mar 2011 14:58:36 +0100
Message-ID: <4D80C20C.4090805@trash.net>
References: <20110316003307.GB26145@canuck.infradead.org> <alpine.LNX.2.01.1103160138160.1189@obet.zrqbmnf.qr> <4D804D51.1010205@trash.net> <20110316082458.GC26145@canuck.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
To: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64507 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748Ab1CPN6i (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Mar 2011 09:58:38 -0400
In-Reply-To: <20110316082458.GC26145@canuck.infradead.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 16.03.2011 09:24, Thomas Graf wrote:
> On Wed, Mar 16, 2011 at 06:40:33AM +0100, Patrick McHardy wrote:
>> Am 16.03.2011 01:43, schrieb Jan Engelhardt:
>>> On Wednesday 2011-03-16 01:33, Thomas Graf wrote:
>>>
>>>> Even though ebtables uses xtables it still requires targets to
>>>> return EBT_CONTINUE instead of XT_CONTINUE. This prevented
>>>> xt_AUDIT to work as ebt module.
>>>
>>> Something that just came to mind is that you could probably do
>>> to keep the code at a minimum:
>>>
>>>
>>> static unsigned int ebt_audit(struct xt_target_param *par)
>>> {
>>> 	unsigned int ret = xt_audit_tg(par);
>>>
>>> 	if (ret == XT_CONTINUE)
>>> 		return EBT_CONTINUE;
>>> 	...
>>> }
> 
> That's a good idea, thanks Jan!
> 
>> Seems like a good idea to me. If more modules need this (f.i.
>> MARK) we could also consider doing the mapping based on a target
>> flag in ebtables itself.
>>
>> However please see Dave's mail about net-next, until the merge
>> window is over and -rc1 released only bugfixes will be accepted.
> 
> I was considering this a bugfix because the module as-is can be
> loaded with ebtables, will create audit records but won't allow
> for the next rule to drop/reject the packet.
> 
> Would you consider Jan's approach a bugfix or should I wait?

Yes, this qualifies as a bugfix in my opinion since we're returning
invalid verdicts to ebtables. I'll apply your patch later today.
