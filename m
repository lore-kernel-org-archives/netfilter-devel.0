Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62F01925BC
	for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2026 07:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779951749; cv=none; b=p4eDbIqszNaBwQbhxkhzNhz/7xHKv8QwUfrP1VuoQe9Nq2ghNEuPStfdEcQ+4h3jfXZE3W5lGcBHEHJcSmJIPX2qGKxj8pbtWremFSvrzCXhMayBWQkZ/XCwYNBEAtjiTUad9xcVBxBlWwd6Rsou4Tzz26f4QQfpF5eUgEKPUoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779951749; c=relaxed/simple;
	bh=oJqM5GSS4yIpg0wBAQfifQRMcapIV/1F+wHNFOR8iVg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G7SeWcVm3I6Um5lgHYknsS/aIW6NwLWwu9I0tlYKLWRUexkCxT+4PvuMtbgFNDtG6xn3FKvGTUcPDk0kDHReLK+XNQCD/Uz2KQGvZen5+zAvMaVCkr5hSXjhNRyiBxjnu8uT7UkHTNbG1ke70aLQDvwZ4twkT/GUGhuWfC1MFno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=q+VJGmO/; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="q+VJGmO/"
Message-ID: <88abc4d7-8316-4c9e-aca0-351fe0ecb2b0@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779951745;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GweloEz9Ibvj3R90PUaQuBgN4mZz0lCO7vpz5l6CWjM=;
	b=q+VJGmO/eXMqCRrj6qwdj6zLp1Go2P8qBItir6mLQ47M9aFr0M1F37GBL5hdRsiAvZyt/R
	VNZ9OvAi5ilWewZytxUyzvGGl6cHQ939E2dfoMBeGeUVjB1cxW27YFj7TjA3DkurL3cBQi
	qvLH4/+c7oQ+PU/NQEsaYstVopjERrQ=
Date: Thu, 28 May 2026 15:02:14 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH nf] netfilter: nft_ct: fix OOB in NFT_CT_SRC/DST eval
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
References: <20260528042620.263828-1-jiayuan.chen@linux.dev>
 <ahfQGCNs8hl6FlHL@strlen.de> <ahfV6K6KrG0akLUZ@strlen.de>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Jiayuan Chen <jiayuan.chen@linux.dev>
In-Reply-To: <ahfV6K6KrG0akLUZ@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


On 5/28/26 1:43 PM, Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
>>> which makes nf_ct_l3num(ct) be 0
>> How?

Yes, it's the template ct path.  The triggering rule is e.g.:

   table ip t {
       chain pre {
           type filter hook prerouting priority raw;
           ct zone set 1
           ct original saddr 1.2.3.4 accept
       }
   }


> Wild guess:
>
> diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
> --- a/net/netfilter/nft_ct.c
> +++ b/net/netfilter/nft_ct.c
> @@ -78,7 +78,7 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
>   		break;
>   	}
>   
> -	if (ct == NULL)
> +	if (!ct || nf_ct_is_template(ct))
>   		goto err;
>   
>   	switch (priv->key) {
> diff --git a/net/netfilter/nft_ct_fast.c b/net/netfilter/nft_ct_fast.c
> --- a/net/netfilter/nft_ct_fast.c
> +++ b/net/netfilter/nft_ct_fast.c
> @@ -30,7 +30,7 @@ void nft_ct_get_fast_eval(const struct nft_expr *expr,
>   		break;
>   	}
>   
> -	if (!ct) {
> +	if (!ct || nf_ct_is_template(ct)) {
>   		regs->verdict.code = NFT_BREAK;
>   		return;
>   	}
>

It looks more general and also covers the other GET keys that would 
equally misbehave on a template.

> .... might also make sense to invert
> nf_ct_l3num(ct) == NFPROTO_IPV4 ? 4 : 16), i.e.:
> nf_ct_l3num(ct) == NFPROTO_IPV6 ? 16 : 4);


As defense-in-depth, IIUC?

