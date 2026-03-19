Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B304317D
	for <netfilter-devel@vger.kernel.org>; Thu, 19 Mar 2026 12:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773921607; cv=none; b=UmYsfidfPSVrEc+tti55tA46jknxnXbm4C9tOFM/jVGopHqqCnyiAsnnKynvbain6K5jo8RyfY+VePA6NPQ06gZls1zWB2Zxa8AXuUQ/JZxH5hCOHwPmUfyw64s+dygrQl89SZ63q+Uy7zoZVrVMNhg55AznqVCCT4ygVsXVj0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773921607; c=relaxed/simple;
	bh=FrbK6G8RVpy05p2ueTv+zPVtaTk9S52g7j+9c8Iqv4A=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=EQXaCoaAyJTJbiD4wQATV+DR9ePYG65oYohjwD59WIpPVzzI7MlVFavJLWkTLVezD2mIt+c0aHfM0lze6o3PvYV1B8HoRBYo8vFqULH8j2gJg2hbHi71gqFvxeewRoqyrFGE/JfzsTUvylUnjAuz+oucuz/LpjyPrgjGszZ708k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=KiS/8Jnq; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=UB8SMsF5; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ogV9Peh7; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=s+qpdl2x; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="KiS/8Jnq";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="UB8SMsF5";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ogV9Peh7";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="s+qpdl2x"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 758194D1F8;
	Thu, 19 Mar 2026 11:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773921599; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=21PQfW7b6Mvr5aR+X5avJ6Pm49XrpGjxdYE4guTjbgo=;
	b=KiS/8JnqoOe5MQRiz7OF3yer4R93/ZTZDIQixIm0mufNoa684iv/2sc51FPloVU5byMEAV
	k9uFiTC9ZGB9tdHqKYWJzXXKj7YWqiSb2QnFFFgRVSFZkdJ9OrIzNe/gi/ClT+aWVq95ay
	G1DCSfmY7REza79YTJ6NSnez52cYWz8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773921599;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=21PQfW7b6Mvr5aR+X5avJ6Pm49XrpGjxdYE4guTjbgo=;
	b=UB8SMsF5eb9wIsK1Hz0n5FPoXEKzoZ99EKrt9FkeeE8lhAhcVHwLxKP/T44qLJauZi4CNk
	Uh5YjT2iReo59WAA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773921598; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=21PQfW7b6Mvr5aR+X5avJ6Pm49XrpGjxdYE4guTjbgo=;
	b=ogV9Peh7u7XZpV+l6HFhFASv+YnvjA/qjpoLSjfNOJR3Vkg/DR8TCG9wWvGzgXI5y0VnJK
	jjafaRwkF82q7bMfxCCBLJq8pK89wU6AeTd1xUCwSW6WSkkIoUMiwo3mtcdH3n4R00N3Sk
	xkawAZ3chxJIh30XB8Ny9vUBJH5FDhw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773921598;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=21PQfW7b6Mvr5aR+X5avJ6Pm49XrpGjxdYE4guTjbgo=;
	b=s+qpdl2xwAPZeI5wqF/1Ot90ppvCEWryL63t39uLhKiktOxm8cc/fD0yfsYTGZP2C0A4RM
	kLVdmcpRzkHizFBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 49C2C4273B;
	Thu, 19 Mar 2026 11:59:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PYT/Dj7lu2m8VwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 19 Mar 2026 11:59:58 +0000
Message-ID: <9da064d6-3d34-495d-a3dc-27711d48dfe9@suse.de>
Date: Thu, 19 Mar 2026 12:59:57 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH libnftnl 2/2] tunnel: validate geneve class and type from
 setter
To: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
References: <20260319114441.205740-1-pablo@netfilter.org>
 <20260319114441.205740-2-pablo@netfilter.org>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20260319114441.205740-2-pablo@netfilter.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 

On 3/19/26 12:44 PM, Pablo Neira Ayuso wrote:
> From: Pengpeng Hou <pengpeng@iscas.ac.cn>
> 
> Ensure size is correct, otherwise bail out with EINVAL.
> 
> Fixes: 239fbdb8979d ("tunnel: add support to geneve options")
> Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>   src/obj/tunnel.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/src/obj/tunnel.c b/src/obj/tunnel.c
> index 08adeb50b107..4b302f66ecc5 100644
> --- a/src/obj/tunnel.c
> +++ b/src/obj/tunnel.c
> @@ -866,9 +866,17 @@ static int nftnl_tunnel_opt_geneve_set(struct nftnl_tunnel_opt *opt, uint16_t ty
>   {
>   	switch(type) {
>   	case NFTNL_TUNNEL_GENEVE_CLASS:
> +		if (data_len != sizeof(uint16_t)) {
> +			errno = EINVAL;
> +			return -1;
> +		}
>   		memcpy(&opt->geneve.geneve_class, data, data_len);
>   		break;
>   	case NFTNL_TUNNEL_GENEVE_TYPE:
> +		if (data_len != sizeof(uint8_t)) {
> +			errno = EINVAL;
> +			return -1;
> +		}
>   		memcpy(&opt->geneve.type, data, data_len);
>   		break;
>   	case NFTNL_TUNNEL_GENEVE_DATA:

Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>

Thanks!
