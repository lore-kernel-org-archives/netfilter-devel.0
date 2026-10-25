Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792933414;
	b=KZl0yqpaLO6h8suouom7VJ/3yZfJ0u/U/CKBlsrXHK2QK76h13lE1YE/FyAc7XkHrfW6
	 c5eOH0Yuu3ZlhYbQAJ3kjneODVglNmmX41JqNV3JPuyPAronqSNam6glV/Pfn/VCU77GW
	 bY8/f+qyFHGB7ZQawblo5D+RAumMHGgXQni+NHWxEaXXTfcOsZ4p/BoTfL/QilnpjGBGQ
	 8fwV6ndtzkcwRaU3tHO3Ak1QDpra93HrDVGH4zEWykdeYvIpF4vqxI3BgvYs7+d2WcydC
	 cIWYfBAdlAA7dot+ShydboCfVdJSfpRwux+yfwS+ap/t3uxnlJVBVbfoTDI4YgAvLrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792933414;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Spamd-Result:X-Spam-Score:
	 X-Spam-Level:X-Spam-Flag;
	bh=xf+PASZyOS2/hhcEwplCEt/VX8qUjVE0cltg5XJpznM=;
	b=oJE1eQRPvxtVGmbsVWlgGOVl1KocKfVxjoLeSUTtLzbBlByAuzF+OrFgL9NC0iPn/FPP
	 X8XrYU9LHR0i3MmSPmmNCezvF8CxtvAQ7uKebLqIt3eu+HB4/kBvPo+PXo11P1OervAZR
	 6yKm1DYnWGLC4kTFIqdk7LYuO2A8Y2d/ix9/bKCJwZfv07WxP+56KOcnjuExKV3R0DokH
	 Y/TxOKkNZanj+RO1bJP+jYQPxStKbPm5NuFRINlIWplNTOn1s68TSdJKXe1sJml5O22X+
	 yfjTxppECMSZwd3C0K8bVMGzaS03o0oVkjd9V3uXUKSEmpABLPtNnS/maEFuhJKIUWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=aALTguCD;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=aKDvm7OI;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=aALTguCD;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=aKDvm7OI;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47BFE606A31A
	for <netfilter-devel@vger.kernel.org>; Sun, 25 Oct 2026 13:03:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 47BFE606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=aALTguCD;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=aKDvm7OI;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=aALTguCD;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=aKDvm7OI
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2BFFD223F5;
	Sun, 25 Oct 2026 13:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792933412; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xf+PASZyOS2/hhcEwplCEt/VX8qUjVE0cltg5XJpznM=;
	b=aALTguCDh/RjPrthh+izD+RFBhUDqLeAqpKaNSY+nT90hCXosjKrKty/4N3OD9b2DYK7hp
	LSFMSUPrRSp9Hu2S3eUffSBcVS8x6457IluRC+PQBUuacaHeCazqDI2KUF0E+KSe6QdWWn
	1V+KTH4Tr4W0imS3j2D0vkJ0DYg8zN4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792933412;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xf+PASZyOS2/hhcEwplCEt/VX8qUjVE0cltg5XJpznM=;
	b=aKDvm7OIZJ4dwgPtT2LGfTc1zgtjagycHCGa3TfVpxnVR6N7lCEB8x4JwQAwyfCCfMG5HE
	YLu9lvq9vIMT7GDg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792933412; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xf+PASZyOS2/hhcEwplCEt/VX8qUjVE0cltg5XJpznM=;
	b=aALTguCDh/RjPrthh+izD+RFBhUDqLeAqpKaNSY+nT90hCXosjKrKty/4N3OD9b2DYK7hp
	LSFMSUPrRSp9Hu2S3eUffSBcVS8x6457IluRC+PQBUuacaHeCazqDI2KUF0E+KSe6QdWWn
	1V+KTH4Tr4W0imS3j2D0vkJ0DYg8zN4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792933412;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xf+PASZyOS2/hhcEwplCEt/VX8qUjVE0cltg5XJpznM=;
	b=aKDvm7OIZJ4dwgPtT2LGfTc1zgtjagycHCGa3TfVpxnVR6N7lCEB8x4JwQAwyfCCfMG5HE
	YLu9lvq9vIMT7GDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A1A7713314;
	Sun, 25 Oct 2026 13:03:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cdauGyP+3WpSJQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Sun, 25 Oct 2026 13:03:31 +0000
Message-ID: <b5509d86-f1e3-463a-aebd-d3409350f4c4@suse.de>
Date: Sun, 25 Oct 2026 14:02:15 +0100
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
Subject: Re: [PATCH nf-next v3] netfilter: nft_limit: reject configs whose
 per-packet cost can overflow
To: SaifAllah benMassaoud <saifmassaoudi18@gmail.com>, pablo@netfilter.org
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org
References: <20261024220928.1751040-1-saifmassaoudi18@gmail.com>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20261024220928.1751040-1-saifmassaoudi18@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-13.29 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com,netfilter.org];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCPT_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email]
X-Spam-Score: -13.29
X-Spam-Level: 
X-Spam-Flag: NO

On 10/25/26 12:09 AM, SaifAllah benMassaoud wrote:
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

Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>

Thanks!

> ---
>   net/netfilter/nft_limit.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/net/netfilter/nft_limit.c b/net/netfilter/nft_limit.c
> index 167d99b1447f..07dc5c55b0a0 100644
> --- a/net/netfilter/nft_limit.c
> +++ b/net/netfilter/nft_limit.c
> @@ -13,6 +13,7 @@
>   #include <linux/netfilter.h>
>   #include <linux/netfilter/nf_tables.h>
>   #include <net/netfilter/nf_tables.h>
> +#include <linux/netdevice.h>
>   
>   struct nft_limit {
>   	spinlock_t	lock;
> @@ -73,6 +74,9 @@ static int nft_limit_init(struct nft_limit_priv *priv,
>   	if (check_mul_overflow(unit, NSEC_PER_SEC, &priv->nsecs))
>   		return -EOVERFLOW;
>   
> +	if (!pkts && priv->nsecs > U64_MAX / GRO_MAX_SIZE)
> +		return -EOVERFLOW;
> +
>   	if (tb[NFTA_LIMIT_BURST])
>   		priv->burst = ntohl(nla_get_be32(tb[NFTA_LIMIT_BURST]));
>   
> 
> base-commit: 734bef548a96e8774d6eef5dfa2026c6edc4e80b

