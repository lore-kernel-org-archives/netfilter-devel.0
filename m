Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88572416855
	for <netfilter-devel@vger.kernel.org>; Mon, 24 Aug 2026 12:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787574265; cv=none; b=JkwhBIgrEzKrP5xspLVINY+QQ1ZNOE1fM9bDuOJQZKyBKCJb4IgQLOGnW6vlfS0ciJxxlga3BALK/+RGrpcX7WApwMPzwWM3qC3wSfq8B+abOoL/2yv02b3WCAAY1wwXyQadECv6jVitghxPmPPV9VhCJtERnGzZbop/UBvUfEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787574265; c=relaxed/simple;
	bh=zKrpjpLbQbT/qn/FLE3qngUQ0HVj9QaUw6HNJNw/r1k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d6kG//GVRltR80HV3Hka1LuCkaFail7Obsu7SXkqmHDNWVuds3ewN+/rREUAOVPOb3logJQJ+LC4gA8EObgwyzf6sGXgecJtJ65UVzCBt4xx7ot5217qog6idx87TogT/bjUQ8dUcm5CboOxzFMdxSDh8G9cfSaiAsGSVyHd11o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=LW79rLYf; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=05goAFdx; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=nZB2jnV4; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=iS5oUJCG; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="LW79rLYf";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="05goAFdx";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="nZB2jnV4";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="iS5oUJCG"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E99D386944;
	Mon, 24 Aug 2026 12:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787574256; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vO+uGmcfabdY/BbD7alOdB///W+fQsY+OddaILHzL5c=;
	b=LW79rLYftq0HL+V96/XUHaTyY7AAAOxjYTROsaCyr7gF2ON/EgWa3fgIX1/vbETOH51Ktg
	yoMo1llTYXgE+6JIT/aPIxaBuZXAAaKd41vl+f2+Y9m5/HUV5v2z94fBxoYTs6DjqKruks
	X64XsUq19pBElvNATrFf12Ihvchddmo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787574256;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vO+uGmcfabdY/BbD7alOdB///W+fQsY+OddaILHzL5c=;
	b=05goAFdxFo6U6lQ+MD0sCHzhh9/rNBVkt/5ZtTCFjiC7Z6FSaWpf0I2Q2mzI24HvhZH+oC
	5sZ/9F0dp+q265CQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=nZB2jnV4;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=iS5oUJCG
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787574251; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vO+uGmcfabdY/BbD7alOdB///W+fQsY+OddaILHzL5c=;
	b=nZB2jnV4Yngf7u6+yzRMXlFezRhSsAoKgqdLd/SOmDKpGszaIvyXpTLTAwwoBixUbeEZyz
	TNCIjZexW0rM5heZmaCpOgQacdryHkcEMB9AjSSCSCK3h6M4tsg9BuC7aDCE/w1xbMlHFq
	HNRpjA4Kcs+EfUx+rhOdCdSnjLP7tIo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787574251;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vO+uGmcfabdY/BbD7alOdB///W+fQsY+OddaILHzL5c=;
	b=iS5oUJCGQZ5mOLGz2sAy5DqXBZd/5vMrCL7JW9Tg5Ordsm9+MypS5qYphQ9bWwSvQUzbQp
	3CNvcyruwb2uRgDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 94BAA13332;
	Mon, 24 Aug 2026 12:24:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4K99Ies3jGoUGwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 24 Aug 2026 12:24:11 +0000
Message-ID: <c409c65e-77b6-4bfa-bf42-027328b101dc@suse.de>
Date: Mon, 24 Aug 2026 14:23:49 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf v2] netfilter: nf_tables: fix device name and prefix
 match in hook lookup
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, fw@strlen.de,
 phil@nwl.cc, Wei Fang <void0red@gmail.com>
References: <20260824092805.4940-1-fmancera@suse.de>
 <aow3QRgFONC_OYnw@chamomile>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aow3QRgFONC_OYnw@chamomile>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,netfilter.org,strlen.de,nwl.cc,gmail.com];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid,suse.de:dkim];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Rspamd-Queue-Id: E99D386944
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

