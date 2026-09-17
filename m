Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA55476CF7;
	Thu, 17 Sep 2026 07:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789628865; cv=none; b=hHL4Be6So8/XSbWCD8IMfeQF7SlFL+vbvyx0wWUeutwU/3shdjEGABvABGwclh8uY4AKpAO0oIbgXlWsCYyGrqQG0e4TXPNTN+HX063hqypv1LedTVGnw7kigcTtnLYkDyIw/2AuqAWcYd10yCvVMOQknVoc2HT3QMi44obY4HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789628865; c=relaxed/simple;
	bh=8HSF+LrOlvT0k5flvlCc9IPHOrpQnuowms4Y/Lxxaz4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lBJxeSFfwAXfF3jYFMgFGGmgRtkwS048GMBFD93SSBtqxpwLplrw6UxMBzVOIbdrlNBF2tH43OZbW/dVC058u0frOkysl/uTxTuEhBlo7Y6gOHQiJkzMLAkchUsGB5tzdIu+4aPNT5kndwJojPo3pkovIvMz2FvPGDNdAe8xktA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=jjc3v8Im; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=e2NjjuV1; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=n+XMeo1n; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=X/KXqiqy; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="jjc3v8Im";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="e2NjjuV1";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="n+XMeo1n";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="X/KXqiqy"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 05D2B21D70;
	Thu, 17 Sep 2026 07:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1789628858; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kjvcZvmqEPMRF/LhXJIRs4s3bEudB5Jl4m8qJV2Wu9c=;
	b=jjc3v8Im+QznQHTfpETVxbLzdwbn66ZxeLS+slepvGG71PY68L8mGhA4e3y6aaw0yonVan
	6r37fyI8QLtFcrrMF7CScPYfZIE/x/VS33aVWqNuiCBdR8Drz6l3kY0V4BIN7le40CWMIo
	8WldHXQfo12Y5SZ2rO3LI5a+lx5iPsU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1789628858;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kjvcZvmqEPMRF/LhXJIRs4s3bEudB5Jl4m8qJV2Wu9c=;
	b=e2NjjuV1H2CD9Lzxd2acRiVhAoOK+Il5RWy8Hy8LWAOu0Q0tffD4TY8vO+I8dEymOyFEyA
	Iy7/EqwCyw9bEUAA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1789628854; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kjvcZvmqEPMRF/LhXJIRs4s3bEudB5Jl4m8qJV2Wu9c=;
	b=n+XMeo1njqwW4rBjHQ5AWI6m0SMaGEfUbAGFDiheonChgXMKnJuMxdY81cQR4v30GUehCM
	R85SwqWTJmi5GNfoxd1X/0xBNJWQymabL+cJGEpNgghBfhjPBsxqDgIyXSW0+c3FO+4PFb
	ZtNw/JrSYru4Bxcyv6DDlcdbP0uWQMY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1789628854;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kjvcZvmqEPMRF/LhXJIRs4s3bEudB5Jl4m8qJV2Wu9c=;
	b=X/KXqiqyecFWWd8CAP7aMBf1OFjZw2VEQe97l6lpFTg5iFvU/uOTb2qTBGLZ50DE1DQh0V
	S7UEp3klHc7BJ+Dg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D81D8134B3;
	Thu, 17 Sep 2026 07:07:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MOz5KLSRq2rfCwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 17 Sep 2026 07:07:32 +0000
Message-ID: <f557e44a-86b6-4ebb-ad35-d7bc5902929a@suse.de>
Date: Thu, 17 Sep 2026 09:06:48 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] selftests: net: update netfilter netlink config
To: Hangbin Liu <hangbin.liu@linux.dev>, Matthieu Baerts
 <matttbe@kernel.org>, Mat Martineau <martineau@kernel.org>,
 Geliang Tang <geliang@kernel.org>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Shuah Khan <shuah@kernel.org>, Pablo Neira Ayuso <pablo@netfilter.org>,
 Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>
Cc: netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, mptcp@lists.linux.dev,
 Hangbin Liu <liuhangbin@kylinos.cn>
References: <20260917-selftest_config-v1-1-bf25ccbfb18e@kylinos.cn>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20260917-selftest_config-v1-1-bf25ccbfb18e@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,kylinos.cn:email]
X-Spam-Flag: NO

On 9/17/26 4:17 AM, Hangbin Liu wrote:
> From: Hangbin Liu <liuhangbin@kylinos.cn>
> 
> Since commit d4349ba9872d ("netfilter: allow nfnetlink built-in only"),
> NETFILTER_NETLINK was changed to a bool. Use 'y' instead of 'm'.
> Otherwise the build emits:
> 
>    .config:5688:warning: symbol value 'm' invalid for NETFILTER_NETLINK
> 
> Fixes: d4349ba9872d ("netfilter: allow nfnetlink built-in only")
> Signed-off-by: Hangbin Liu <liuhangbin@kylinos.cn>

Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>

Thanks!

> ---
> This is a simple update addressing the same issue, so I’d like to post it
> directly to netdev instead of bothering two separate subsystems
> (mptcp and netfilter).
> ---
>   tools/testing/selftests/net/mptcp/config     | 2 +-
>   tools/testing/selftests/net/netfilter/config | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/net/mptcp/config b/tools/testing/selftests/net/mptcp/config
> index 59051ee2a986..bb9c4c97c620 100644
> --- a/tools/testing/selftests/net/mptcp/config
> +++ b/tools/testing/selftests/net/mptcp/config
> @@ -18,7 +18,7 @@ CONFIG_NET_CLS_ACT=y
>   CONFIG_NET_CLS_FW=m
>   CONFIG_NETFILTER=y
>   CONFIG_NETFILTER_ADVANCED=y
> -CONFIG_NETFILTER_NETLINK=m
> +CONFIG_NETFILTER_NETLINK=y
>   CONFIG_NETFILTER_XTABLES=m
>   CONFIG_NETFILTER_XTABLES_LEGACY=y
>   CONFIG_NETFILTER_XT_MATCH_BPF=m
> diff --git a/tools/testing/selftests/net/netfilter/config b/tools/testing/selftests/net/netfilter/config
> index c3c121b6f300..629b2b29ed1a 100644
> --- a/tools/testing/selftests/net/netfilter/config
> +++ b/tools/testing/selftests/net/netfilter/config
> @@ -44,7 +44,7 @@ CONFIG_NET_CLS_U32=m
>   CONFIG_NETDEVSIM=m
>   CONFIG_NETFILTER=y
>   CONFIG_NETFILTER_ADVANCED=y
> -CONFIG_NETFILTER_NETLINK=m
> +CONFIG_NETFILTER_NETLINK=y
>   CONFIG_NETFILTER_NETLINK_QUEUE=m
>   CONFIG_NETFILTER_SYNPROXY=m
>   CONFIG_NETFILTER_XTABLES=m
> 
> ---
> base-commit: 1dd85662fee6e2ac580b1c4f9a0c0a7ae6e31f0e
> change-id: 20260917-selftest_config-286bdd44b22b
> 
> Best regards,

