Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E1727A444
	for <netfilter-devel@vger.kernel.org>; Thu, 16 Oct 2025 23:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760657964; cv=none; b=TNYuIZVi2G4JQvK2z0BYK49rCWmKyd5mFOrAsQ1jeQu56/dp6rav+f0DjsSAp8ifvN/Z4dvcBh367ARDhbfjVW/5m/IgoMmg6yqyFN5k2jq2T8ALlq7i0n3WA5RpkcAe2f0TK3bLn+8CuN2wVVJLru+m/m57ohYq3s5ho7+/Q/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760657964; c=relaxed/simple;
	bh=SgjJXUXQGL54YuUEpH3KUHujMklDiU0i438fdGE/pw0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=VeDcvpSuEDxTURch/L11Vt7Tl/OTeOfi3kAd+TyvAVGAnSYTbEcXlsiHWx6THHclhjDw3FqtvYvQdltx0Yehu028RRHzdFvrmbbs5xjLuRkWCqxb2YbU0J1cKmiQ/F31vWe4L0QdRI6wYzhbhfRDpSg5ytUuJgQUqEMwnRnMG4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=MX71SyfL; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=n6gXW8Qk; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=MX71SyfL; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=n6gXW8Qk; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="MX71SyfL";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="n6gXW8Qk";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="MX71SyfL";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="n6gXW8Qk"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 36CAC21AE8;
	Thu, 16 Oct 2025 23:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760657960; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JpZdPKo1jwaEk5dBRLfH4cMUjZYNaeDdoRad8ORLnBE=;
	b=MX71SyfL9g1mYTtilpf2vILwqd4sy/5z8QYpwr+asMAQs+KdDD5w80v2DFULCpEMmBx7Dd
	fo0bpd+lZXsgEGC2qVlg8ie6QaLgchisqpnX+kDp0hWZnpB6wQDJMUu8Y2XD5TJV1Brrsu
	mr3oSd/2pG5ZGOkRSd/77aJaEf0H1hQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760657960;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JpZdPKo1jwaEk5dBRLfH4cMUjZYNaeDdoRad8ORLnBE=;
	b=n6gXW8QkQL1TyDN9X1aAfKq48+7ZxzevW32Wzf1hOY/xKJXeOQzdf7cMySjwcYm51SlGOB
	Gfkl2vjZ5Y+zx7BQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760657960; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JpZdPKo1jwaEk5dBRLfH4cMUjZYNaeDdoRad8ORLnBE=;
	b=MX71SyfL9g1mYTtilpf2vILwqd4sy/5z8QYpwr+asMAQs+KdDD5w80v2DFULCpEMmBx7Dd
	fo0bpd+lZXsgEGC2qVlg8ie6QaLgchisqpnX+kDp0hWZnpB6wQDJMUu8Y2XD5TJV1Brrsu
	mr3oSd/2pG5ZGOkRSd/77aJaEf0H1hQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760657960;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JpZdPKo1jwaEk5dBRLfH4cMUjZYNaeDdoRad8ORLnBE=;
	b=n6gXW8QkQL1TyDN9X1aAfKq48+7ZxzevW32Wzf1hOY/xKJXeOQzdf7cMySjwcYm51SlGOB
	Gfkl2vjZ5Y+zx7BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0950C1340C;
	Thu, 16 Oct 2025 23:39:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tc6JOieC8WjyCQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 16 Oct 2025 23:39:19 +0000
Message-ID: <a22d90e7-4ae1-42f4-a1d7-4df553e01118@suse.de>
Date: Fri, 17 Oct 2025 01:39:15 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nft 2/4] src: tunnel src/dst must be a symbolic expression
To: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20251016145955.7785-1-fw@strlen.de>
 <20251016145955.7785-3-fw@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20251016145955.7785-3-fw@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 



On 10/16/25 4:59 PM, Florian Westphal wrote:
> Included bogons crash with segfault and assertion.  After fix:
> 
> tunnel_with_garbage_dst:3:12-14: Error: syntax error, unexpected tcp, expecting string or quoted string or string with a trailing asterisk or '$'
>    ip saddr tcp dport { }
>             ^^^
> The parser change restricts the grammar to no longer allow this,
> we would crash here because we enter payload evaluation path that
> tries to insert a dependency into the rule, but we don't have one
> (ctx->rule and ctx->stmt are NULL as expected here).
> 
> The eval stage change makes sure we will reject non-value symbols:
> 
> tunnel_with_anon_set_assert:1:12-31: Error: must be a value, not set
> define s = { 1.2.3.4, 5.6.7.8 }
>             ^^^^^^^^^^^^^^^^^^^^
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>   src/evaluate.c                                | 20 +++++++++++++++++--
>   src/parser_bison.y                            |  8 ++++----
>   .../bogons/nft-f/tunnel_with_anon_set_assert  |  8 ++++++++
>   .../bogons/nft-f/tunnel_with_garbage_dst      |  5 +++++
>   4 files changed, 35 insertions(+), 6 deletions(-)
>   create mode 100644 tests/shell/testcases/bogons/nft-f/tunnel_with_anon_set_assert
>   create mode 100644 tests/shell/testcases/bogons/nft-f/tunnel_with_garbage_dst
> 

Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
