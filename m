Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFDD745DF63;
	Fri, 21 Aug 2026 09:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787305170; cv=none; b=JXQwkTtyJf4T3598lKEI9I9zGYMjJ+MppZMHy//aqIlrsNhPGoFzxRKrPWTRpU8ByCLeC85FDcI7X3vMFbMDaOTgDk9OqoPH74a/1hqujun4j72eiV6/NUct0JCyMORW+SooQfJfO31W56C16MKbypfwJYIV2hZ0T1zJE35Lzu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787305170; c=relaxed/simple;
	bh=Fe3VXKtdaYDqWDY06EYgX2pTwJu1BP/kWGB0orWUPyM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vkvoh5hRdzVmTvIz+GK7Qbjahc9+xOS3B5aVfZ+8wJosQcggACzeOAyigeqbSRNm3EEdPzxOs9mF4a1CBTPKaYnD+XT4Jv80O0xdkwU50MJMyPQ1H+udSgy+IvP891CABxLnYdVdBbQO37EL0aswT0p3IO1GAtbPOV7CjATKtSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=bkVd/R1d; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="bkVd/R1d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787304774;
	bh=we9FCJiO9fcgT4U49pP6TIQkwzXYMuqpwtrgWTxq+KY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bkVd/R1dtDts3Fko8+Hya7manqWF8DjnbGd2yvVO7sAo5UNyXVzaZPpXv6P+Gqu46
	 4qZPXxxq8+qlS1pBXg57REQmgUYFAu3xksHfjLFivxa+p2IL1HNA3RJ+QggGwGSQuF
	 tXvsyXEDtK1DH58Tyy9+Y14LfYh6tPIfkOUmA+RcNI44psMTi9nSER24rIDp5O2ed/
	 /iXw+Ocj6XXJSkgm+8ZFBIPhmpgAok90e+I7VOdiigVcmJqefC+rFnDsYJQZkPda6V
	 VNhSeHmWXr1hmV8eK2m20NOjhKT+B7pEihCmAQObjq+9bA5ZQXPykUgLEH/kxP2C+c
	 GYZjiYSFLlhuA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id D21C16005B;
	Fri, 21 Aug 2026 11:32:53 +0200 (CEST)
Date: Fri, 21 Aug 2026 11:32:49 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Linkui Xiao <xiaolinkui@126.com>
Cc: fw@strlen.de, phil@nwl.cc, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, Linkui Xiao <xiaolinkui@kylinos.cn>
Subject: Re: [PATCH] netfilter: osf: remove unreachable break in nf_osf_ttl()
Message-ID: <aogbQZyLQonPE-GV@chamomile>
References: <20260821022817.153861-1-xiaolinkui@126.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260821022817.153861-1-xiaolinkui@126.com>

On Fri, Aug 21, 2026 at 10:28:17AM +0800, Linkui Xiao wrote:
> From: Linkui Xiao <xiaolinkui@kylinos.cn>
> 
> In nf_osf_ttl(), the break statement after return in NF_OSF_TTL_TRUE
> case is unreachable dead‑code. The return statement exits the function
> immediately, so break will never execute.
> 
> Remove the useless break, no functional change.

Please, use [PATCH nf-next] to specify this goes to the netfilter tree.

Thanks.

> Signed-off-by: Linkui Xiao <xiaolinkui@kylinos.cn>
> ---
>  net/netfilter/nfnetlink_osf.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
> index 92002079f8ea..a3f855905d52 100644
> --- a/net/netfilter/nfnetlink_osf.c
> +++ b/net/netfilter/nfnetlink_osf.c
> @@ -36,7 +36,6 @@ static inline int nf_osf_ttl(const struct sk_buff *skb,
>  	switch (ttl_check) {
>  	case NF_OSF_TTL_TRUE:
>  		return ip->ttl == f_ttl;
> -		break;
>  	case NF_OSF_TTL_NOCHECK:
>  		return 1;
>  	case NF_OSF_TTL_LESS:
> -- 
> 2.25.1
> 
