From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] netfilter: add locking for counters zeroing
Date: Wed, 24 Sep 2008 12:08:15 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0809241206030.16193@fbirervta.pbzchgretzou.qr>
References: <4884bd82.Dh41l9jJY8sI8ajg%ole@ans.pl> <48DA643C.5000702@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Krzysztof Piotr Oledzki <ole@ans.pl>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39269 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbYIXQIR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Sep 2008 12:08:17 -0400
In-Reply-To: <48DA643C.5000702@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-09-24 12:01, Patrick McHardy wrote:
>> diff --git a/net/netfilter/nf_conntrack_netlink.c
>> b/net/netfilter/nf_conntrack_netlink.c
>> index 9432da4..ff1bbb0 100644
>> --- a/net/netfilter/nf_conntrack_netlink.c
>> +++ b/net/netfilter/nf_conntrack_netlink.c
>> @@ -545,6 +545,7 @@ ctnetlink_dump_table(struct sk_buff *skb, struct
>> netlink_callback *cb)
>>   u_int8_t l3proto = nfmsg->nfgen_family;
>>  
>> 	rcu_read_lock();
>> +	spin_lock_bh(&nf_conntrack_lock);
>
> We only need the spinlock. I'm not so happy about taking it
> unconditionally even though we might not be zeroing the
> counters. Moving it in the inner loop will greatly increase
> the amount of locks/unlocks on the other hand.
>
> How about moving the inner loop to a new function and adding
> back the ctnetlink_dump_counterzero (or whatever it was called)
> function? It would take the spinlock, while normal dumping
> would only use rcu_read_lock().

Perhaps this might work?

+	if (cb->args[0] >= nf_conntrack_htable_size) {
+		nf_ct_put(cb->args[1]);
+		return skb->len;
+	}

	rcu_read_lock();
	last = (struct nf_conn *)cb->args[1];
	for (...) {
		...
	}
out:
	if (last)
		nf_ct_put(last);
	return skb->len;
