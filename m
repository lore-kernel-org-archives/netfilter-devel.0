From: Patrick McHardy <kaber@trash.net>
Subject: Re: [patch] netfilter: nfnetlink: guard against undefined entries
Date: Fri, 12 Nov 2010 08:35:05 +0100
Message-ID: <4CDCEE29.30808@trash.net>
References: <alpine.LNX.2.01.1011100249390.23289@obet.zrqbmnf.qr> <4CDBC6A0.2000108@trash.net> <alpine.LNX.2.01.1011112156080.30863@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55873 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab0KLHfE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Nov 2010 02:35:04 -0500
In-Reply-To: <alpine.LNX.2.01.1011112156080.30863@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11.11.2010 21:56, Jan Engelhardt wrote:
> On Thursday 2010-11-11 11:34, Patrick McHardy wrote:
> 
>> On 10.11.2010 02:50, Jan Engelhardt wrote:
>>> parent a391d495f6082f6348b9074214e81c7e2dc1151c (v2.6.37-rc1-184-ga391d49)
>>> commit 6e97eb121bc8e39c651645c3d937f468d2b3e7fe
>>> Author: Jan Engelhardt <jengelh@medozas.de>
>>> Date:   Sat Nov 6 21:19:16 2010 +0100
>>>
>>> netfilter: nfnetlink: guard against undefined entries
>>>
>>> Check for empty entries in struct nfnl_callback[] to avoid potential
>>> NULL deference. (Because I have run into one during development.)
>>
>> It seems silly to add checks for easy to find bugs in users of
>> this code. Finding the cause of -EINVAL is much harder than
>> getting a nice oops.
> 
> But costs a reboot.

A forced unload of the nfnetlink module will release the mutex.

> How about a printk?

We usually don't protect against API misuse. There is an endless
amount of mistakes you can make that will cause oopses.
