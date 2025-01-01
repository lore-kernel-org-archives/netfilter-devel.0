Received: from smtp-out.freemail.hu (fmfe17.freemail.hu [46.107.16.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8169E1854;
	Wed,  1 Jan 2025 23:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.107.16.210
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735775884; cv=none; b=sqyBKwv3S3XQxygWApfR3aOXmkIjudDmAUrXyRdWizWT3yINb34QoszW/bBql3ZeuzByQGGwxRDsqNnULVhxwzw8JfhamZjfL0njjVM8yLBCFCJiWUXnV7yRLp44E/PXLYgRLjulwZHTAj2GhPffEpVZlYhWshyg5n1MYZgoAQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735775884; c=relaxed/simple;
	bh=KjWzF3wS0pZoSKx1P6Zodu9Sg77YM5SYHTU5nytsAAc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hAXQAlkLc57q6v1jARm5h3DtUkuzlTHd4Jr3g79RRgchiDnkjzN8kTbPlLPawdd/WzqVqGUbgDlkH9VW2iAmvPDdjD/JtZ2skQgc9QdKSfq1UfMhes/wHd4evYUvtHILTN7YAEpQikBbe22Er3IlQ9YlFLSsEYo2v57IT4pCNaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu; spf=pass smtp.mailfrom=freemail.hu; dkim=fail (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b=BKVpkmJK reason="signature verification failed"; arc=none smtp.client-ip=46.107.16.210
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freemail.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b="BKVpkmJK"
Received: from [192.168.0.16] (catv-178-48-208-49.catv.fixed.vodafone.hu [178.48.208.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.freemail.hu (Postfix) with ESMTPSA id 4YNmjn1B3NzPV2;
	Thu, 02 Jan 2025 00:47:57 +0100 (CET)
Message-ID: <4ad8fb04-b2d6-493b-978c-7dea46fdc623@freemail.hu>
Date: Thu, 2 Jan 2025 00:47:36 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] netfilter: uapi: Merge xt_*.h/c and ipt_*.h which has
 same name.
To: Florian Westphal <fw@strlen.de>
Cc: pablo@netfilter.org, lorenzo@kernel.org, daniel@iogearbox.net,
 leitao@debian.org, amiculas@cisco.com, kadlec@netfilter.org,
 davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20250101192015.1577-1-egyszeregy@freemail.hu>
 <20250101224644.GA18527@breakpoint.cc>
Content-Language: hu
From: =?UTF-8?Q?Sz=C5=91ke_Benjamin?= <egyszeregy@freemail.hu>
In-Reply-To: <20250101224644.GA18527@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=simple/relaxed; t=1735775278;
	s=20181004; d=freemail.hu;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	l=1604; bh=q0DSNwLScRiaQLxNwZVLQDZw681oZvLtrXtBTsVUgC0=;
	b=BKVpkmJK08j8fQ28lzkET563USp5ok4mnxqpJhCAt+9ffgl/bPveORrvogwIjQ9E
	eFGDkJ3Wnwra0ZM2XRwmj9TNP1LS8JuqkWDs2X/9NuPjKUmZf4fYnFb/yH30dQhYI4g
	uCbtGF3rMTDbzlTf/tNqBYuCRhyTVkaIbxhGa0fvEnv/yqTmWotF9M+vmBjz4ifJTpG
	96vK7HGYFpvMHtfyubTx7EK9jaYZxUMLlzvBINyF+Za79f3f+v5vsw6mXLcp9BHbil3
	YmeWrQV6U+cbB7z8uIVTUkDaEE1cfDX6x0N1SvKN61Evfw1a2wxoBpR5XPX4wgpljYR
	KGpCFav/EQ==

2025. 01. 01. 23:46 keltezéssel, Florian Westphal írta:
> egyszeregy@freemail.hu <egyszeregy@freemail.hu> wrote:
>>   /* match info */
>> -struct xt_dscp_info {
>> +struct xt_dscp_match_info {
> 
> To add to what Jan already pointed out, such renames
> break UAPI, please don't do this.
> 
> It could be done with compat ifdef'ry but I think its rather ugly,
> better to keep all uapi structure names as-is.

If i keep the original, maybe one of them will be in conflict between "match" 
and "target" structs name if i remember well (they go the same text). By the way 
original structs name are absolutely not following any good clean coding, they 
will be still ugly and they are hard to understand quickly in the code, what 
goes for "target" and what goes fot "match" codes. Why is it bad to step forward 
and accept a breaking change to gets a better clean code?

> 
>>   MODULE_LICENSE("GPL");
>>   MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
>> -MODULE_DESCRIPTION("Xtables: TCP MSS match");
>> +MODULE_DESCRIPTION("Xtables: TCP Maximum Segment Size (MSS) adjustment/match");
>>   MODULE_ALIAS("ipt_tcpmss");
>>   MODULE_ALIAS("ip6t_tcpmss");
>> +MODULE_ALIAS("ipt_TCPMSS");
>> +MODULE_ALIAS("ip6t_TCPMSS");
> 
> I think you should add MODULE_ALIAS("xt_TCPMSS") just in case, same
> for all other merged (== 'removed') module names, to the respective
> match (preserved) modules.

Do you mean in all of xt_*.c source, it can be appended by its own 
MODULE_ALIAS("xt_TCPMSS"), MODULE_ALIAS("xt_RATEEST") ... and so on? Can be kept 
old MODULE_ALIAS() names  or they can be removed?

