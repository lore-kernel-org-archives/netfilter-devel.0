Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C2B4418F0
	for <netfilter-devel@vger.kernel.org>; Tue, 12 May 2026 08:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778573597; cv=none; b=Z81tQigxiJKdezOCdmu8y95YPWcBVBeOFnKoUu9fnHnIKAZIs1QX1rl4IQsWa8/5ZmNl2I1y+imW1q9s+v0SzR+cPIovP4rFXbw4WzY4+RboB9RzWdL1iXGQFEZTzvsrrfn1uwYJzWGQ48zayfR9aGE/uC3kwSdylSx130UZgOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778573597; c=relaxed/simple;
	bh=PK6aSXAilBcWWbHOL04QvQetI3k2arLzsbq9g/CJ8jU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i3t9eYokgk/TicKwobxhwmZU7v3jWdVvEKEWJu7Ljwe/INDOGYi90arSRVN+w/k9wOBNrHKF98WkNgG1bQm6+ZCnxr8mIF/aq0eWhDrZV4UL65YANrHhF9JRPaRqJKrOjTHlnxSwJj1nKoeh6Sya4nziyciE4PH6yUxacFKGKUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=wE2Mu2vK; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=JvEirj65; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=JIwDYP5u; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=iM+tMM3i; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="wE2Mu2vK";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="JvEirj65";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="JIwDYP5u";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="iM+tMM3i"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D10C36BDA0;
	Tue, 12 May 2026 08:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778573593; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VzXXNGw/AVHXhERA1dM5vnDVbfWSUQkRLOL87CEnXYs=;
	b=wE2Mu2vK/2slsk95WAKaC/sbLqm5A4+uOCCooGP2MNwjBm5CDENBUprQyGk4BFYzXF3AFD
	mRDXXS7/JaXcT0VRAa5EIx7/z4GiZE+uI6znL/5UQM6pTJhfXFDPuxejiM1Po6Yp8bOYOL
	hSw3WCo2+qB0Dc+u8Y8IqKCsKnEbh9g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778573593;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VzXXNGw/AVHXhERA1dM5vnDVbfWSUQkRLOL87CEnXYs=;
	b=JvEirj659ZW6N8eO916ikywIDPN5lwaNWRRIiuTBE06I0WZB28s+7wO5Y9UIgvutURh4UN
	kbEq+/g+HMYHYUCg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778573591; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VzXXNGw/AVHXhERA1dM5vnDVbfWSUQkRLOL87CEnXYs=;
	b=JIwDYP5u85aYyhViveF85W/3YncoOSFi43zJm2q6sBzRac8jVxJmXnyTMv7dQiqwWgJt2w
	hu9HT1uWBg4tsXfLm+0Pu/2xYRfqzHoHh7FeD87tMswFaoipZeK0X7L+sSK4OkQ/hytUu0
	ZtMmB94fMmlK8jOorDLglByPgtde2LA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778573591;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VzXXNGw/AVHXhERA1dM5vnDVbfWSUQkRLOL87CEnXYs=;
	b=iM+tMM3iqe7ss6Eq3Sv+vt3nLibka9ukNa2bMvF7lz9XqRKBxcP6nSS0RanLzySY4Mk9Dk
	TMmHptY2ihXCAfDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0DCB1593A9;
	Tue, 12 May 2026 08:13:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VsB+ABfhAmr5awAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 12 May 2026 08:13:11 +0000
Message-ID: <dc486fd5-daac-4a9f-b477-52a8f02206c4@suse.de>
Date: Tue, 12 May 2026 10:13:05 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 nf] netfilter: nft_inner: Fix IPv6 inner_thoff desync
To: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>,
 netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>, Xuewei Feng
 <fengxw06@126.com>, Qi Li <qli01@tsinghua.edu.cn>,
 Ke Xu <xuke@tsinghua.edu.cn>, stable@vger.kernel.org
References: <20260511173048.7256-1-zhaoyz24@mails.tsinghua.edu.cn>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20260511173048.7256-1-zhaoyz24@mails.tsinghua.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[15];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[126.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[netfilter.org,strlen.de,nwl.cc,davemloft.net,google.com,kernel.org,redhat.com,mails.tsinghua.edu.cn,126.com,tsinghua.edu.cn,vger.kernel.org];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,tsinghua.edu.cn:email,z.ai:url,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 

On 5/11/26 7:30 PM, Yizhou Zhao wrote:
> In nft_inner_parse_l2l3(), when processing inner IPv6 packets,
> ipv6_find_hdr() correctly computes the transport header offset
> traversing all extension headers, but the result is immediately
> overwritten with nhoff + sizeof(_ip6h) (40 bytes), which only
> accounts for the IPv6 base header. This creates a desync between
> inner_thoff (wrong — points to extension header start) and l4proto
> (correct — e.g., IPPROTO_TCP), enabling transport header forgery
> and potential firewall bypass. This issue affects stable versions
> from Linux 6.2.
> 
> For comparison, the normal (non-inner) IPv6 path correctly
> preserves ipv6_find_hdr()'s result. Removing the incorrect overwrite
> ensures that ipv6_find_hdr()'s calculated transport header offset is
> preserved, thereby fixing the desynchronization.
> 
> Fixes: 3a07327d10a0 ("netfilter: nft_inner: support for inner tunnel header matching")
> Cc: stable@vger.kernel.org
> Reported-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
> Reported-by: Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
> Reported-by: Xuewei Feng <fengxw06@126.com>
> Reported-by: Qi Li <qli01@tsinghua.edu.cn>
> Reported-by: Ke Xu <xuke@tsinghua.edu.cn>
> Assisted-by: GLM:5.1 Z.ai
> Signed-off-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>

Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
