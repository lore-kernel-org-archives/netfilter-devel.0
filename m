Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9053E415B6A
	for <netfilter-devel@vger.kernel.org>; Fri,  9 Oct 2026 10:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791541358; cv=none; b=Boir0L89nHC0AgQF/sogIwgWbcxPXvBEqnCCIv/kqoYZ2ys38FWCqMnZQjMk+apZScKCSVl2S3x1TNJ5QJZLcM7Id+sE4eWFbYiEYTt3FDFzqwsTWv1RV31rWktfPWXNVlqN3vucGDV4p/+XY97KXZdEsiGPzN0y/bPbxW4FIRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791541358; c=relaxed/simple;
	bh=VexQrBDwiveBSOaCruzeIZvKSmvSK+dKY5KxmuIwu30=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YCMEhkjcVuwKvY+oFul+ELN9tAR6qeMb6RbSJKIJ9+GiWdsbDfQXTa7znbmEJ5lxyvNoBl0fwmOXDVK8/E7t24dkTedEpVghG2STK5deEIOJe+H7hnJSzW4hfHWCzfgukubUj28Xr2/P5wxTdXBgk2rCyUo+5gsDbYrnFZ+cVh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GzaFvz42; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GzaFvz42"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 734511F000FF;
	Fri,  9 Oct 2026 10:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791541356;
	bh=qZEEdWky7hoI32w/BNSSaSbCZC+qvKJFxnWe5CLTxLU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GzaFvz42Hwed6qcfEkxk88AbvBPx/A+o+BMMxa/gQx1d4ZTpToLlPLf56xrGBuh6S
	 98WKBAMLof8KxWXCPAh+KsJ5rZQyiZBJfRdsdKP+cKe5iInm0l0KMEs6t355+mtxtD
	 OFsZQWVvd6ZW+n0eZ/bytkSP5fXFYdzMoHFbJiKo74roidCXo6KnJjFgA0rjRbt+QN
	 W3QgLaPlYEVHnOKiqysq19Vddz2/KTjMS9f3G9s3ATGeSAfw5+mtTQSyjZwNedT4do
	 C7gQUNSeN/UcKcQKXRU73nRAouvsvGAvKmrL5j/dZiIpmTcqbPPXbURw9PnP0tI15s
	 mAjvZiB2VIxUw==
Message-ID: <3424732e-6dec-4bb8-8f33-6f4b8a430de0@kernel.org>
Date: Fri, 9 Oct 2026 12:22:32 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH nf-next RFC] netfilter: nft_exthdr: add inner option type
 search for MPTCP
Content-Language: fr
To: Fernando Fernandez Mancera <fmancera@suse.de>,
 netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org, pablo@netfilter.org, fw@strlen.de, phil@nwl.cc
