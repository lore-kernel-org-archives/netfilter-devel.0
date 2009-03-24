From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] ctnetlink: optional packet drop to make event delivery
 reliable
Date: Tue, 24 Mar 2009 14:41:38 +0100
Message-ID: <49C8E312.5060005@netfilter.org>
References: <20090324110706.13981.24167.stgit@Decadence> <49C8DE75.1050109@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59099 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757847AbZCXNlr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Mar 2009 09:41:47 -0400
In-Reply-To: <49C8DE75.1050109@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> diff --git a/include/net/netfilter/nf_conntrack_core.h
>> b/include/net/netfilter/nf_conntrack_core.h
>> index 5a449b4..98078b2 100644
>> --- a/include/net/netfilter/nf_conntrack_core.h
>> +++ b/include/net/netfilter/nf_conntrack_core.h
>> @@ -62,8 +62,11 @@ static inline int nf_conntrack_confirm(struct
>> sk_buff *skb)
> 
> What tree is this against? I get reject in my nf-next tree.

net-next.git with some patches that you passed to 2.6.29 which are not
in your tree yet. I was aware of this but I didn't know how to proceed
exactly in this situation.

>>      if (ct && ct != &nf_conntrack_untracked) {
>>          if (!nf_ct_is_confirmed(ct) && !nf_ct_is_dying(ct))
>>              ret = __nf_conntrack_confirm(skb);
>> -        if (likely(ret == NF_ACCEPT))
>> -            nf_ct_deliver_cached_events(ct);
>> +        if (likely(ret == NF_ACCEPT) &&
>> +            nf_ct_deliver_cached_events(ct) < 0) {
> 
> The combined condition is unlikely I'd say. My main question though:
> how does this make event delivery reliable? It will drop the packet,
> fine, but all state changes have already been performed, new connections
> have been confirmed, etc.

Indeed. This is patch is missing some flag in the conntrack that I could
set to send the event once the packet is retransmitted.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
