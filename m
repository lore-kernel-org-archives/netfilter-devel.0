From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 3/9] netfilter: xtables: make use of
 xt_request_find_target
Date: Tue, 23 Mar 2010 15:27:34 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1003231526500.21464@obet.zrqbmnf.qr>
References: <1269285486-22653-1-git-send-email-jengelh@medozas.de> <1269285486-22653-4-git-send-email-jengelh@medozas.de> <4BA8CF0D.1090707@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:53525 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315Ab0CWO1f (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Mar 2010 10:27:35 -0400
In-Reply-To: <4BA8CF0D.1090707@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2010-03-23 15:24, Patrick McHardy wrote:
>Jan Engelhardt wrote:
>> diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
>> index f07d77f..0665e1b 100644
>> --- a/net/ipv4/netfilter/arp_tables.c
>> +++ b/net/ipv4/netfilter/arp_tables.c
>> @@ -523,13 +523,11 @@ find_check_entry(struct arpt_entry *e, const char *name, unsigned int size)
>>  		return ret;
>>  
>>  	t = arpt_get_target(e);
>> -	target = try_then_request_module(xt_find_target(NFPROTO_ARP,
>> -							t->u.user.name,
>> -							t->u.user.revision),
>> -					 "arpt_%s", t->u.user.name);
>> -	if (IS_ERR(target) || !target) {
>> +	target = xt_request_find_target(NFPROTO_ARP, t->u.user.name,
>> +	         t->u.user.revision);
>
>Indentation according to maintainers taste, please :)

With sugar on top?




(SCNR)
