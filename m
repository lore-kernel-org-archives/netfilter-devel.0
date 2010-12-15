From: Patrick McHardy <kaber@trash.net>
Subject: Re: [patch] xtables: use guarded types
Date: Wed, 15 Dec 2010 22:59:37 +0100
Message-ID: <4D093A49.2060500@trash.net>
References: <alpine.LNX.2.01.1012032012320.26825@obet.zrqbmnf.qr> <4D00B2D7.4010401@netfilter.org> <alpine.LNX.2.01.1012092024000.30670@obet.zrqbmnf.qr> <4D01FFC5.90808@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59907 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391Ab0LOV7l (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Dec 2010 16:59:41 -0500
In-Reply-To: <4D01FFC5.90808@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 10.12.2010 11:24, schrieb Pablo Neira Ayuso:
> On 09/12/10 20:25, Jan Engelhardt wrote:
>> On Thursday 2010-12-09 11:43, Pablo Neira Ayuso wrote:
>>
>>> On 03/12/10 20:13, Jan Engelhardt wrote:
>>>> parent b880c1f077000956b9f475d5f3b6c5e45ff2e342 (v2.6.37-rc1-241-gb880c1f)
>>>> commit 4826151aedbe6e364b7b801f026fbe7383904b6a
>>>> Author: Jan Engelhardt <jengelh@medozas.de>
>>>> Date:   Thu Dec 2 21:01:17 2010 +0100
>>>>
>>>> netfilter: xtables: use guarded types
>>>>
>>>> We are supposed to use the kernel's own types in userspace exports.
>>>
>>> What's the point to have different headers in the kernel source code
>>> tree and iptables?
>>
>> Because iptables needs to know more structs than the kernel provides.
>>
>> But... what does that have to do with the patch?
> 
> I mean that, after this patch, iptables headers and Linux kernel headers
> will be out of sync, right?
> 

Well, we can resync userspace, but the __ types specifically exist
to avoid namespace polution.

Applied, thanks.

I'll also gladly apply a patch to get rid of the u_int_XX crap.
