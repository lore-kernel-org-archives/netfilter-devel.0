Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794567913;
	b=v4Ki7xHwCZeO0OKmZhQrxvrPKTDZJ5hDgjyLJ0lt4g4RonVS0f22a9OwFG/rqV5VirUi
	 hgqbNsu+wrUkIo+BcEIoUmDjp7PsrdhJARqJ4qDbz4jfDgY9Ss/eOFQ6ybajszUCp1Tze
	 vvAPCFXDcBahTt1qEcP2+6aAHafLQlqW4YeYg7gXbco/V4/FT6B2285x91jyLRt9Q/xTx
	 SAVxoEcHJQ19CFqFPdoGJv/7BvLvoRVuHwkW4DGP2OHTv+p/8NK6Z6yEr/libflFh/Jbz
	 H/8pXJMH2H7DYaqut4GPYbAABpJMtePedhG7G1qK1tWJmXvLPxMeJsAEIcOv3gBgfmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794567913;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=drqOGeCwG8bpqjI7Lmtgp303O9Fg7qLukmjnQwyfszk=;
	b=E03BsWU9s4RIQ/jsc09SV7oSQ0yg9hvwLVM6wHVPNH2NSc+1n2180GaFx7g/ZAimS5dh
	 H7o9Xb1qTJ/+NKzfLoldW9CDsQKSYZ/j6Qn9aNUGV73Oo8fD4GkosD6cZlMHSB5BYvAb3
	 rNHl8rlp/VgmJ4WULkcBNi8ndpq+K++9yNo2NYtFk1r8aH3nJUHZJN85pL2QdlmscXN+A
	 jgVibM0rL8wb95du9nBnYDo3Mm/MaKRCyeTeiKkjdYSdGZL0LWkzSmUap/wP6VpSCPoNc
	 +IGVmjiBshkBB3IKVgpw8rXOt2+KdMx04qxd+2WfHg+1CR2DMlt8Dz3BdhS4Nl0j/KA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b="fC3W/tiY";
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 1BAB6606A8A2
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Nov 2026 11:05:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1BAB6606A8A2
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=fC3W/tiY
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794567910;
	bh=drqOGeCwG8bpqjI7Lmtgp303O9Fg7qLukmjnQwyfszk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fC3W/tiY52NFj0V7DjhkJ+yyp4IAEb23UYQspTcPq0/ss9jO7gwLmG08S7rGpVSfE
	 BSqgwn+OrbnAc1u9h2+j4mBwNpf37N8TFrrzOJ7pAjzlI7ZMZ2ycz5GBG9uaVu5bIS
	 2414vWuzZfsIWhRTaQ5qxTuK2uCvkujz5P/SzPYSrji3ieOfX0feyo/XHhBlic9d/U
	 SXAUClEi6X/IE7VhLEhcOAZele0lkuZZ8OG4iWhiSH1cp6AFLoGP02L5CyEUH7HFLB
	 tPj6a1eakEvIMTeJrkvorbFh8g/iNGRSjhdhtsD/3ZftPNKwLJcSIOkyv44zMkkmUa
	 c0RgMWsqWvmEw==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id A8FB960056;
	Fri, 13 Nov 2026 12:05:10 +0100 (CET)
Date: Fri, 13 Nov 2026 12:05:08 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Stosse <florian.stosse@harvester.fr>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libmnl 5/5] callback: avoid signed overflow on INT_MIN
 error code
Message-ID: <avbu5GRDDig6xAZj@chamomile>
References: <20261106191841.1645-1-florian.stosse@harvester.fr>
 <20261106191841.1645-6-florian.stosse@harvester.fr>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261106191841.1645-6-florian.stosse@harvester.fr>

On Fri, Nov 06, 2026 at 08:18:40PM +0100, Florian Stosse wrote:
> mnl_cb_error() negates the error field of an NLMSG_ERROR message to get
> a positive errno. For INT_MIN the negation overflows, which is undefined
> behaviour. No errno has that value, so report the message as malformed
> with EBADMSG instead.
> 
> Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>
> Signed-off-by: Florian Stosse <florian.stosse@harvester.fr>
> ---
>  src/callback.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/src/callback.c b/src/callback.c
> index 703ae80..660c90a 100644
> --- a/src/callback.c
> +++ b/src/callback.c
> @@ -8,6 +8,7 @@
>   */
>  
>  #include <errno.h>
> +#include <limits.h>
>  #include <libmnl/libmnl.h>
>  #include "internal.h"
>  
> @@ -25,7 +26,9 @@ static int mnl_cb_error(const struct nlmsghdr *nlh, void *data)
>  		return MNL_CB_ERROR;
>  	}
>  	/* Netlink subsystems returns the errno value with different signess */
> -	if (err->error < 0)
> +	if (err->error == INT_MIN)
> +		errno = EBADMSG;

This is most likely processing an errno from the kernel.

IIRC, this is for historical reasons, I remember there was a very old
bug in netlink.

Probably this branch can just go away? 

> +	else if (err->error < 0)
>  		errno = -err->error;
>  	else
>  		errno = err->error;
> -- 
> 2.56.0.windows.4
> 
