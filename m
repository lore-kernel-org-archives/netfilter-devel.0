Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792673606;
	b=rL1KpMXYvUahSgz8+4Qhm1Wr+Dx7zgZ0kjg4VlAnSgkTVh336hdHTMd/pRJK8ml/tqBc
	 +laC6CGGZ8As1+T21rhWHIl72P121IU5hl2kI4jcLmfcxVwzHiIPx8gSne3jrO1ujmcdo
	 FIbDp0RyTK0ThHPzRl3SbWU+IOGM5OGGv7MQlixzrm0/uHgVYoYtK/z82XTBZp4mvZ7F2
	 9pGa+50XmgICKB+pYk9iDIkjVWehgnKY40lVnX3Uiv7png4WysWEGCD3ZAGaO7AQGQNBZ
	 qAgCLLjzJl8l7GMlCDuSynrTEKKR5TKpaWpnOQjSpVxkDevlONFQD4USCCL4fWjPorw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792673606;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Rspamd-Queue-Id:X-Spam-Level:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:
	 X-Spam-Score;
	bh=jO73yar0UBQ303MNxcXQUAF7N3B35NwpIjL9un2nWV0=;
	b=eAQHnaFMPnhikt+5Rb3fTnBvsCtqm+4bxYLBRkmQm3+SRTsJNzH8bXaorPMwIK+hpODK
	 6yj+0fTEJigVLWQ7f+fMgwdXfgGKRQ8oXdUCeFxl1s5bxjH0T+0WiuSqs/2C8ABSgZo7I
	 95qYrKIONpURrNw944kgan8Ye7ECBlibkjRB/bSjj6E2LJvt5rGn92A2LCD9AZdC0LdTw
	 fLfxsPTOAIDad4a0vEXEoFEDh7BY0AsTJu4n+METbP9sdU9fL29N+REnNrB80PO5vLTTM
	 1GLp4RjJWPWw/0peDm+ehUdg3SwDeVzEYtPQXjcb+apY2DINqbUpNnbb+XCSuJT0uNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=rYJIqort;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=neiGvPKx;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=rYJIqort;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=neiGvPKx;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9474E606A31E
	for <netfilter-devel@vger.kernel.org>; Thu, 22 Oct 2026 12:53:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9474E606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=rYJIqort;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=neiGvPKx;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=rYJIqort;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=neiGvPKx
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7DD141F393;
	Thu, 22 Oct 2026 12:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792673602; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jO73yar0UBQ303MNxcXQUAF7N3B35NwpIjL9un2nWV0=;
	b=rYJIqortixY0OD5r0ELH1vpUfkvAzqNlcjfub/V6WBpWQcvdwkzSWrC1C6PudLKVxVCZg+
	zJ7qyAbMWnw2vhDyvZAWZ4hGvlaO0RjAekvBKNVpDTIoSpZvlUQEhlg8lNoBe8tSfLvhun
	ijLA/TNYUyTWe37SBdy1xGlAiOOxC8A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792673602;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jO73yar0UBQ303MNxcXQUAF7N3B35NwpIjL9un2nWV0=;
	b=neiGvPKxDucGwWv1Rbr7pSwPjoU3ZZcukUOswCEg70WiRaEPAbIuOGKoxD8zDHWlRd2MdV
	b2000eOq08g5qLDQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=rYJIqort;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=neiGvPKx
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792673602; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jO73yar0UBQ303MNxcXQUAF7N3B35NwpIjL9un2nWV0=;
	b=rYJIqortixY0OD5r0ELH1vpUfkvAzqNlcjfub/V6WBpWQcvdwkzSWrC1C6PudLKVxVCZg+
	zJ7qyAbMWnw2vhDyvZAWZ4hGvlaO0RjAekvBKNVpDTIoSpZvlUQEhlg8lNoBe8tSfLvhun
	ijLA/TNYUyTWe37SBdy1xGlAiOOxC8A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792673602;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jO73yar0UBQ303MNxcXQUAF7N3B35NwpIjL9un2nWV0=;
	b=neiGvPKxDucGwWv1Rbr7pSwPjoU3ZZcukUOswCEg70WiRaEPAbIuOGKoxD8zDHWlRd2MdV
	b2000eOq08g5qLDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1FDE5134E6;
	Thu, 22 Oct 2026 12:53:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id l9J2OEEH2mq8RgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 22 Oct 2026 12:53:22 +0000
Message-ID: <8baeb83d-def2-46f1-aece-0ec15ec7ed60@suse.de>
Date: Thu, 22 Oct 2026 14:52:11 +0200
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
Subject: Re: [PATCH nf-next] netfilter: nft_limit: reject configurations that
 cause integer overflow
To: SaifAllah benMassaoud <saifmassaoudi18@gmail.com>, pablo@netfilter.org
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org
References: <aswI8NBK6sLj-fdk@chamomile>
 <20261015225705.76031-1-saifmassaoudi18@gmail.com>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20261015225705.76031-1-saifmassaoudi18@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7DD141F393
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -13.50

*dropping security list from Cc as I do not think they care about this*

On 10/16/26 12:57 AM, SaifAllah benMassaoud wrote:
> Byte-rate limits using long time units (e.g. bytes/week) can overflow
> priv->nsecs * skb->len in the packet-path cost calculation, silently
> defeating the configured rate limit.
> 
> Reject such configurations at rule-add time instead.
> 
> Suggested-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: SaifAllah benMassaoud <saifmassaoudi18@gmail.com>
> ---
>   net/netfilter/nft_limit.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nft_limit.c b/net/netfilter/nft_limit.c
> index 167d99b1447f..d92455fc8665 100644
> --- a/net/netfilter/nft_limit.c
> +++ b/net/netfilter/nft_limit.c
> @@ -13,6 +13,7 @@
>   #include <linux/netfilter.h>
>   #include <linux/netfilter/nf_tables.h>
>   #include <net/netfilter/nf_tables.h>
> +#include <net/gro.h>
>   
>   struct nft_limit {
>   	spinlock_t	lock;
> @@ -58,7 +59,7 @@ static inline bool nft_limit_eval(struct nft_limit_priv *priv, u64 cost)
>   static int nft_limit_init(struct nft_limit_priv *priv,
>   			  const struct nlattr * const tb[], bool pkts)
>   {
> -	u64 unit, tokens, rate_with_burst;
> +	u64 unit, tmp, tokens, rate_with_burst;
>   	bool invert = false;
>   
>   	if (tb[NFTA_LIMIT_RATE] == NULL ||
> @@ -73,6 +74,10 @@ static int nft_limit_init(struct nft_limit_priv *priv,
>   	if (check_mul_overflow(unit, NSEC_PER_SEC, &priv->nsecs))
>   		return -EOVERFLOW;
>   
> +	if (!pkts &&
> +	    check_mul_overflow(priv->nsecs, GRO_MAX_SIZE, &tmp))
> +		return -EOVERFLOW;
> +

Couldn't this be:

if (!pkts && priv->nsecs > U64_MAX / GRO_MAX_SIZE)
	return -EOVERFLOW;

As we are not using the result, we do not need to perform the operation 
and store the value, so this is simpler IMHO.

Thanks,
Fernando.
>   	if (tb[NFTA_LIMIT_BURST])
>   		priv->burst = ntohl(nla_get_be32(tb[NFTA_LIMIT_BURST]));
>   

