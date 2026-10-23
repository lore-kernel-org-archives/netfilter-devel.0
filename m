Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792787807;
	b=N2K6+eoVPqXRBcsC8K5E5QjYTaAV87SS74BIHG6QfZ7L/BEaUuT2k89Cv6OxzEHUlPtB
	 erD+PmpXqtOED5Uw4QwaAsUtbNVQLdcSIls/U7BisqRAlfvb2d1cHCA0GvXmIlfltCIHR
	 Qkj5POVvZsNZv8GMjCosEHNJ5gb0nHpDSdWnZ/zbjPdyihexF2+Rw6U7wRa41NCcEEzbA
	 EslYw9Mby6hJ68EvqqgTvpyfOGWMNSCQJPtS4F5s8ZBj3yhMDSFHqYlE4HWAz4ShqXKLV
	 F5KHvSr8KCp9b3EVwk2jzZ3Utb+NToDdttJrzbZ2JtOW9s/sl761ILqtE3ks2zsORIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792787807;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Spam-Flag:X-Spam-Level:
	 X-Spamd-Result:X-Spam-Score;
	bh=s2zg4hhD4c/DLwSkL/EQbmOSTKXX7/cWvKehCbYaLhc=;
	b=N+7vMEcREEJDlQW6GVr+TUMXRLXwF6Krv8TmQRe1MKpQ6/ZmXlfr9KoNlDjrDH/ljux6
	 EMzqQf89uMJsg926ShnHR+EEKerJl5YSH9eRDMNAfViGLoEmvizbxJswlsY6R9QsE82dp
	 WtXGj0dpVb63uxIiEa8tdtXHmdD4FJvbwzjZSit5wwqT8qrueCdFq2K+73Vz4+FBOKjrd
	 H2uL7UQX6lph5c7hnyjy8bl8FuE7hb6TXX+FfOoVER4sTAXV1Lf0zfX+p2wEJV6iiOgy2
	 7vWAx2C6xOuGqA2exVqCPggsQYCvPM5568azQJhRWPunzOA7hCeNJHbiB4VMoSrVxRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=rKQavVZh;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ao5gUyzr;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=rKQavVZh;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ao5gUyzr;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C9FD606A31A
	for <netfilter-devel@vger.kernel.org>; Fri, 23 Oct 2026 20:36:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3C9FD606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=rKQavVZh;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ao5gUyzr;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=rKQavVZh;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ao5gUyzr
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6C0971F74D;
	Fri, 23 Oct 2026 20:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792787805; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s2zg4hhD4c/DLwSkL/EQbmOSTKXX7/cWvKehCbYaLhc=;
	b=rKQavVZhcgvxRquZbDGkHm+NDslikkjVo6x7+eXo52F1plMekaO1mVNfAxVZmE1asrA4CZ
	s0yPTooI0yg+5YdMwqk19BesXzqu6U8LAnlCxJVHQ3tiBoQicMg9TPhbWHYLX+bkZMFj8t
	iwUk+cMgzxp6XIxojbAGmjULkppbBvQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792787805;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s2zg4hhD4c/DLwSkL/EQbmOSTKXX7/cWvKehCbYaLhc=;
	b=ao5gUyzr8I/Lx8h1Bsa7JkyQsF9er0jx9CVXkZE/fnJMJmJcQi24F3GA+VM2GqysvUacNn
	oMbidKOFmWJ0XNBw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792787805; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s2zg4hhD4c/DLwSkL/EQbmOSTKXX7/cWvKehCbYaLhc=;
	b=rKQavVZhcgvxRquZbDGkHm+NDslikkjVo6x7+eXo52F1plMekaO1mVNfAxVZmE1asrA4CZ
	s0yPTooI0yg+5YdMwqk19BesXzqu6U8LAnlCxJVHQ3tiBoQicMg9TPhbWHYLX+bkZMFj8t
	iwUk+cMgzxp6XIxojbAGmjULkppbBvQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792787805;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s2zg4hhD4c/DLwSkL/EQbmOSTKXX7/cWvKehCbYaLhc=;
	b=ao5gUyzr8I/Lx8h1Bsa7JkyQsF9er0jx9CVXkZE/fnJMJmJcQi24F3GA+VM2GqysvUacNn
	oMbidKOFmWJ0XNBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0AADE133F3;
	Fri, 23 Oct 2026 20:36:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EaOdM1zF22p1CgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Fri, 23 Oct 2026 20:36:44 +0000