References: <20261008174030.6536-1-fmancera@suse.de>
From: Matthieu Baerts <matttbe@kernel.org>
Autocrypt: addr=matttbe@kernel.org; keydata=
 xsFNBFXj+ekBEADxVr99p2guPcqHFeI/JcFxls6KibzyZD5TQTyfuYlzEp7C7A9swoK5iCvf
 YBNdx5Xl74NLSgx6y/1NiMQGuKeu+2BmtnkiGxBNanfXcnl4L4Lzz+iXBvvbtCbynnnqDDqU
 c7SPFMpMesgpcu1xFt0F6bcxE+0ojRtSCZ5HDElKlHJNYtD1uwY4UYVGWUGCF/+cY1YLmtfb
 WdNb/SFo+Mp0HItfBC12qtDIXYvbfNUGVnA5jXeWMEyYhSNktLnpDL2gBUCsdbkov5VjiOX7
 CRTkX0UgNWRjyFZwThaZADEvAOo12M5uSBk7h07yJ97gqvBtcx45IsJwfUJE4hy8qZqsA62A
 nTRflBvp647IXAiCcwWsEgE5AXKwA3aL6dcpVR17JXJ6nwHHnslVi8WesiqzUI9sbO/hXeXw
 TDSB+YhErbNOxvHqCzZEnGAAFf6ges26fRVyuU119AzO40sjdLV0l6LE7GshddyazWZf0iac
 nEhX9NKxGnuhMu5SXmo2poIQttJuYAvTVUNwQVEx/0yY5xmiuyqvXa+XT7NKJkOZSiAPlNt6
 VffjgOP62S7M9wDShUghN3F7CPOrrRsOHWO/l6I/qJdUMW+MHSFYPfYiFXoLUZyPvNVCYSgs
 3oQaFhHapq1f345XBtfG3fOYp1K2wTXd4ThFraTLl8PHxCn4ywARAQABzSRNYXR0aGlldSBC
 YWVydHMgPG1hdHR0YmVAa2VybmVsLm9yZz7CwZEEEwEIADsCGwMFCwkIBwIGFQoJCAsCBBYC
 AwECHgECF4AWIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZUDpDAIZAQAKCRD2t4JPQmmgcz33
 EACjROM3nj9FGclR5AlyPUbAq/txEX7E0EFQCDtdLPrjBcLAoaYJIQUV8IDCcPjZMJy2ADp7
 /zSwYba2rE2C9vRgjXZJNt21mySvKnnkPbNQGkNRl3TZAinO1Ddq3fp2c/GmYaW1NWFSfOmw
 MvB5CJaN0UK5l0/drnaA6Hxsu62V5UnpvxWgexqDuo0wfpEeP1PEqMNzyiVPvJ8bJxgM8qoC
 cpXLp1Rq/jq7pbUycY8GeYw2j+FVZJHlhL0w0Zm9CFHThHxRAm1tsIPc+oTorx7haXP+nN0J
 iqBXVAxLK2KxrHtMygim50xk2QpUotWYfZpRRv8dMygEPIB3f1Vi5JMwP4M47NZNdpqVkHrm
 jvcNuLfDgf/vqUvuXs2eA2/BkIHcOuAAbsvreX1WX1rTHmx5ud3OhsWQQRVL2rt+0p1DpROI
 3Ob8F78W5rKr4HYvjX2Inpy3WahAm7FzUY184OyfPO/2zadKCqg8n01mWA9PXxs84bFEV2mP
 VzC5j6K8U3RNA6cb9bpE5bzXut6T2gxj6j+7TsgMQFhbyH/tZgpDjWvAiPZHb3sV29t8XaOF
 BwzqiI2AEkiWMySiHwCCMsIH9WUH7r7vpwROko89Tk+InpEbiphPjd7qAkyJ+tNIEWd1+MlX
 ZPtOaFLVHhLQ3PLFLkrU3+Yi3tXqpvLE3gO3LM7BTQRV4/npARAA5+u/Sx1n9anIqcgHpA7l
 5SUCP1e/qF7n5DK8LiM10gYglgY0XHOBi0S7vHppH8hrtpizx+7t5DBdPJgVtR6SilyK0/mp
 9nWHDhc9rwU3KmHYgFFsnX58eEmZxz2qsIY8juFor5r7kpcM5dRR9aB+HjlOOJJgyDxcJTwM
 1ey4L/79P72wuXRhMibN14SX6TZzf+/XIOrM6TsULVJEIv1+NdczQbs6pBTpEK/G2apME7vf
 mjTsZU26Ezn+LDMX16lHTmIJi7Hlh7eifCGGM+g/AlDV6aWKFS+sBbwy+YoS0Zc3Yz8zrdbi
 Kzn3kbKd+99//mysSVsHaekQYyVvO0KD2KPKBs1S/ImrBb6XecqxGy/y/3HWHdngGEY2v2IP
 Qox7mAPznyKyXEfG+0rrVseZSEssKmY01IsgwwbmN9ZcqUKYNhjv67WMX7tNwiVbSrGLZoqf
 Xlgw4aAdnIMQyTW8nE6hH/Iwqay4S2str4HZtWwyWLitk7N+e+vxuK5qto4AxtB7VdimvKUs
 x6kQO5F3YWcC3vCXCgPwyV8133+fIR2L81R1L1q3swaEuh95vWj6iskxeNWSTyFAVKYYVskG
 V+OTtB71P1XCnb6AJCW9cKpC25+zxQqD2Zy0dK3u2RuKErajKBa/YWzuSaKAOkneFxG3LJIv
 Hl7iqPF+JDCjB5sAEQEAAcLBXwQYAQIACQUCVeP56QIbDAAKCRD2t4JPQmmgc5VnD/9YgbCr
 HR1FbMbm7td54UrYvZV/i7m3dIQNXK2e+Cbv5PXf19ce3XluaE+wA8D+vnIW5mbAAiojt3Mb
 6p0WJS3QzbObzHNgAp3zy/L4lXwc6WW5vnpWAzqXFHP8D9PTpqvBALbXqL06smP47JqbyQxj
 Xf7D2rrPeIqbYmVY9da1KzMOVf3gReazYa89zZSdVkMojfWsbq05zwYU+SCWS3NiyF6QghbW
 voxbFwX1i/0xRwJiX9NNbRj1huVKQuS4W7rbWA87TrVQPXUAdkyd7FRYICNW+0gddysIwPoa
 KrLfx3Ba6Rpx0JznbrVOtXlihjl4KV8mtOPjYDY9u+8x412xXnlGl6AC4HLu2F3ECkamY4G6
 UxejX+E6vW6Xe4n7H+rEX5UFgPRdYkS1TA/X3nMen9bouxNsvIJv7C6adZmMHqu/2azX7S7I
 vrxxySzOw9GxjoVTuzWMKWpDGP8n71IFeOot8JuPZtJ8omz+DZel+WCNZMVdVNLPOd5frqOv
 mpz0VhFAlNTjU1Vy0CnuxX3AM51J8dpdNyG0S8rADh6C8AKCDOfUstpq28/6oTaQv7QZdge0
 JY6dglzGKnCi/zsmp2+1w559frz4+IC7j/igvJGX4KDDKUs0mlld8J2u2sBXv7CGxdzQoHaz
 lzVbFe7fduHbABmYz9cefQpO7wDE/Q==
