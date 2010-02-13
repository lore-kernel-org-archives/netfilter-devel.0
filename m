From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 1/6] netfilter: xtables: replace XT_ENTRY_ITERATE macro
Date: Sat, 13 Feb 2010 11:39:07 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1002131137310.1587@obet.zrqbmnf.qr>
References: <1265970044-19518-1-git-send-email-jengelh@medozas.de> <1265970044-19518-2-git-send-email-jengelh@medozas.de> <4B767EFB.7030600@treenet.co.nz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Amos Jeffries <squid3@treenet.co.nz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:47283 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524Ab0BMKjI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 13 Feb 2010 05:39:08 -0500
In-Reply-To: <4B767EFB.7030600@treenet.co.nz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2010-02-13 11:29, Amos Jeffries wrote:
> Jan Engelhardt wrote:
>> The macro is replaced by a list.h-like foreach loop. This makes
>> the code much more inspectable.
>>
> <snip>
>> 	if (IS_ERR(counters))
>> @@ -1967,9 +2009,12 @@ compat_copy_entries_to_user(unsigned int total_size,
>> struct xt_table *table,
>> 	loc_cpu_entry = private->entries[raw_smp_processor_id()];
>> 	pos = userptr;
>> 	size = total_size;
>> -	ret = IP6T_ENTRY_ITERATE(loc_cpu_entry, total_size,
>> -				 compat_copy_entry_to_user,
>> -				 &pos, &size, counters, &i);
>> +	xt_entry_foreach(iter, loc_cpu_entry, total_size) {
>> +		ret = compat_copy_entry_to_user(iter, &pos,
>> +		      &size, counters, &i);
>> +		if (ret != 0)
>> +			break;
>> +	}
>> 
>
> <snip>
>
>> 	loc_cpu_entry = private->entries[raw_smp_processor_id()];
>> -	IP6T_ENTRY_ITERATE(loc_cpu_entry, private->size, cleanup_entry, net,
>> NULL);
>> +	xt_entry_foreach(iter, loc_cpu_entry, private->size)
>> +		if (cleanup_entry(iter, net, NULL) != 0)
>> +			break;
>> 	if (private->number > private->initial_entries)
>> 		module_put(table_owner);
>> 	xt_free_table_info(private);
>
> Just my 2c, but you seem to be floating between several coding styles on this
> one.

What, where? It goes by two simple rules:
- no assignments in if()
- only use {} where needed
