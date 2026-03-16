Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2764B34DCCC;
	Mon, 16 Mar 2026 08:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773648880; cv=none; b=R6uifiXiLHKtekGvGFZHlgopOJ3rI64uioDzTcaLsOo1hjwDQdYn9uz1/8wPu5hy1Vbl5h/9hTcXOMiGDXjzZrCFhefjyE29gZBN2rDgpjekavyF28mS2+XVznrzblsPRvKiAmKRvzvy0i1bFrTKY7s3aRDQ3O1/JKrO9IOyhyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773648880; c=relaxed/simple;
	bh=b2j34XojWvxpTyiKlIsQIbjuS132RtdM75MXanwM9Jg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QWa92uK4pRXTeI7vFt6qAWy7ZiIaFFNDY+vm8z+OnjIsFZCB9Tm/pcNl2JEbCIpLEYE9OPnWXVbzpXfp49UByKcsRt4ITs8GNfc+r0wduobH2L+7J/nojnyS5KP3WBJ5SQFNQwh4XuYES888iKCbOjn7rLFL/w0ACqxPuGaDK4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uPUhZkxi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uPUhZkxi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A3FC19421;
	Mon, 16 Mar 2026 08:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773648879;
	bh=b2j34XojWvxpTyiKlIsQIbjuS132RtdM75MXanwM9Jg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uPUhZkxim25wWZXzpgbSheIErlUFekp/qR6UUT+slOHt30dzJ02wLS6A0zLY0L35I
	 zdvD7s9jjev7+waAnavON1Ue4EktLPew7msSGk249SkKXGomKpxuGwXuMcR4R/NAF2
	 Gpws6P0u5Xji6mO0x5prCS+S5S1sIVFt4hMeYf5w7kFJRK7p7gUCanvt8AaaFDwDAs
	 GaiX8kbWZiMCgp92oTcuJKrU5N3pll2+c2AJiLBAD+xQgvrki8GjtXLlX2EdzPGqPz
	 wQmBWVco/TW+eB0vSxDyMITwJFKXvJjTn0kBgWVjkO5LpQWCQHYSy3a85rminZ9Mmx
	 u5knf9ffVS4bw==
Message-ID: <e45a039e-3b91-466f-b89c-c1fdc3a8b2b4@kernel.org>
Date: Mon, 16 Mar 2026 09:14:34 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH net 04/11] netfilter: revert nft_set_rbtree: validate open
 interval overlap: manual merge
To: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
Cc: Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 netfilter-devel@vger.kernel.org, pablo@netfilter.org,
 linux-next@vger.kernel.org, Mark Brown <broonie@kernel.org>
References: <20260313150614.21177-1-fw@strlen.de>
 <20260313150614.21177-5-fw@strlen.de>
From: Matthieu Baerts <matttbe@kernel.org>
Content-Language: fr
Autocrypt: addr=matttbe@kernel.org; keydata=
 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
 lzVbFe7fduHbABmYz9cefQpO7wDE/Q==
Organization: NGI0 Core
In-Reply-To: <20260313150614.21177-5-fw@strlen.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Florian,

(+cc linux-next)

On 13/03/2026 16:06, Florian Westphal wrote:
> This reverts commit 648946966a08 ("netfilter: nft_set_rbtree: validate
> open interval overlap").
> 
> There have been reports of nft failing to laod valid rulesets after this
> patch was merged into -stable.
> 
> I can reproduce several such problem with recent nft versions, including
> nft 1.1.6 which is widely shipped by distributions.
> 
> We currently have little choice here.
> This commit can be resurrected at some point once the nftables fix that
> triggers the false overlap positive has appeared in common distros
> (see e83e32c8d1cd ("mnl: restore create element command with large batches" in
>  nftables.git).

FYI, we got a small conflict when merging 'net' in 'net-next' in the
MPTCP tree due to this patch applied in 'net':

  598adea720b9 ("netfilter: revert nft_set_rbtree: validate open interval overlap")

and this one from 'net-next':

  3aea466a4399 ("netfilter: nft_set_rbtree: don't disable bh when acquiring tree lock")

(...)

> diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
> index ee3d4f5b9ff7..fe8bd497d74a 100644
> --- a/net/netfilter/nft_set_rbtree.c
> +++ b/net/netfilter/nft_set_rbtree.c

(...)

> @@ -685,12 +640,8 @@ static int nft_rbtree_insert(const struct net *net, const struct nft_set *set,
>  		cond_resched();
>  
>  		write_lock_bh(&priv->lock);
> -		err = __nft_rbtree_insert(net, set, rbe, elem_priv, tstamp, last);
> +		err = __nft_rbtree_insert(net, set, rbe, elem_priv, tstamp);
>  		write_unlock_bh(&priv->lock);

The conflict was in the context: the patch in "net-next" stop disabling
bh, modifying the two write_(un)lock_bh() calls, while here the code
executed with the lock and just after is modified.

Rerere cache is available in [1]. The patch is attached below.

Cheers,
Matt

1: https://github.com/multipath-tcp/mptcp-upstream-rr-cache/commit/a0ec8d0

-------------------- 8< --------------------
diff --cc net/netfilter/nft_set_rbtree.c
index e42905376654,fe8bd497d74a..b7501b2b873e
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@@ -684,13 -639,9 +639,9 @@@ static int nft_rbtree_insert(const stru
  
  		cond_resched();
  
 -		write_lock_bh(&priv->lock);
 +		write_lock(&priv->lock);
- 		err = __nft_rbtree_insert(net, set, rbe, elem_priv, tstamp, last);
+ 		err = __nft_rbtree_insert(net, set, rbe, elem_priv, tstamp);
 -		write_unlock_bh(&priv->lock);
 +		write_unlock(&priv->lock);
- 
- 		if (nft_rbtree_interval_end(rbe))
- 			priv->start_rbe_cookie = 0;
- 
  	} while (err == -EAGAIN);
  
  	return err;
-------------------- 8< --------------------

-- 
Sponsored by the NGI0 Core fund.