Organization: NGI0 Core
In-Reply-To: <20261008174030.6536-1-fmancera@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Fernando,

On 08/10/2026 19:40, Fernando Fernandez Mancera wrote:
> MPTCP carries each of its suboptions as a separate TCP option of kind
> 30. The suboption type is stored in the upper four bits of the third
> byte of the option. A single packet can therefore carry several kind 30
> options, for example a dss followed by an mp-prio.
> 
> nft_exthdr_tcp_eval() stops at the first option whose kind equals
> NFTA_EXTHDR_TYPE. A rule such as:
> 
>   tcp option mptcp subtype mp-prio drop
> 
> only ever sees the first MPTCP suboption. If that is a dss, the subtype
> comparison fails and the rule never matches, even though an mp-prio is
> present later in the same header.

Thank you for working on this!

> Add NFTA_EXTHDR_INNER_TYPE. When present, the expression keeps walking
> the options of the requested kind until one carries the requested inner
> type.  If the end of the options area is reached without a match, the
> expression behaves as if the option was not found: NFT_BREAK, or 0 when
> NFT_EXTHDR_F_PRESENT is set.
> 
> See the generated bytecodes below:
> 
> - Bytecode for matching mp-join without using NFT_EXTHDR_F_PRESENT flag.
> 
> ip mptcp_exthdr input 3 2
>   [ exthdr load tcpopt 1b @ 30 + 2 inner 1 => reg 1 ]
>   [ bitwise reg 1 = ( reg 1 & 0xf0 ) ^ 0x00 ]
>   [ cmp eq reg 1 0x10 ]
> 
> - Bytecode for matching mp-join using the NFT_EXTHDR_F_PRESENT flag.
> 
> ip mptcp_exthdr input 8 7
>   [ exthdr load tcpopt 1b @ 30 + 0 present inner 1 => reg 1 ]
>   [ cmp eq reg 1 0x01 ]
> 
> Note that while using the present flag is more efficient, if we decide
> to use it in nftables command line tool it would change the behavior
> when using old kernels reverting from false negatives to false
> positives.

Could nft use NFTA_EXTHDR_INNER_TYPE if the kernel supports it, and
fallback to the previous method if not?

Or maybe better to have a new option that will explicitly fail if the
kernel doesn't support it, not to miss packets on older kernel versions?

(...)

> diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
> index 861bab93f435..984b54d2c6dd 100644
> --- a/net/netfilter/nft_exthdr.c
> +++ b/net/netfilter/nft_exthdr.c

(...)

> @@ -207,7 +209,15 @@ static void nft_exthdr_tcp_eval(const struct nft_expr *expr,
>  		if (priv->type != opt[i])
>  			continue;
>  
> -		if (i + optl > tcphdr_len || priv->len + priv->offset > optl)
> +		if (i + optl > tcphdr_len)
> +			goto err;
> +
> +		if (priv->has_inner && priv->type == TCPOPT_MPTCP) {

Why does it need to be limited to MPTCP?

(I understand it is probably easier like that, and that's fine for my
use-case, but I'm just thinking about extensions that could be done only
via the userspace.)

> +			if (!(optl >= 3 && (opt[i + 2] >> 4) == priv->inner_type))

Can you not use priv->offset and priv->len not to have something
specific to MPTCP?

But then, you need to keep the safety check around them before this. And
you probably need to check that the length is <= 8 at parsing time.

(...)

> @@ -679,6 +706,11 @@ static int nft_exthdr_dump_common(struct sk_buff *skb, const struct nft_exthdr *
>  		goto nla_put_failure;
>  	if (nla_put_be32(skb, NFTA_EXTHDR_OP, htonl(priv->op)))
>  		goto nla_put_failure;
> +	if (priv->has_inner) {
> +		if (nla_put_be32(skb, NFTA_EXTHDR_INNER_TYPE,  htonl(priv->inner_type)))

(double spaces before htonl())

Cheers,
Matt
-- 
Sponsored by the NGI0 Core fund.

