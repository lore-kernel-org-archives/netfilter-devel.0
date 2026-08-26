Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44283E557B
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Aug 2026 10:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787741774; cv=none; b=DCjRUqVPIwiF/O91jm86ZkQvVmkjex2m5miYt/+YdW95JRu+EWHp8EOG+bhD9m/inLc2dn0TbTBJzT0zbcY99EjJgB+aeDUIS6qa1wIYD9UaCv1RWHJwFpUntg8IQLfJnLzy7qDOwgEVwXfeuonA75T+FYEhSHxkgg/3rhDzwnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787741774; c=relaxed/simple;
	bh=+E4xIqzZk10mBQXzIH4tm2T9FGB1BEKfcHLZh+tUbcU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pnt7apHEIEnqZRu2HKEJxYwxwIZfU9zW9sDuySqYBK3aUv6u6aX6RDgSivo7IiUqiBFrp0918OAx7Ki50FZQpzDlHIIiOQcxC8R5EnPxOPckKu4zYsFAjQQKdF1GtX9W3uB39zhen4WxouHf4K0qXrWzUc8sUcT4NHfcu7sthiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=2KIFpwIp; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=XPtCp5Be; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ScPEoFl3; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Hv0VtATU; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="2KIFpwIp";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="XPtCp5Be";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ScPEoFl3";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Hv0VtATU"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E6E4D1F827;
	Wed, 26 Aug 2026 10:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787741759; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R/DI4VjCU05Ig5nR6Wlxq9Zcw7Yp/2BrpBSWfTePvTY=;
	b=2KIFpwIpKiJQSIBMGk23Y7gz/To4p9MWdS+dPGtyHNuS8SuY3lJyUa2lxUPl/68GFpg0+P
	ds0yNAA6NWw3bOPoRhTXq+hloocS4spGrn8oEXECXqAHjYunSX8qF/UaSEQFvTilXWmKzt
	pNY13DFWI+U6ab7Qd30DQ0SedsLfhIQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787741759;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R/DI4VjCU05Ig5nR6Wlxq9Zcw7Yp/2BrpBSWfTePvTY=;
	b=XPtCp5BeMakLcmdhnc7RXEO6EE4j3nwZoptIduodsIqZvlqCfwMkl0YWUcnBV7thxHNjkK
	kf7M7Wdf/uocdrCA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ScPEoFl3;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Hv0VtATU
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787741754; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R/DI4VjCU05Ig5nR6Wlxq9Zcw7Yp/2BrpBSWfTePvTY=;
	b=ScPEoFl3eDN14USW5g0xwp2x+m7Dv5gZQmnWcS4eW4/l/VD7RtB5blLntfSIALJfhmlZzL
	H0f1//NrgST4qtyq7CR2ECV4QO8ulBcSRbAJV+84N2kXhJJKGJ2hwMb6DRms0uJLGc6CxI
	NTF0RKB0trdgZbolvubofaFukAPgAoA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787741755;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R/DI4VjCU05Ig5nR6Wlxq9Zcw7Yp/2BrpBSWfTePvTY=;
	b=Hv0VtATUs8MY0A3goi9qAlZzfAHHhQV9wo6alWHiTnCOfn6xzbfHpdiL1ofskPR+lSBP8a
	XtQE4Y2qCzTkhTCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 902A413354;
	Wed, 26 Aug 2026 10:55:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DpllIDrGjmotSAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Wed, 26 Aug 2026 10:55:54 +0000
Message-ID: <694e353c-3d03-468c-9001-b2872d8ae9f7@suse.de>
Date: Wed, 26 Aug 2026 12:55:32 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf v2] netfilter: nf_tables: fix device name and prefix
 match in hook lookup
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 pablo@netfilter.org, fw@strlen.de, Wei Fang <void0red@gmail.com>
References: <20260824092805.4940-1-fmancera@suse.de>
 <ao7D-ZH3oN8qrxw9@orbyte.nwl.cc>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <ao7D-ZH3oN8qrxw9@orbyte.nwl.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.51
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: E6E4D1F827
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,netfilter.org,strlen.de,gmail.com];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,suse.de:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

On 8/26/26 12:46 PM, Phil Sutter wrote:
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
>>
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
> 
> I don't think this is necessary: The first ifnamelen chars of both
> hooks' ifname either contain the NUL-char or not. If both ifnamelen
> values are identical, the following strncmp will only match if either
> both are prefixes or both are not.
> 
> (I realized my initial approach using max() won't work when comparing
> "eth0\0" (non-prefix) to "eth0" (prefix) as the latter is followed by
> NUL-chars as well.)
> 
>> +		if (hook->ifnamelen != this->ifnamelen)
>> +			continue;
> 
> Given the above, this could become 'if (strict && hook-ifnamelen !=...)'
> in nft_hook_list_find with extra parameter, up to you.
> 

Hm, that is true. I am sending a v3 following this method as it is simpler.

Pablo, feel free to pick up either this v2 or the v3 I am sending. Both 
are fine to me.

Thank you Phil and Pablo!
