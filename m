Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F13D337B90
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Oct 2025 08:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761811963; cv=none; b=HU+4PBS9P6Psi5oxki6NQGl9hp3TAdraeV7a9RW/2S6V+SbKW4tu4jQnD3OTinXlS3fJOKLdCSXlldwt7ud2RZw9lnD+jGHAi1mCqmTpMWRveIhi5o1NQrxzmujTKnlTkkGjsrkMy2Ck62kAmoQ44B11YiIBvA5KrwT2l/xkgJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761811963; c=relaxed/simple;
	bh=E2lzRf2FEy3gJmAHjpX0LS21T2+ircZO99u1RJqHnpA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GpF2rDQQFQJvRvy2mRqGSOjPbhiVVp30yeuLWkWbbaUZMNE21heEuKw1WL8TCOvJPQoM0mjvNfbUZA9qlcCle/RIMALvl+eviNFDVOkKsiv/VI75NM8PSiucaRKZeHXTCNdcdIC67u1Qyc54jqAB5S3mjUU4u12c2jE08hVLzwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=10ovsABE; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=xs/n8cCF; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=10ovsABE; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=xs/n8cCF; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="10ovsABE";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="xs/n8cCF";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="10ovsABE";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="xs/n8cCF"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1D97B1F7E3;
	Thu, 30 Oct 2025 08:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761811959; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MKFszFgPY8/LjOHvVZeG1Cq64sXaLOQSi8GaRVKJVvk=;
	b=10ovsABEAQeFnwQPhEZs+ASuxjn6UzYAOxbDmSVWkEYKLLZzmN9JP6918i7zAaO61lmOLi
	2eYPkJbDGMtXzMBo+KHInIjwc9YiPTiwWho5oRRxF4aOEk80iFQEdypuF5zmtkruyUk8M3
	qGQzId+PzHt51yhBT31Jt6KozVHFJiY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761811959;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MKFszFgPY8/LjOHvVZeG1Cq64sXaLOQSi8GaRVKJVvk=;
	b=xs/n8cCF51Ibmaj9nedsGl5nVUhqgMYEHVeurpNU5Mi2jlQhS7+5+jrFyMdFTANr5/ZGxd
	m8aWddksdFSeuLBw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761811959; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MKFszFgPY8/LjOHvVZeG1Cq64sXaLOQSi8GaRVKJVvk=;
	b=10ovsABEAQeFnwQPhEZs+ASuxjn6UzYAOxbDmSVWkEYKLLZzmN9JP6918i7zAaO61lmOLi
	2eYPkJbDGMtXzMBo+KHInIjwc9YiPTiwWho5oRRxF4aOEk80iFQEdypuF5zmtkruyUk8M3
	qGQzId+PzHt51yhBT31Jt6KozVHFJiY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761811959;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MKFszFgPY8/LjOHvVZeG1Cq64sXaLOQSi8GaRVKJVvk=;
	b=xs/n8cCF51Ibmaj9nedsGl5nVUhqgMYEHVeurpNU5Mi2jlQhS7+5+jrFyMdFTANr5/ZGxd
	m8aWddksdFSeuLBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CCB5A13393;
	Thu, 30 Oct 2025 08:12:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EYD+LvYdA2k2JgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 30 Oct 2025 08:12:38 +0000
Message-ID: <c58ae9ad-46f3-4853-bc61-ac725c860160@suse.de>
Date: Thu, 30 Oct 2025 09:12:32 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf v2] netfilter: nft_connlimit: fix duplicated tracking
 of a connection
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, fw@strlen.de
References: <20251029132318.5628-1-fmancera@suse.de>
 <aQJ6AysjCMTHLzsP@calendula>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aQJ6AysjCMTHLzsP@calendula>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid]
X-Spam-Flag: NO
X-Spam-Score: -4.30



