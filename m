Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792788031;
	b=bppXo8OEysGG+KbpPl3vF4F8tnMST4TdcW+i4E4QrzrKWxlUHbjaXNcVGvGtSFqqpxFv
	 HMVlyaiOWAGeEtRPsIsqdCouJh9OBLwSIr8RLO8Z0cNTRuSkt7b1oQJ6x32Ihy/ohTCo4
	 E2ijhv82dmWxoF+541PFOWsfj4IUSJdu3UXaMrsytSM5Bu3zv+ghfqQtjq+u0XVZNQxxh
	 /5tUUSENBFMqX6zU+opoJb23EHqrV6WN8/0SeYK2+wOSqK8/tO6b/LAE+wY6iYRqss5xN
	 qO2Xolf7GjJ4FVxmPswl7ECjnurimP6oe45Li1q3S8GV6PJk6RTXveA5AFTsSWLOoUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792788031;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:From:To:Cc:References:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Spamd-Result:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=1y7bf7f7ulikzn/CTnheDuwfmHsZtlgc7lpDIY88btA=;
	b=YfZI107sqepquOCsCn7wCza8Os5SJANi7c60oqN0nGCG+1JoXbxxbbDdjQ1azWCYj3uS
	 UCbNLm+WakjEIFRk+mX/SEvyio1biW8nwUElyzAi8/yL7jLrnBQrWfi00Sr3PzPGH/0h6
	 LXYEYnbyYqs63LSDX8QPy/v5p0Z/d1YFHF7SRrVYfvBDqu0apMPayF4YQoiOi0bzRdwvS
	 qVaSc4lhe9xqsXR0c8kmRNlcqDDAkpVTcpsl49Y6v4dBoAcE/DUOvBvKpiF4WH4sV9LFM
	 6nkyb05bwWwDnZqjMjhbysI3eNCb6T1Yd45R8JW7MXM3DgByG8xkLPwhPbNjy920Rbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=zXR9vYDj;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=POLe3BTz;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=zXR9vYDj;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=POLe3BTz;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A38F606A31E
	for <netfilter-devel@vger.kernel.org>; Fri, 23 Oct 2026 20:40:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7A38F606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=zXR9vYDj;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=POLe3BTz;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=zXR9vYDj;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=POLe3BTz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7B01F22146;
	Fri, 23 Oct 2026 20:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792788028; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1y7bf7f7ulikzn/CTnheDuwfmHsZtlgc7lpDIY88btA=;
	b=zXR9vYDjtiQ6Cq+u0POKzdfKGWoS5T0j8Efpf+HSw0Ee3ytFLr6g+9kg36LlYdzn1Mgr3D
	zrRFOt7EEGcBc3RhdgY+C48eCEvlnWc9mDVBuIkIqXTp3oScDKQ99Ev/KIpXEzRohPD6CA
	CTHnOa+LynqbJPV/SlabU+VdZx4d2pw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792788028;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1y7bf7f7ulikzn/CTnheDuwfmHsZtlgc7lpDIY88btA=;
	b=POLe3BTzCrYZ27Nwk9f6UV4QfgK4iP0mGRtLgJz9aZ93ZQCk/XvrNlU9wiCyZuqyJ+SgCE
	/8tIut/aWK4o4QBQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=zXR9vYDj;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=POLe3BTz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792788028; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1y7bf7f7ulikzn/CTnheDuwfmHsZtlgc7lpDIY88btA=;
	b=zXR9vYDjtiQ6Cq+u0POKzdfKGWoS5T0j8Efpf+HSw0Ee3ytFLr6g+9kg36LlYdzn1Mgr3D
	zrRFOt7EEGcBc3RhdgY+C48eCEvlnWc9mDVBuIkIqXTp3oScDKQ99Ev/KIpXEzRohPD6CA
	CTHnOa+LynqbJPV/SlabU+VdZx4d2pw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792788028;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1y7bf7f7ulikzn/CTnheDuwfmHsZtlgc7lpDIY88btA=;
	b=POLe3BTzCrYZ27Nwk9f6UV4QfgK4iP0mGRtLgJz9aZ93ZQCk/XvrNlU9wiCyZuqyJ+SgCE
	/8tIut/aWK4o4QBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E264E133F3;
	Fri, 23 Oct 2026 20:40:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id z40PLDvG22quDQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Fri, 23 Oct 2026 20:40:27 +0000
