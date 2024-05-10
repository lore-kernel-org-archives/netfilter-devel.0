Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF2087F
	for <netfilter-devel@vger.kernel.org>; Fri, 10 May 2024 00:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715301614; cv=none; b=dDOkGwVWIn7Z6VBrXZyOSm4CHOXk/HmKWy0tIe/SMj/KTkd181+QLwNDoCX/CF0NDW+I+UEBRW/xAWQTlzKAsg/4c+MyQlQBK2YOIjhvdHdEycHYiD+e/EwL1FM1YPR4/7hWxv8SNgHY/cUajCCYuIbcTuEKffWQk/XzgpCTIF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715301614; c=relaxed/simple;
	bh=AWRqPVVb4LVeoGLSw9OC4JtGIa/ezrc4C7g4K49n4K8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qyPKZWztgwHnBOiBQFTmCjhBThNCrosK4ZOkDhiArdl9Y3Er4qzvdP+uV/aiMdFSy8mev/IoHTyriiHzeITJV/Pol+5Mq7b1U4EoqaO8Jfv38Bl6W8pIifxLD7Pu2er2kOGLeh2T3Cyb16tcT8670qVEBuKVDaoDcDC38TZY7Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Fri, 10 May 2024 02:40:08 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, sbrivio@redhat.com
Subject: Re: [PATCH nf-next v2 7/8] netfilter: nft_set_pipapo: move cloning
 of match info to insert/removal path
Message-ID: <Zj1s6HcwpUsHKkrK@calendula>
References: <20240425120651.16326-1-fw@strlen.de>
 <20240425120651.16326-8-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240425120651.16326-8-fw@strlen.de>

Hi Florian,

I have iterated several times over this batch, but I came up with one
late question today, see below.

On Thu, Apr 25, 2024 at 02:06:46PM +0200, Florian Westphal wrote:
> This set type keeps two copies of the sets' content,
>    priv->match (live version, used to match from packet path)
>    priv->clone (work-in-progress version of the 'future' priv->match).
> 
> All additions and removals are done on priv->clone.  When transaction
> completes, priv->clone becomes priv->match and a new clone is allocated
> for use by next transaction.
> 
> Problem is that the cloning requires GFP_KERNEL allocations but we
> cannot fail at either commit or abort time.
> 
> This patch defers the clone until we get an insertion or removal
> request.  This allows us to handle OOM situations correctly.
> 
> This also allows to remove ->dirty in a followup change:
> 
> If ->clone exists, ->dirty is always true
> If ->clone is NULL, ->dirty is always false, no elements were added
> or removed (except catchall elements which are external to the specific
> set backend).
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
> ---
>  net/netfilter/nft_set_pipapo.c | 73 ++++++++++++++++++++++++----------
>  1 file changed, 52 insertions(+), 21 deletions(-)
> 
> diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
> index 9c8da9a0861d..2b1c91e56ca1 100644
> --- a/net/netfilter/nft_set_pipapo.c
> +++ b/net/netfilter/nft_set_pipapo.c
> @@ -615,6 +615,9 @@ nft_pipapo_get(const struct net *net, const struct nft_set *set,
>  	struct nft_pipapo_match *m = priv->clone;
>  	struct nft_pipapo_elem *e;
>  
> +	if (!m)
> +		m = rcu_dereference(priv->match);

nft_pipapo_get() is called from rcu path via _GET netlink command.
Is it safe to walk over priv->clone? Userspace could be updating
(with mutex held) while a request to get an element can be done.

That makes me think nft_pipapo_get() should always use priv->match?

Thanks, and apologies for the late review.
