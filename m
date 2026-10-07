Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1377395AFB;
	Wed,  7 Oct 2026 08:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791361372; cv=none; b=d/Uhg/ZSXHzgzXhAmSMYyHk6kvrO9RWDb+8HnGsQgPjeYHJcxbtk+fFn18Kmv8pGsqtLrZ9hiNX3Lmvn6wyOV3AdyiK0Y8zbOcWxRzJkv5oOl30mvm56uWkTlLbCNb2Sj5YDvbrDQG73v4/Y5RjoUz49JaavZnNcwoSEHyyVI0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791361372; c=relaxed/simple;
	bh=GuxAnzaKWf6UopysBjcBuyhnD9jmzw3VG2fTP9EbGMw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fSB2EzR3vtomszPrvvBZ3X7+1VmNoXl0bxOzxBM4KsjK3R6kXqF6GYQlNcGNKAiXT9ekg3DxMZ6he0Uot+CjiZEBO9wpgFFq7zM2SgC1zC9h9aIyWZxEB32aNN1GixeIwwktIAZ09oqEyuOn9LsXQj8qdkqY2SwmDWXyfhYubx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=owj7EXMQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="owj7EXMQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6614F1F0089C;
	Wed,  7 Oct 2026 08:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791361371;
	bh=j/jb4rIebekOrIhzEx/OGMhErwRV4lZ90xfG88fh870=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=owj7EXMQa8xb665dUarnqo62ayy3j+gTkfP0ovaZZbTb7Gx/aXcfOw6kyaZsechVL
	 f4LVX2ljJAnTLHhOXStqJBp5uknqdblghh02GaoC+NIe0STj/wDRCuht4EA+2E2fKD
	 l4pzR4pOZ7HqhwJEsyGBRvGOqjrG0OhYgJvrYKww0V18AXdcELKFPe8XW/ZIqEVt+B
	 wNEZYgT15FiBrF2tzuENSUTNyeFZNfJf71MnoeWROa4PmKDocxIslCVX/J71jmqFOJ
	 X2TeLy1iiu+Gp8j4agplXKKecJyMe0NDLBW28p+s80oDyG0N9U6SBTBtl+kZBPNsm1
	 Y6qsbK9PvxNsA==
Message-ID: <b6b1c5b1-1004-4415-924b-b349e95d5cfc@kernel.org>
Date: Wed, 7 Oct 2026 10:22:48 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH nft v2] doc: add MPTCP subtypes documentation to man page
Content-Language: fr
To: Fernando Fernandez Mancera <fmancera@suse.de>, netdev@vger.kernel.org
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 pablo@netfilter.org, fw@strlen.de, phil@nwl.cc
References: <20261006204803.11155-1-fmancera@suse.de>
From: Matthieu Baerts <matttbe@kernel.org>
Autocrypt: addr=matttbe@kernel.org; keydata=
 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
 lzVbFe7fduHbABmYz9cefQpO7wDE/Q==
Organization: NGI0 Core
In-Reply-To: <20261006204803.11155-1-fmancera@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Fernando,

On 06/10/2026 22:48, Fernando Fernandez Mancera wrote:
> In addition, document the limitation when there are multiple MPTCP
> options.

Thank you for the v2, it looks good to me!

Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>

> diff --git a/doc/payload-expression.txt b/doc/payload-expression.txt
> index ceccfdaa..53e92905 100644
> --- a/doc/payload-expression.txt
> +++ b/doc/payload-expression.txt

(...)

> @@ -833,6 +859,21 @@ filter input tcp option sack-perm exists counter
>  filter input tcp option maxseg size lt 536
>  --------------------
>  
> +.matching MPTCP suboptions
> +--------------------
> +filter input tcp option mptcp subtype mp-join drop
> +--------------------
> +
> +[NOTE]
> +====================
> +Netfilter currently evaluates only the first MPTCP option found in the TCP
> +header. If a packet contains multiple MPTCP options, a rule attempting to match
> +the second option will never match. Having multiple MPTCP options in the same
> +packet is valid, e.g the Linux MPTCP stack inserts 'remove-addr', 'mp-prio' and

(small nit: I would have added an extra '.' after 'e.g', but I don't
think a v3 is needed to fix that.)

> +'mp-fail' after an MPTCP 'dss' option; 'mp-tcprst' can also be inserted after
> +an 'mp-fastclose'.
> +====================
> +
>  .matching IPv6 exthdr
>  ---------------------
>  ip6 filter input frag more-fragments 1 counter

Cheers,
Matt
-- 
Sponsored by the NGI0 Core fund.

