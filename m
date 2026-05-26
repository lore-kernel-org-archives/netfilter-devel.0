Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4372FFDCB
	for <netfilter-devel@vger.kernel.org>; Tue, 26 May 2026 01:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779760092; cv=none; b=h/5iaMDZIDI93NhWnIsH99KgyCj6XVe4vFPO+nXljIAWTsgladsDuYpF+HyHVmLNRhSt1bd9TMYtnzie5RNJZXZJKDAn4aNAhkeYrYRQV7kGX1kzc3FkptDnOTKu4X30iWkP5fO2KkFTTwCCbSSfZnCQXW8/5hgvv4z6Y7+OGQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779760092; c=relaxed/simple;
	bh=HcYKLE3hjt+fLrz0JfinWbn2Y26q5xV28+OqVCF9h1s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XraI7M+BepB1eOrB7a2m/EM7A6wGHepZ25DXCDUWMxAeFYawF7w3hAiPQ/HCha7jx2YBmIVtX2CLe9iFyzDF+1O35b1p9ekHak68npyECWthZo6GNSf0LTgSIZoMkGzKml7bjwMqhapRKlwdFR1A1wj8b5FtE+l5qt3m+T6K2xQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=klTDo1+z; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="klTDo1+z"
Message-ID: <2c1c63e0-bcba-41e0-bd15-d0fcb1924838@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779760087;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nxeX/Rryqa+3CrMFdLnffW2rEf8PSvP10FtGzY3Yw3M=;
	b=klTDo1+zJvGL0N9FQmljcHBeNKNz42UEthBiESSk95oHbwSE4dVEA7i+SGBr+AvBDj6aBs
	wtIglgaI9fcfW1cfGzmXMFi29obEfUue8KvQMbi3J7qmGMONdQqEXOvUKz00dTN+ifeDgS
	ddSBAeZkttlViBFImoWpMpPBBlYnhig=
Date: Tue, 26 May 2026 09:47:55 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: Followup needed for netfilter: nft_fib_ipv6: walk fib6_siblings
 under RCU?
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
References: <ahSMn9GB65ztRN2e@strlen.de>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Jiayuan Chen <jiayuan.chen@linux.dev>
In-Reply-To: <ahSMn9GB65ztRN2e@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT


On 5/26/26 1:53 AM, Florian Westphal wrote:
> Hello,
>
> Sashiko claims we need this change:
>
> diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
> --- a/net/ipv6/netfilter/nft_fib_ipv6.c
> +++ b/net/ipv6/netfilter/nft_fib_ipv6.c
> @@ -191,6 +191,9 @@ static bool nft_fib6_info_nh_uses_dev(struct fib6_info *rt,
>   
>                  if (nft_fib6_info_nh_dev_match(nh_dev, dev))
>                          return true;
> +
> +               if (!READ_ONCE(rt->fib6_nsiblings))
> +                       return false;
>          }
>   
>          return false;
>
>
> Could ypu please check and send a followup if its correct?
> AFAICS the nodes can be relinked to a*different* list and
> then this turns into busyloop without the extra test.
>
> https://sashiko.dev/#/patchset/20260520023411.391233-1-jiayuan.chen%40linux.dev
>
> Thank you.


Hi,

Thanks, you're right. net/ipv6/route.c already uses the same
pattern, and Eric applied similar fixes:

f8d8ce1b515a ("ipv6: fix possible infinite loop in fib6_info_uses_dev()")
54e6fe9dd3b0 ("ipv6: prevent infinite loop in rt6_nlmsg_size()")

I'll send a follow-up patch.

Thanks,
Jiayuan

