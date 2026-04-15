Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32FDA1A275
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Apr 2026 08:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776241170; cv=none; b=hOb0Oj1N3P8Wi0jpjyl3PHkWEI/yefun5y6JlFPbN0pWat9dUvA01uiHjp+MQnTg53LXpx7TI+2SZy5BxBIOrxeJaKOEgPMj5aMvO1+ehBlA/YoZ+any53z9ng7TFpP0xWf+ISAlF5G6x7/hubeZGpOtLznnFw0aUYy++9BFfqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776241170; c=relaxed/simple;
	bh=0CJhqkuHbSYxX6FgR+5XXPyYt33YfWEkXPJmPQAcBfQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iYzey5PHi4LJOdSAFMMmO6t80D6dLsw5dIvSid/GynWAbml1ukfYpdPqDAZoyU1RJ/7Pw6wjTVzSBvICH+M07ovL990CyGD6lZJ3W4zch9Nw39Aw7/KzJEppFocdkXZxVEvmPGkQon1OgeEbzT5E2R7Z4kOuiWYIERmECCEsQ/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=bceXyvJq; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=BPCAzqnt; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=bceXyvJq; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=BPCAzqnt; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="bceXyvJq";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="BPCAzqnt";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="bceXyvJq";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="BPCAzqnt"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3C1D26A7DB;
	Wed, 15 Apr 2026 08:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776241167; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kWu0+5CPB13fa3KvNixAplh3nxn9ycFPeiv7HS8ztBk=;
	b=bceXyvJqti+VG4dUeuHIjcDrTOAQvyzLzt9nKAdjrnFzCE7fFbBm+THgOT2P3fwIdqCP6Q
	qkez/OsIN4qM7t+IpkHP6UvT5e+6opdH4smQUD7nShOEih9DrnbYzdFDbdZ5xqHfEahyHB
	eb9/LLJqNBd4rTrJ1yXJfATvAz3wtXM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776241167;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kWu0+5CPB13fa3KvNixAplh3nxn9ycFPeiv7HS8ztBk=;
	b=BPCAzqntMBmt1DZ83nIO4keH0aEyd3yZsMJpywZkc4TLaCsFBaQzbATBjsgg1PHbosL7+1
	oSy+ip70Cl7jTiDg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776241167; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kWu0+5CPB13fa3KvNixAplh3nxn9ycFPeiv7HS8ztBk=;
	b=bceXyvJqti+VG4dUeuHIjcDrTOAQvyzLzt9nKAdjrnFzCE7fFbBm+THgOT2P3fwIdqCP6Q
	qkez/OsIN4qM7t+IpkHP6UvT5e+6opdH4smQUD7nShOEih9DrnbYzdFDbdZ5xqHfEahyHB
	eb9/LLJqNBd4rTrJ1yXJfATvAz3wtXM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776241167;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kWu0+5CPB13fa3KvNixAplh3nxn9ycFPeiv7HS8ztBk=;
	b=BPCAzqntMBmt1DZ83nIO4keH0aEyd3yZsMJpywZkc4TLaCsFBaQzbATBjsgg1PHbosL7+1
	oSy+ip70Cl7jTiDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CC4CC4B8EB;
	Wed, 15 Apr 2026 08:19:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sA0MLw5K32lBMQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Wed, 15 Apr 2026 08:19:26 +0000
Message-ID: <767aa4eb-fd87-4bc5-a4ea-654b28310cfb@suse.de>
Date: Wed, 15 Apr 2026 10:19:16 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf v2] netfilter: nfnetlink_osf: fix divide-by-zero in
 OSF_WSS_MODULO
To: Xiang Mei <xmei5@asu.edu>, netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>, coreteam@netfilter.org,
 Weiming Shi <bestswngs@gmail.com>
References: <20260414221401.2809350-1-xmei5@asu.edu>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20260414221401.2809350-1-xmei5@asu.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[netfilter.org,strlen.de,nwl.cc,gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 

On 4/15/26 12:14 AM, Xiang Mei wrote:
> nf_osf_match_one() computes ctx->window % f->wss.val in the
> OSF_WSS_MODULO branch with no guard for f->wss.val == 0. A
> CAP_NET_ADMIN user can add such a fingerprint via nfnetlink; a
> subsequent matching TCP SYN divides by zero and panics the kernel.
> 
> Reject the bogus fingerprint in nfnl_osf_add_callback() above the
> per-option for-loop. f->wss is per-fingerprint, not per-option, so
> the check must run regardless of f->opt_num (including 0). Also
> reject wss.wc >= OSF_WSS_MAX; nf_osf_match_one() already treats that
> as "should not happen".
> 
> Crash:
>   Oops: divide error: 0000 [#1] SMP KASAN NOPTI
>   RIP: 0010:nf_osf_match_one (net/netfilter/nfnetlink_osf.c:98)
>   Call Trace:
>   <IRQ>
>    nf_osf_match (net/netfilter/nfnetlink_osf.c:220)
>    xt_osf_match_packet (net/netfilter/xt_osf.c:32)
>    ipt_do_table (net/ipv4/netfilter/ip_tables.c:348)
>    nf_hook_slow (net/netfilter/core.c:622)
>    ip_local_deliver (net/ipv4/ip_input.c:265)
>    ip_rcv (include/linux/skbuff.h:1162)
>    __netif_receive_skb_one_core (net/core/dev.c:6181)
>    process_backlog (net/core/dev.c:6642)
>    __napi_poll (net/core/dev.c:7710)
>    net_rx_action (net/core/dev.c:7945)
>    handle_softirqs (kernel/softirq.c:622)
> 
> Fixes: 11eeef41d5f6 ("netfilter: passive OS fingerprint xtables match")
> Reported-by: Weiming Shi <bestswngs@gmail.com>
> Suggested-by: Florian Westphal <fw@strlen.de>
> Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Xiang Mei <xmei5@asu.edu>
> ---

This looks good to me.

Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>

> v2: Fix the bug in configure path and correct the fix tag
> 
>   net/netfilter/nfnetlink_osf.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
> index 45d9ad231..70172ca07 100644
> --- a/net/netfilter/nfnetlink_osf.c
> +++ b/net/netfilter/nfnetlink_osf.c
> @@ -320,6 +320,10 @@ static int nfnl_osf_add_callback(struct sk_buff *skb,
>   	if (f->opt_num > ARRAY_SIZE(f->opt))
>   		return -EINVAL;
>   
> +	if (f->wss.wc >= OSF_WSS_MAX ||
> +	    (f->wss.wc == OSF_WSS_MODULO && f->wss.val == 0))
> +		return -EINVAL;
> +
>   	for (i = 0; i < f->opt_num; i++) {
>   		if (!f->opt[i].length || f->opt[i].length > MAX_IPOPTLEN)
>   			return -EINVAL;

