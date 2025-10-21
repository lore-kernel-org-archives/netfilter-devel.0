Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6445A33B962;
	Tue, 21 Oct 2025 14:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761057297; cv=none; b=SG77Da/0RiQCvBJfVkU+suBvjdWXKSaSKxJBZ3mF0WYQjQbDSXraVZ8rMlUZOHzK0R8oBjLcgnaOp/mUkf0RBw1dx0SIKlYtbszRK8Zq6QQ55nxt1BdPETT3EwFuV4gJlQYb/0rjx9KHEIvdscXVTB/GA+Fr2BKsXDmR9rmX2Bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761057297; c=relaxed/simple;
	bh=7AV0bZ5ky6RQOPDKqcUxBiX3HxO6+fXBr7NNrD6G+bU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ly1qJTQRtCA92SOld/2ivIJaer+i+q+JM1NsG892IbFEiaokBSrHVhLcvYdGKCzcortYUAlJ/e4mrkkk4dO8WYYUpdOLBcuPg5CiuAJMn7Obqw3TWRavjAnfc/Uma0ABGE5HbBOoaPRQlEbmzHGQ7gWWBQz3arAUnb6TB6ipNCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B86DF61117; Tue, 21 Oct 2025 16:34:46 +0200 (CEST)
Date: Tue, 21 Oct 2025 16:34:46 +0200
From: Florian Westphal <fw@strlen.de>
To: Andrii Melnychenko <a.melnychenko@vyos.io>
Cc: pablo@netfilter.org, kadlec@netfilter.org, phil@nwl.cc,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, horms@kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/1] nft_ct: Added nfct_seqadj_ext_add() for NAT'ed
 conntrack.
Message-ID: <aPeZ_4bano8JJigk@strlen.de>
References: <20251021133918.500380-1-a.melnychenko@vyos.io>
 <20251021133918.500380-2-a.melnychenko@vyos.io>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251021133918.500380-2-a.melnychenko@vyos.io>

Andrii Melnychenko <a.melnychenko@vyos.io> wrote:
>  
>  struct nft_ct_helper_obj  {
>  	struct nf_conntrack_helper *helper4;
> @@ -1173,6 +1174,9 @@ static void nft_ct_helper_obj_eval(struct nft_object *obj,
>  	if (help) {
>  		rcu_assign_pointer(help->helper, to_assign);
>  		set_bit(IPS_HELPER_BIT, &ct->status);
> +
> +		if ((ct->status & IPS_NAT_MASK) && !nfct_seqadj(ct))
> +			nfct_seqadj_ext_add(ct);

Any reason why you removed the drop logic of earlier versions?

I think this needs something like this:

	if (!nfct_seqadj_ext_add(ct))
           regs->verdict.code = NF_DROP;

so client will eventually retransmit the connection request.

I can also mangle this locally, let me know.
