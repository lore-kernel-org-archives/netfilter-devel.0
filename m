Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86232446857;
	Mon,  5 Oct 2026 23:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791241544; cv=none; b=pRMuc9m6zk+YYbvMSYJn6xUqEKp2oZOQEZsQva9IBg5XIFvjit4WRecvIZaCvyCdKHpY8FVdueAQKpxXHGWL2hGsN5rw02gwnbO050JrcFjJ+VjWxsSLeRNbxN4sOmYSBaemt39hHdZ2qpwTEc4NFM+kDGaA6aCEunkQhhX9iFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791241544; c=relaxed/simple;
	bh=LXlPLXZ616GpRTYLWPN6QbfAdOSQGfoV+w7HBJmol5g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I657/loFIaQfx3UhEpS3R7vjlSsgE2mWPPDvxk3Fznk6O1PxK3aiDkFcwwMIPFGROkSMCPWkVBQ+yvgP4O2+yANsm7aSI79hf601Yl7WoHOQl5rf5oFYQfG5sz6Zh5MJHNgrpLsiMW50Sb8wq51wrXfq1vVDvXlqNg5iVYNL2ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=O0WG+DDS; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="O0WG+DDS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1791241536;
	bh=c99KASve6Ees45vUEP4qfb1SchJPRipEWmwIvCrBhYo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O0WG+DDS1ZcrqM/HOs5kqAGYM3cmZsr+E1MK0535kpVbYQjE6HR3/lr1TOpTBNXri
	 anFPAeemjcgo7+/jWX1Wqe664D/pGGlxJ2qPSlG0/trXdPraCRWzRhK9ymEzZvWcIU
	 awTH7lH7eYqudzjEwBmuQl/4TLrqXydDl7vQqEaeJDOekp3u/DEe/wG50G5TDRYEB0
	 xee83E+aB47bmwu7+QaN1XG43bRT4giq+g41PQP4TOLMb1qlaALnLzhdY8M9hx5OxL
	 WnzL1N8OwAgw+1hzu3Ko9kTc6Z5GQH2JlK0ymxsDr87O+Eyrv/2xzvCe78hE4EoQKW
	 vUCp8OLVLY23Q==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 6666060058;
	Tue,  6 Oct 2026 01:05:36 +0200 (CEST)
Date: Tue, 6 Oct 2026 01:05:33 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: =?utf-8?B?SsOpcsOpbXk=?= Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nft_set_rbtree: reject expired interval
 ends
Message-ID: <asQtPfgYhK1uxMpR@chamomile>
References: <20261005200404.3544062-2-Jeremy.Jean@oss.cyber.gouv.fr>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="qEnWkv4Thx0oRRZb"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261005200404.3544062-2-Jeremy.Jean@oss.cyber.gouv.fr>


--qEnWkv4Thx0oRRZb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi,

On Mon, Oct 05, 2026 at 08:04:05PM +0000, Jérémy Jean wrote:
> Consider two ranges in a netfilter verdict map:
> * keys 10-19 accept packets, and
> * keys 30-39 jump to chain 'victim'.
> Now, delete the end marker at 20. The lookup array now uses element 30
> as the first range's end, so an INTERVAL_END query for key 15 returns
> element 30, including its jump verdict and chain pointer. This can make
> KASAN reports a UAF after the GC releases reference chain for 30 that
> has expired:
> 
>   BUG: KASAN: slab-use-after-free in nft_verdict_dump+0xdd/0x110
>   Read of size 8 at addr ff110000009dfb58 by task repro/50
>   ...
>   Call Trace:
>   ...
>    nft_verdict_dump+0xdd/0x110
>    nft_data_dump+0x4d/0x80
>    nf_tables_fill_setelem+0x30b/0x8a0
>    ? __asan_memcpy+0x3c/0x60
>    nf_tables_fill_setelem_info+0x1b0/0x200
>    nft_get_set_elem+0x3fd/0x4b0
>   ...
>   Freed by task 24:
>   ...
>    kfree+0x1a5/0x280
>    nf_tables_trans_destroy_work+0x2cb/0x520
> 
> Reject expired endpoints in nft_rbtree_get() before returning them.
> 
> Fixes: 2aa34191f06f ("netfilter: nft_set_rbtree: use binary search array in get command")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
> ---
>  net/netfilter/nft_set_rbtree.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
> index 9894832..1fd9cbe 100644
> --- a/net/netfilter/nft_set_rbtree.c
> +++ b/net/netfilter/nft_set_rbtree.c
> @@ -187,6 +187,8 @@ nft_rbtree_get(const struct net *net, const struct nft_set *set,
>  	if (flags & NFT_SET_ELEM_INTERVAL_END) {
>  		if (!interval->to)
>  			return NULL;
> +		if (nft_set_elem_expired(interval->to))
> +			return ERR_PTR(-ENOENT);
>  
>  		rbe = container_of(interval->to, struct nft_rbtree_elem, ext);
>  	} else {
> -- 
> 2.47.3


Can you test this fix instead? Thanks

--qEnWkv4Thx0oRRZb
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="tentative-fix.patch"

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 12431b55752f..fbe1750f1ca2 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -1091,7 +1091,8 @@ static void nft_rbtree_commit(struct nft_set *set)
 		 * representation. Use next start element to complete this
 		 * interval.
 		 */
-		if (nft_rbtree_interval_start(rbe) &&
+		if (nft_set_is_anonymous(set) &&
+		    nft_rbtree_interval_start(rbe) &&
 		    nft_rbtree_interval_start(prev_rbe) &&
 		    priv->array_next->intervals[num_intervals].from)
 			priv->array_next->intervals[num_intervals++].to = &prev_rbe->ext;

--qEnWkv4Thx0oRRZb--
