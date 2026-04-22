Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA8F387594
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Apr 2026 18:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776881249; cv=none; b=CCNX/eynlxW9HL+JSrS/3+4atz3mlJ+Q8GbEPWJUYCijFwKX7CmA9CHGr7SQSOfUSYAp/YWTa9GZY+hcACofrHaAbZTY4REkjNT/4X/IqMZTueylWqGY3ayc5px7Gw91M009Gj5JKpX6ptSnhdOL102IG02aUlHvifUGQpL4hLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776881249; c=relaxed/simple;
	bh=YvUM8qOUy9WhDTYzAG5Mik3nxmgStgV1kp4u4MUBZTc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CfKuPgPQRN1O6r6pTNNIFgwiMFPVGBBaxWAfRMB5msr9xOdgQgNcHVN+3g90NkER99XnuhKS7J044s4LFErsK3zHlqIwD33N6PIhckftjZxH+K/0XChFHjZ6Th3QRHpJnh1Krxpb74894FVrzY68zVaPM9Cf3wCsSB2E3Rl87W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=1iq9Csh4; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=9y0R5UYe; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=1iq9Csh4; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=9y0R5UYe; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="1iq9Csh4";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="9y0R5UYe";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="1iq9Csh4";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="9y0R5UYe"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1AC415BD33;
	Wed, 22 Apr 2026 18:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776881246; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VuCkhLoRLC9lrzx8fvFMucxkSisEGye2DBWzpre6BSo=;
	b=1iq9Csh4evSlkv3KJy8r0hgJw3lSUkCr+dNY6/xrD3Yjnhiq0JLs7iTWt3cgfPYDmkUN8z
	r8a0lvd9se7UsHsbcG0/zj0hySWO1VsrShYGx83Zxt2ZcFFdAMWi6OQuYHq5mHvcW5AYSC
	v3kjS4Datydz5EdYM/Srt0ZdViHP320=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776881246;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VuCkhLoRLC9lrzx8fvFMucxkSisEGye2DBWzpre6BSo=;
	b=9y0R5UYeRqk3UHhwEyN7eVddmoHqoqfu5X+YnKVHqF55apSH7VFS568B7uP8rVDHKpHVWq
	7tasIBXtkskBTFDg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776881246; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VuCkhLoRLC9lrzx8fvFMucxkSisEGye2DBWzpre6BSo=;
	b=1iq9Csh4evSlkv3KJy8r0hgJw3lSUkCr+dNY6/xrD3Yjnhiq0JLs7iTWt3cgfPYDmkUN8z
	r8a0lvd9se7UsHsbcG0/zj0hySWO1VsrShYGx83Zxt2ZcFFdAMWi6OQuYHq5mHvcW5AYSC
	v3kjS4Datydz5EdYM/Srt0ZdViHP320=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776881246;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VuCkhLoRLC9lrzx8fvFMucxkSisEGye2DBWzpre6BSo=;
	b=9y0R5UYeRqk3UHhwEyN7eVddmoHqoqfu5X+YnKVHqF55apSH7VFS568B7uP8rVDHKpHVWq
	7tasIBXtkskBTFDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2F5D4593AF;
	Wed, 22 Apr 2026 18:07:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id k8xvCF0O6WnaOwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Wed, 22 Apr 2026 18:07:25 +0000
Message-ID: <55b8bb86-3f2d-4feb-9311-3381a460b243@suse.de>
Date: Wed, 22 Apr 2026 20:07:11 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf v2 1/1] netfilter: reject zero shift in nft_bitwise
To: Ren Wei <n05ec@lzu.edu.cn>, netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org, fw@strlen.de, phil@nwl.cc, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 jeremy@azazel.net, yuantan098@gmail.com, yifanwucs@gmail.com,
 tomapufckgml@gmail.com, bird@lzu.edu.cn, k4729.23098@gmail.com
References: <20260422145419.2927088-1-n05ec@lzu.edu.cn>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20260422145419.2927088-1-n05ec@lzu.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[16];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[netfilter.org,strlen.de,nwl.cc,davemloft.net,google.com,kernel.org,redhat.com,azazel.net,gmail.com,lzu.edu.cn];
	MID_RHS_MATCH_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email]
X-Spam-Flag: NO

On 4/22/26 4:54 PM, Ren Wei wrote:
> From: Kai Ma <k4729.23098@gmail.com>
> 
> Reject zero shift operands for nft_bitwise left and right shift
> expressions during initialization.
> 
> The carry propagation logic computes the carry from the adjacent 32-bit
> word using BITS_PER_TYPE(u32) - shift. A zero shift operand turns this
> into a 32-bit shift, which is undefined behaviour.
> 
> Reject zero shift operands in the control plane, alongside the existing
> check for values greater than or equal to 32, so malformed rules never
> reach the packet path.
> 
> Fixes: 567d746b55bc ("netfilter: bitwise: add support for shifts.")
> Cc: stable@kernel.org

What is the point of Cc'ing stable@kernel.org? Also they are not on CC. 
This is a corner case that no one hit before because it is useless to 
perform a 0-shift operation.

> Reported-by: Yuan Tan <yuantan098@gmail.com>
> Reported-by: Yifan Wu <yifanwucs@gmail.com>
> Reported-by: Juefei Pu <tomapufckgml@gmail.com>
> Reported-by: Xin Liu <bird@lzu.edu.cn>
> Signed-off-by: Kai Ma <k4729.23098@gmail.com>
> Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>

Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>

> ---
> changes in v2:
>    - Reject zero shift operands in nft_bitwise_init_shift() and drop the
>      runtime zero-shift handling in the eval path.
>    - v1 Link: https://lore.kernel.org/all/5166c80ac3006080e4542ef4c3bf28bc78c696bc.1776667409.git.k4729.23098@gmail.com/
> 
>   net/netfilter/nft_bitwise.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
> index 13808e9cd999..94dccdcfa06b 100644
> --- a/net/netfilter/nft_bitwise.c
> +++ b/net/netfilter/nft_bitwise.c
> @@ -196,7 +196,8 @@ static int nft_bitwise_init_shift(struct nft_bitwise *priv,
>   	if (err < 0)
>   		return err;
>   
> -	if (priv->data.data[0] >= BITS_PER_TYPE(u32)) {
> +	if (!priv->data.data[0] ||
> +	    priv->data.data[0] >= BITS_PER_TYPE(u32)) {
>   		nft_data_release(&priv->data, desc.type);
>   		return -EINVAL;
>   	}

