Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F79321F5F
	for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2026 07:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779953270; cv=none; b=CiznwnJI4Dy0UfG9EaIjwvb2lYBDpnXvu8Lx2cy0jA/bWbtT2GkS3RPf1BkiomBM8TNYkwmMqvS8IIY2IfmKs5IhupbpeIZ5ppvObGNs9+YwS3jK2CMO0Amtlsz7n+UO7EpyPMZNgNg5XdrC3l+8GKqo+QsZLaSWwuqkRRdSGTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779953270; c=relaxed/simple;
	bh=YTA+PfyUHN8bpRCudtplWAl3a/qfJKAxYvLWX7VW9OI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bmQN1TQ+6MubXQFl1tObCGDi3y+eVwGxGvnnoAxJNrdC+JBK81Uc4R3w31BZ2fEH1K5LmD+IO+Vri34aXRIOsyUrUNTMo+GW7hTsDTn7XBgMxdBRGb2X06rZ+uA/f63VTI9WmZn8kTupAvwVbKxUBLie+ClDnQe7u94ki4sZg9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lHf/e28m; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lHf/e28m"
Message-ID: <58fc5150-76e7-46e5-a72f-41133c408109@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779953266;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8i8kgteLwN5G6ocfa4DRAqvFUspyLhNHU7pI+VpfeFo=;
	b=lHf/e28m8l6c03My+egMHO5n0JJi+5LC2K2yXOz1dfhcxoW93laWlx+hZdIZxpD59B2Ubn
	q1lIRrvTnYrgahdcLuweSOr9NcdEvONOkyXds0oIN0wBHVv+QDuu7pQrohiYbAycUlwwGm
	uy+vr4MJROyevrRBDlZ+gzoIHb2+hI8=
Date: Thu, 28 May 2026 15:27:21 +0800
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
 <88abc4d7-8316-4c9e-aca0-351fe0ecb2b0@linux.dev> <ahfqfM6xQKZr_xbA@strlen.de>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Jiayuan Chen <jiayuan.chen@linux.dev>
In-Reply-To: <ahfqfM6xQKZr_xbA@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT


On 5/28/26 3:10 PM, Florian Westphal wrote:
> Jiayuan Chen <jiayuan.chen@linux.dev> wrote:
>>> diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
>>> --- a/net/netfilter/nft_ct.c
>>> +++ b/net/netfilter/nft_ct.c
>>> @@ -78,7 +78,7 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
>>>    		break;
>>>    	}
>>> -	if (ct == NULL)
>>> +	if (!ct || nf_ct_is_template(ct))
>>>    		goto err;
>>>    	switch (priv->key) {
>>> diff --git a/net/netfilter/nft_ct_fast.c b/net/netfilter/nft_ct_fast.c
>>> --- a/net/netfilter/nft_ct_fast.c
>>> +++ b/net/netfilter/nft_ct_fast.c
>>> @@ -30,7 +30,7 @@ void nft_ct_get_fast_eval(const struct nft_expr *expr,
>>>    		break;
>>>    	}
>>> -	if (!ct) {
>>> +	if (!ct || nf_ct_is_template(ct)) {
>>>    		regs->verdict.code = NFT_BREAK;
>>>    		return;
>>>    	}
>>>
>> It looks more general and also covers the other GET keys that would equally
>> misbehave on a template.
> Would you mind sending a v2?

No problem, will do.


>>> .... might also make sense to invert
>>> nf_ct_l3num(ct) == NFPROTO_IPV4 ? 4 : 16), i.e.:
>>> nf_ct_l3num(ct) == NFPROTO_IPV6 ? 16 : 4);
>> As defense-in-depth, IIUC?
> Yes, alternatively merge your v1 with the template check. I don't see how
> we can ever have nf_ct_l3num(ct) != nft_pf(pkt) outside of the template
> bug.
I think the template check plus the family check (nf_ct_l3num(ct) != 
nft_pf(pkt)) is enough as defense-in-depth.
