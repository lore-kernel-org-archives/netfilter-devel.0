Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D35E251791
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Feb 2026 13:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770815325; cv=none; b=bLCF2h6HZzLZEPSrKWvlwSkyCFqT7fXuBGzsanL35U73TGuQ9MJpXrwrQOkqJSGNIrtUzYVkwvw7LUGtHvy5XA/JkbsenImFXRDwMAZs2Z+U0w4TxtxufnuPRxhr4ab+18vpZp8Y3W2W+2K0lbRcq5H7/ONlT4mnDHbiHLeuR4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770815325; c=relaxed/simple;
	bh=OdNxs3qOiY3ItzBXB/7vUbUthUU5QbuoKXHuaPHefxw=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aRk6rhksC7utcDA6Iv/pEU/jM+jmPhxS5UORnrlsU21bNB74dl0J9tU1ST6O7gnQYdPzFzPyihKVL2hScRJxBHkDtLw9GO2Gmz4wFEaWu/1Fpscpuy4u3YMG07xCSKnJ3Sj5eBdlKHleHcAHn5Fdbbpeh5Abz2xB8ONYLVbImFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 79050605E7; Wed, 11 Feb 2026 14:08:42 +0100 (CET)
Date: Wed, 11 Feb 2026 14:08:42 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>, Ilia Kashintsev <ilia.kashintsev@gmail.com>,
	netfilter-devel@vger.kernel.org
Subject: Re: Global buffer overflow in parse_ip6_mask()
Message-ID: <aYx_Wupq7R-2ndbc@strlen.de>
References: <CAF6ebR70NXKv54uEE=kGC2O9tg5K+LoB5gZCm7tKJJaJRGLZcg@mail.gmail.com>
 <aUQTNcIKD-7YzYQQ@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUQTNcIKD-7YzYQQ@orbyte.nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> The reason why the second memset() call may mis-behave is the broken
> div-round-up in there: It does (bits / 8) + 1 when it should do
> (bits + 7) / 8 instead. Fixed that, only the p[bits / 8] field access
> needs to remain conditional:
> 
> @@ -364,8 +364,9 @@ static struct in6_addr *parse_ip6_mask(char *mask)
>         if (bits != 0) {
>                 char *p = (char *)&maskaddr;
>                 memset(p, 0xff, bits / 8);
> -               memset(p + (bits / 8) + 1, 0, (128 - bits) / 8);
> -               p[bits / 8] = 0xff << (8 - (bits & 7));
> +               memset(p + (bits + 7) / 8, 0, (128 - bits) / 8);
> +               if (bits & 7)
> +                       p[bits / 8] = 0xff << (8 - (bits & 7));
>                 return &maskaddr;
>         }

Phil, would you mind formally submitting this as fix?
