Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585C8153828;
	Tue, 22 Oct 2024 07:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.237.130.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729582787; cv=none; b=Va7RaGo4cZg0CQroMmHjv8b2z7yh+P8g51VenD9vAlSKzNz5TkNLiCi8iB807kz1QtJPBCbD23ugFnhDtyhsRXIgwxxCgC8Cgvgkq6fg3JqvAlz+UnuvKB44HXyqs3GtO2hxuS8ceJsOgqbV8sxhN1rqHIcbh/y9sdX9PGhZ47w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729582787; c=relaxed/simple;
	bh=Eano7e7ZbmoFzyy0lr6CS59PmcuzUR+xyyhAGeM82Pc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KUlAjNme4oLTg+vnVVJjCio84JTsVQcHLmLfBrCDAihIjTwitSnruVnXofol48yhTiaTw71biBv6VqXXdRGW11BX8zAkoJ+XRTlVvPxOHon/EPakZsHzzRln1HXUK+7wVpj6Q+GkTvkNj8cxoyfbBRUuYTYJMlILpZuMnM4WYrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=lnxpR4kt; arc=none smtp.client-ip=80.237.130.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="lnxpR4kt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=leemhuis.info; s=he214686; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:Reply-To:MIME-Version:Date:
	Message-ID:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:
	Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	In-Reply-To:References; bh=mvPEUn3wk8MI/IHfQskE7Vd0iKR0polAny/1Lu808DE=;
	t=1729582785; x=1730014785; b=lnxpR4ktmQC7GQQhYnIkpd6CA9m4rHJCyBVOI4EILeIdxFy
	rKtRf7tH4+Ur6wneLxz9hJlTtf+Y+Ifo9UGgQa0an8R7/U2b+rM7NehSR85nEVIGBEDhOtdfv3MC0
	vOgrNBVt0/u++ykfpBhXtefqdnsh7Y8Kulnh3DI3Zjj8vjg8Ih/bCYmSEwJk7n2lb7OkWCglV0oFV
	brFTPEfLjviZVaxSpfH7j3CV5VAwTFNufhh59QOggcoLwNgaJiQMSbukcEKVQtGzPyiHmVpGFCKle
	T/slmeSP9zEXhuXhEtzh7ditijmWsWYOPgkqFUvQyejD5wfkrHAqwiiu7LxcBxpA==;
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	id 1t39UT-00009u-M6; Tue, 22 Oct 2024 09:39:41 +0200
Message-ID: <8cd31ad2-7351-4275-ab11-bca6494f408a@leemhuis.info>
Date: Tue, 22 Oct 2024 09:39:38 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
Subject: Re: [PATCH net 2/2] netfilter: xtables: fix typo causing some targets
 not to load on IPv6
To: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
 pabeni@redhat.com, edumazet@google.com, fw@strlen.de,
 Linux kernel regressions list <regressions@lists.linux.dev>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>,
 Greg KH <gregkh@linuxfoundation.org>
References: <20241021094536.81487-1-pablo@netfilter.org>
 <20241021094536.81487-3-pablo@netfilter.org>
From: "Linux regression tracking (Thorsten Leemhuis)"
 <regressions@leemhuis.info>
Content-Language: en-US, de-DE
In-Reply-To: <20241021094536.81487-3-pablo@netfilter.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1729582785;8bbdb3f4;
X-HE-SMSGID: 1t39UT-00009u-M6

[CCing Greg and the stable list, to ensure he is aware of this, as well
as the regressions list]

On 21.10.24 11:45, Pablo Neira Ayuso wrote:
> - There is no NFPROTO_IPV6 family for mark and NFLOG.
> - TRACE is also missing module autoload with NFPROTO_IPV6.
> 
> This results in ip6tables failing to restore a ruleset. This issue has been
> reported by several users providing incomplete patches.
> 
> Very similar to Ilya Katsnelson's patch including a missing chunk in the
> TRACE extension.
> 
> Fixes: 0bfcb7b71e73 ("netfilter: xtables: avoid NFPROTO_UNSPEC where needed")
> [...]

Just FYI as the culprit recently hit various stable series (v6.11.4,
v6.6.57, v6.1.113, v5.15.168) quite a few reports came in that look like
issues that might be fixed by this to my untrained eyes. I suppose they
won't tell you anything new and maybe you even have seen them, but on
the off-chance that this might not be the case you can find them here:

https://bugzilla.kernel.org/show_bug.cgi?id=219397
https://bugzilla.kernel.org/show_bug.cgi?id=219402
https://bugzilla.kernel.org/show_bug.cgi?id=219409

Ciao, Thorsten
