Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574C42E736F
	for <netfilter-devel@vger.kernel.org>; Fri, 29 May 2026 07:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780038857; cv=none; b=btG9iigGHMUlPIL1QATnS07xI2impaaFJ6TS/zRQVsvMzWzR3sbggbsa4udLWZjTjHYm+NiEtVzXxB0z4MMkbtLveqAmf2zq50tf6NNwMY5yhSlw3fd+kpPwvGmtHUoJa//HbxqGUPBIC5HZ/DclDyxAIiycWQBdNqJm6VJDL7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780038857; c=relaxed/simple;
	bh=q7saC2uXuq0fRzDHXXZamkwYDVEVpp2BsF+gE6L30qE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gODgKdmGXZdFuc6LGE9fQzn75otIcQE/buFqdvu7Aynjrv+5zCzajRH8JSXiUnK7jW4qmyM2RoJSGHOV7w9A99JtaEHzOgwtr2/s5o/q5Wn/Brz+w98J9s020OWBrGs4hJg4D/1Lfvrimknp37CKCxEhrGtq48XNZUKLqhF4eMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=AtFHpIao; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=yW4glwfL; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=r35SGfEA; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=U8fxgeuH; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="AtFHpIao";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="yW4glwfL";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="r35SGfEA";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="U8fxgeuH"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 883E06AD6F;
	Fri, 29 May 2026 07:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780038853; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sqKJS7VItIryjZpr2+rwnWoyw8ld5FtNpbGI2o/zcxo=;
	b=AtFHpIaozA7e2lRMSLQxCtXmqUy5hy/GdTzUmzNhB41SKdolstEzuPBAR5H8Gypb8qG/b6
	Puf9WCZSPhmwrBL0XMjchKozewzJ5hAnLHPNBRFCM2ziLlLQqo1shJDXegZkq0tR+WDwrH
	2+b82mLjUmJ2+Kk8Hgnp/EjmBNewD4c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780038853;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sqKJS7VItIryjZpr2+rwnWoyw8ld5FtNpbGI2o/zcxo=;
	b=yW4glwfLOJxCYb+phOUYwdYKWud0QDyLenItGZgiCfXWZpevJYsHRffJgTOJm/SKH/TtUi
	wGDI4SA1fwKXYlCQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=r35SGfEA;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=U8fxgeuH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780038852; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sqKJS7VItIryjZpr2+rwnWoyw8ld5FtNpbGI2o/zcxo=;
	b=r35SGfEAJ2bmNGSgQDpBIW+38k4MQU9+YMFOXR6klctMg+t1/uI5uLQjsAbeMoyqG04E4M
	BnBSbf+5zacPumI3g005EtS4MpKcHoVVrTcYd0Hjg8SK4U0v1UdiccneUSUcVJskwFQCk0
	+7PDKTHJzkW4TXLcANLcwzO8y9nRT6Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780038852;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sqKJS7VItIryjZpr2+rwnWoyw8ld5FtNpbGI2o/zcxo=;
	b=U8fxgeuHnHL3SftnCoVnEX2mZRJsrI7hva0s+8BwDO4MyL2yKRNhIlvCAoSWV0fG+Bk6Bn
	L0bb9naH0hAX7pBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AB7095B1FE;
	Fri, 29 May 2026 07:14:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zuo1JsM8GWquSwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Fri, 29 May 2026 07:14:11 +0000
Message-ID: <381e22d3-fa30-4dde-bd53-705b4a868a90@suse.de>
Date: Fri, 29 May 2026 09:14:00 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] netfilter: TCPMSS: fix dropped packets when MSS option
 is unaligned
To: Kacper Kokot <kacper.kokot.44@gmail.com>, netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
 david.laight.linux@gmail.com, Phil Sutter <phil@nwl.cc>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, coreteam@netfilter.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260528204020.7ae744ab@pumpkin>
 <20260528223412.27311-1-kacper.kokot.44@gmail.com>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20260528223412.27311-1-kacper.kokot.44@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 883E06AD6F
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[15];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[netfilter.org,strlen.de,gmail.com,nwl.cc,davemloft.net,google.com,kernel.org,redhat.com,vger.kernel.org];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim]

On 5/29/26 12:34 AM, Kacper Kokot wrote:
> Padding TCP options with NOPs is optional, so it is legal to send an
> MSS option that is not aligned to a word boundary and therefore not
> aligned for checksum calculation. The current TCPMSS target is not
> robust to this: when the MSS option is unaligned it produces an
> invalid checksum, and the packet is dropped.
> 
> This has not been observed in any real environment. Senders place the
> MSS at the beginning of the options block, where it is naturally
> aligned, but the spec allows unaligned options and the kernel shouldn't
> silently drop legal packets.
> 
> When the changed word is not aligned, the modified bytes straddle two
> checksum words, and using the standard incremental update helper
> (which assumes alignment) produces an invalid checksum:
> 
>      | w1     | w2     |
> OLD |  a  b  |  c  d  |
> NEW |  a  b' |  c' d  |
> 
> Since b' and c' sit across w1 and w2, we could compute the incremental
> checksum in two operations by recalculating w1 and then w2:
> 
>      C' = C - w1 + w1' - w2 + w2'
> 
> But working it out:
> 
>      C' = C - w1 - w2 + w1' + w2'
>         = C - (a * 2^8 + b)  - (c * 2^8 + d)
>             + (a * 2^8 + b') + (c' * 2^8 + d)
>         = C + 2^8 * (a - a + c' - c) + (b' - b + d - d)
>         = C + 2^8 * (c' - c) + (b' - b)
>         = C - (2^8 * c + b) + (2^8 * c' + b')
> 
> So an unaligned incremental checksum can be done in a single operation
> by byteswapping the changed bytes before passing them to the helper.
> This patch implements that trick for unaligned MSS option updates.
> 
> Signed-off-by: Kacper Kokot <kacper.kokot.44@gmail.com>
> ---

Just a couple of nits..

Please use nf-next target, like "[PATCH nf-next v3] netfilter: 
xt_TCPMSS: ...". Let's handle this as an enhancement.

> I decided to go with the get_unaligned_be16 suggestion because
> it's idiomatic and it produces shorter assembly on x86-64
> (6 instructions vs 9). SYN processing is a cold path so
> I didn't look into it further.
> 
> v2:
>   - Use get_unaligned_be16 (Fernando's suggestion)
>   - Fix alignment check expression (David)
>   - Mention it's a theoretical bug in the commit message
>   - Drop cc stable, the bug is only theoretical
> 
>   net/netfilter/xt_TCPMSS.c | 16 ++++++++++++++--
>   1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
> index 80e1634bc51f..32c87a520361 100644
> --- a/net/netfilter/xt_TCPMSS.c
> +++ b/net/netfilter/xt_TCPMSS.c
> @ -117,8 +117,9 @@ tcpmss_mangle_packet(struct sk_buff *skb,
>   	for (i = sizeof(struct tcphdr); i <= tcp_hdrlen - TCPOLEN_MSS; i += optlen(opt, i)) {
>   		if (opt[i] == TCPOPT_MSS && opt[i+1] == TCPOLEN_MSS) {
>   			u_int16_t oldmss;
> +			u16 csum_oldmss, csum_newmss;

Please use reversed xmas tree:

+			u16 csum_oldmss, csum_newmss;
   			u_int16_t oldmss;

Thanks,
Fernando.
