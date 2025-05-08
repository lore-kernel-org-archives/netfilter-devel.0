Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58BAF76026;
	Thu,  8 May 2025 11:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746703617; cv=none; b=A2k7FFtQNhf6IC6EHHcYshKMp2O5afqn/bXo4giISoAB3wnU0fkyryUuP6TlN8zHDT1gQN/74rDvfUiVMfAPjwxT3CTAUMrsx7/FKkg/LVf5jHVqM2OF6UHkOX1WzupOBsh1yH6XPPp28PtmzWqNGAEuUxPFrkEqR8Tw0r4M1S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746703617; c=relaxed/simple;
	bh=e2MhZEJpPEbV62HK5hxDqQC1GmZBIbPOwL64HD1Vhdg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UcI7yfUfZcPlPEjUum+FttUHtWeZQb7N/KRsm15FFQjLenzozlxRA35MaCjbv7oCGrAI+8jeM3yF5RNbXzsWikprI4ZX9XhZqUops0rxhKABuA1hKfZ0nZ/y/5VYWhdDZVBFwyEJbYr3pIXtPw8rFu3TZkktUPuqdLKSpv5lhQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Qij8LAZV; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=GZ2VOeFW; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Qij8LAZV";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="GZ2VOeFW"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 680D8602A3; Thu,  8 May 2025 13:26:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1746703612;
	bh=p/TXaYYX6FtVDhGllLhHq42M0ZrH70L0gdr7W/loawM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Qij8LAZVXf7JqQL2yo7i2GHnkg3HamjoCiyMYe6QNlPkupE7e3yda/7PL1yEnan9+
	 jB9xFH31NNSq/Uk/YM7bad6Dbi/PgaXzm6cgueQYk1kHj6skTOlNOzchYd2Ot7aqkO
	 1OpMixRS836JCZzCX8aYaeCjRk9LK+tUpOazhJ3uJYkyiQJdjpl9UOlUfvZ/aK+V/D
	 0nlkxRF5uJy5SQaoNzL16gnPZ6IZCLxSkDLwVxEO5Ee3v1196vx4u74wEHhKatZyHB
	 MLkG/nRY1/yVKVgnMDuuHJXumxo3oRyQyeBQH0F9sZyF1/x/BkOeIb9F3rmZQfO1/i
	 WNTNU+nShc4Nw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4F242602A3;
	Thu,  8 May 2025 13:26:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1746703610;
	bh=p/TXaYYX6FtVDhGllLhHq42M0ZrH70L0gdr7W/loawM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GZ2VOeFW0rSf4z0zMIzXD3049tX5/dsuud0MWZEjwNMurQmASFpoPAy9SjMFH+Hqx
	 U0z+ZTuzMIhTGCmVHFmoncnz+/HM//98L/TqCzOlrrF3DMcCYcNgeq33U3kS8oWHsf
	 YSb5YVPlpv4L9LT+1BdRRnYEZ+UhBI5jQ8EcaVwCHy5r9RpU5SCKx3zkY3U0tOe/W0
	 EMWIaJUKCpiC0Q6sHqGJvXHQ7LZFY+FlQvIRGIdhHDpeuom2Jyy+JSSNHOscd1y9NC
	 2VFIOgNQGWIvyzPfXx97tMHRldQtcBRyjetu0jCH2O/bHS2/7Q6p6yg8sl+Eg9GK76
	 cjJvsW0GJ9q4A==
Date: Thu, 8 May 2025 13:26:48 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Colin Ian King <colin.i.king@gmail.com>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] [NETFILTER]: nf_conntrack_h323: Fix spelling
 mistake "authenticaton" -> "authentication"
Message-ID: <aByU-B19He-Ud7Iz@calendula>
References: <20250227225928.661471-1-colin.i.king@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250227225928.661471-1-colin.i.king@gmail.com>

Hi,

On Thu, Feb 27, 2025 at 10:59:28PM +0000, Colin Ian King wrote:
> There is a spelling mistake in a literal string. Fix it.

I can see ASN1 h225 refers to authenticaton, not authenticaton

> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  net/netfilter/nf_conntrack_h323_types.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_conntrack_h323_types.c b/net/netfilter/nf_conntrack_h323_types.c
> index fb1cb67a5a71..4f6433998418 100644
> --- a/net/netfilter/nf_conntrack_h323_types.c
> +++ b/net/netfilter/nf_conntrack_h323_types.c
> @@ -1108,7 +1108,7 @@ static const struct field_t _SecurityCapabilities[] = {	/* SEQUENCE */
>  	 _NonStandardParameter},
>  	{FNAME("encryption") CHOICE, 2, 3, 3, SKIP | EXT, 0,
>  	 _SecurityServiceMode},
> -	{FNAME("authenticaton") CHOICE, 2, 3, 3, SKIP | EXT, 0,
> +	{FNAME("authentication") CHOICE, 2, 3, 3, SKIP | EXT, 0,
>  	 _SecurityServiceMode},
>  	{FNAME("integrity") CHOICE, 2, 3, 3, SKIP | EXT, 0,
>  	 _SecurityServiceMode},
> -- 
> 2.47.2
> 
