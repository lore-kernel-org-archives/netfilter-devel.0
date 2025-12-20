Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF4F27FB2F
	for <netfilter-devel@vger.kernel.org>; Sat, 20 Dec 2025 21:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766265089; cv=none; b=AeAJnuH50m12rrMSm3NWVcjLdIoF2Q8V+j/ShX7EJGE6SZumpdC9/BdY+IIBr56sW+ruWg71sh9uYO/fVNo3HJV6HKYDzMqzAZyLqT9meS1BHV4xOqMLFFN24Hsv+9Rqad32LW1PSBLCzpU5fnTqgHZTz/91UWNModKLfhdaW7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766265089; c=relaxed/simple;
	bh=bdDTfTVsbbh7s1W8Xwg79msIDAIWlcUokWg/IeHU+b8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bKjduqj5+mYs8XHUZCMEPEEuY61VXGXsvivamfJPcCCfvzmomTImbWUDnQ2gAkuPeEWhv8yS6aJatB3RGO7Oh2P/8Yjdn/jcSQHLmeJnsBfS+zr2krbvCfi/TSQzB/SFVtdUIuSBFgf4bOCVwm/ofGIq1+/j/Swg0VLK6MvdIJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=rnFAExBd; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="rnFAExBd"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 09EC460255;
	Sat, 20 Dec 2025 22:11:25 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1766265085;
	bh=ukv8Ptfrjx6eEU4w6E2AM6rgoCFlWf4tLxOdT+Xk2cE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rnFAExBdFreAYGPLRWOHfpy8mf3rptApLL6GNqIhg4IL/IL5eiuraI7fYhJes04ce
	 ZcW/wptgt3J/fhx+LoW3IgS8gJ7pJwS7C9vURTftt3NAiTBVpqlXWe0teRF2lHf56J
	 Jml4fBdxAK7smKZr1kzzFONELxwPDuwZD3yMyIi8yjo1V4Ni/OJ7AS6WWLLaqHZEma
	 D9AhFrn/tHOoURASROjn9q4v+tbJIJ5r/monLs7sdgq29nixMCPry7GdCD6V4oSnLj
	 0YArFnN60qUaHWvN+Ttw2LZhULsx2HTd5RG/4LLGvwc3IW6sOYtZCuU8zfYS3HWQ0H
	 po9dzgfkMHWfA==
Date: Sat, 20 Dec 2025 22:11:22 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Ilia Kashintsev <ilia.kashintsev@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: Global buffer overflow in parse_ip6_mask()
Message-ID: <aUcQ-lW5FWeVH90G@chamomile>
References: <CAF6ebR70NXKv54uEE=kGC2O9tg5K+LoB5gZCm7tKJJaJRGLZcg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAF6ebR70NXKv54uEE=kGC2O9tg5K+LoB5gZCm7tKJJaJRGLZcg@mail.gmail.com>

On Thu, Dec 18, 2025 at 04:15:05PM +0300, Ilia Kashintsev wrote:
[...]
> 2) Build the example:
> 
> clang -g -O0 -fsanitize=address -o reproduction reproduction.c
> libebtc_la-useful_functions.o ./.libs/libebtc.a
> 
> reproduction.c:

Hm, a custom file that uses this static library?
Maybe you describe how to crash this using ebtables userspace tool?
This is not even a shared library system wide available?

More comments below.

> #include <stdio.h>
> #include <unistd.h>
> 
> #include <arpa/inet.h>
> #include <netinet/in.h>
> 
> #if defined(__linux__)
> #  include <netinet/ether.h>
> #else
> #  include <net/ethernet.h>
> #  include <arpa/inet.h>
> #  include <netinet/ether.h>
> #endif
> 
> void ebt_parse_ip6_address(char *address, struct in6_addr *addr,
> struct in6_addr *msk);
> 
> int main(void) {
>     unsigned char buf[256];
>     ssize_t len;
> 
>     len = read(STDIN_FILENO, buf, sizeof(buf));
>     if (len <= 0) {
>         if (len == 0) {
>             return 0;
>         } else {
>             perror("read");
>             return 1;
>         }
>     }
> 
>     if (len < sizeof(buf)) {
>         buf[len] = '\0';
>     } else {
>         buf[sizeof(buf) - 1] = '\0';
>     }
> 
>     struct in6_addr addr = {0};
>     struct in6_addr msk = {0};
> 
>     ebt_parse_ip6_address((char *)buf, &addr, &msk);
> 
>     return 0;
> }
> 
> 
> 3) Launch the example with the provided inputs:
> 
> ./reproduction < input1.txt
> ./reproduction < input2.txt
> 
> To generate input1.txt and input2.txt copy the corresponding text into
> bs64_1.txt and bs64_2.txt and then run:
> 
> base64 -d bs64_1.txt > input1.txt
> base64 -d bs64_2.txt > input2.txt
> 
> bs64_1.txt:
> WTEvLzESES8vMTI4AAAAWQAAAAExEhIfAIAADgBk/wB/8Q4mLwAAAAAAAAEAMTIxDg4=
> 
> bs64_2.txt:
> WWxsN4BvUTYg2GxsLzgADg==

Maybe next time just post a patch to fix this silly bug... this tool
can only be run with root priviledges.

> Suggested fix:
> 
> It is proposed to handle 2 cases separately, keeping current behaviour
> when bits % 8 != 0 and avoiding it when bits % 8 == 0. Nevertheless, i
> can't be sure this fix is totally correct.
> 
> diff --git a/useful_functions.c b/useful_functions.c

As said, post a patch that applies via git-format-patch for review.

Thanks.

> index 133ae2f..a8dfcbc 100644
> --- a/useful_functions.c
> +++ b/useful_functions.c
> @@ -364,8 +364,12 @@ static struct in6_addr *parse_ip6_mask(char *mask)
>         if (bits != 0) {
>                 char *p = (char *)&maskaddr;
>                 memset(p, 0xff, bits / 8);
> -               memset(p + (bits / 8) + 1, 0, (128 - bits) / 8);
> -               p[bits / 8] = 0xff << (8 - (bits & 7));
> +               if (bits & 7) {
> +                       memset(p + (bits / 8) + 1, 0, (128 - bits) / 8);
> +                       p[bits / 8] = 0xff << (8 - (bits & 7));
> +               } else {
> +                       memset(p + (bits / 8), 0, (128 - bits) / 8);
> +               }
>                 return &maskaddr;
>         }
> 
