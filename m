Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB83304BB9
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Nov 2025 10:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763634501; cv=none; b=Y/wDuH+28YXqvWBmdrENREkEQN1EeCVhhlPJlWQwtcnFVRBSm59w95Wx1sAEGCj3VqOc/J3RFRLQILRj0ThDkAac71yitClPUPIIwUO66waEuVHvJrbDB7/m+6R5+MIVT8GpKNyg+HuzAjGVPsuHhapPrP9Hf+S+S/6s+CUqpxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763634501; c=relaxed/simple;
	bh=ZvFub69cJP2GoANhTvt4bgZwqAnRurszIUnSJwAeFko=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qAVb4p6e8UcxmilsDCXDwk+YjVn5rp4DQnyWUvrlHm/+zvg1kTFxQzYiL2F4aldn6Hyg2os3lKKDmV2t3EB+B9xr7YczeSNRqPNPSswvFK+2B/nvpHsjjTD1ZlI1ISU4B115TAda8YqH+0sRn5YNI2EB7rNYppsslJzvpEvTHg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id F2722604C4; Thu, 20 Nov 2025 11:28:16 +0100 (CET)
Date: Thu, 20 Nov 2025 11:28:16 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 0/3] netfilter: nft_set_rbtree: use cloned tree
 for insertions and removal
Message-ID: <aR7tQFEkfqotwT36@strlen.de>
References: <20251118111657.12003-1-fw@strlen.de>
 <9a4e63da-6d36-4365-8c08-547961c9bfa7@suse.de>
 <aR29ddgmrjWcayAV@orbyte.nwl.cc>
 <aR3osq6hSxh7JwVm@strlen.de>
 <aR5BT0-HnwPEkBR5@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aR5BT0-HnwPEkBR5@orbyte.nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:

Thanks for doing this but I'm not sold on this.
This also traverses the entire tree, which is afaics not avoidable
and also the expensive part.

I don't get much better results with this version
(10 inserts into 800k tree: mainline: ~3m, patchset, 3m47m, your
version 3m47s).

> +static void nft_rbtree_copy(const struct nft_set *set, struct rb_node *parent,
> +			    struct rb_node **pos, struct nft_rbtree_elem *elem)
> +{
> +	struct nft_rbtree *priv = nft_set_priv(set);
> +	u8 genbit = nft_rbtree_genbit_copy(priv);
> +
> +	rb_link_node_rcu(&elem->node[genbit], parent, pos);
> +	rb_set_parent_color(&elem->node[genbit], parent,
> +			    rb_color(&elem->node[!genbit]));
> +
> +	if (elem->node[!genbit].rb_left)
> +		nft_rbtree_copy(set, &elem->node[genbit],
> +				&elem->node[genbit].rb_left,
> +				rb_entry(elem->node[!genbit].rb_left,
> +					 struct nft_rbtree_elem,
> +					 node[!genbit]));

... and that makes recursive calls, i am reluctant here.

It should be fine given its limited by tree height, but it makes
me uneasy to have this.
