Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC661FCFC6;
	Fri, 17 Jan 2025 10:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737111001; cv=none; b=huPnPyhaTYd7xJ0yVvLUZy83ieBwklpZSJ3e7SOi5PNTK4yd8BFNBPjymNSUkbVGhvSPlaEBVewBrvGC86aeQtFls7uCXcDCZfHA0xp0s/XXaLPmpVWBm118McJSYVqRuQ+Y0CkScZeyw9xbYasq/LTfk8kJe7Cx/fm/LjlzsP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737111001; c=relaxed/simple;
	bh=CazV5uos1NITCYZZ4rDXeX9a/Bj6TVkhmyDyy7U5K9U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UXr/FSIT7+qlVUT2yDEoHnvHT8lzXSZtIz94UFt++lk9xdsU8hojf4ooKNjYFIIo+zoISJuCirEB46CK1RAbectcXh1VLcf6VSnPIG/LxxEXlhGR4fzYKO3gF82VS1Dk9RTk/WMJPl7n5ZJlAu+EvmoKhL5DzsLUTBu+ONAYbHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ye2Fi7GA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ye2Fi7GA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 861B8C4CEDD;
	Fri, 17 Jan 2025 10:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737111001;
	bh=CazV5uos1NITCYZZ4rDXeX9a/Bj6TVkhmyDyy7U5K9U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ye2Fi7GADN9GV/uxHO8hFSs9WeXmLXw/YylVOdLZ7aXbpN9nJhRIGD6f1WiU/jZ0W
	 ZNnV7pwJV1qQFuFNGbq/B/lz6CnROY/cBDS9nmpMrm1XTTQplm9YrjfDeV2jKKyz4J
	 Rhju3l0i76BSugJBL6JWnv3rdcEHG9yUtZxY91Yhrr8Emw2ZmPL7uC2cgRXHZWuZSA
	 R46I6JvjAwhND+XMUw1JU3MydPhya+D1AXSopTCK+Mxh6jjwPgxVIBzf/ZmYH2X7DD
	 Xg2z7AhiHFexDZjG56X/xdS4wVos1fsyqfBNUWzu59ZkqUJs425yvD2zvPB+6aGbzL
	 xMgc1WDkx/8vA==
Date: Fri, 17 Jan 2025 10:49:57 +0000
From: Simon Horman <horms@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, fw@strlen.de
Subject: Re: [PATCH net-next 01/14] netfilter: nf_tables: fix set size with
 rbtree backend
Message-ID: <20250117104957.GK6206@kernel.org>
References: <20250116171902.1783620-1-pablo@netfilter.org>
 <20250116171902.1783620-2-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250116171902.1783620-2-pablo@netfilter.org>

On Thu, Jan 16, 2025 at 06:18:49PM +0100, Pablo Neira Ayuso wrote:
> The existing rbtree implementation uses singleton elements to represent
> ranges, however, userspace provides a set size according to the number
> of ranges in the set.
> 
> Adjust provided userspace set size to the number of singleton elements
> in the kernel by multiplying the range by two.
> 
> Check if the no-match all-zero element is already in the set, in such
> case release one slot in the set size.
> 
> Fixes: 0ed6389c483d ("netfilter: nf_tables: rename set implementations")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  include/net/netfilter/nf_tables.h |  3 ++
>  net/netfilter/nf_tables_api.c     | 49 +++++++++++++++++++++++++++++--
>  net/netfilter/nft_set_rbtree.c    | 43 +++++++++++++++++++++++++++
>  3 files changed, 93 insertions(+), 2 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
> index 0027beca5cd5..7dcea247f853 100644
> --- a/include/net/netfilter/nf_tables.h
> +++ b/include/net/netfilter/nf_tables.h
> @@ -495,6 +495,9 @@ struct nft_set_ops {
>  					       const struct nft_set *set,
>  					       const struct nft_set_elem *elem,
>  					       unsigned int flags);
> +	u32				(*ksize)(u32 size);
> +	u32				(*usize)(u32 size);
> +	u32				(*adjust_maxsize)(const struct nft_set *set);
>  	void				(*commit)(struct nft_set *set);
>  	void				(*abort)(const struct nft_set *set);
>  	u64				(*privsize)(const struct nlattr * const nla[],

Hi Pablo,

As a follow-up could these new fields be added to
the Kernel doc for nft_set_ops?