Message-ID: <0a7c3cee-a62c-40bd-887f-ca3ba41834e9@suse.de>
Date: Fri, 23 Oct 2026 22:39:21 +0200
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf-next v2] netfilter: nft_limit: reject configs whose
 per-packet cost can overflow
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: SaifAllah benMassaoud <saifmassaoudi18@gmail.com>, pablo@netfilter.org
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org
References: <20261015225705.76031-1-saifmassaoudi18@gmail.com>
 <20261023190914.1487094-1-saifmassaoudi18@gmail.com>
 <c3bcb432-2c5a-403a-81b7-c892d575d261@suse.de>
Content-Language: en-US
In-Reply-To: <c3bcb432-2c5a-403a-81b7-c892d575d261@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-13.50 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	XM_UA_NO_VERSION(0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_TO(0.00)[gmail.com,netfilter.org];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_TRACE(0.00)[suse.de:+];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -13.50
X-Spam-Level: 
X-Rspamd-Queue-Id: 7B01F22146



On 10/23/26 10:35 PM, Fernando Fernandez Mancera wrote:
> On 10/23/26 9:09 PM, SaifAllah benMassaoud wrote:
>> Byte-rate limits using long time units (e.g. bytes/week) can overflow
>> priv->nsecs * skb->len in the packet-path cost calculation, silently
>> defeating the configured rate limit.
>>
>> Reject such configurations at rule-add time instead, using the GRO
>> maximum packet size as a conservative bound on skb length for the
>> multiplication check.
>>
>> Fixes: d2168e849ebf ("netfilter: nft_limit: add per-byte limiting")
>> Signed-off-by: SaifAllah benMassaoud <saifmassaoudi18@gmail.com>
>>
>> diff --git a/net/netfilter/nft_limit.c b/net/netfilter/nft_limit.c
>> index d92455fc8665..07dc5c55b0a0 100644
>> --- a/net/netfilter/nft_limit.c
>> +++ b/net/netfilter/nft_limit.c
>> @@ -13,7 +13,7 @@
>>   #include <linux/netfilter.h>
>>   #include <linux/netfilter/nf_tables.h>
>>   #include <net/netfilter/nf_tables.h>
>> -#include <net/gro.h>
>> +#include <linux/netdevice.h>
>>   struct nft_limit {
>>       spinlock_t    lock;
>> @@ -59,7 +59,7 @@ static inline bool nft_limit_eval(struct 
>> nft_limit_priv *priv, u64 cost)
>>   static int nft_limit_init(struct nft_limit_priv *priv,
>>                 const struct nlattr * const tb[], bool pkts)
>>   {
>> -    u64 unit, tmp, tokens, rate_with_burst;
>> +    u64 unit, tokens, rate_with_burst;
>>       bool invert = false;
>>       if (tb[NFTA_LIMIT_RATE] == NULL ||
>> @@ -74,8 +74,7 @@ static int nft_limit_init(struct nft_limit_priv *priv,
>>       if (check_mul_overflow(unit, NSEC_PER_SEC, &priv->nsecs))
>>           return -EOVERFLOW;
>> -    if (!pkts &&
>> -        check_mul_overflow(priv->nsecs, GRO_MAX_SIZE, &tmp))
>> +    if (!pkts && priv->nsecs > U64_MAX / GRO_MAX_SIZE)
>>           return -EOVERFLOW;
> 
> Hi,
> 
> This patch won't apply because it is based in top of the v1 that you 
> sent. Contribution process don't work that way. Instead, you need either 
> to squash both patches or amend the existing one (v1). In essence, your 
> diff must be based on the upstream HEAD of nf-next.git tree.
> 
> If it isn't clear, let me know so we can avoid more back and forth.
> 
> In addition now that I look at it.. a bit below we have:
> 
> if (pkts) {
> ...
> } else {
> ...
> }
> 
> Could we insert the new if (priv->nsecs > U64_MAX / GRO_MAX_SIZE) check 
> at the beginning of the else block there? So we don't need to check pkts 
> again.
> 
> Sorry I should have spotted this the first time I reviewed the code.

Actually I changed my mind, since I looked at it, it is better to have 
it close to the calculation of priv->nsecs as you did initially.

So, scratch that part. Could you just send the v3 using the right base 
commit so the patch applies?

Thanks!

>>       if (tb[NFTA_LIMIT_BURST])
> 

