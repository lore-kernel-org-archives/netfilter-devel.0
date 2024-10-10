Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C560A1C9EA6;
	Thu, 10 Oct 2024 13:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728568115; cv=none; b=SNyzig7bwrqpLdM5ZjWM4HAuTQQTRYBtWWGDTUk7rmIv1GfrvMoqM4HuI3yGiHA2mG/eSdPhhELaBjn4KkNbX+6B9k3q4NbmytLyf7w7EjkN0TRZ0OBGmBEc+P8vPqNQgoIuvCR8fEJyC3bOfgp6RJKgy1c596++SjeF/1Xjbyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728568115; c=relaxed/simple;
	bh=B+SRA3wGamZN+Jkbv4ADv2rNdpKnl2uX8ctXhrniUVc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EwTjXc1mCHPYxnkKfot2R5Jk4BsxTu3gsm8gwLE64FSVsQgmUp0vSBZoPwng/jVxgFVl6iTXllKAVjysm9Ud6UnBJGID579KH0Q09DWNDVCpKYtwo5EuxUyD4sjCfGr6cQlBTabrAWyYjlsbWtSxSFQXI8XlpIWgUdH44Huri5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sytWl-0000zX-5H; Thu, 10 Oct 2024 15:48:27 +0200
Date: Thu, 10 Oct 2024 15:48:27 +0200
From: Florian Westphal <fw@strlen.de>
To: Richard Weinberger <richard@sigma-star.at>
Cc: Richard Weinberger <richard@nod.at>, upstream@sigma-star.at,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
	davem@davemloft.net, kadlec@netfilter.org, pablo@netfilter.org,
	rgb@redhat.com, paul@paul-moore.com, upstream+net@sigma-star.at,
	Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] netfilter: Record uid and gid in xt_AUDIT
Message-ID: <20241010134827.GC30424@breakpoint.cc>
References: <20241009203218.26329-1-richard@nod.at>
 <20241009213345.GC3714@breakpoint.cc>
 <3048359.FXINqZMJnI@somecomputer>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3048359.FXINqZMJnI@somecomputer>
User-Agent: Mutt/1.10.1 (2018-07-13)

Richard Weinberger <richard@sigma-star.at> wrote:
> Am Mittwoch, 9. Oktober 2024, 23:33:45 CEST schrieb Florian Westphal:
> > There is no need to follow ->file backpointer anymore, see
> > 6acc5c2910689fc6ee181bf63085c5efff6a42bd and
> > 86741ec25462e4c8cdce6df2f41ead05568c7d5e,
> > "net: core: Add a UID field to struct sock.".
> 
> Oh, neat!
>  
> > I think we could streamline all the existing paths that fetch uid
> > from sock->file to not do that and use sock_net_uid() instead as well.
>  
> Also xt_owner?

sk->sk_uid is already used e.g. for fib lookups so I think it makes
sense to be consistent, so, yes, xt_owner, nfqueue, nft_meta.c, all can
be converted.
