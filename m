Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022231E0DB8;
	Tue,  3 Dec 2024 10:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733220516; cv=none; b=QkptNFVEhaspdiZGNp7L77SsKe7M6EUvRPgVBj8g6RsW0aF0/B/2wPr/mAIQwN2QImNMf7iGny4rDT7gFc98bharkuWNg/2+iWaEnho033YV52FVOu0EacbcfKLvViO0xMRs8KtPAELlRal2twBEsSJMyA7mP3/vAzMPscic8vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733220516; c=relaxed/simple;
	bh=biskAuw/9n5z2nWODeQ36N+1jPZ/rMIU0+Wyd29MGnE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fX4rWN9+8UGxF8jZUjZVUjK1+/9v4Y0mCSFyQD+7z34Pc/rdefE+EtFAWTjNaG7l/TvNHBqDzWzeHSU6pxRbvMo6t02vgljI6TCam8oPFBbeIasJ2pf+Z9nqwDWD3CwkkWwNadR/ja0td5DZ68O50FGDhcrSxrpKTuepz202084=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ml5auETw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ml5auETw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B80FC4CECF;
	Tue,  3 Dec 2024 10:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733220515;
	bh=biskAuw/9n5z2nWODeQ36N+1jPZ/rMIU0+Wyd29MGnE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ml5auETwLlj73XKAOZEmN1cc+QJbmB3q2KmYEjQMPpwZihWB8tmGb6ugNq5DIRbD8
	 XJIkWqluCLqhFl+jQcf8+VqWlF/SOuLz3yPrJiAAeX/qYCEFJm/pe0JetobbsyMhIV
	 8HN+QYpPwyom7tiN3OzKptUCVVPkFsCwTjhBJpcK2WcFzcEDWECxjbcVtBuFEV3p/T
	 0K8VTcUeH6Vw6UtA60XkqNY/gw/xgAf3ZnH9JcJpfpUzOwLPFgRB+EUq9Eir1NQWcL
	 rlc1sAuGT+oQ2XFi6m/gq84UIcjqbULoEtyLw5xasgf2DrgQRI1WmdnzVq0QbBzKG6
	 b+SDy3pomSlAQ==
Date: Tue, 3 Dec 2024 10:08:31 +0000
From: Simon Horman <horms@kernel.org>
To: jiang.kun2@zte.com.cn
Cc: pablo@netfilter.org, kadlec@netfilter.org, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	tu.qiang35@zte.com.cn, xu.xin16@zte.com.cn
Subject: Re: [PATCH linux-next] netfilter: nf_tables: remove the genmask
 parameter
Message-ID: <20241203100831.GC9361@kernel.org>
References: <20241125202634242hoMPn5q_ViCvJA9BygRYX@zte.com.cn>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241125202634242hoMPn5q_ViCvJA9BygRYX@zte.com.cn>

On Mon, Nov 25, 2024 at 08:26:34PM +0800, jiang.kun2@zte.com.cn wrote:
> From: tuqiang <tu.qiang35@zte.com.cn>
> 
> The genmask parameter is not used within the nf_tables_addchain function
>  body. It should be removed to simplify the function parameter list.
> 
> Signed-off-by: tuqiang <tu.qiang35@zte.com.cn>
> Signed-off-by: Jiang Kun <jiang.kun2@zte.com.cn>
> Cc: xu xin <xu.xin16@zte.com.cn>
> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Simon Horman <horms@kernel.org>
> ---
>  net/netfilter/nf_tables_api.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)

Reviewed-by: Simon Horman <horms@kernel.org>

