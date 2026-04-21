Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 659F230E0E5
	for <netfilter-devel@vger.kernel.org>; Tue, 21 Apr 2026 14:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776783243; cv=none; b=bxuqrt6W1x/0JfuRwTpB7o389jqQYk7333v4qYiA9gaUKyCz5FdUsb83zeM8vI5NRxPwkc6bPKovkdIjmIr3fu7H/Rh38zviUPZjA/lmBArYmeoz3+A////AX0Cecp/D1y1EM65iJRRlXnXLSMWrOFyUw3Z2PUN70VAGlAVk3gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776783243; c=relaxed/simple;
	bh=c1HUwhBeIUyF9MulnGSXF0HqDqtVg4ut2Hb/SHeGqvI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BSzDoT0bGrwbnZcpGGNH2nDFx0eB1nupJjUC+FbjVWQTvHWOlDZ2vhlSSVKEjhvTA5IHFDAxsDp+a3YkEGDRk4qloLXH8e88XmjRuosnr9zbu7IMTbuq/fTiaMnB9T/mFWCHZftCQCEQd3AXw0FRuseasJJ7BBHttTWjwAlHJKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=k3VHMZZR; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=YEVXqqfA; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=k3VHMZZR; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=YEVXqqfA; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="k3VHMZZR";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="YEVXqqfA";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="k3VHMZZR";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="YEVXqqfA"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 807F15BCCC;
	Tue, 21 Apr 2026 14:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776783240; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HMbkMgHUA8X/aTaFPx60Avg2ZG67p91c+qO62srgKO4=;
	b=k3VHMZZRJK07c85Uj6EwEFrGyqO3XxPRZo0xRf17JZYSEfuC2LQqMLAH3kWyFPUYyCV18h
	Lv3jpJO+OxhsmJC26Z5yskzDRctb0jFnThd+RRMBFhumYhuyTddTgvlJD5kzkc8R3grXzl
	czZiVlH6u+2zXvmUjaCaHltCAPNq/SA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776783240;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HMbkMgHUA8X/aTaFPx60Avg2ZG67p91c+qO62srgKO4=;
	b=YEVXqqfAkj5k6iC7PYLJoenurC67cIrgQnYe5Iv56KgZxdHRvmym0WHqzRIqNqhgibZp/k
	usbwJZ6ENA0ySNDw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=k3VHMZZR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=YEVXqqfA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776783240; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HMbkMgHUA8X/aTaFPx60Avg2ZG67p91c+qO62srgKO4=;
	b=k3VHMZZRJK07c85Uj6EwEFrGyqO3XxPRZo0xRf17JZYSEfuC2LQqMLAH3kWyFPUYyCV18h
	Lv3jpJO+OxhsmJC26Z5yskzDRctb0jFnThd+RRMBFhumYhuyTddTgvlJD5kzkc8R3grXzl
	czZiVlH6u+2zXvmUjaCaHltCAPNq/SA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776783240;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HMbkMgHUA8X/aTaFPx60Avg2ZG67p91c+qO62srgKO4=;
	b=YEVXqqfAkj5k6iC7PYLJoenurC67cIrgQnYe5Iv56KgZxdHRvmym0WHqzRIqNqhgibZp/k
	usbwJZ6ENA0ySNDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E74C6593AF;
	Tue, 21 Apr 2026 14:53:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5kxpNYeP52n4YwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 21 Apr 2026 14:53:59 +0000
Message-ID: <41c9cd18-d5dc-41e0-a453-b936f15acfc5@suse.de>
Date: Tue, 21 Apr 2026 16:53:45 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 1/1] netfilter: shift-out-of-bounds in nft_bitwise
To: Ren Wei <n05ec@lzu.edu.cn>, netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org, fw@strlen.de, jeremy@azazel.net,
 yuantan098@gmail.com, yifanwucs@gmail.com, tomapufckgml@gmail.com,
 bird@lzu.edu.cn, k4729.23098@gmail.com
