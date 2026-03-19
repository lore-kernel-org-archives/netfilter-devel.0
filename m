Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 466BA3BE63C
	for <netfilter-devel@vger.kernel.org>; Thu, 19 Mar 2026 11:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773921489; cv=none; b=WW2TFqMEtRe6uJlyWXPJrQ4d2MrO5NOkFGV3jrxy6hJ520Y6J3+bB1O6r56Qw/MPmf4vhkS05sJ9yxYe0uV03jpjSXkKJvp4CBizpiorsToWqNWqXDzx9h6ToTHSIHwzw7UO5m+apYIKAbciKP33Ad7Vd/3LisCGwJ6yRBdeJxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773921489; c=relaxed/simple;
	bh=nn/alg+NO59/DC9fDqbNsgKkn6p97EW56o/GVNh/v4c=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=DFW/K77YGuUpQ3rox6lT6qiuhw+r9aeQyxXVB9z2hIu1+0FSyrGkf7wDE5z9ymTXRAEZo2+5q5rxp0V41/CgMVpaWBnke7gquklRP0r4BVsQ9GYf0I6M+Cuhnv1YWJIRNmG11C3QIF32N2Kr+qsQdtzFAkIQnWy8HKSvqy0cS1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ACJU/tGG; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=AE2dBXDF; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=wG4kuHGV; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=XwbKnQkn; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ACJU/tGG";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="AE2dBXDF";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="wG4kuHGV";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="XwbKnQkn"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2A1DD5BD45;
	Thu, 19 Mar 2026 11:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773921484; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XeXZuSbkE1jowaB7LSWwlepIExul4eW0x3Hh18Po8ac=;
	b=ACJU/tGGY34BcGZjMUzW/IPk04q61OJQHTzT+lkhbYzGTMzYEmXrPePpvS/lrjFmBvh7ww
	r4hXbXGorXQSjovvUci7QCAmEZKHzvBBB7/mD3ZJ8OObR/lc5AmUai64D/KLgyakTbf+RM
	N7zcuQYVuHO1W+jRz5+w0r5PPbprKTU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773921484;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XeXZuSbkE1jowaB7LSWwlepIExul4eW0x3Hh18Po8ac=;
	b=AE2dBXDF368vCxVuVAFa8jVpI1UZZ0R2+4ZgVnPmA9+CRRYFc911c+wNizWS99nuZjVwYx
	U+cCYxecKr5ZWSBw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773921483; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XeXZuSbkE1jowaB7LSWwlepIExul4eW0x3Hh18Po8ac=;
	b=wG4kuHGVvHYYVfdW4UjdpuTxY4v2ajobhDTYcx+CU7Wg8Iji4EzIaaL0bJhAhPSNapkFwE
	LpHunTV8pLtzktBz2QU6hsr3ndcBZwKkPGHKObjuUgcjzb5RD4W221mPWTxQvQcndWYCSF
	NUqIGKGYp6k2bEvOzt0AlyPOVwQSeG4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773921483;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XeXZuSbkE1jowaB7LSWwlepIExul4eW0x3Hh18Po8ac=;
	b=XwbKnQknQzCMUXgOuZ7V3DPaT9fRWMmuxGpJGJzUs/1eM3XU/cO0gX6C7pZRUyoceBoZ9g
	0aV5tUYvqRbj+ADQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 014064273B;
	Thu, 19 Mar 2026 11:58:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id spr8OMrku2n9VQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 19 Mar 2026 11:58:02 +0000
Message-ID: <d9f87aee-2dd2-4411-b6c9-a396db8344ad@suse.de>
Date: Thu, 19 Mar 2026 12:57:49 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH libnftnl 1/2] tunnel: check kernel does not provide too
 large geneve data
To: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
References: <20260319114441.205740-1-pablo@netfilter.org>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20260319114441.205740-1-pablo@netfilter.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 

On 3/19/26 12:44 PM, Pablo Neira Ayuso wrote:
> From: Pengpeng Hou <pengpeng@iscas.ac.cn>
> 
> Make sure kernel does not provide geneve data larger than
> NFTNL_TUNNEL_GENEVE_DATA_MAXLEN, which might overrun the buffer.
> 
> Fixes: 239fbdb8979d ("tunnel: add support to geneve options")
> Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>   src/obj/tunnel.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/src/obj/tunnel.c b/src/obj/tunnel.c
> index ea9cb021741d..08adeb50b107 100644
> --- a/src/obj/tunnel.c
> +++ b/src/obj/tunnel.c
> @@ -596,6 +596,11 @@ nftnl_obj_tunnel_parse_geneve(struct nftnl_tunnel_opts *opts, struct nlattr *att
>   	if (tb[NFTA_TUNNEL_KEY_GENEVE_DATA]) {
>   		uint32_t len = mnl_attr_get_payload_len(tb[NFTA_TUNNEL_KEY_GENEVE_DATA]);
>   
> +		if (len > NFTNL_TUNNEL_GENEVE_DATA_MAXLEN) {
> +			free(opt);
> +			return -1;
> +		}
> +
>   		memcpy(opt->geneve.data,
>   		       mnl_attr_get_payload(tb[NFTA_TUNNEL_KEY_GENEVE_DATA]),
>   		       len);

Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>

Thanks!
