Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D038312FB18;
	Wed,  1 May 2024 16:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714579254; cv=none; b=CMgukwlYpXSrm+K6uc+eL9VPfRqndEYnQIVbpVhFS7IhDby141g7JIK63MjaZ7shNd6aH9koXdSKwcjBjM8mit3vNQO/Ixw2/86inMEyr2R/KTKFXYRsgF9ucv+f4A6n6DBZzrxs8mv8ahO5X9+XVWoWPheHdAr/PhtpCq43RLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714579254; c=relaxed/simple;
	bh=0/Hb3brEn7WHSxXa5tAZ97I1JJQR8J0huGCMX9i1tjs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RWWR2azcS+2UMozp2g1QymDH06tuCq7+i+Y9xDevlGPQkdsY/OYmAmbR09FuFtmRFLc90H2xk1FxNUNuuAWGOl6RFb5CgCe/ODvfCjCFYuODkVmoVOhVV6uRhXFs9EI4k8jmkl9S+WqeFJoTzTgogL6SS5Y5kdfLYsSRkLHGYjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ujdUVK4U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ujdUVK4U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EEF6C4AF14;
	Wed,  1 May 2024 16:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714579254;
	bh=0/Hb3brEn7WHSxXa5tAZ97I1JJQR8J0huGCMX9i1tjs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ujdUVK4UEVS2bC0L/z7fyasmgGA1p+htXjXiaMt1SupHqxv4MrJyAlK2BURcqVwHu
	 5etQz+VltrjMqe1tktfM0gvFZ8SiXz6/ao+t9vuhkfdMzwhUYu5fBqZlJiq7mkShcj
	 F5TqXox/1YKTdtnqo2Qfl/ZnTdX8YGDgVsOv7wchz3mh4ECGmq/tUZswJFxB43lSeP
	 /VoZzkzGo4xgKpz02lY+8oZj48uH928k9dzaTI8MZS/H+FJpjeWSXMIb6yic8jDN/j
	 P2PefTP8xFKmRBraJz3ZsgpzNj/mnkgi4r/CKbcSWg2dKardayV69vrsW2o3yKyqek
	 p4nEb+7FaPvnA==
Date: Wed, 1 May 2024 16:59:20 +0100
From: Simon Horman <horms@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org
Subject: Re: [PATCH net-next] selftests: netfilter: nft_concat_range.sh:
 reduce debug kernel run time
Message-ID: <20240501155920.GV2575892@kernel.org>
References: <20240430145810.23447-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240430145810.23447-1-fw@strlen.de>

On Tue, Apr 30, 2024 at 04:58:07PM +0200, Florian Westphal wrote:

...

> diff --git a/tools/testing/selftests/net/netfilter/nft_concat_range.sh b/tools/testing/selftests/net/netfilter/nft_concat_range.sh

...

> @@ -1584,10 +1594,16 @@ for name in ${TESTS}; do
>  			continue
>  		fi
>  
> -		printf "  %-60s  " "${display}"
> +		[ "$KSFT_MACHINE_SLOW" = "yes" ] && count=1
> +
> +		printf "  %-32s  " "${display}"
> +		tthen=$(date +%s)
>  		eval test_"${name}"
>  		ret=$?
>  
> +		tnow=$(date +%s)
> +		printf "%5ds%-30s" $((tnow-tthen))
> + 

Hi Florian,

A minor nit: the format string above expects two variables, but only one
is passed.

Flagged by Shellcheck.


>  		if [ $ret -eq 0 ]; then
>  			printf "[ OK ]\n"
>  			info_flush

...