References: <cover.1776667409.git.k4729.23098@gmail.com>
 <5166c80ac3006080e4542ef4c3bf28bc78c696bc.1776667409.git.k4729.23098@gmail.com>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <5166c80ac3006080e4542ef4c3bf28bc78c696bc.1776667409.git.k4729.23098@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	DWL_DNSWL_LOW(-1.00)[suse.de:dkim];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[netfilter.org,strlen.de,azazel.net,gmail.com,lzu.edu.cn];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim,suse.de:mid]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 807F15BCCC

On 4/21/26 2:42 PM, Ren Wei wrote:
> From: Kai Ma <k4729.23098@gmail.com>
> 
> Handle zero shift operands explicitly in nft_bitwise_eval_lshift() and
> nft_bitwise_eval_rshift().
> 
> Shift expressions accept values in the range [0, 31], but the carry
> propagation code assumes a non-zero shift and computes the carry from the
> adjacent 32-bit word unconditionally. For a zero shift operand, the
> expected result is to leave the value unchanged.
> 
> Treat zero shift as a no-op before entering the carry propagation loops.
> This preserves the existing behaviour for non-zero shifts and matches the
> expected semantics of shifting by zero.
> 

I think the issue here is an Undefined Behavior actually, AFAICS when 
shifting by the size of the type is UB and depending on the architecture 
used it can lead to shift-out-of-bounds due to carry being equals to .

Shouldn't this be rejected in control plane during validation? As a 0 
shift operation is pointless, we can reject it right away.

In addition, please use nf target for v2.

Thanks,
Fernando.

> Fixes: 567d746b55bc ("netfilter: bitwise: add support for shifts.")
> Cc: stable@kernel.org
> Reported-by: Yuan Tan <yuantan098@gmail.com>
> Reported-by: Yifan Wu <yifanwucs@gmail.com>
> Reported-by: Juefei Pu <tomapufckgml@gmail.com>
> Reported-by: Xin Liu <bird@lzu.edu.cn>
> Signed-off-by: Kai Ma <k4729.23098@gmail.com>
> Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
> ---
>   net/netfilter/nft_bitwise.c | 20 ++++++++++++++++----
>   1 file changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
> index d550910aabec..f74774b176af 100644
> --- a/net/netfilter/nft_bitwise.c
> +++ b/net/netfilter/nft_bitwise.c
> @@ -39,10 +39,16 @@ static void nft_bitwise_eval_lshift(u32 *dst, const u32 *src,
>   				    const struct nft_bitwise *priv)
>   {
>   	u32 shift = priv->data.data[0];
> -	unsigned int i;
> +	unsigned int i, n = DIV_ROUND_UP(priv->len, sizeof(u32));
>   	u32 carry = 0;
>   
> -	for (i = DIV_ROUND_UP(priv->len, sizeof(u32)); i > 0; i--) {
> +	if (!shift) {
> +		for (i = 0; i < n; i++)
> +			dst[i] = src[i];
> +		return;
> +	}
> +
> +	for (i = n; i > 0; i--) {
>   		dst[i - 1] = (src[i - 1] << shift) | carry;
>   		carry = src[i - 1] >> (BITS_PER_TYPE(u32) - shift);
>   	}
> @@ -52,10 +58,16 @@ static void nft_bitwise_eval_rshift(u32 *dst, const u32 *src,
>   				    const struct nft_bitwise *priv)
>   {
>   	u32 shift = priv->data.data[0];
> -	unsigned int i;
> +	unsigned int i, n = DIV_ROUND_UP(priv->len, sizeof(u32));
>   	u32 carry = 0;
>   
> -	for (i = 0; i < DIV_ROUND_UP(priv->len, sizeof(u32)); i++) {
> +	if (!shift) {
> +		for (i = 0; i < n; i++)
> +			dst[i] = src[i];
> +		return;
> +	}
> +
> +	for (i = 0; i < n; i++) {
>   		dst[i] = carry | (src[i] >> shift);
>   		carry = src[i] << (BITS_PER_TYPE(u32) - shift);
>   	}

