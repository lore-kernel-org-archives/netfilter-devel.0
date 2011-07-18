From: Rainer Weikusat <rweikusat@mobileactivedefense.com>
Subject: Re: [PATCH] netfilter: add per-namespace logging to nfnetlink_log.c
Date: Mon, 18 Jul 2011 20:11:33 +0100
Message-ID: <87livve74q.fsf@sapphire.mobileactivedefense.com>
References: <87sjqqawmk.fsf@sapphire.mobileactivedefense.com>
	<4E245D70.4030907@trash.net>
	<8739i3fp6s.fsf@sapphire.mobileactivedefense.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Rainer Weikusat <rweikusat@mobileactivedefense.com>,
	netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mss-uk.mssgmbh.com ([217.174.251.109]:60018 "EHLO
	mss-uk.mssgmbh.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab1GRTLn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Jul 2011 15:11:43 -0400
In-Reply-To: <8739i3fp6s.fsf@sapphire.mobileactivedefense.com> (Rainer Weikusat's message of "Mon\, 18 Jul 2011 18\:56\:11 +0100")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Rainer Weikusat <rw@sapphire.mobileactivedefense.com> writes:
> Patrick McHardy <kaber@trash.net> writes:

[...]

>>> +#define INSTANCE_BUCKETS	16
>>> +
>>> +struct nfulnl_instances {
>>> +	spinlock_t lock;
>>> +	atomic_t global_seq;
>>> +	struct hlist_head table[INSTANCE_BUCKETS];
>>> +	unsigned hash_init;
>>> +#ifdef NET_NS
>>> +	struct net *net;
>>> +#endif
>>> +};
>>> +
>>>  struct nfulnl_instance {
>>>  	struct hlist_node hlist;	/* global list of instances */
>>>  	spinlock_t lock;
>>> @@ -67,14 +85,92 @@ struct nfulnl_instance {
>>>  	u_int16_t flags;
>>>  	u_int8_t copy_mode;
>>>  	struct rcu_head rcu;
>>> +#ifdef NET_NS
>>> +	struct nfulnl_instances *instances;
>>> +#endif
>>
>> This seems odd, the usual way is to add the global data to the
>> net-ns structure.
>
> Since a facility for having 'per subsystem' network namespace specific
> data exists, there seems to be little reason to not use it.

An additional remark: There is actually a reason for using it, namely,
'adding global data to the net-ns structure' implies that this
structure has to contain per-module data of modules which aren't
loaded, while using 'generic net pointers' enables this data to be
allocated/ deallocated on module load/ unload.
