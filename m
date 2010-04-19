From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 2/4] netfilter: xtables2: make ip_tables reentrant
Date: Mon, 19 Apr 2010 14:54:48 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1004191451100.9177@obet.zrqbmnf.qr>
References: <1271373909-6959-1-git-send-email-jengelh@medozas.de> <1271373909-6959-3-git-send-email-jengelh@medozas.de> <4BCC4B19.7040805@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:58678 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754830Ab0DSMyu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Apr 2010 08:54:50 -0400
In-Reply-To: <4BCC4B19.7040805@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2010-04-19 14:22, Patrick McHardy wrote:
>Jan Engelhardt wrote:
>> This patch decouples the jumpstack from struct ip6t_entry and instead
>> puts it into xt_table_info. Not being restricted by 'comefrom'
>> anymore, we can set up a stack as needed. By default, there is room
>> allocated for two entries into the traverser. The setting is
>> configurable at runtime through sysfs and will take effect when a
>> table is replaced by a new one.
>
>The changelog is not up to date anymore, but ...

Oops ;-)

>> --- a/include/linux/netfilter/x_tables.h
>> +++ b/include/linux/netfilter/x_tables.h
>> @@ -401,6 +401,13 @@ struct xt_table_info {
>>  	unsigned int hook_entry[NF_INET_NUMHOOKS];
>>  	unsigned int underflow[NF_INET_NUMHOOKS];
>>  
>> +	/*
>> +	 * Number of user chains. Since tables cannot have loops, at most
>> +	 * @stacksize jumps (number of user chains) can possibly be made.
>> +	 */
>> +	unsigned int stacksize;
>> +	unsigned int *stackptr;
>> +	void ***jumpstack;
>...
>> --- a/net/netfilter/x_tables.c
>> +++ b/net/netfilter/x_tables.c
>> @@ -62,6 +62,9 @@ static const char *const xt_prefix[NFPROTO_NUMPROTO] = {
>>  	[NFPROTO_IPV6]   = "ip6",
>>  };
>>  
>> +/* Allow this many total (re)entries. */
>> +static const unsigned int xt_jumpstack_multiplier = 2;
>> +
>
>Why aren't you using a define instead of saving the stack size
>in the table info?

I don't see how a define does any good here. Since you were quoting
the multiplier line, I guess you could be confusing the multiplier
with stored stacksize. FTR, the definition is:

table->stacksize := number_of_user_chains(#UC) * multiplier;

Since #UC is variable, so is stacksize, and so stacksize cannot
be replaced by a constant.
