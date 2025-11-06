Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E25130B506
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Nov 2025 10:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762423228; cv=none; b=kBQhFMGbP0LtzuX3T4S7vUaFQ+PspKO4JHLtudwwyJg/mYaUjbESI9/prU1z+bkbc30IFU5DWEy5eNbj1cAXacr0Ktm33JudarbSIJPOa5XOXv7bNCh8sQQZkH7dkXWhz+iJwKEFUHCRGCV3T96z528dm2St5mtfzK2Nu27R2Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762423228; c=relaxed/simple;
	bh=Fhbm+jCXOV176bsCApwW5Y6esJwds1PrG5VapGP0Cto=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Sj6WYnM46zZ9elPug/gVcH2vCzbK4hhsbeXTlS8UntLf1Pq+1UF73yj5OyeUbC2fTz9P0FRq7JI1leHk4CFD0tyJ6mYRyECCMv3Co/Vg+ahvFnnn/1zT48CkF/U5BLZvuIzagi7w9rhWk2S8r7alCqzvNADdR+GDgH6a59+IzeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=EnF4JGrX; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=WAy3aE65; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=EnF4JGrX; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=WAy3aE65; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="EnF4JGrX";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="WAy3aE65";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="EnF4JGrX";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="WAy3aE65"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 37A922116D;
	Thu,  6 Nov 2025 10:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762423224; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JlmAauOd10dOeyOY2M1pIjpuf/4+TUhWDwYpNkaKvsI=;
	b=EnF4JGrXQFgAZ0C2b5+w418aSd2w8vh/KxXkjIRJxLgsxB8zUyYx0QxLsoZunWCEL1kRWV
	b3iGloKZCoG1aLrDuyXIzKk2M/i1UXvefdnlVd/zNJOKsWrNoQr+SEjZHRqa0g+Izgu5/O
	0eNZEXQtTb9yXOrTZkCtNMEMDs2lG24=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762423224;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JlmAauOd10dOeyOY2M1pIjpuf/4+TUhWDwYpNkaKvsI=;
	b=WAy3aE651KbaJAENuldc+EqgohyQrZGendVmX1LiGhuRop7IV6Y9EtKmm7Qym5mKVkeUAq
	7i/YfY6B9VXAfhDQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=EnF4JGrX;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=WAy3aE65
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762423224; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JlmAauOd10dOeyOY2M1pIjpuf/4+TUhWDwYpNkaKvsI=;
	b=EnF4JGrXQFgAZ0C2b5+w418aSd2w8vh/KxXkjIRJxLgsxB8zUyYx0QxLsoZunWCEL1kRWV
	b3iGloKZCoG1aLrDuyXIzKk2M/i1UXvefdnlVd/zNJOKsWrNoQr+SEjZHRqa0g+Izgu5/O
	0eNZEXQtTb9yXOrTZkCtNMEMDs2lG24=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762423224;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JlmAauOd10dOeyOY2M1pIjpuf/4+TUhWDwYpNkaKvsI=;
	b=WAy3aE651KbaJAENuldc+EqgohyQrZGendVmX1LiGhuRop7IV6Y9EtKmm7Qym5mKVkeUAq
	7i/YfY6B9VXAfhDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A95A413A31;
	Thu,  6 Nov 2025 10:00:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ARFJJrdxDGlSNQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 06 Nov 2025 10:00:23 +0000
Message-ID: <1f5a5a3d-a38a-4f81-9912-38242480de9c@suse.de>
Date: Thu, 6 Nov 2025 11:00:16 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3 nf-next] netfilter: nf_conncount: only track
 connection if it is not confirmed
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 pablo@netfilter.org, phil@nwl.cc, aconole@redhat.com, echaudro@redhat.com,
 i.maximets@ovn.org, dev@openvswitch.org
References: <20251106005557.3849-1-fmancera@suse.de>
 <20251106005557.3849-2-fmancera@suse.de> <aQv8YE3sZ1Rp1iYG@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aQv8YE3sZ1Rp1iYG@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 37A922116D
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -4.51



