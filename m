From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/4] netfilter: xtables2: make ip_tables reentrant
Date: Tue, 20 Apr 2010 15:18:52 +0200
Message-ID: <4BCDA9BC.50201@trash.net>
References: <1271373909-6959-1-git-send-email-jengelh@medozas.de> <1271373909-6959-3-git-send-email-jengelh@medozas.de> <4BCC4B19.7040805@trash.net> <alpine.LSU.2.01.1004191451100.9177@obet.zrqbmnf.qr> <4BCC636A.1080401@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48300 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488Ab0DTNSx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 Apr 2010 09:18:53 -0400
In-Reply-To: <4BCC636A.1080401@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Jan Engelhardt wrote:
>>>> +/* Allow this many total (re)entries. */
>>>> +static const unsigned int xt_jumpstack_multiplier = 2;
>>>> +
>>> Why aren't you using a define instead of saving the stack size
>>> in the table info?
>> I don't see how a define does any good here. Since you were quoting
>> the multiplier line, I guess you could be confusing the multiplier
>> with stored stacksize. FTR, the definition is:
>>
>> table->stacksize := number_of_user_chains(#UC) * multiplier;
>>
>> Since #UC is variable, so is stacksize, and so stacksize cannot
>> be replaced by a constant.
> 
> Right, thanks for the explanation. Applied.

I just noticed a problem with this patch:

[  428.295752] BUG: sleeping function called from invalid context at
mm/slub.c:1705
[  428.295762] in_atomic(): 1, irqs_disabled(): 0, pid: 9111, name: iptables
[  428.295771] Pid: 9111, comm: iptables Not tainted 2.6.34-rc1 #2
[  428.295776] Call Trace:
[  428.295791]  [<c012138e>] __might_sleep+0xe5/0xed
[  428.295801]  [<c019e8ca>] __kmalloc+0x92/0xfc
[  428.295825]  [<f865b3bb>] ? xt_jumpstack_alloc+0x36/0xff [x_tables]
[  428.295839]  [<f865b3bb>] xt_jumpstack_alloc+0x36/0xff [x_tables]
[  428.295851]  [<f865abe1>] ? try_module_get+0x82/0x9b [x_tables]
[  428.295864]  [<f865b4c0>] xt_replace_table+0x3c/0x5f [x_tables]
[  428.295876]  [<f86b5dc3>] do_ipt_set_ctl+0x182/0x3d5 [ip_tables]
[  428.295922]  [<c037388f>] nf_sockopt+0x167/0x17c
[  428.295931]  [<c03738d8>] nf_setsockopt+0x1a/0x1f
[  428.295940]  [<c037dda4>] ip_setsockopt+0x60/0x84
[  428.295951]  [<c039260a>] raw_setsockopt+0x1f/0x62
[  428.295960]  [<c034d909>] sock_common_setsockopt+0x18/0x1d
[  428.295968]  [<c034bfb9>] sys_setsockopt+0x5e/0x79
[  428.295977]  [<c034d0a0>] sys_socketcall+0x12d/0x190
[  428.295987]  [<c0102a57>] sysenter_do_call+0x12/0x26

You probably shouldn't be allocating the jumpstack while BHs are
disabled.
