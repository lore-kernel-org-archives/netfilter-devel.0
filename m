Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 181531CCEEE;
	Tue, 27 Aug 2024 16:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724777848; cv=none; b=FM2daT5pIQEHtHhbQ7a0nn/8wmU2kJefLH4FFjX9jGIeAboi+LBI59hqq/DHAuGskiTloIRgdxpnsSLcFmDGa0IpgJ70jNYON0gkJth5Ij4HPQjb/U0w//XWuv3RA1lQedTJWanhvOJ3j/s1OXcu9en/aVfzxs97hFLdtDU/F5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724777848; c=relaxed/simple;
	bh=oJyqD4VpJjqosMXWNu7suplXDr6vmBZm5Ry/21c2LBU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=emZXaVD72rF92thlMvpHSoSlVbfiBYe32ACGlSnXS5e8jdzjP04iK3iGfTll7/f9PGte7L4JlhTYuxT9gsDHzNIKinc39wlZ+IsMjHGywK2LNQjmmM1dnoY31ifWq34wluKf0C97asHeBNcRwE0hL1z76T0UIHXNwFc2DZo+4Eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p1UJBBJ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p1UJBBJ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43572C4AF13;
	Tue, 27 Aug 2024 16:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724777847;
	bh=oJyqD4VpJjqosMXWNu7suplXDr6vmBZm5Ry/21c2LBU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p1UJBBJ1mKHOdQHBhmDJ4EQ027Jc7U6bl7ykT0Ei8+Fd1S9knKc4mKlsYdVFe0jA2
	 67MI2BNnbQfbVUch9cnSWXGd4uW5gqyz5kKkJVX/fLwNO/RULoGULCRZZXMc9pfx51
	 XRTLZQteAJYn2GX+qJ66xMsjf2S/zpfF8eCTKAJTV1BBFlT8X+IASKNCJWrq7CMG/H
	 DhkHoQwyqZwF5i3GWgu6HldMAs6tP5VemMeGV1Z8xKESko/5bwTUtLy7hk60RHGTOh
	 9rtCuQA2XHfkk8AGLu0RNXJ6d3pTlHa5IdFhtBJ1pHd6ulrim6ioH3KcgotwnkjuOl
	 OXVK1KhDDMepQ==
Date: Tue, 27 Aug 2024 17:57:23 +0100
From: Simon Horman <horms@kernel.org>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, jmaloy@redhat.com,
	ying.xue@windriver.com, pablo@netfilter.org, kadlec@netfilter.org,
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next 2/5] net/tipc: make use of the helper macro
 LIST_HEAD()
Message-ID: <20240827165723.GQ1368797@kernel.org>
References: <20240827100407.3914090-1-lihongbo22@huawei.com>
 <20240827100407.3914090-3-lihongbo22@huawei.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240827100407.3914090-3-lihongbo22@huawei.com>

On Tue, Aug 27, 2024 at 06:04:04PM +0800, Hongbo Li wrote:
> list_head can be initialized automatically with LIST_HEAD()
> instead of calling INIT_LIST_HEAD(). Here we can simplify
> the code.
> 
> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> ---
>  net/tipc/socket.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/net/tipc/socket.c b/net/tipc/socket.c
> index 1a0cd06f0eae..9d30e362392c 100644
> --- a/net/tipc/socket.c
> +++ b/net/tipc/socket.c
> @@ -1009,12 +1009,11 @@ static int tipc_send_group_anycast(struct socket *sock, struct msghdr *m,
>  	struct tipc_member *mbr = NULL;
>  	struct net *net = sock_net(sk);
>  	u32 node, port, exclude;
> -	struct list_head dsts;
>  	int lookups = 0;
>  	int dstcnt, rc;
>  	bool cong;
> +	LIST_HEAD(dsts);

nit: Please place this new line where the old dsts line was,
     in order to preserve, within the context of this hunk,
     reverse xmas tree order - longest line to shortest -
     for local variable declarations.

>  
> -	INIT_LIST_HEAD(&dsts);
>  	ua->sa.type = msg_nametype(hdr);
>  	ua->scope = msg_lookup_scope(hdr);
>  
> @@ -1161,10 +1160,9 @@ static int tipc_send_group_mcast(struct socket *sock, struct msghdr *m,
>  	struct tipc_group *grp = tsk->group;
>  	struct tipc_msg *hdr = &tsk->phdr;
>  	struct net *net = sock_net(sk);
> -	struct list_head dsts;
>  	u32 dstcnt, exclude;
> +	LIST_HEAD(dsts);
>  
> -	INIT_LIST_HEAD(&dsts);
>  	ua->sa.type = msg_nametype(hdr);
>  	ua->scope = msg_lookup_scope(hdr);
>  	exclude = tipc_group_exclude(grp);

-- 
pw-bot: cr
