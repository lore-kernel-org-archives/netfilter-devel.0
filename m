Received: from smtp.emenem.pl (cmyk.emenem.pl [217.79.154.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9CFA92F;
	Mon, 21 Oct 2024 02:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.79.154.63
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729479490; cv=none; b=XvI0F0otKtAon0wK06DoiBcf0214yOSWKCdRufVL5oi+JhXC7IJhEFmT7JB1NiAjAh4+Qooml97zKzFn1Y9U+qrtl1X1RwQimDf1VBollfop0BrMCBT6bHLQ0zOMwy4StEcw+/le7uRQNH4FHMHwptyq0xYhQMHGzpG9Lyqrapo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729479490; c=relaxed/simple;
	bh=gvnhP3QR2v/zK5Lm6aagczIw/TFzfWmYcKiZFGwl2KI=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=ld32+tHT/qF33LGYsfJ3sYOd5d0fAY428uI4LTdQkxN1JXY/jbo+rs9p2yBJCs15ndHIbu4SWeMCMHS4TAFgr7NFsVzSpiyJEAE2QXAxFMijSEV7XvfW1dizYgHmM43s6xZehSQoFhp420eV+Zx5oN3lw1RC/jmiqA9PgEVz+Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ans.pl; spf=none smtp.mailfrom=ans.pl; dkim=pass (1024-bit key) header.d=ans.pl header.i=@ans.pl header.b=Anz6nZFF; arc=none smtp.client-ip=217.79.154.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ans.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ans.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ans.pl header.i=@ans.pl header.b="Anz6nZFF"
X-Virus-Scanned: amavisd-new at emenem.pl
Received: from [192.168.1.10] (c-98-45-176-131.hsd1.ca.comcast.net [98.45.176.131])
	(authenticated bits=0)
	by cmyk.emenem.pl (8.17.1.9/8.17.1.9) with ESMTPSA id 49L2vmNd024121
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Mon, 21 Oct 2024 04:57:50 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ans.pl; s=20190507;
	t=1729479472; bh=3wqb91UsdampFD5fRrQ9mHDNugrdeONpWtaLAOGbpjA=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=Anz6nZFF/IQ8xBjeZY+43+whTOWA2tUxLwdHaPJ1Bnqrmam2pKR6c5GtIO5AVBFoe
	 mW55AKn1qGT/ssnmnwzlHy7WEqMA90p5IGYjjeJcof42dCTRSuPI7eT+D6SSAknsEF
	 mrOAqsl1R88OVqeEzJWUY9YdSfu6b1e3IbC7cBIY=
Message-ID: <74317861-2cff-424b-a3db-8b214cec5f70@ans.pl>
Date: Sun, 20 Oct 2024 19:57:47 -0700
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: 6.6.57-stable regression: "netfilter: xtables: avoid
 NFPROTO_UNSPEC where needed" broke NFLOG on IPv6
From: =?UTF-8?Q?Krzysztof_Ol=C4=99dzki?= <ole@ans.pl>
To: Florian Westphal <fw@strlen.de>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ilya Katsnelson <me@0upti.me>, Phil Sutter <phil@nwl.cc>
Cc: stable@vger.kernel.org, netfilter-devel
 <netfilter-devel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <8eb81c74-4311-4d87-9c13-be6a99c94e2f@ans.pl>
Content-Language: en-US
In-Reply-To: <8eb81c74-4311-4d87-9c13-be6a99c94e2f@ans.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 19.10.2024 at 22:22, Krzysztof Olędzki wrote:
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
> 
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

Seems like this is already being taken care of:

https://lore.kernel.org/netdev/ZxT8ow0auDTe-TDA@calendula/T/#t

Krzysztof
