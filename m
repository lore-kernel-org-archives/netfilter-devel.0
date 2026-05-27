Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5582ECE93
	for <netfilter-devel@vger.kernel.org>; Wed, 27 May 2026 05:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779859122; cv=none; b=X6neSLb1qMg0A3tQCzzzzqWG9EhhmkmxSunwKuNpDVeiHBKFLzaK3/nTo8/tsnvke4/GL8yv1F4p4HQb1uO8KwL+0EwYMJJLaJ6EUVNLzkGlk9gPLbPyHvjnZWoPlYcJVb0zjMPftUiRYPupC8k6IjZUms4d0mwIHiioyB0WJhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779859122; c=relaxed/simple;
	bh=EE128L4x+GiWNRqjZDLWSo0Sxj6tA+dNNUTfm6Riv9w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AemXhT7Jx32LAVZDahLkZHeNU07vqQaac72xvKcKyPIBGdCAkL7T83BJNY4Vetipk9fbLB7uy8pn3iXuvJ2fTs4QR9MsDbTxJYreRScfjvLAds82o7TZy0rII7tTuTmkRl/eVQN6c6/Q86VMTzXIw9GR8JJASlrAKJvHAaq+MDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KIgLqbI8; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KIgLqbI8"
Message-ID: <796e346d-1975-47cd-b4f9-d7b67c3f010c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779859119;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CbPWbT5yFCiTVdfSfkj6ZEGRAfHI88VYZKVbC/07yQ8=;
	b=KIgLqbI8aAU2dxP3ppPu00tnL1bk/4YpXZuChIj2lXBhESG0LlM3Vvd0if3j9fmsq1EMGG
	x0K2sKTCu6rAogY9T8zPStOTyzDYeG9ls6Svwa6Szp66UJQILgOnxPULDiFz4ZKS2zISqm
	SKWFdylfF5a8dLRfxXRBuijSTtpYVjE=
Date: Wed, 27 May 2026 13:18:32 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH nf] netfilter: nft_fib_ipv6: bail out of sibling walk if
 rt got unlinked
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
References: <20260526020227.4857-1-jiayuan.chen@linux.dev>
 <ahWrbTAdNIjo02D-@strlen.de>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Jiayuan Chen <jiayuan.chen@linux.dev>
In-Reply-To: <ahWrbTAdNIjo02D-@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT


On 5/26/26 10:17 PM, Florian Westphal wrote:
>> diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
>> index c0a0075e2590..2dbe44715df3 100644
>> --- a/net/ipv6/netfilter/nft_fib_ipv6.c
>> +++ b/net/ipv6/netfilter/nft_fib_ipv6.c
>> @@ -191,6 +191,9 @@ static bool nft_fib6_info_nh_uses_dev(struct fib6_info *rt,
>>   
>>   		if (nft_fib6_info_nh_dev_match(nh_dev, dev))
>>   			return true;
>> +
>> +		if (!READ_ONCE(rt->fib6_nsiblings))
>> +			return false;
>>   	}
> This time sashiko points to same bug pattern in rt6_fill_node:
>
> This is a pre-existing issue, but does rt6_fill_node() also need this
> detach check to prevent the same infinite loop?
>
> https://sashiko.dev/#/patchset/20260526020227.4857-1-jiayuan.chen%40linux.dev
>
> (No need to resend this patch, but maybe you have cycles to fix the
>   other spot too)



Hi Florian,

Thanks for the heads-up. After auditing the rest of net/ipv6/route.c
I noticed fib6_select_path() seems to have the same pattern as well
(walks &first->fib6_siblings under RCU with no inside-loop bail-out).

I'll send fixes for both spots directly against net.

Thanks,
Jiayuan

