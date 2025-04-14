Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21EC21F4CA8
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Apr 2025 21:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744667754; cv=none; b=KXuabCi/+y79BLaiksis6b0K+Hg1dbNljrsCPaQnt/rT7lo78JLq6WmIpSxXWjOS3Y9zSwI1VrgFB5+RGafkF5R7HF1NveJJ6bzse2eAFphFnsg6VfqFb8AZUquUL9YrZACH/fZlWcp6kvVuwyzCzh2yJGdT1OaTRQSj1FTGStY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744667754; c=relaxed/simple;
	bh=MhzLRVXU7VNTOyBlv2LyXLiOhxcf1yQ9O5xRR8m3uj8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U8+ucgJvWPhS3k4NyDBYOBEQu4KeyWpy/cvF4sWPawAcoorA1Z+Hl4NqBYJDvFZ6G60zS0nv6AtkJEp3Pv0bz/iW50Vda+XeTsZZmdINQ4Q8B7ShC7StAi7A0ARn7ngXm4U46/o5jUNO70il8yS+tVPlkPMTU8G7ocEOPX4ZS0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=UCmZ566p; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=O/i2qgIP; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="UCmZ566p";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="O/i2qgIP"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 40D6F61084; Mon, 14 Apr 2025 23:55:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744667749;
	bh=b5LT+ODsGSHJg/ZP1GY9n55Wml7xI+Q5oFC6HugIbbo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UCmZ566pBfBOrDh7sRe8F2kH+bSkN52GmBcFLh6fy3e6sv7WQ1LUzsFvk2miBP0C3
	 yhY37T3QgB+J4P2PwYUAGjKlkbmYjBe86X8vzVf7vret828pafxtO+SQwvvXaFazeI
	 Nu/LpF2LOYVuVAh1xdEpDSnYczxpEVVOynyeLAqs6N/g3cni+JlPhJmMmF5LMM3ngC
	 eYUAhTARDx4+mefDYrU2oKlGQirNR55Ha114WjmwLHlyY4PKVqXmoTz+khgSMxmIfM
	 dSh/SwNA/cP9XL7v/1BRNR6CpBD6G8fhMWPIh2+QfkJ5osog1HkTuTlp+IEtVLf3/P
	 7W1NTyoVsnmJw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9D3EC6107C;
	Mon, 14 Apr 2025 23:55:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744667747;
	bh=b5LT+ODsGSHJg/ZP1GY9n55Wml7xI+Q5oFC6HugIbbo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O/i2qgIPidxv7mMr4BiCPENcMGOgAnbEkgBJWj5u4+p6dfr2gkeMZcrAnS4sJdUqK
	 WETtN0VvCoVSLyM+eCX6BYEKOMwmfhzAYCD//nBpXigCIFzZxbF151pX4f/gOZUjY1
	 ZKpxGvCwucrIp2/R665R6uLAMN7ICcu/6yUMXLwYIKWcyAhRCsBqR86Jovnfh5Qv1n
	 TXckuHS36O5ZaTQCv+J9ejcZSuAX88dCYXMeEfhGW8ggHihsSHXttfsIJ2ys+tkNFW
	 F4xc+wRJ3fGYbUjeTZQNnLRHlLbsPNv2H7siX0+4CtCgUN2ckDWmLrmq/eyVNui0gp
	 Q+8yAQJo9vBcg==
Date: Mon, 14 Apr 2025 23:55:45 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
Cc: coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Simon Horman <horms@kernel.org>
Subject: Re: [PATCH nf] netfilter: nft_quota: make nft_overquota() really
 over the quota
Message-ID: <Z_2EYV1JiDkgf3gm@calendula>
References: <20250410071748.248027-1-dzq.aishenghu0@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250410071748.248027-1-dzq.aishenghu0@gmail.com>

On Thu, Apr 10, 2025 at 07:17:47AM +0000, Zhongqiu Duan wrote:
> Keep consistency with xt_quota and nfacct.

Where is the inconsistency?

> Fixes: 795595f68d6c ("netfilter: nft_quota: dump consumed quota")
> Signed-off-by: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
> ---
>  net/netfilter/nft_quota.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nft_quota.c b/net/netfilter/nft_quota.c
> index 9b2d7463d3d3..0bb43c723061 100644
> --- a/net/netfilter/nft_quota.c
> +++ b/net/netfilter/nft_quota.c
> @@ -21,7 +21,7 @@ struct nft_quota {
>  static inline bool nft_overquota(struct nft_quota *priv,
>  				 const struct sk_buff *skb)
>  {
> -	return atomic64_add_return(skb->len, priv->consumed) >=
> +	return atomic64_add_return(skb->len, priv->consumed) >
>  	       atomic64_read(&priv->quota);

From xt_quota:

        if (priv->quota >= skb->len) {
                priv->quota -= skb->len;
                ret = !ret;
