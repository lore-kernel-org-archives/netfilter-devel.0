From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] netfilter: conntrack: move event cache to conntrack
 extension infrastructure
Date: Sat, 06 Jun 2009 08:24:55 +0200
Message-ID: <4A2A0BB7.7090909@netfilter.org>
References: <20090604110307.6702.10147.stgit@Decadence> <20090604110818.6702.51833.stgit@Decadence> <4A28FBCB.4070100@trash.net> <4A291863.4090604@netfilter.org> <4A29281B.6010607@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32946 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516AbZFFGZc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 6 Jun 2009 02:25:32 -0400
In-Reply-To: <4A29281B.6010607@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> Patrick McHardy wrote:
>>>> @@ -8,12 +8,14 @@ enum nf_ct_ext_id
>>>>      NF_CT_EXT_HELPER,
>>>>      NF_CT_EXT_NAT,
>>>>      NF_CT_EXT_ACCT,
>>>> +    NF_CT_EXT_ECACHE,
>>>>      NF_CT_EXT_NUM,
>>>
>>> Quoting nf_conntrack_extend.c:
>>>
>>> /* This assumes that extended areas in conntrack for the types
>>>    whose NF_CT_EXT_F_PREALLOC bit set are allocated in order */
>>>
>>> Is that actually the case here? It might be beneficial to move
>>> this before accounting if possible, I guess its used more often.
>>
>> I think that accounting information is updated more often. Events are
>> only updated for very few packet specifically the setup and the
>> tear-down packets of a flow.
> 
> No, events are only sent to userspace every seldom. But f.i. TCP
> conntrack generates at least one event per packet.

Yes, that's true for small TCP connections, but not for long TCP ones.

> But what I actually meant was that its used more often I think.
> Never mind, also forget about the PREALLOC question, I should
> have read what I pasted :) Of course you could add the PREALLOC
> flag, when events are enabled you add the extension for every
> conntrack anyways.

Indeed, I'll add the PREALLOC flag.

[...]
>>> Why are we suddenly caching a lot more events manually?
>>
>> Currently, in user-space triggered events, we are including in the
>> event message some fields that may not have been updated. Now we can
>> provide more accurante events by notifying only the conntrack object
>> fields that have been updated.
>>
> The patch is already pretty large, please seperate that part if
> doesn't has to be in this patch to make it work.

I'll try to split this into another patch. Thanks for your comments!

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
