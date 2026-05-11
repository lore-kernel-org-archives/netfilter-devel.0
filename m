Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C63222565
	for <netfilter-devel@vger.kernel.org>; Mon, 11 May 2026 12:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778503159; cv=none; b=Ry/xtfdEfDFUCbCHamOG0zdqvO93LSVYqk9oOIudj5j3HPjrMX5PVLjgBXO/eJzIthcm43alfm0xMtO7eIBd5SE7Hb/3XINiQC8R1gwlhhI3yS7nhjXAgQY8/f3D37nlX10Tnvd4KCWgzJgK+QFn4iyDMU5iUzYG4gUDkZPqtIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778503159; c=relaxed/simple;
	bh=QYibbpy9EA5yb7sY4Niv2wbynoC7escUZs0pWWa2ymQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Rx4DQDE2ZQCWRk5TdwkvQLZFcbvlM0DaifpsqBwFvYYwtBpZAvyQ0HOhX55VtbemLJL+OK9iPO0zgFZL/aieIj+8KnfybRKfau8aTSUDnTUgKMxBlhRWcJU39obaa2id5LCmaG5W215I3PIs1JM6iaF+sco+LkQpaArJhmdCTpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=mx9fHVgm; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Of4sVXfY; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=znlQp2rY; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=RcxI+VET; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="mx9fHVgm";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Of4sVXfY";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="znlQp2rY";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="RcxI+VET"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4E52D5CF17;
	Mon, 11 May 2026 12:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778503156; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sWkfHxIoF1KtE2xYWFlX/qGyW/NSU7VrWKydmcSU7Fc=;
	b=mx9fHVgmN5kjKKm/I8XtafGzrGiXJD2uR9cyCWgrLpfX6WcL9FO57V+cybOLB8O90hN8ej
	N2ErNB0R4jT77RAdfIBokYFT4Rd1mB9RDLHhs362JbFeF0JnFXAXMazzKIyoEpuLVJvawY
	Rq7zY99303c+l+YeIlpR2suA8pxSoWg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778503156;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sWkfHxIoF1KtE2xYWFlX/qGyW/NSU7VrWKydmcSU7Fc=;
	b=Of4sVXfY1WAIfkX91e7uw/KYkaqG9Y149Od9uBvzmKd6YzhmH6v8WYBw2poWjq4itWMYEr
	iuYseRyUNVOKEHCA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=znlQp2rY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=RcxI+VET
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778503155; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sWkfHxIoF1KtE2xYWFlX/qGyW/NSU7VrWKydmcSU7Fc=;
	b=znlQp2rYBGXMyMsQgouaA1h3NxADDLiQlHYAWenB1XYM7JQ0GWvmxEomTYhxhj+k8Hi6t+
	YG3WmpBHSWiHgm8/XXJ+2OOoDN/yI0iN93SwlJvdgdctlbPgp8Zgg8hW1nAjjmauidNn1P
	isRmjLt6Cn/UbbeinKYxtWSS87JS/SY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778503155;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sWkfHxIoF1KtE2xYWFlX/qGyW/NSU7VrWKydmcSU7Fc=;
	b=RcxI+VETAu3sMDDPteBC7ipNEJi3LlR+xedaz8AwbsSwptfXiudt5B7DHIo/BLJd8XJXWD
	cQoD9UlwyhhCcBBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7E70D593A3;
	Mon, 11 May 2026 12:39:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id nRz0G/LNAWqScgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 11 May 2026 12:39:14 +0000
Message-ID: <0bbeadd4-a4b4-44e9-9312-85e563f2bd1c@suse.de>
Date: Mon, 11 May 2026 14:39:08 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nft] netfilter: nft_inner: Fix IPv6 inner_thoff desync
To: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>,
 netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 stable@vger.kernel.org, Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>,
 Xuewei Feng <fengxw06@126.com>, Qi Li <qli01@tsinghua.edu.cn>,
 Ke Xu <xuke@tsinghua.edu.cn>
References: <20260510131953.32790-1-zhaoyz24@mails.tsinghua.edu.cn>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20260510131953.32790-1-zhaoyz24@mails.tsinghua.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[126.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[netfilter.org,strlen.de,nwl.cc,davemloft.net,google.com,kernel.org,redhat.com,vger.kernel.org,mails.tsinghua.edu.cn,126.com,tsinghua.edu.cn];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:mid];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Queue-Id: 4E52D5CF17
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Score: -4.51

On 5/10/26 3:19 PM, Yizhou Zhao wrote:
> In nft_inner_parse_l2l3(), when processing inner IPv6 packets, ipv6_find_hdr()
> correctly computes the transport header offset traversing all extension headers,
> but the result is immediately overwritten with nhoff + sizeof(_ip6h) (40 bytes),
> which only accounts for the IPv6 base header. This creates a desync between
> inner_thoff (wrong — points to extension header start) and l4proto (correct
>   — e.g., IPPROTO_TCP), enabling transport header forgery and potential firewall
> bypass. This issue was found and reproduced with the assistance of GLM 5.1 from
> Z.ai, and exists up to Linux 7.1, affecting stable versions from Linux 6.2.
> 

I don't think there is need to mention the model here. Please use the 
Assisted-by tag instead.

> File: net/netfilter/nft_inner.c
> Function: nft_inner_parse_l2l3()
> 
> ```c
> thoff = nhoff;
> l4proto = ipv6_find_hdr(pkt->skb, &thoff, -1, &fragoff, &fh_flags);
> if (l4proto < 0 || thoff > U16_MAX)
>      return -1;
> if (fragoff == 0) {
>      thoff = nhoff + sizeof(_ip6h);  // BUG: overwrites correct thoff
>      ctx->inner_thoff = thoff;        // stores WRONG offset
>      ctx->l4proto = l4proto;
> }
> ```
> 

I do not think this is relevant in the commit message.

> For comparison, the normal (non-inner) IPv6 path correctly preserves
> ipv6_find_hdr()'s result. Removing the incorrect overwrite ensures
> that ipv6_find_hdr()’s calculated transport header offset is preserved,
> thereby fixing the desynchronization.
> 

The solution makes sense to me. Thanks!

> Fixes: 3a07327d10a09 ("netfilter: nft_inner: support for inner tunnel header matching")

Please stick to a 12 characters long commit hash. Make sure that 
checkpatch.pl script passes.

> Reported-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
> Reported-by: Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
> Reported-by: Xuewei Feng <fengxw06@126.com>
> Reported-by: Qi Li <qli01@tsinghua.edu.cn>
> Reported-by: Ke Xu <xuke@tsinghua.edu.cn>
> Reported-by: GLM 5.1 from Z.ai

This isn't correct. It should be Assisted-by tag instead.

Thanks,
Fernando.

> Signed-off-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
> ---
>   net/netfilter/nft_inner.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/net/netfilter/nft_inner.c b/net/netfilter/nft_inner.c
> index c4569d4b9..1b3e7a976 100644
> --- a/net/netfilter/nft_inner.c
> +++ b/net/netfilter/nft_inner.c
> @@ -163,7 +163,6 @@ static int nft_inner_parse_l2l3(const struct nft_inner *priv,
>   			return -1;
>   
>   		if (fragoff == 0) {
> -			thoff = nhoff + sizeof(_ip6h);
>   			ctx->flags |= NFT_PAYLOAD_CTX_INNER_TH;
>   			ctx->inner_thoff = thoff;
>   			ctx->l4proto = l4proto;