On 8/24/26 2:21 PM, Pablo Neira Ayuso wrote:
> Hi Fernando,
> 
> On Mon, Aug 24, 2026 at 11:28:05AM +0200, Fernando Fernandez Mancera wrote:
>> Currently, a netdev chain or flowtable hooked to a device prefix can be
>> unintentionally deleted by a control-plane request targeting an exact
>> device name or even a shorter one due to the usage of min() to calculate
>> the length to match.
>>
>> Fix this by making sure an exact device match never matches a prefix and
>> that both the target and the candidate have the same length during
>> delete operation. The add and update paths retain the existing overlap
>> matching to prevent a single device from matching multiple hooks.
> 
> netdev maintainers prefer follow ups for LLM reported issues.
> 
> Please, provide an incremental patch for your v1 that we can take in
> the next PR round.
> 

Oh really? Even in this situation? Will do once the PR is accepted. The 
patch won't be much different of course.

Thanks!

> Thanks!
> 
>> Reported-by: Wei Fang <void0red@gmail.com>
>> Closes: https://lore.kernel.org/netfilter-devel/CANE+tVrDeNCHQVmsqkV2ozeBqyE3GtRDMhZgsg1bhw10yGNTRQ@mail.gmail.com/
>> Fixes: 6d07a289504a ("netfilter: nf_tables: Support wildcard netdev hook specs")
>> Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
>> ---
>>   net/netfilter/nf_tables_api.c | 27 ++++++++++++++++++++++++---
>>   1 file changed, 24 insertions(+), 3 deletions(-)
>>
>> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
>> index c112ecc4fca3..3ad9a5e88c5b 100644
>> --- a/net/netfilter/nf_tables_api.c
>> +++ b/net/netfilter/nf_tables_api.c
>> @@ -1978,7 +1978,7 @@ static int nft_dump_stats(struct sk_buff *skb, struct nft_stats __percpu *stats)
>>   	return -ENOSPC;
>>   }
>>   
>> -static bool hook_is_prefix(struct nft_hook *hook)
>> +static bool hook_is_prefix(const struct nft_hook *hook)
>>   {
>>   	return strlen(hook->ifname) >= hook->ifnamelen;
>>   }
>> @@ -2457,6 +2457,27 @@ static struct nft_hook *nft_hook_list_find(struct list_head *hook_list,
>>   	return NULL;
>>   }
>>   
>> +static struct nft_hook *nft_hook_list_find_strict(struct list_head *hook_list,
>> +						  const struct nft_hook *this)
>> +{
>> +	struct nft_hook *hook;
>> +
>> +	list_for_each_entry(hook, hook_list, list) {
>> +		if (hook_is_prefix(hook) != hook_is_prefix(this))
>> +			continue;
>> +		if (hook->ifnamelen != this->ifnamelen)
>> +			continue;
>> +		if (!strncmp(hook->ifname, this->ifname, hook->ifnamelen)) {
>> +			if (hook->flags & NFT_HOOK_REMOVE)
>> +				continue;
>> +
>> +			return hook;
>> +		}
>> +	}
>> +
>> +	return NULL;
>> +}
>> +
>>   static int nf_tables_parse_netdev_hooks(struct net *net,
>>   					const struct nlattr *attr,
>>   					struct list_head *hook_list,
>> @@ -3257,7 +3278,7 @@ static int nft_delchain_hook(struct nft_ctx *ctx,
>>   		return err;
>>   
>>   	list_for_each_entry(this, &chain_hook.list, list) {
>> -		hook = nft_hook_list_find(&basechain->hook_list, this);
>> +		hook = nft_hook_list_find_strict(&basechain->hook_list, this);
>>   		if (!hook) {
>>   			err = -ENOENT;
>>   			goto err_chain_del_hook;
>> @@ -9383,7 +9404,7 @@ static int nft_delflowtable_hook(struct nft_ctx *ctx,
>>   		return err;
>>   
>>   	list_for_each_entry(this, &flowtable_hook.list, list) {
>> -		hook = nft_hook_list_find(&flowtable->hook_list, this);
>> +		hook = nft_hook_list_find_strict(&flowtable->hook_list, this);
>>   		if (!hook) {
>>   			err = -ENOENT;
>>   			goto err_flowtable_del_hook;
>> -- 
>> 2.55.0
>>

