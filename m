Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08638305678
	for <netfilter-devel@vger.kernel.org>; Mon, 25 May 2026 22:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779748528; cv=none; b=rs81rx5M20UphjX4s9UP6oFwOMRB6AcXBXic4RQVx0hc7+OD4oWa31wh5mQUYNKflYom21OO5PAUDVW2WdHLdKad1BgsCImHy//oVFTLA0xzsuHKWkA4lUEutjBlf31C1LBF+1oMdObcxEfIIqVFS3a2IW8Ph02vJoLtKTJ4RjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779748528; c=relaxed/simple;
	bh=8ylAFAS9YuJD4k4XP63R+PHoBvZ7K3dsTcFK+Avw/ZM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A3xn/qGmiBxIy57sSy+bJ5awK89eX5JIIKuLtyJSr7tcf7nzfHwxyogUD+y4AdtBn1iT8aLUuELZiCwCAfRPkWKDLLmG3pzvzDVhrkHL1s50DkqUr3qv3QpGF3FQPOjWvADDdHfHAor2dG8MfQU7Ad0xt/Hsq/QnPI8ZKwz7txI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ZIMrObWJ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=5BVP8QMi; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=OjQB8ihL; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=EBK4dwgK; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ZIMrObWJ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="5BVP8QMi";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="OjQB8ihL";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="EBK4dwgK"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 275DE75946;
	Mon, 25 May 2026 22:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779748525; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gmgQD5TPM5PC2w3vqp/6mUVFtt+95CGRqTMfAdXxESQ=;
	b=ZIMrObWJvTuar6/P3LUJAYK2HxviMldqSD5lRFkZww0HS948fzDc3iPlff0EsV2D4H6q1p
	YrPPqHLYQ09jhfZQiJF0itEWZJYOdi0VZOtKYnb5Ru8JugOrCVtUw0526cubeuOybnj4qu
	L0MqyepaMXIxnWAtNeKGO7xOGhEyT/w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779748525;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gmgQD5TPM5PC2w3vqp/6mUVFtt+95CGRqTMfAdXxESQ=;
	b=5BVP8QMibEqomWHj21WqJNEW4Qw3S5NRzLp2hsEKxPV5/hQqeu9Y6zqEZsu1VBRBi13rhh
	Qqdg8SE/712v79BQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=OjQB8ihL;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=EBK4dwgK
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779748524; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gmgQD5TPM5PC2w3vqp/6mUVFtt+95CGRqTMfAdXxESQ=;
	b=OjQB8ihL4MPRE1MCblbyOispMLN+1JsUFXEeGxlKyFCqAyvZmHRGUbzlpnjQbTV+YzcDsu
	wRXc0Ov+zMj6GsgRz5lTGHZ/uMYIydSAdLl2loVGldu4gI/kjPrMUuCsx6SPvCiUSJv2Mp
	4lKQC6ntjcCXMgpcde+16gSIY5JINOw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779748524;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gmgQD5TPM5PC2w3vqp/6mUVFtt+95CGRqTMfAdXxESQ=;
	b=EBK4dwgKxdxZTE1zS7zILMd8OzyR7uxzN/3hWmBU8A7/zUKyXOiNwQJgR50kEB5Iq8l0sI
	U5aBcS2mKQKUcqBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 63FAC59E9E;
	Mon, 25 May 2026 22:35:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tr6GFavOFGo5CQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 25 May 2026 22:35:23 +0000
Message-ID: <a8cfeb06-6ffb-49f2-a14d-c5a50bc4e5be@suse.de>
Date: Tue, 26 May 2026 00:35:22 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] netfilter: nf_conntrack: use get_unaligned_be32() in
 tcp_sack()
To: Rosen Penev <rosenp@gmail.com>, netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, linusw@kernel.org,
 Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, "open list:NETFILTER"
 <coreteam@netfilter.org>,
 "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>
References: <20260525215840.93217-1-rosenp@gmail.com>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20260525215840.93217-1-rosenp@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.51
X-Rspamd-Queue-Id: 275DE75946
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO

On 5/25/26 11:58 PM, Rosen Penev wrote:
> The timestamp-only fast path dereferences the option stream as
> *(__be32 *)ptr, which assumes 4-byte alignment that the TCP option
> stream does not guarantee. Use get_unaligned_be32() instead, which
> reads the value safely and already returns host byte order, so the
> htonl() on the comparison constant can be dropped.
> 
> This matches the existing get_unaligned_be32() use later in the same
> function.
> 
> Assisted-by: Claude:Opus-4.7
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
I already spotted this corner case when working on a SYNPROXY patch [1] 
but didn't send a patch yet. I think this is for correctness too.

Anyway, it is likely that there are more places where this tweak is 
needed.. I will look around.. meanwhile:

Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>

[1] lore.kernel.org/netfilter-devel/20260525124450.6043-4-fmancera@suse.de/