Message-ID: <c3bcb432-2c5a-403a-81b7-c892d575d261@suse.de>
Date: Fri, 23 Oct 2026 22:35:34 +0200
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
To: SaifAllah benMassaoud <saifmassaoudi18@gmail.com>, pablo@netfilter.org
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org
References: <20261015225705.76031-1-saifmassaoudi18@gmail.com>
 <20261023190914.1487094-1-saifmassaoudi18@gmail.com>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20261023190914.1487094-1-saifmassaoudi18@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-13.29 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	FREEMAIL_TO(0.00)[gmail.com,netfilter.org];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -13.29

On 10/23/26 9:09 PM, SaifAllah benMassaoud wrote:
> Byte-rate limits using long time units (e.g. bytes/week) can overflow
> priv->nsecs * skb->len in the packet-path cost calculation, silently
> defeating the configured rate limit.
> 
> Reject such configurations at rule-add time instead, using the GRO
> maximum packet size as a conservative bound on skb length for the
> multiplication check.
> 
> Fixes: d2168e849ebf ("netfilter: nft_limit: add per-byte limiting")
> Signed-off-by: SaifAllah benMassaoud <saifmassaoudi18@gmail.com>
> 
> diff --git a/net/netfilter/nft_limit.c b/net/netfilter/nft_limit.c
> index d92455fc8665..07dc5c55b0a0 100644
> --- a/net/netfilter/nft_limit.c
> +++ b/net/netfilter/nft_limit.c
> @@ -13,7 +13,7 @@
>   #include <linux/netfilter.h>
>   #include <linux/netfilter/nf_tables.h>
>   #include <net/netfilter/nf_tables.h>
> -#include <net/gro.h>
> +#include <linux/netdevice.h>
>   
>   struct nft_limit {
>   	spinlock_t	lock;
> @@ -59,7 +59,7 @@ static inline bool nft_limit_eval(struct nft_limit_priv *priv, u64 cost)
>   static int nft_limit_init(struct nft_limit_priv *priv,
>   			  const struct nlattr * const tb[], bool pkts)
>   {
> -	u64 unit, tmp, tokens, rate_with_burst;
> +	u64 unit, tokens, rate_with_burst;
>   	bool invert = false;
>   
>   	if (tb[NFTA_LIMIT_RATE] == NULL ||
> @@ -74,8 +74,7 @@ static int nft_limit_init(struct nft_limit_priv *priv,
>   	if (check_mul_overflow(unit, NSEC_PER_SEC, &priv->nsecs))
>   		return -EOVERFLOW;
>   
> -	if (!pkts &&
> -	    check_mul_overflow(priv->nsecs, GRO_MAX_SIZE, &tmp))
> +	if (!pkts && priv->nsecs > U64_MAX / GRO_MAX_SIZE)
>   		return -EOVERFLOW;
>   

Hi,

This patch won't apply because it is based in top of the v1 that you 
sent. Contribution process don't work that way. Instead, you need either 
to squash both patches or amend the existing one (v1). In essence, your 
diff must be based on the upstream HEAD of nf-next.git tree.

If it isn't clear, let me know so we can avoid more back and forth.

In addition now that I look at it.. a bit below we have:

if (pkts) {
...
} else {
...
}

Could we insert the new if (priv->nsecs > U64_MAX / GRO_MAX_SIZE) check 
at the beginning of the else block there? So we don't need to check pkts 
again.

Sorry I should have spotted this the first time I reviewed the code.
>   	if (tb[NFTA_LIMIT_BURST])