On 11/6/25 2:39 AM, Florian Westphal wrote:
> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>> Since commit d265929930e2 ("netfilter: nf_conncount: reduce unnecessary
>> GC") if nftables/iptables connlimit is used without a check for new
>> connections there can be duplicated entries tracked.
>>
>> Pass the nf_conn struct directly to the nf_conncount API and check
>> whether the connection is confirmed or not inside nf_conncount_add(). If
>> the connection is confirmed, skip it.
> 
> I think there is a bit too much noise here, can this be
> split in several chunks?
> 

Not sure, I could try but the noise comes from removing zone and tuple 
which requires many changes around. Otherwise this would compile with 
warnings/errors. I am not sure I can split this more.

>> -unsigned int nf_conncount_count(struct net *net,
>> +unsigned int nf_conncount_count(struct net *net, const struct nf_conn *ct,
>>   				struct nf_conncount_data *data,
>> -				const u32 *key,
>> -				const struct nf_conntrack_tuple *tuple,
>> -				const struct nf_conntrack_zone *zone);
>> +				const u32 *key);
> 
> nf_conn *ct has pitfalls that I did not realize earlier.
> Current code is also buggy in that regard.
> Maybe we need additional function to ease this for callers.
> 
> See below.
>> +static int __nf_conncount_add(const struct nf_conn *ct,
>> +			      struct nf_conncount_list *list)
>>   {
>>   	const struct nf_conntrack_tuple_hash *found;
>>   	struct nf_conncount_tuple *conn, *conn_n;
>> +	const struct nf_conntrack_tuple *tuple;
>> +	const struct nf_conntrack_zone *zone;
>>   	struct nf_conn *found_ct;
>>   	unsigned int collect = 0;
>>   
>> +	if (!ct || nf_ct_is_confirmed(ct))
>> +		return -EINVAL;
>> +
> 
> When is the caller expected to pass a NULL ct?
> Maybe this just misses a comment.
> 

No, I don't think the caller is expected to pass a NULL ct. That should 
be removed.

>> index fc35a11cdca2..e815c0235b62 100644
>> --- a/net/netfilter/nft_connlimit.c
>> +++ b/net/netfilter/nft_connlimit.c
>> @@ -24,28 +24,35 @@ static inline void nft_connlimit_do_eval(struct nft_connlimit *priv,
>>   					 const struct nft_pktinfo *pkt,
>>   					 const struct nft_set_ext *ext)
>>   {
>> -	const struct nf_conntrack_zone *zone = &nf_ct_zone_dflt;
>> -	const struct nf_conntrack_tuple *tuple_ptr;
>> +	struct nf_conntrack_tuple_hash *h;
>>   	struct nf_conntrack_tuple tuple;
>>   	enum ip_conntrack_info ctinfo;
>>   	const struct nf_conn *ct;
>>   	unsigned int count;
>> -
>> -	tuple_ptr = &tuple;
>> +	int err;
>>   
>>   	ct = nf_ct_get(pkt->skb, &ctinfo);
>> -	if (ct != NULL) {
>> -		tuple_ptr = &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
>> -		zone = nf_ct_zone(ct);
>> -	} else if (!nf_ct_get_tuplepr(pkt->skb, skb_network_offset(pkt->skb),
>> -				      nft_pf(pkt), nft_net(pkt), &tuple)) {
>> -		regs->verdict.code = NF_DROP;
>> -		return;
>> +	if (!ct) {
>> +		if (!nf_ct_get_tuplepr(pkt->skb, skb_network_offset(pkt->skb),
>> +				       nft_pf(pkt), nft_net(pkt), &tuple)) {
>> +			regs->verdict.code = NF_DROP;
>> +			return;
>> +		}
>> +
>> +		h = nf_conntrack_find_get(nft_net(pkt), &nf_ct_zone_dflt, &tuple);
>> +		if (!h) {
>> +			regs->verdict.code = NF_DROP;
>> +			return;
>> +		}
>> +		ct = nf_ct_tuplehash_to_ctrack(h);
> 
> This ct had its refcount incremented.
> 

Thank you! Will fix it.

> I also see that this shared copypaste with xtables.
> Would it be possible to pass 'const struct sk_buff *'
> and let the nf_conncount core handle this internally?
> 
> nf_conncount_add(net, pf, skb, priv->list);
> 
> which does:
> 	ct = nf_ct_get(skb, &ctinfo);
> 	if (ct && !nf_ct_is_template(ct))
> 		return __nf_conncount_add(ct, list);
> 
> 	if (!nf_ct_get_tuplepr(skb, skb_network_offset(skb), pf, net,
> 				&tuple))
> 		return -ERR;
> 
> 	if (ct)	/* its a template, so do lookup in right zone */
> 		zone = nf_ct_zone(ct);
> 	else
> 		zone = &nf_ct_zone_dflt;
> 
> 	h = nf_conntrack_find_get(nft_net(pkt), zone, &tuple);
> 	if (!h)
> 		return -ERR;
> 
> 	ct = nf_ct_tuplehash_to_ctrack(h);
> 
> 	err = __nf_conncount_add(ct, list);
> 
> 	nf_ct_put(ct):
> 
> 	return err;
> 
> I.e., the existing nf_conncount_add() becomes a helper that takes
> a ct, as you have already proposed, but its renamed and turned into
> an internal helper so frontends don't need to duplicate tuple lookup.
> 
> Alternatively, no need to rename it and instead add a new API call
> that takes the ct argument, e.g. 'nf_conncount_add_ct' or whatever,
> and then make nf_conncount_add() internal in a followup patch.
> 

Unfortunately, I do not think this is possible. xt_connlimit is using 
the rbtree with nf_conncount_count() while nft_connlimit isn't. I 
believe we do not want to change that. In addition, for the rbtree we 
need to calculate the key.. I would leave this code as duplicated given 
that is shared only between xt_connlimit and nft_connlimit. Openvswitch 
doesn't care about this as they always call nf_conncount_count() while 
holding a reference to a ct..

>> +		h = nf_conntrack_find_get(net, &nf_ct_zone_dflt, &tuple);
> 
> We should not restrict the lookup to the default zone,
> but we should follow what the template (if any) says.
> 
> I under-estimated the work to get this right, I think this is too much
> code to copypaste between nft+xt frontends.  Sorry for making that
> suggestion originally.

No worries at all, I think there is some benefit from this change even 
with the copy-paste. Maybe we can create a helper function to just get 
the ct from the sk_buff.. what about "nf_conntrack_get_or_find()"? I 
accept suggestions for a better name :)

