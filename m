From: Amos Jeffries <squid3@treenet.co.nz>
Subject: Re: [PATCH 1/6] netfilter: xtables: replace XT_ENTRY_ITERATE macro
Date: Sat, 13 Feb 2010 23:42:54 +1300
Message-ID: <4B76822E.5090306@treenet.co.nz>
References: <1265970044-19518-1-git-send-email-jengelh@medozas.de> <1265970044-19518-2-git-send-email-jengelh@medozas.de> <4B767EFB.7030600@treenet.co.nz> <alpine.LSU.2.01.1002131137310.1587@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ip-58-28-153-233.static-xdsl.xnet.co.nz ([58.28.153.233]:36969
	"EHLO treenet.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab0BMKnG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 13 Feb 2010 05:43:06 -0500
Received: from troja.treenetnz.com. (60-234-166-233.bitstream.orcon.net.nz [60.234.166.233])
	by treenet.co.nz (Postfix) with ESMTP id EAEF1204F54
	for <netfilter-devel@vger.kernel.org>; Sat, 13 Feb 2010 23:43:02 +1300 (NZDT)
In-Reply-To: <alpine.LSU.2.01.1002131137310.1587@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Saturday 2010-02-13 11:29, Amos Jeffries wrote:
>> Jan Engelhardt wrote:
>>> The macro is replaced by a list.h-like foreach loop. This makes
>>> the code much more inspectable.
>>>
>> <snip>
>>> 	if (IS_ERR(counters))
>>> @@ -1967,9 +2009,12 @@ compat_copy_entries_to_user(unsigned int total_size,
>>> struct xt_table *table,
>>> 	loc_cpu_entry = private->entries[raw_smp_processor_id()];
>>> 	pos = userptr;
>>> 	size = total_size;
>>> -	ret = IP6T_ENTRY_ITERATE(loc_cpu_entry, total_size,
>>> -				 compat_copy_entry_to_user,
>>> -				 &pos, &size, counters, &i);
>>> +	xt_entry_foreach(iter, loc_cpu_entry, total_size) {
>>> +		ret = compat_copy_entry_to_user(iter, &pos,
>>> +		      &size, counters, &i);
>>> +		if (ret != 0)
>>> +			break;
>>> +	}
>>>
>> <snip>
>>
>>> 	loc_cpu_entry = private->entries[raw_smp_processor_id()];
>>> -	IP6T_ENTRY_ITERATE(loc_cpu_entry, private->size, cleanup_entry, net,
>>> NULL);
>>> +	xt_entry_foreach(iter, loc_cpu_entry, private->size)
>>> +		if (cleanup_entry(iter, net, NULL) != 0)
>>> +			break;
>>> 	if (private->number > private->initial_entries)
>>> 		module_put(table_owner);
>>> 	xt_free_table_info(private);
>> Just my 2c, but you seem to be floating between several coding styles on this
>> one.
> 
> What, where? It goes by two simple rules:
> - no assignments in if()
> - only use {} where needed


Oh I see. ret being used later. nevermind.

AYJ
