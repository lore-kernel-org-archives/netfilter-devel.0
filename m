Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ABA62FCBF0;
	Wed, 11 Feb 2026 03:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770782163; cv=none; b=c2zg6JZn4pQkzcNZ4l9Ei6VJAW8BwBo8j+Xh5OUzOMuj/zDiKyWEGMvDHrMtpcAhikvXOHuryPEnoIG6ol8yvew506350GAHd53wj2kLOD7b/EViIX88GVfpTZUK5Vo0m8sVF/2gqLmVmdf0/EXBdtqDoVCMn47doE4yNf9QaGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770782163; c=relaxed/simple;
	bh=V0HQ8jM4urK3kh0UIR+xuD+hZmcFkHmmUz561pGmwNU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ouVH1+iShNVDe/C2c622OeXHifizhEkrhZ1Qdc/EN07ZW4drt/48q3BLChasOk6DbS98vrTed94Kuc3jheqPMGDUOU3ttVXOU9BMUu1p2RdwPr5jTjCQRnQXuMR26GUWZuU0VFOb/tkiNGHgRd3DKTsV3SZZIfSvlmGmhw99caY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mjB1oht4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mjB1oht4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4811C16AAE;
	Wed, 11 Feb 2026 03:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770782163;
	bh=V0HQ8jM4urK3kh0UIR+xuD+hZmcFkHmmUz561pGmwNU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=mjB1oht4khR2Swi3y9rG7du9PIwN5qDlBYmg+mHaLWCtY+BDvA8pOohSTgG3SadBe
	 TmvurEjLOsOX7UOAnPX2VmgCYqm7/EnV1JqDaP0UI17A72QQ61xwhz6HnFx8bO/585
	 tRgzJ54sziDuucGCKzBhniTg2otKdvsXd0u912cEW5ytGfQdP6+WKvjJnwtnsWs/lB
	 B6fKdkVmRjFhhzjiD1OQv7jzaSrU79SsSduhh6H/CS+Y+5q1Oc4QRVL99KxqZHZuna
	 GgE/yiPEER+4+c03C2obiaYl5luqHtnsJbyIxSsYipjtWu9P09cBJfX+eq4++Ug6/o
	 laMOAj9aoayJA==
Date: Tue, 10 Feb 2026 19:56:01 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: [PATCH v2 net-next 11/11] netfilter: nft_set_rbtree: validate
 open interval overlap
Message-ID: <20260210195601.16c54ce7@kernel.org>
In-Reply-To: <aYtO3gzm0nRSR91a@strlen.de>
References: <20260206153048.17570-1-fw@strlen.de>
	<20260206153048.17570-12-fw@strlen.de>
	<4d02b8fc-ac17-4fd7-a9dd-bff35c3719e4@redhat.com>
	<aYtO3gzm0nRSR91a@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 10 Feb 2026 16:29:40 +0100 Florian Westphal wrote:
> Paolo Abeni <pabeni@redhat.com> wrote:
> > On 2/6/26 4:30 PM, Florian Westphal wrote:  
> > > @@ -515,6 +553,12 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
> > >  	    nft_rbtree_interval_end(rbe_ge) && nft_rbtree_interval_end(new))
> > >  		return -ENOTEMPTY;
> > >  
> > > +	/* - start element overlaps an open interval but end element is new:
> > > +	 *   partial overlap, reported as -ENOEMPTY.  
> > 
> > AI noticed a typo above, should be: -ENOTEMPTY.
> > 
> > Given the timeline, a repost will land into the next cycle. I guess it's
> > better to merge this as-is and eventually follow-up later.  
> 
> Thanks.  Comments are for humans not machines so I think its fine.
> 
> That said, I will try to set up some form of AI code review here for
> future MRs.

FWIW if you have a patchwork where patches are queued and a tree on
kernel.org against which you test -- I can hook up our AI bot to your
patchwork instance.
