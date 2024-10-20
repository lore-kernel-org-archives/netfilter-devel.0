Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACEA717543;
	Sun, 20 Oct 2024 06:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.237.130.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729404608; cv=none; b=RJ/mdQDwa/KJfb1QaA53EuGlhOqLfGaI8YJnWE8hWTEzGj7TYMtsH7p8cjH3inDsySp1IEgKFO8QfS4rdwz1Nfehjqt3rdl7rgt1yOLAHQhHBOwbUOogeF5oQ2P9TAw3TieoCwJsXw0B0C5nTkzpqeGSW1xLAgc1h64QDNxE5Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729404608; c=relaxed/simple;
	bh=F3grSouN+TZpsaEREplq00cTbboxFvzZ7+5mcLi7Qws=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sRhyOePANfx1+V5vXZKsaioXvBwXNlrkhVOXArAYStLK4DeEgqXHIsWaoBY9qvnrwTOKpAM6SEUAmBQ/bxfWcdlr4Cq4HHJRVBP3SIuyKxvDs/p4qBlJld+iXnBb10RUm4eFMDP5pW+V5afsmAIdYhNGFw8ROZ/GyxgSJssdg+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=aB/jlrpL; arc=none smtp.client-ip=80.237.130.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="aB/jlrpL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=leemhuis.info; s=he214686; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:
	Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	In-Reply-To:References; bh=cx6s8aoEP6mh4BZD5a9PwPy6TZKM720Amha8z1oJXV4=;
	t=1729404606; x=1729836606; b=aB/jlrpLXo+Put0ibDiMj/RLx1PJQSbR6dRVjDXSxG3c3CD
	aUqmczPkynz74ntVVT4YyeFiaxkk5sd9x6wjWF/UMtd8ghojm6uP8Il5cx5BWyEWdZsNUfoPLPjmb
	qHaptiB2e5AgFdl03sJ8ZR3EEixWdWMAQsm4DPZy4U+RUIBc4xL4wL3paesM6U7GWDUyvyEY02oZS
	FX8lAVD7/g+XOH5mk6JTPZkWV9EXvGDjRyx8P709aiLIzsJ4AoQYh+PzmtEcnTMqsqr3oND1wV/Vi
	CeUUX/vU79cdqjuMIU/uS5IIusFaoYN9P8a5hDAY+Nro/ZwL9npG0qHBh8Ebz1qw==;
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	id 1t2P8W-0005yr-TA; Sun, 20 Oct 2024 08:09:56 +0200
Message-ID: <64702a91-e8c8-4d9e-92a0-e53c58e5ff77@leemhuis.info>
Date: Sun, 20 Oct 2024 08:09:55 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: 6.6.57-stable regression: "netfilter: xtables: avoid
 NFPROTO_UNSPEC where needed" broke NFLOG on IPv6
To: =?UTF-8?Q?Krzysztof_Ol=C4=99dzki?= <ole@ans.pl>,
 Florian Westphal <fw@strlen.de>, Pablo Neira Ayuso <pablo@netfilter.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Ilya Katsnelson <me@0upti.me>
Cc: stable@vger.kernel.org, netfilter-devel
 <netfilter-devel@vger.kernel.org>,
 Linux kernel regressions list <regressions@lists.linux.dev>
References: <8eb81c74-4311-4d87-9c13-be6a99c94e2f@ans.pl>
From: "Linux regression tracking (Thorsten Leemhuis)"
 <regressions@leemhuis.info>
Content-Language: en-US, de-DE
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
In-Reply-To: <8eb81c74-4311-4d87-9c13-be6a99c94e2f@ans.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1729404606;71981361;
X-HE-SMSGID: 1t2P8W-0005yr-TA

[CCing Ilya and the regression list, as it should be in the loop for
regressions: https://docs.kernel.org/admin-guide/reporting-regressions.html]

> Hi,
> 
> After upgrading to 6.6.57 I noticed that my IPv6 firewall config failed to load.
> 
> Quick investigation flagged NFLOG to be the issue:
> 
> # ip6tables -I INPUT -j NFLOG
> Warning: Extension NFLOG revision 0 not supported, missing kernel module?
> ip6tables: No chain/target/match by that name.
> 
> The regression is caused by the following commit:
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?h=linux-6.6.y&id=997f67d813ce0cf5eb3cdb8f124da68141e91b6c

Not my area of expertise, but from a quick look is seems to be a known
problem due to some typos and people are working on a fix here:

https://lore.kernel.org/all/20241019-xtables-typos-v3-1-66dd2eaacf2f@0upti.me/

Ciao, Thorsten

> More precisely, the bug is in the change below:
> 
> +#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
> +	{
> +		.name       = "NFLOG",
> +		.revision   = 0,
> +		.family     = NFPROTO_IPV4,
> +		.checkentry = nflog_tg_check,
> +		.destroy    = nflog_tg_destroy,
> +		.target     = nflog_tg,
> +		.targetsize = sizeof(struct xt_nflog_info),
> +		.me         = THIS_MODULE,
> +	},
> +#endif
> 
> Replacing NFPROTO_IPV4 with NFPROTO_IPV6 fixed the issue.
> 
> Looking at the commit, it seems that at least one more target (MARK) may be also impacted:
> 
> +#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
> +	{
> +		.name           = "MARK",
> +		.revision       = 2,
> +		.family         = NFPROTO_IPV4,
> +		.target         = mark_tg,
> +		.targetsize     = sizeof(struct xt_mark_tginfo2),
> +		.me             = THIS_MODULE,
> +	},
> +#endif
> 
> The same errors seem to be present in the main tree:
>  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=0bfcb7b71e735560077a42847f69597ec7dcc326
> 
> I also suspect other -stable trees may be impacted by the same issue.
> 
> Best regards,
>  Krzysztof Olędzki

