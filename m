Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DFC1376A03;
	Wed,  1 Jul 2026 05:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782882291; cv=none; b=EZKP1687CJzjA9eiw/lVUwW8Z0AyIOqA2PAm7SHglTbIVv13eC4psO6P5LY2d6hWn3ALZuBDRmGn1NsiwyXYvc+/kI0J17p5nxj9dtEAL4vw0mG9YKbId3/yJpAerNzT7P82fxswnI2Za7m6QQYrjU/q+GsGkRJQdsEeE9MrszU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782882291; c=relaxed/simple;
	bh=3/bcfk5R6s6mYvlAKkoTCNkE7xr7VCgPLci3LmO7QZI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i7WXJrzBKRUZWc7kX7YMLtCSq3Z4Sxstc4WUH5g3kRaCow2zKzRD2QadtZ3CX7kgpu3anMtlts6pTKy7YCbzNAhTXGLv3tlsqN/93c03G6v0NaKpXgXcyKsFgnC3U6tu7fRwP1cEzdvxsZuNBy7+5T5DsbZD/71ETu2bsSAYCjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id DBEA56038C; Wed, 01 Jul 2026 07:04:47 +0200 (CEST)
Date: Wed, 1 Jul 2026 07:04:47 +0200
From: Florian Westphal <fw@strlen.de>
To: netdev@vger.kernel.org
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org
Subject: Re: [PATCH net 5/9] netfilter: nfnetlink_cthelper: cap to maximum
 number of expectation per master
Message-ID: <akSf7y4cm8S485nh@strlen.de>
References: <20260630045243.2657-1-fw@strlen.de>
 <20260630045243.2657-6-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260630045243.2657-6-fw@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> If userspace helper policy updates sets maximum number of expectation to
> zero, cap it to NF_CT_EXPECT_MAX_CNT (255) on updates too.
> 
> Fixes: 397c8300972f ("netfilter: nf_conntrack_helper: cap maximum number of expectation at helper registration")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Pablo, can you please check

https://sashiko.dev/#/message/20260630045243.2657-6-fw%40strlen.de

?

AFAICS the comment is correct, but it should be handled in a
followup patch rather than a v2.