On 10/29/25 9:33 PM, Pablo Neira Ayuso wrote:
> Hi Fernando,
> 
> On Wed, Oct 29, 2025 at 02:23:18PM +0100, Fernando Fernandez Mancera wrote:
>> Connlimit expression can be used for all kind of packets and not only
>> for packets with connection state new. See this ruleset as example:
>>
>> table ip filter {
>>          chain input {
>>                  type filter hook input priority filter; policy accept;
>>                  tcp dport 22 ct count over 4 counter
>>          }
>> }
>>
>> Currently, if the connection count goes over the limit the counter will
>> count the packets. When a connection is closed, the connection count
>> won't decrement as it should because it is only updated for new
>> connections due to an optimization on __nf_conncount_add() that prevents
>> updating the list if the connection is duplicated.
>>
>> In addition, since commit d265929930e2 ("netfilter: nf_conncount: reduce
>> unnecessary GC") there can be situations where a duplicated connection
>> is added to the list. This is caused by two packets from the same
>> connection being processed during the same jiffy.
>>
>> To solve these problems, check whether this is a new connection and only
>> add the connection to the list if that is the case during connlimit
>> evaluation. Otherwise run a GC to update the count. This doesn't yield a
>> performance degradation.
> 
> This is true is list is small, e.g. ct count over 4.
> 
> But user could much larger value, then every packet could trigger a
> long list walk, because gc is bound to CONNCOUNT_GC_MAX_NODES which is
> the maximum number of nodes that is _collected_.
> 
> And maybe the user selects:
> 
>    ct count over N mark set 0x1
> 
> where N is high, the gc walk can be long.
> 
> TBH, I added this expression mainly focusing on being used with
> dynset, I allowed it too in rules for parity. In the dynset case,
> there is a front-end datastructure (set) and this conncount list
> is per element. Maybe there high ct count is also possible.
> 
> With this patch, gc is called more frequently, not only for each new
> packet.
> 

How is it called more frequently? Before, it was calling 
nf_conncount_add() for every packet which is indeed performing a GC 
inside, both nf_conncount_add() and nf_conncount_gc_list() return 
immediately if a GC was performed during the same jiffy.

I tried with a limit of 2000 connections and didn't notice any 
performance change. I could try with CONNCOUNT_GC_MAX_NODES too.

>> Fixed in xt_connlimit too.
>>
>> Fixes: d265929930e2 ("netfilter: nf_conncount: reduce unnecessary GC")
>> Fixes: 976afca1ceba ("netfilter: nf_conncount: Early exit in nf_conncount_lookup() and cleanup")
>> Closes: https://lore.kernel.org/netfilter/trinity-85c72a88-d762-46c3-be97-36f10e5d9796-1761173693813@3c-app-mailcom-bs12/
>> Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
>> ---
>> v2: use nf_ct_is_confirmed(), add comment about why the gc call is
>> needed and fix this in xt_connlimit too.
>> ---
>>   net/netfilter/nft_connlimit.c | 17 ++++++++++++++---
>>   net/netfilter/xt_connlimit.c  | 14 ++++++++++++--
>>   2 files changed, 26 insertions(+), 5 deletions(-)
>>
>> diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
>> index fc35a11cdca2..dedea1681e73 100644
>> --- a/net/netfilter/nft_connlimit.c
>> +++ b/net/netfilter/nft_connlimit.c
>> @@ -43,9 +43,20 @@ static inline void nft_connlimit_do_eval(struct nft_connlimit *priv,
>>   		return;
>>   	}
>>   
>> -	if (nf_conncount_add(nft_net(pkt), priv->list, tuple_ptr, zone)) {
>> -		regs->verdict.code = NF_DROP;
>> -		return;
>> +	if (!ct || !nf_ct_is_confirmed(ct)) {
>> +		if (nf_conncount_add(nft_net(pkt), priv->list, tuple_ptr, zone)) {
>> +			regs->verdict.code = NF_DROP;
>> +			return;
>> +		}
>> +	} else {
>> +		/* Call gc to update the list count if any connection has been
>> +		 * closed already. This is useful to softlimit connections
>> +		 * like limiting bandwidth based on a number of open
>> +		 * connections.
>> +		 */
>> +		local_bh_disable();
>> +		nf_conncount_gc_list(nft_net(pkt), priv->list);
>> +		local_bh_enable();
>>   	}
>>   
>>   	count = READ_ONCE(priv->list->count);
>> diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
>> index 0189f8b6b0bd..5c90e1929d86 100644
>> --- a/net/netfilter/xt_connlimit.c
>> +++ b/net/netfilter/xt_connlimit.c
>> @@ -69,8 +69,18 @@ connlimit_mt(const struct sk_buff *skb, struct xt_action_param *par)
>>   		key[1] = zone->id;
>>   	}
>>   
>> -	connections = nf_conncount_count(net, info->data, key, tuple_ptr,
>> -					 zone);
>> +	if (!ct || !nf_ct_is_confirmed(ct)) {
>> +		connections = nf_conncount_count(net, info->data, key, tuple_ptr,
>> +						 zone);
>> +	} else {
>> +		/* Call nf_conncount_count() with NULL tuple and zone to update
>> +		 * the list if any connection has been closed already. This is
>> +		 * useful to softlimit connections like limiting bandwidth based
>> +		 * on a number of open connections.
>> +		 */
>> +		connections = nf_conncount_count(net, info->data, key, NULL, NULL);
>> +	}
> 
> Maybe remove this from xt_connlimit?
>

Dropping this would leave xt_connlimit broken for the use-cases I 
discussed with Florian on the v1.
>> +
>>   	if (connections == 0)
>>   		/* kmalloc failed, drop it entirely */
>>   		goto hotdrop;
>> -- 
>> 2.51.0
>>

