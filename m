From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 1/7] netfilter: xtables2: initial table skeletal
 functions
Date: Fri, 20 Jan 2012 10:23:06 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1201200933160.29049@frira.zrqbmnf.qr>
References: <1326990381-14534-1-git-send-email-jengelh@medozas.de> <1326990381-14534-2-git-send-email-jengelh@medozas.de> <20120120002329.GB3176@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:34281 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752620Ab2ATJXI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Jan 2012 04:23:08 -0500
In-Reply-To: <20120120002329.GB3176@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2012-01-20 01:23, Pablo Neira Ayuso wrote:
>> +#ifndef _NET_NETFILTER_XTABLES2_H
>> +#define _NET_NETFILTER_XTABLES2_H 1
>> +
>> +#define XTABLES2_VTAG "Xtables2 A8"
>
>I don't want to center the discussion on naming, but I'd prefer if we
>stick to xtables without version 2 and A8 (what does it mean A8, btw?).

Architecture no. 8 (it's in the technical PDFs posted last time).
I just had to enumerate the different implementation proposals that
we have had over time.

>At some point the old xtables infrastructure will be removed, then
>we'll have lots of references to xt2 in the tree.

That can be renamed afterwards when xt1 is gone.
Right now I feel it is a reasonable separation method,
and the '2' is not present in any static part of the kernel-user 
interface.

>> index 32bff6d..5b3d9ca 100644
>> --- a/net/netfilter/Kconfig
>> +++ b/net/netfilter/Kconfig
>> @@ -321,7 +321,13 @@ config NETFILTER_XTABLES
>>  	  This is required if you intend to use any of ip_tables,
>>  	  ip6_tables or arp_tables.
>>  
>> -if NETFILTER_XTABLES
>> +config NETFILTER_XTABLES2
>> +	tristate "Netfilter Xtables2 packet filtering"
>> +	---help---
>> +	Xtables2 is a rework of the internal architecture of Xtables.
>> +	It supersedes iptables, ip6tables, arptables and ebtables.
>
>My idea is that this does not supersede any of these tools.

Right, the wording is chosen little weirdly, since no kernel
interface (except maybe sysfs) can replace a userspace tool to do the 
talking.

>Instead, these tools should be ported to the netlink interface.
>I prefer if users don't notice any change regarding tools in the
>short term.

I have it all worked out :) they won't notice.

>I still think there's valuable work in Patrick's nftables. IMO, the
>scope of this work should be limited to providing the netlink
>interface for iptables (ip6tables, arptables, and so on), not modifying
>the command line tool syntax (which is a different discussion, don't
>get me wrong I'm not telling that revisiting the syntax is bad, but
>it's a different discussion and I don't want to mix things).

I concur, this is already underway in exactly the way you say it.
