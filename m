Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C583B27FE
	for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2026 10:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779964033; cv=none; b=kpaxL+ASYnW9uefYpnOy21ErueZtbSaGcOHY5MOtd0IAaZglhZyiiQRuXYXVii7XSmBeilAayG5IoTE0m4xwCGQRHcloEJ2AZ/Nv+ADni4bUE41h8poLla4CGa9Ecr7ncsC5m4YvTPjisCCLTudZzgwgIu7Rx9j3IdDWKhIhwhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779964033; c=relaxed/simple;
	bh=6gyckp/Yq7alFvbBfF5eSvDYse6meMoHJZb6RvOCw/o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j4Kj6FZokqJHHt5RDYSJP1eCXxn7LbkjuzcsLLMkRLeEadEoX7fvnCSTwK7L7HkX2SkcWUuG0IwJYxW58SRPtrSQ2p2rfn9E0JxybI3rHIknGo13PYbVCg0LXM8Bjv2EmIVHeG+EYFfINDOziY/E3VmdCtUA/HdFw/tLElSQg+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=H9WNLuHs; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="H9WNLuHs"
Message-ID: <013ca7c3-7291-4191-998f-7b675a7e7e77@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779964027;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7K6/gasPkREiQYS6ehQF/oau2lXpXat9nc+U46AcBTc=;
	b=H9WNLuHsD+TilY82+JQ395kzQRCUi6fRh4DAoHWuZA7oe+iLwu5H2l6x9x9ReW2LEJcay+
	/IaibpWRw3DGrIXvM6yoSRowE2tllJGD0KaZmskTXZjwpcJmTSEO8tREQup2vV0OtHkrau
	b8OogYcnsKvMh0VfJeFMCw1OsPqAY04=
Date: Thu, 28 May 2026 18:26:45 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH nf] netfilter: nft_ct: fix OOB in NFT_CT_SRC/DST eval
To: Florian Westphal <fw@strlen.de>, Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
References: <20260528042620.263828-1-jiayuan.chen@linux.dev>
 <ahfQGCNs8hl6FlHL@strlen.de> <ahfV6K6KrG0akLUZ@strlen.de>
 <88abc4d7-8316-4c9e-aca0-351fe0ecb2b0@linux.dev> <ahfqfM6xQKZr_xbA@strlen.de>
 <58fc5150-76e7-46e5-a72f-41133c408109@linux.dev> <ahf2XAmRnsjK0krp@strlen.de>
 <c1383a3a-6c76-411a-8ae3-1dfe90052fb7@linux.dev> <ahgLdDKloq01r7lK@strlen.de>
 <ahgS9K_8Q9AHhQ0K@chamomile> <ahgXzrLZx8J5NbVx@strlen.de>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Jiayuan Chen <jiayuan.chen@linux.dev>
In-Reply-To: <ahgXzrLZx8J5NbVx@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT


On 5/28/26 6:24 PM, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> On Thu, May 28, 2026 at 11:31:32AM +0200, Florian Westphal wrote:
>>> Jiayuan Chen <jiayuan.chen@linux.dev> wrote:
>>>   type filter hook output priority -300; policy accept;
>>>   ct zone set 1
>>>   ct original saddr 0.0.0.0 counter accept
>>> }
>>>
>>> Then: ping -c 1 127.0.0.1
>>>
>>> should the rule match the template or not?
>> I don't think so, no matching on the template conntrack.
> Great, I will make a test case for nftables.
> Jiayuan, would you send a v2  that fixes the OOB+register leak
> and restricts template matching?
>
> Thanks!

Sure. I will send V2 since everything is clear.

