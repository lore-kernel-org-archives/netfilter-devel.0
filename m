Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E917D4734CF
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Aug 2026 16:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787762935; cv=none; b=TrvIJGRuOa4g15PMDp7JNnI3PdfPuD/WeQFr+4rLo7mvhc9QCVKfuIiAMu2vpm5jrCaNpZKEGP7Uu3uaRO1idPa8/v6sAUbgnv1KX94nbbkCFqXN5MMgoDbrnMKSE6jYgWl9koAAK0ToujwJ/hGk8Z7Do+XF9l10/p33BdDDDfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787762935; c=relaxed/simple;
	bh=F5rHLRtoFTpX1SncFFWRPkc/LgzyS2R/uaT4Qk4QNMs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YTqs94lp3Tx5Z/ZC8N/qrcc9gapj7JomP+8J/pQBIvzs4seZrkHmymQo0V50AzypVdrZ6gOXHRdUY6ZstSHrJEyGHirrSYnER7vXjx8Ey+4ROYa6Hqogh6XF2zx0aVcwkNcGdCUuL6LwTZu+LXbS0iob9X+Y7/IpcG4tIDCmjps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=XPgKW4Sj; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=rwC84hEW; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=l+AQB4D2; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Sy97B1jL; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="XPgKW4Sj";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="rwC84hEW";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="l+AQB4D2";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Sy97B1jL"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6E39B21228;
	Wed, 26 Aug 2026 16:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787762908; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xmZlRw4AtTgWeTHNa7GIU/xLHhYi2mVbObzQmhv11r0=;
	b=XPgKW4SjURed/MSBdlf6piFzF+o49Q2aFJy0cdX/Iq1QVbgXTJM4yzTHmzQlIJD8TjR51Y
	UpN6Jr8GX/oU9LUPYU7vMF5dtYG7vhoS4upMXDHwFh/8HnaA4Mw9zT7INXAByJUz5lXg5x
	iuLzm7KRS6ColUOUzTp1dO/UzM66E2M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787762908;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xmZlRw4AtTgWeTHNa7GIU/xLHhYi2mVbObzQmhv11r0=;
	b=rwC84hEW9BmqWR8tBixmynbjyO0Jps1YEr2M7qnSWXxBZ1L1wN7WBWRHhfS66qsg3L8+aP
	kGVYuUgMmedAbZBA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=l+AQB4D2;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Sy97B1jL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787762904; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xmZlRw4AtTgWeTHNa7GIU/xLHhYi2mVbObzQmhv11r0=;
	b=l+AQB4D28EHDnZHCiDXoPlzUBlhUWUzuoS8uW2a5ItRIpLeyyq1l3W5Mom6+4eTUSz8xHF
	HemFOrZmybD7xb8uDC7UdHedJJgP0mC3x5oLELcfTcqRSCA+SstacnvcEU1l8vXW06/AkL
	l0a7/MZKCuMlaxG8KbMyXzakgSdWsJs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787762904;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xmZlRw4AtTgWeTHNa7GIU/xLHhYi2mVbObzQmhv11r0=;
	b=Sy97B1jLzIRFsPL+rm3C7LAraJmsJB8mrH89y2iDIQIM/M5r+R1oKgfgqLUeNPye4oslId
	0LrM47rHV3DKeYCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1766913354;
	Wed, 26 Aug 2026 16:48:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MKTiAtgYj2o+LwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Wed, 26 Aug 2026 16:48:24 +0000
Message-ID: <ddea4e10-2aa9-4063-ab17-5c86d5ec7125@suse.de>
Date: Wed, 26 Aug 2026 18:47:57 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf v3] netfilter: nf_tables: fix device name and prefix
 match in hook lookup
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 pablo@netfilter.org, fw@strlen.de, Wei Fang <void0red@gmail.com>
References: <20260826133208.4550-1-fmancera@suse.de>
 <ao8SujdfOcqEJLUD@orbyte.nwl.cc>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <ao8SujdfOcqEJLUD@orbyte.nwl.cc>
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
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,netfilter.org,strlen.de,gmail.com];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,suse.de:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Rspamd-Queue-Id: 6E39B21228
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

On 8/26/26 6:22 PM, Phil Sutter wrote:
> On Wed, Aug 26, 2026 at 03:32:08PM +0200, Fernando Fernandez Mancera wrote:
>> Currently, a netdev chain or flowtable hooked to a device prefix can be
>> unintentionally deleted by a control-plane request targeting an exact
>> device name or even a shorter one due to the usage of min() to calculate
>> the length to match.
>>
>> Fix this by making sure an exact device match never matches a prefix and
>> that both the target and the candidate have the same length during
>> delete operation. The add and update paths retain the existing overlap
>> matching to prevent a single device from matching multiple hooks.
>>
>> Reported-by: Wei Fang <void0red@gmail.com>
>> Closes: https://lore.kernel.org/netfilter-devel/CANE+tVrDeNCHQVmsqkV2ozeBqyE3GtRDMhZgsg1bhw10yGNTRQ@mail.gmail.com/
>> Fixes: 6d07a289504a ("netfilter: nf_tables: Support wildcard netdev hook specs")
>> Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
>> ---
>>   net/netfilter/nf_tables_api.c | 24 ++++++++++++++----------
>>   1 file changed, 14 insertions(+), 10 deletions(-)
>>
>> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
>> index c112ecc4fca3..9ef12feec1ac 100644
>> --- a/net/netfilter/nf_tables_api.c
>> +++ b/net/netfilter/nf_tables_api.c
>> @@ -1978,7 +1978,7 @@ static int nft_dump_stats(struct sk_buff *skb, struct nft_stats __percpu *stats)
>>   	return -ENOSPC;
>>   }
>>   
>> -static bool hook_is_prefix(struct nft_hook *hook)
>> +static bool hook_is_prefix(const struct nft_hook *hook)
> 
> This is an unrelated change now.
> 

