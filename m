From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 01/12] IP set core support
Date: Wed, 19 Jan 2011 23:41:29 +0100
Message-ID: <4D376899.20609@trash.net>
References: yes <1295047436-20702-1-git-send-email-kadlec@blackhole.kfki.hu> <1295047436-20702-2-git-send-email-kadlec@blackhole.kfki.hu> <4D370BE5.4050901@trash.net> <alpine.DEB.2.00.1101192201310.31954@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55584 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021Ab1ASWld (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Jan 2011 17:41:33 -0500
In-Reply-To: <alpine.DEB.2.00.1101192201310.31954@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 19.01.2011 22:54, schrieb Jozsef Kadlecsik:
> Hi Patrick,
> 
> On Wed, 19 Jan 2011, Patrick McHardy wrote:
> 
>> On 15.01.2011 00:23, Jozsef Kadlecsik wrote:
>>> The patch adds the IP set core support to the kernel.
>>
>> Following are some comments based on a first review. I'll make another
>> pass over this patch to have a closer look at the netlink protocol.
> 
> First of all, thanks for the review! A very terse "description" of the 
> protocol can be found here: 
> https://git.netfilter.org/cgi-bin/gitweb.cgi?p=ipset.git;a=blob_plain;f=lib/PROTOCOL;hb=7cd45445d55b14b7aca69a81b7815a98afc51784

Thanks for the pointer.

>>> The netlink protocol passes all u16, etc values in network order, but it
>>> honors the NLA_F_NET_BYTEORDER flag. The protocol enforces the proper
>>> use of the NLA_F_NESTED flag for its container type of attributes.
>>> Backward/forward compatibility is supported with proper protocol (and set
>>> type) version number.
>>
>> I don't really see the benefit of accepting both byteorders, why not
>> simply define the byteorder to big endian (with or without the
>> NLA_F_NET_BYTEORDER flag)? 
> 
> It's a remnant of an early version: at the very beginning the set types 
> used their "natural" byte-ordering, so both form could appear. I'll
> keep it as big endiand only with the NLA_F_NET_BYTEORDER flag.

Great, that sounds good.
>>> +/* Sets are identified by an index in kernel space. Tweak with ip_set_id_t
>>> + * and IPSET_INVALID_ID if you want to increase the max number of sets.
>>> + */
>>> +typedef u16 ip_set_id_t;
>>
>> This typedef does not really fit any of the "acceptable" cases of
>> CodingStyle, but I see why you're using it.
> 
> Hm, it could be eliminated: with the exception of the list:set type, the 
> typedef is used in the core and the xt_set.c match/target files only. 
> 65535 sets should be enough for anyone (;-), but if it ever needs to be 
> changed, it's not a big deal.

Yeah, I'm actually not advocating for eliminating it, the intention
of making the maximum easily increasible without having to go through
all the source files makes sense in my opinion.

>>> ...
>>> +
>>> +/* Interface to iptables/ip6tables */
>>> +
>>> +#define SO_IP_SET		83
>>
>> Just wondering if we should define this in relation to IP_BASE_CTL
>> or something like that to avoid possible clashes in the future.
> 
> Or make it a module parameter?

I don't think that makes sense, the option needs to be known to
userspace and is part of the ABI. My main concern was clashes with
other options added in the future since the definition doesn't
use any of the reserved ranges, like IP_CTL_BASE. I wasn't able
to figure how you arrived at the value 83 and how we can avoid
people reusing this value.

>>> diff --git a/include/linux/netfilter/ipset/pfxlen.h b/include/linux/netfilter/ipset/pfxlen.h
>>> new file mode 100644
>>> index 0000000..fe7153c
>>> --- /dev/null
>>> +++ b/include/linux/netfilter/ipset/pfxlen.h
>>> @@ -0,0 +1,16 @@
>>> +#ifndef _PFXLEN_H
>>> +#define _PFXLEN_H
>>> +
>>> +#include <asm/byteorder.h>
>>> +#include <linux/netfilter.h> 
>>> +
>>> +/* Prefixlen maps, by Jan Engelhardt  */
>>> +extern const union nf_inet_addr prefixlen_netmask_map[];
>>> +extern const union nf_inet_addr prefixlen_hostmask_map[];
>>> +
>>> +#define NETMASK(n)	prefixlen_netmask_map[n].ip
>>> +#define NETMASK6(n)	prefixlen_netmask_map[n].ip6
>>> +#define HOSTMASK(n)	prefixlen_hostmask_map[n].ip
>>> +#define HOSTMASK6(n)	prefixlen_hostmask_map[n].ip6
>>
>> These names seem a bit to generic.
> 
> PREFIXLEN2NETMAKS are just overly long. PFLEN2NETMASK?

If you're going to change this anyways, I'd suggest a couple
of simple inline functions, perhaps ipset_pfxlen2mask() or
something like that.

>>> +static DEFINE_MUTEX(ip_set_type_mutex);		/* protects ip_set_type_list */
>>> +
>>> +static struct ip_set **ip_set_list;		/* all individual sets */
>>> +static ip_set_id_t ip_set_max = CONFIG_IP_SET_MAX; /* max number of sets */
>>> +
>>> +#define STREQ(a, b)	(strncmp(a, b, IPSET_MAXNAMELEN) == 0)
>>> +
>>> +static int max_sets;
>>> +
>>> +module_param(max_sets, int, 0600);
>>
>> unsigned int?
> 
> Why it's int at the first place??

I don't know :) My feeling is that people requiring negative numbers of
sets don't need iptables at all :)


> Thanks again, I fix the issues above and re-send the patches.

Thanks Jozsef.

I'll continue my review tommorrow.

