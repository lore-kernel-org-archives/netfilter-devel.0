Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F25736C598
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Apr 2026 16:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776960418; cv=none; b=ktJje9C1XCC3H4M3ycN/m+t19HExNaKTLiuuN+B7H/v5xKxoHJkU8YoCGfaRMyUOJsCLEXzWS19xYccvPl7dsrx7xwH/EoHilvMYeBu4XPiS/rvUK2Qw9zb9tih3e/Lm0r5yv5q/sogdOrWs19AZVi3R76rryuw12JDiqzG78MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776960418; c=relaxed/simple;
	bh=gtLtCROUv3kWPSrNhwwWjN/REHDEftjbhmv2/aXAjVE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=DmZZrOsRbzhc9hchjTZO4goUnOTNH7EAeoSjXMS2w1lijDi7F1QLTD4lqSPbmojg0o/clJDPl9RDhXzyFQ8ZKjeAHFKYGs0q4xpOs09RbRowwUvXhhmGjSp1JhumUSgcNpNM0AvZ+6WZO65DQTWAdWnj4mGh31zOkkQUyz7sDA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=XSuNTkmJ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=6vQ0TrNQ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=XSuNTkmJ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=6vQ0TrNQ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="XSuNTkmJ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="6vQ0TrNQ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="XSuNTkmJ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="6vQ0TrNQ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 88F8F6A882;
	Thu, 23 Apr 2026 16:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776960415; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=03mHhwrVErBBFYKVMjjyAWZhU0nBIHih8dnTq/STpMM=;
	b=XSuNTkmJ4YPT3JuTj6EHk6gYRJvvUfKn1Fs/EWIv285q1LDLNIv0rhpaAlGfeKfVG5QhP+
	Lp3aeYe8rMZQ2ELlr8wDxogVlr4tVBiVdNEfaX6y4ckb0cJPHWd46yZKYaO9u78LGUaB8L
	qwcnycMUyCu/6IMTeUq2GINKo4aBnTw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776960415;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=03mHhwrVErBBFYKVMjjyAWZhU0nBIHih8dnTq/STpMM=;
	b=6vQ0TrNQhvoye+YwgmF+D6S0JNFEvZ6uLFoeifkwv4CMJngz0pkzxq/YbGcaAw6l3/Cd3U
	nV4oDwUiMqzmp/Bg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776960415; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=03mHhwrVErBBFYKVMjjyAWZhU0nBIHih8dnTq/STpMM=;
	b=XSuNTkmJ4YPT3JuTj6EHk6gYRJvvUfKn1Fs/EWIv285q1LDLNIv0rhpaAlGfeKfVG5QhP+
	Lp3aeYe8rMZQ2ELlr8wDxogVlr4tVBiVdNEfaX6y4ckb0cJPHWd46yZKYaO9u78LGUaB8L
	qwcnycMUyCu/6IMTeUq2GINKo4aBnTw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776960415;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=03mHhwrVErBBFYKVMjjyAWZhU0nBIHih8dnTq/STpMM=;
	b=6vQ0TrNQhvoye+YwgmF+D6S0JNFEvZ6uLFoeifkwv4CMJngz0pkzxq/YbGcaAw6l3/Cd3U
	nV4oDwUiMqzmp/Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 60957593A3;
	Thu, 23 Apr 2026 16:06:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iVjEFJ9D6mmXTgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 23 Apr 2026 16:06:55 +0000
Message-ID: <362cafcd-2ce0-4da0-be6b-39a78c6b94b7@suse.de>
Date: Thu, 23 Apr 2026 18:06:54 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nft] evaluate: zap useless 0-shifts
To: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20260422172659.24184-1-fw@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20260422172659.24184-1-fw@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email]
X-Spam-Flag: NO

On 4/22/26 7:26 PM, Florian Westphal wrote:
> There is a (not yet applied) kernel patch that rejects 0-shifts,
> auto-suppress them at eval stage.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---

Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>

That is quite elegant indeed, thanks!

>   src/evaluate.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 482708ae6191..8bb7b6095309 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -1454,6 +1454,12 @@ static int expr_evaluate_shift(struct eval_ctx *ctx, struct expr **expr)
>   					 "shifts exceeding %u bits are not supported", UINT_MAX);
>   
>   	shift = mpz_get_uint32(right->value);
> +	if (shift == 0) {
> +		*expr = expr_get(left);
> +		expr_free(op);
> +		return 0;
> +	}
> +
>   	if (ctx->stmt_len > left->len)
>   		max_shift_len = ctx->stmt_len;
>   	else