Oops, yes sorry.

>>   {
>>   	return strlen(hook->ifname) >= hook->ifnamelen;
>>   }
>> @@ -2440,11 +2440,14 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
>>   }
>>   
>>   static struct nft_hook *nft_hook_list_find(struct list_head *hook_list,
>> -					   const struct nft_hook *this)
>> +					   const struct nft_hook *this,
>> +					   bool strict)
>>   {
>>   	struct nft_hook *hook;
>>   
>>   	list_for_each_entry(hook, hook_list, list) {
>> +		if (strict && hook->ifnamelen != this->ifnamelen)
>> +			continue;
>>   		if (!strncmp(hook->ifname, this->ifname,
>>   			     min(hook->ifnamelen, this->ifnamelen))) {
>>   			if (hook->flags & NFT_HOOK_REMOVE)
>> @@ -2486,7 +2489,7 @@ static int nf_tables_parse_netdev_hooks(struct net *net,
>>   			err = PTR_ERR(hook);
>>   			goto err_hook;
>>   		}
>> -		if (nft_hook_list_find(hook_list, hook)) {
>> +		if (nft_hook_list_find(hook_list, hook, false)) {
>>   			NL_SET_BAD_ATTR(extack, tmp);
>>   			nft_netdev_hook_free(hook);
>>   			err = -EEXIST;
>> @@ -2943,7 +2946,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
>>   					ops->hook	= basechain->ops.hook;
>>   				}
>>   
>> -				if (nft_hook_list_find(&basechain->hook_list, h)) {
>> +				if (nft_hook_list_find(&basechain->hook_list, h, false)) {
> 
> I think this should be a strict match. It fixes a problem you didn't
> intend to fix (I feel like an LLM-reviewer now), when updating a chain
> with a partially matching wildcard:
> 
> | add table netdev t
> | add chain netdev t c '{ type filter hook ingress priority 0; devices = { eth* }; }'
> | add chain netdev t c '{ type filter hook ingress priority 0; devices = { et* }; }'
> 
> The last command should return EEXIST instead of being accepted and
> treated as a NOP.

Hm. I am not so sure about it. Wouldn't that allow for overlapping 
devices with prefixes?

Given this is not straightforward and we need to think a bit about it, 
Pablo leave this out of the next PR to netdev. I am going to do a bit 
more testing.

> 
>>   					list_del(&h->list);
>>   					nft_netdev_hook_free(h);
>>   					continue;
>> @@ -2956,7 +2959,8 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
>>   					    !nft_trans_chain_update(trans))
>>   						continue;
>>   
>> -					if (nft_hook_list_find(&nft_trans_chain_hooks(trans), h)) {
>> +					if (nft_hook_list_find(&nft_trans_chain_hooks(trans),
>> +							       h, false)) {
>>   						nft_chain_release_hook(&hook);
>>   						return -EEXIST;
>>   					}
>> @@ -3257,7 +3261,7 @@ static int nft_delchain_hook(struct nft_ctx *ctx,
>>   		return err;
>>   
>>   	list_for_each_entry(this, &chain_hook.list, list) {
>> -		hook = nft_hook_list_find(&basechain->hook_list, this);
>> +		hook = nft_hook_list_find(&basechain->hook_list, this, true);
>>   		if (!hook) {
>>   			err = -ENOENT;
>>   			goto err_chain_del_hook;
>> @@ -9073,7 +9077,7 @@ static int nft_register_flowtable_net_hooks(struct net *net,
>>   			if (!nft_is_active_next(net, ft))
>>   				continue;
>>   
>> -			if (nft_hook_list_find(&ft->hook_list, hook)) {
>> +			if (nft_hook_list_find(&ft->hook_list, hook, false)) {
>>   				err = -EEXIST;
>>   				goto err_unregister_net_hooks;
>>   			}
>> @@ -9150,7 +9154,7 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
>>   		return err;
>>   
>>   	list_for_each_entry_safe(hook, next, &flowtable_hook.list, list) {
>> -		if (nft_hook_list_find(&flowtable->hook_list, hook)) {
>> +		if (nft_hook_list_find(&flowtable->hook_list, hook, false)) {
> 
> Same here.
> 
> I'll write test cases for nftables shell test suite to cover these.
> 

Thank you Phil for these reviews!

> Thanks, Phil>
>>   			list_del(&hook->list);
>>   			nft_netdev_hook_free(hook);
>>   			continue;
>> @@ -9163,7 +9167,7 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
>>   			    !nft_trans_flowtable_update(trans))
>>   				continue;
>>   
>> -			if (nft_hook_list_find(&nft_trans_flowtable_hooks(trans), hook)) {
>> +			if (nft_hook_list_find(&nft_trans_flowtable_hooks(trans), hook, false)) {
>>   				err = -EEXIST;
>>   				goto err_flowtable_update_hook;
>>   			}
>> @@ -9383,7 +9387,7 @@ static int nft_delflowtable_hook(struct nft_ctx *ctx,
>>   		return err;
>>   
>>   	list_for_each_entry(this, &flowtable_hook.list, list) {
>> -		hook = nft_hook_list_find(&flowtable->hook_list, this);
>> +		hook = nft_hook_list_find(&flowtable->hook_list, this, true);
>>   		if (!hook) {
>>   			err = -ENOENT;
>>   			goto err_flowtable_del_hook;
>> -- 
>> 2.55.0
>>
>>

