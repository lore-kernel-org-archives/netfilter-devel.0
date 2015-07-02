From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH nf] netfilter: arptables: use percpu jumpstack
Date: Thu, 2 Jul 2015 13:48:22 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1507021331210.9353@nerf40.vanv.qr>
References: <1435695660-26048-1-git-send-email-fw@strlen.de> <20150702113044.GA21930@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:58081 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304AbbGBLsX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jul 2015 07:48:23 -0400
In-Reply-To: <20150702113044.GA21930@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2015-07-02 13:30, Pablo Neira Ayuso wrote:
>> 
>> Unlike ip and ip6tables, arp tables were never converted to use the percpu
>> jump stack.
>> 
>>  net/ipv4/netfilter/arp_tables.c | 25 ++++++++++++++++---------
>> -				/* Save old back ptr in next entry */
>> -				struct arpt_entry *next = arpt_next_entry(e);
>> -				next->comefrom = (void *)back - table_base;
>>  
>> -				/* set back pointer to next entry */
>> -				back = next;
>> +				if (WARN_ON_ONCE(stackidx >= private->stacksize)) {
>> +					verdict = NF_DROP;
>> +					break;
>> +				}
>
>I can see you're getting this in sync with iptables, but I wonder
>about this defensive check to make sure we don't go over the allocated
>jumpstack area. This was added in f3c5c1bfd43.
>
>If we remove it and things are broken, then this will crash with a
>general protection fault when accessing memory out of the jumpstack
>boundary.

To the best of my knowledge, arp_tables does not offer any target
that can re-enter (such as REJECT, TEE, SYNPROXY do in IPv6/IPv4), so
we would never have a situation with stackidx >= stacksize anyway.

>Eric Dumazet indicated during the NFWS that it would be a good idea
>to make this jumpstack fixed length as in nftables, so we can place
>it in the stack and get rid of this percpu jumpstack that was
>introduced to cope with reentrancy (only TEE needs this).

fixed *and reduced* (you don't want to place a 64-chain list
onto the stack), and the reduction is what will be in conflict
with rulesets.
