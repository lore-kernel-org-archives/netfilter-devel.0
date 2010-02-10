From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/4] netfilter: xtables: use xt_table for hook instantiation
Date: Wed, 10 Feb 2010 17:10:13 +0100
Message-ID: <4B72DA65.4040308@trash.net>
References: <1265813954-13854-1-git-send-email-jengelh@medozas.de> <1265813954-13854-4-git-send-email-jengelh@medozas.de> <4B72D069.2040106@trash.net> <alpine.LSU.2.01.1002101705260.12673@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53953 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab0BJQKV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Feb 2010 11:10:21 -0500
In-Reply-To: <alpine.LSU.2.01.1002101705260.12673@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2010-02-10 16:27, Patrick McHardy wrote:
> 
>> Jan Engelhardt wrote:
>>> diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
>>> index 766c6fd..2367953 100644
>>> --- a/net/ipv4/netfilter/iptable_raw.c
>>> +++ b/net/ipv4/netfilter/iptable_raw.c
>>> @@ -41,6 +41,7 @@ static const struct xt_table packet_raw = {
>>>  	.valid_hooks =  RAW_VALID_HOOKS,
>>>  	.me = THIS_MODULE,
>>>  	.af = NFPROTO_IPV4,
>>> +	.priority = NF_IP_PRI_FIRST,
>> You're changing priorities here, NF_IP_PRI_RAW is not NF_IP_PRI_FIRST.
> 
> Aww.. that must have stemmed from ip6table_raw using _FIRST. Will fix.

This might actually be a bug. IPv4 uses:

	NF_IP_PRI_FIRST = INT_MIN,
	NF_IP_PRI_CONNTRACK_DEFRAG = -400,
	NF_IP_PRI_RAW = -300,
	NF_IP_PRI_SELINUX_FIRST = -225,
	NF_IP_PRI_CONNTRACK = -200,

while IPv6 uses:

	NF_IP6_PRI_FIRST = INT_MIN,
	NF_IP6_PRI_CONNTRACK_DEFRAG = -400,
	NF_IP6_PRI_SELINUX_FIRST = -225,
	NF_IP6_PRI_CONNTRACK = -200,

So we actually defragment packets in IPv4 even though they're
untracked. Perhaps Jozsef knows more details why we use
different priorities here.
