Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE0B3D9DB0
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Apr 2026 11:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776167598; cv=none; b=A843vvqzv2Xq0vwHyJqazhyHq8y1B/42ZFcOGH7Z0ZpNkD5+mKLqLHFmhDxO5YqWWRhUS5CgPS/OSkBCAzca4phZuX4rGVITlQ2VOI9KHUxb9bllsoT3rf9oqd7+tm+qqZgzGH//O0qCSsKlJ7g6Ls2hkWprU+BbszvUXK3vRhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776167598; c=relaxed/simple;
	bh=Ejrfq3VFhT/J0R+ccrI8LeQQfxTuDuK0frfKpDYB8Yg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=bKYp1UymjvYnt9uSYHmdH1nfggYKMwYC3y8Lx+nzzrgb9u+GtPgYEMUqCugj0stT3ZqGMOBcOPLuUls1erT8jl2qxleD4kx7mNKUIQaJd3dfnq2l7W3Co4GJP+OZSebcZXbobK0AtK16t3Ywbe2gBUDAVKN69WkdwvpxL6UmfCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=fPIQPrbk; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=2cM47wTt; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=fPIQPrbk; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=2cM47wTt; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="fPIQPrbk";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="2cM47wTt";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="fPIQPrbk";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="2cM47wTt"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6DA9C6A8C1;
	Tue, 14 Apr 2026 11:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776167595; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4FsOkb+P87jMNviLVfjRBTOBnNows2LTl7VpPyWDw18=;
	b=fPIQPrbkmEfj9/lFI6dtzTGVLQcrypXnRA30AHeRK+ukMA5Qjm6fjBt9Re9zYGJw63oC+V
	HEx3k3tB3r0twhkD89XWZyOnkO4oWsuCtDGX5aC6NwUOGQ0CINwUm9vfayZzolfXyMghcP
	WPQ+wjQ31+ixg7CHl1/NaY0AP2yhF94=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776167595;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4FsOkb+P87jMNviLVfjRBTOBnNows2LTl7VpPyWDw18=;
	b=2cM47wTtB1Sw9/S4JFK4RIJORHg7I15oaLTFPsSQkILozewe16LKgdppS4u6uefxYzYzeC
	hIFNorxs6zd09ACQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fPIQPrbk;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=2cM47wTt
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776167595; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4FsOkb+P87jMNviLVfjRBTOBnNows2LTl7VpPyWDw18=;
	b=fPIQPrbkmEfj9/lFI6dtzTGVLQcrypXnRA30AHeRK+ukMA5Qjm6fjBt9Re9zYGJw63oC+V
	HEx3k3tB3r0twhkD89XWZyOnkO4oWsuCtDGX5aC6NwUOGQ0CINwUm9vfayZzolfXyMghcP
	WPQ+wjQ31+ixg7CHl1/NaY0AP2yhF94=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776167595;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4FsOkb+P87jMNviLVfjRBTOBnNows2LTl7VpPyWDw18=;
	b=2cM47wTtB1Sw9/S4JFK4RIJORHg7I15oaLTFPsSQkILozewe16LKgdppS4u6uefxYzYzeC
	hIFNorxs6zd09ACQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 43C084B41F;
	Tue, 14 Apr 2026 11:53:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pkl+Dasq3ml6XwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 14 Apr 2026 11:53:15 +0000
Message-ID: <981ce550-bc53-4724-85f2-fd66d364433c@suse.de>
Date: Tue, 14 Apr 2026 13:53:14 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf] netfilter: nft_osf: restrict it to ipv6
To: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
References: <20260414110811.6178-1-pablo@netfilter.org>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20260414110811.6178-1-pablo@netfilter.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,netfilter.org:email,suse.de:dkim,suse.de:mid,suse.de:email];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Queue-Id: 6DA9C6A8C1
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 

On 4/14/26 1:08 PM, Pablo Neira Ayuso wrote:
> This expression only supports for ipv4, restrict it.
> 
> Fixes: b96af92d6eaf ("netfilter: nf_tables: implement Passive OS fingerprint module in nft_osf")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>   net/netfilter/nft_osf.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nft_osf.c b/net/netfilter/nft_osf.c
> index 1c0b493ef0a9..bdc2f6c90e2f 100644
> --- a/net/netfilter/nft_osf.c
> +++ b/net/netfilter/nft_osf.c
> @@ -28,6 +28,11 @@ static void nft_osf_eval(const struct nft_expr *expr, struct nft_regs *regs,
>   	struct nf_osf_data data;
>   	struct tcphdr _tcph;
>   
> +	if (nft_pf(pkt) != NFPROTO_IPV4) {
> +		regs->verdict.code = NFT_BREAK;
> +		return;
> +	}
> +
>   	if (pkt->tprot != IPPROTO_TCP) {
>   		regs->verdict.code = NFT_BREAK;
>   		return;
> @@ -114,7 +119,6 @@ static int nft_osf_validate(const struct nft_ctx *ctx,
>   
>   	switch (ctx->family) {
>   	case NFPROTO_IPV4:
> -	case NFPROTO_IPV6:
>   	case NFPROTO_INET:
>   		hooks = (1 << NF_INET_LOCAL_IN) |
>   			(1 << NF_INET_PRE_ROUTING) |

Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>

I have the feeling I should re-review everything I did 7 years ago :-)

Thanks!
