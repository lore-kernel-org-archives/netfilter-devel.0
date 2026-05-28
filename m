Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C603254A2
	for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2026 08:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779956734; cv=none; b=QDIpAvylLuJC3JaVg4bCIkVEGO9e0rX90fGqsGEH0ilLBFT8QqNYBQt1JFOyhTX0OgFRCEvuFX+MULICmOWpLVtPVNLB+0EnWLxrAjiOcCyX9WKg6db+sQzd475xnzqUCvGkTvh7dEUlSAzgHqH/XEvTv20n+wACCefoJFnrVEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779956734; c=relaxed/simple;
	bh=jYNTKaNFFK6rnDeSmd20xilMQ46weKCf0mvH1wvKd+w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TtuXZ+CrkGHN5DkThKQwDcTu2JvYEp9Xfudbr5sd7mV9TTHKmh+zuSPxf2KQJrhF4t0eJzcfoPE3dRd3x4VOYc5Gx6emSKehzxuSrhr+xMqQPKhgi9uJnAD4UDiab+N+0ym8cc+sm+tjFYWY+MzhdMQBy2e1PFclvQ1CVlyv/qA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=r0MdfKHP; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="r0MdfKHP"
Message-ID: <c1383a3a-6c76-411a-8ae3-1dfe90052fb7@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779956731;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jYNTKaNFFK6rnDeSmd20xilMQ46weKCf0mvH1wvKd+w=;
	b=r0MdfKHP4K0Vy294XBONpBIc6owWDscTc41uz9ss9sFP8MCQ2DWy2ZiMJrJFKAKDCW/RTL
	289iaS4Vl3uAIjT50ekmfPWTRL2PNcG9gRSzndhNPpUhd5osrWg8zdwNBnRKEpGIFxu5XU
	kmdpKH4Q6/JgEaCPZD645ho5B+3SyJk=
Date: Thu, 28 May 2026 16:25:09 +0800
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
 <58fc5150-76e7-46e5-a72f-41133c408109@linux.dev> <ahf2XAmRnsjK0krp@strlen.de>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Jiayuan Chen <jiayuan.chen@linux.dev>
In-Reply-To: <ahf2XAmRnsjK0krp@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


On 5/28/26 4:01 PM, Florian Westphal wrote:
> Jiayuan Chen <jiayuan.chen@linux.dev> wrote:
>>>>> nf_ct_l3num(ct) == NFPROTO_IPV6 ? 16 : 4);
>>>> As defense-in-depth, IIUC?
>>> Yes, alternatively merge your v1 with the template check. I don't see how
>>> we can ever have nf_ct_l3num(ct) != nft_pf(pkt) outside of the template
>>> bug.
>> I think the template check plus the family check (nf_ct_l3num(ct) !=
>> nft_pf(pkt)) is enough as defense-in-depth.
> Actually, I think we need to fix this to copy priv->len unconditionally.
> Or, alternatively, add a memcpy wrapper that zero-pads the remainder of
> the registers.
>
> https://sashiko.dev/#/patchset/20260528042620.263828-1-jiayuan.chen%40linux.dev
>
> "This is a pre-existing issue, but does copying only addr_len bytes when
> priv->len is larger leave the remainder of the register uninitialized?
> In nft_do_chain(), the register array is allocated on the kernel stack
> without zero-initialization. If priv->len is 16 and addr_len is 4, only
> the first 4 bytes are written."


I just spotted that too.  I think copying priv->len unconditionally
is enough -- tuple->{src,dst} is zeroed in nf_ct_get_tuple() before the
protocol pkt_to_tuple callback fills in only the relevant leading bytes,
so the trailing bytes of tuple->{src,dst}.u3.all are well-defined zeros
and no wrapper is needed.

