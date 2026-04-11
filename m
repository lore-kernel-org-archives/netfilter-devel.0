Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57811B4F1F
	for <netfilter-devel@vger.kernel.org>; Sat, 11 Apr 2026 07:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775894178; cv=none; b=WXg44etF0Q0I1QATMcaKyuxetsUEp5BKhQ8RAlu20cDut6d3HpOzEAOsZuQ+z3/4waQBcg7zGXecKjMZ1wOmYIk/7I5WRQUiB/qjXz0IK8wBx7Kppk4UTP8IT7V3zvOBYkVhbKOiI+JxatZhTnaWnWdkVHbVOpPnyVZ++o0DOgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775894178; c=relaxed/simple;
	bh=4EyWVh+sqba13i3DcNNp9IktKUHkroxhfrmheQLss3Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HrXH4O6Ay6OwKemXSyD6wsQUkWRTzr5+tNQLtchNntRkExIMv+OoDlhR7iHLoFpmA/20/Kfbjzv/l7Y+5FDDpRe8jf6B798yxX5lwl+JJX1B/twNzDNd9joBuU12SSJaDKZKZqquz+NO34zRLBxILIpvvqbIbwun8VYLec5wGFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=qb24Z+Br; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Mjirkspp; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=J7d6KbSk; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=UjeuIZpc; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="qb24Z+Br";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Mjirkspp";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="J7d6KbSk";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="UjeuIZpc"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D75805BCE9;
	Sat, 11 Apr 2026 07:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775894176; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y9ogqdpWFxG/8VwOBBIyYhZvg5tUZjc7AasSF5vpd7A=;
	b=qb24Z+BraCaE4cMlOJtjsCGAzKmrAyONAbUCicRt/MuK98xvm9HKX65twso/PjVmLvFBGU
	4Jv3BFbB2oWxCw2xcHyssm6vPuYF7WL9rrgQ75HCRnpwJoVAfTwOMRthNSWmOEbA5kR25h
	PdzCBXEj/odzq4Ea8WRzhSmE8c7blks=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775894176;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y9ogqdpWFxG/8VwOBBIyYhZvg5tUZjc7AasSF5vpd7A=;
	b=MjirksppC3nBQPVW0CcCZnGaSvpQNvyv92xZO26zJ9cr84g3gFQJHgDj9ENDSViqqgxBPK
	PvurOfvUfHkD0yAw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775894175; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y9ogqdpWFxG/8VwOBBIyYhZvg5tUZjc7AasSF5vpd7A=;
	b=J7d6KbSknOX6B6fRrPAqsdPTDmnrNB96OilGXL7FKECpWJLZu2jmr4Dxzys2UYxwte/bvN
	s9soegb36+p9ng8UcYvp2ojl8aRGTwtY9vNh/zCe1H0rsBdif2x43+myUb0p1giIZ5NzW5
	SknFe+w7ffTqbhUrvKuW5dS7QvjX7XM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775894175;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y9ogqdpWFxG/8VwOBBIyYhZvg5tUZjc7AasSF5vpd7A=;
	b=UjeuIZpcHFMtM2ZZ7K+/pmImroyk8tAX7tsr4eQgNHjBv51Fwrz1322oVp/MkvrjLbt09f
	4c60rn/d4lcrzyDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 654DC4A0A3;
	Sat, 11 Apr 2026 07:56:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZaFwFZ/+2WkkUQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Sat, 11 Apr 2026 07:56:15 +0000
Message-ID: <6c09eeed-8f7f-4bd5-977e-a7b0da4b4cf4@suse.de>
Date: Sat, 11 Apr 2026 09:56:05 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf] netfilter: nfnetlink_osf: fix divide-by-zero in
 OSF_WSS_MODULO
To: Xiang Mei <xmei5@asu.edu>, netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>, coreteam@netfilter.org,
 Weiming Shi <bestswngs@gmail.com>
References: <20260410204843.64259-1-xmei5@asu.edu>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20260410204843.64259-1-xmei5@asu.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.29
X-Spam-Level: 
X-Spamd-Result: default: False [-4.29 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.19)[-0.933];
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

On 4/10/26 10:48 PM, Xiang Mei wrote:
> The OSF_WSS_MODULO branch in nf_osf_match_one() performs:
> 
>    ctx->window % f->wss.val
> 
> without guarding against f->wss.val == 0.  A user with CAP_NET_ADMIN
> can add an OSF fingerprint with wss.wc = OSF_WSS_MODULO and wss.val = 0
> via nfnetlink.  When a matching TCP SYN packet arrives, the kernel
> executes a division by zero and panics.
> 
> The OSF_WSS_PLAIN case already treats val == 0 as a wildcard (match
> everything).  Apply the same semantics to OSF_WSS_MODULO: if val is 0,
> any window value matches rather than dividing by zero.
> 
> Crash:
>   Oops: divide error: 0000 [#1] SMP KASAN NOPTI
>   RIP: 0010:nf_osf_match_one (net/netfilter/nfnetlink_osf.c:98)
>   Call Trace:
>   <IRQ>
>    nf_osf_match (net/netfilter/nfnetlink_osf.c:220 (discriminator 6))
>    xt_osf_match_packet (net/netfilter/xt_osf.c:32)
>    ipt_do_table (net/ipv4/netfilter/ip_tables.c:348)
>    nf_hook_slow (net/netfilter/core.c:622 (discriminator 1))
>    ip_local_deliver (net/ipv4/ip_input.c:265)
>    ip_rcv (include/linux/skbuff.h:1162)
>    __netif_receive_skb_one_core (net/core/dev.c:6181)
>    process_backlog (.include/linux/skbuff.h:2502 net/core/dev.c:6642)
>    __napi_poll (net/core/dev.c:7710)
>    net_rx_action (net/core/dev.c:7945)
>    handle_softirqs (kernel/softirq.c:622)
> 
> Fixes: 31a9c29210e2 ("netfilter: nf_osf: add struct nf_osf_hdr_ctx")
> Reported-by: Weiming Shi <bestswngs@gmail.com>
> Signed-off-by: Xiang Mei <xmei5@asu.edu>

LGTM, but I don't see this happening at all to be honest. Such 
fingerprint would be bogus anyway.

The fixes tag is not correct I think. This was introduced on 
11eeef41d5f6 ("netfilter: passive OS fingerprint xtables match") actually.

Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
