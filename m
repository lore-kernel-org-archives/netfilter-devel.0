From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 3/4] netfilter: xtables: use xt_table for hook
 instantiation
Date: Wed, 10 Feb 2010 17:05:51 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1002101705260.12673@obet.zrqbmnf.qr>
References: <1265813954-13854-1-git-send-email-jengelh@medozas.de> <1265813954-13854-4-git-send-email-jengelh@medozas.de> <4B72D069.2040106@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:41558 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754939Ab0BJQFw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Feb 2010 11:05:52 -0500
In-Reply-To: <4B72D069.2040106@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2010-02-10 16:27, Patrick McHardy wrote:

>Jan Engelhardt wrote:
>> diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
>> index 766c6fd..2367953 100644
>> --- a/net/ipv4/netfilter/iptable_raw.c
>> +++ b/net/ipv4/netfilter/iptable_raw.c
>> @@ -41,6 +41,7 @@ static const struct xt_table packet_raw = {
>>  	.valid_hooks =  RAW_VALID_HOOKS,
>>  	.me = THIS_MODULE,
>>  	.af = NFPROTO_IPV4,
>> +	.priority = NF_IP_PRI_FIRST,
>
>You're changing priorities here, NF_IP_PRI_RAW is not NF_IP_PRI_FIRST.

Aww.. that must have stemmed from ip6table_raw using _FIRST. Will fix.
