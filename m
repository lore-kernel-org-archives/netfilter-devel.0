From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Xtables2 Netlink spec
Date: Fri, 17 Dec 2010 15:56:19 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1012171511100.29660@obet.zrqbmnf.qr>
References: <alpine.LNX.2.01.1011242314580.32646@obet.zrqbmnf.qr> <alpine.DEB.2.00.1011261950100.18019@blackhole.kfki.hu> <4D00C6A4.6090305@netfilter.org> <alpine.LNX.2.01.1012140257430.7384@obet.zrqbmnf.qr> <4D08C892.3080704@netfilter.org>
 <20101216140537.GA23297@canuck.infradead.org> <4D0B3387.5030807@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, netfilter@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:38106 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755137Ab0LQO4V (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Dec 2010 09:56:21 -0500
In-Reply-To: <4D0B3387.5030807@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2010-12-17 10:55, Pablo Neira Ayuso wrote:

>On 16/12/10 15:05, Thomas Graf wrote:
>> On Wed, Dec 15, 2010 at 02:54:26PM +0100, Pablo Neira Ayuso wrote:
>>>> BTW, can response messages - all those leading up to NLMSG_DONE -
>>>> have different nlmsg_type, or not?
>>>
>>> They all have the same type.
>> 
>> This is not a MUST. It is perfectly legal to f.e.:
>> 
>>  -> FOO_GET (seq=1, NLM_F_REQUEST)
>>  <- FOO_DEL (seq=1, NLM_F_MULTI)
>>  <- FOO_ADD (seq=1, NLM_F_MULTI)
>>  <- NLMSG_DONE (seq=1)
>
>What realistic situation will require this?

This does:

-> NFXTM_CHAIN_DUMP<NFXTA_NAME>
<- NFXTM_RULE_START<>
<- NFXTM_EMATCH<NFXTA_NAME,NFXTA_REVISION,NFXTA_DATA>
<- NFXTM_EMATCH<NFXTA_NAME,NFXTA_REVISION,NFXTA_DATA>
<- NFXTM_ETARGET<NFXTA_NAME,NFXTA_REVISION,NFXTA_DATA>
<- NFXTM_ETARGET<NFXTA_NAME,NFXTA_REVISION,NFXTA_DATA>
<- NFXTM_RULE_END<>
<- NFXTM_RULE_START<>
<- NFXTM_ETARGET<NFXTA_VERDICT>
<- NFXTM_RULE_END<>
<- NLMSG_DONE

This is 9 messages with answers related to the ruleset.

If only a single nlmsg_type was possible for NLM_F_MULTI replies,
this is probably how things would have looked:

-> CHAIN_DUMP<NFXTA_NAME>
<- CHAIN_DUMP<NFXTA_RULE_START>
<- CHAIN_DUMP<NFXTA_MATCH_START>
<- CHAIN_DUMP<NFXTA_NAME><NFXTA_REVISION><NFXTA_DATA>
<- CHAIN_DUMP<NFXTA_MATCH_END>
<- CHAIN_DUMP<NFXTA_MATCH_START>
<- CHAIN_DUMP<NFXTA_NAME><NFXTA_REVISION><NFXTA_DATA>
<- CHAIN_DUMP<NFXTA_MATCH_END>
<- CHAIN_DUMP<NFXTA_TARGET_START>
<- CHAIN_DUMP<NFXTA_NAME><NFXTA_REVISION><NFXTA_DATA>
<- CHAIN_DUMP<NFXTA_TARGET_END>
<- CHAIN_DUMP<NFXTA_TARGET_START>
<- CHAIN_DUMP<NFXTA_NAME><NFXTA_REVISION><NFXTA_DATA>
<- CHAIN_DUMP<NFXTA_TARGET_END>
<- CHAIN_DUMP<NFXTA_RULE_END>
<- CHAIN_DUMP<NFXTA_RULE_START>
<- CHAIN_DUMP<NFXTA_TARGET_START>
<- CHAIN_DUMP<NFXTA_VERDICT>
<- CHAIN_DUMP<NFXTA_TARGET_END>
<- CHAIN_DUMP<NFXTA_RULE_END>
<- NLMSG_DONE

This requires more forth-and-back between userspace and the kernel:
19 messages instead. Using multiple nlmsg_type seems a good thing to
exploit.
