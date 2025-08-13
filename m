Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AAB835959;
	Wed, 13 Aug 2025 14:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755094811; cv=none; b=uZInzPOq4R3ahR37hvRFcdaZYtfzhIWGsKxO7nZihs5merRh0MQ++DGi4M9QcCrnM7fD7LGE+K4lyq3750x2p5PD+7q6l+yswV3ipIxm6zEbnhG/9DvLsquN3/VUFe4ou65t2YCqtUrP4ckSD6yrFUUUqvAP6EOLHXyupL6hSsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755094811; c=relaxed/simple;
	bh=Bj74TrIW+856jOK8G8uA9CvCCtJEp2XspJ6ZD/sgPvc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JAzWsmZoC6rXPWzztHEbXXhG+pQbX7nL4mW4Jp7S9KRxLyQaTz+dB5YmxlZlIAuDHGGLgr8fE2lauLUUEh9yKQs8FXQbZlsjt5nZ/E7qb2Z3f93mgXoblV0F2UPKN4dbym83RV873/uj0cWZUB75q0nZPd7ZbN6OL4fTYRF/CfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gB1eYKf6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gB1eYKf6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D58DC4CEEB;
	Wed, 13 Aug 2025 14:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755094810;
	bh=Bj74TrIW+856jOK8G8uA9CvCCtJEp2XspJ6ZD/sgPvc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gB1eYKf6CCouEX8OaBb6lmAPpW+FR4kzdgLKTzlV8nDU4bCLntSxyzxY5KfM+vRG1
	 ILaj39gXwjibv37VjI4cAWx1AQb4tACP3y1tfrOZb4nBKVicXg3bsCLHAIx9MuUPFc
	 hWNtpqVml16eLwj+gkN/HU9vqgsXvaEF/Wvu2J7A=
Date: Wed, 13 Aug 2025 16:20:07 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Stanislav Fomichev <sdf@fomichev.me>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, ayush.sawal@chelsio.com,
	andrew+netdev@lunn.ch, horms@kernel.org, dsahern@kernel.org,
	pablo@netfilter.org, kadlec@netfilter.org,
	steffen.klassert@secunet.com, mhal@rbox.co,
	abhishektamboli9@gmail.com, linux-kernel@vger.kernel.org,
	linux-staging@lists.linux.dev, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, herbert@gondor.apana.org.au
Subject: Re: [PATCH net-next 5/7] staging: octeon: Convert to skb_dst_drop
Message-ID: <2025081301-thirsty-battalion-8b01@gregkh>
References: <20250812155245.507012-1-sdf@fomichev.me>
 <20250812155245.507012-6-sdf@fomichev.me>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250812155245.507012-6-sdf@fomichev.me>

On Tue, Aug 12, 2025 at 08:52:43AM -0700, Stanislav Fomichev wrote:
> Instead of doing dst_release and skb_dst_set, do skb_dst_drop which
> should do the right thing.
> 
> Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
> ---
>  drivers/staging/octeon/ethernet-tx.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/octeon/ethernet-tx.c b/drivers/staging/octeon/ethernet-tx.c
> index 261f8dbdc382..0ba240e634a1 100644
> --- a/drivers/staging/octeon/ethernet-tx.c
> +++ b/drivers/staging/octeon/ethernet-tx.c
> @@ -346,8 +346,7 @@ netdev_tx_t cvm_oct_xmit(struct sk_buff *skb, struct net_device *dev)
>  	 * The skbuff will be reused without ever being freed. We must
>  	 * cleanup a bunch of core things.
>  	 */
> -	dst_release(skb_dst(skb));
> -	skb_dst_set(skb, NULL);
> +	skb_dst_drop(skb);
>  	skb_ext_reset(skb);
>  	nf_reset_ct(skb);
>  	skb_reset_redirect(skb);
> -- 
> 2.50.1
> 
> 

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
