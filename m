Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 065982C027F;
	Wed, 24 Sep 2025 08:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758703809; cv=none; b=A+q4owzEF2OLECSUD3bO9S++yzx0/s8kJfTrRlkNUwBR8SPyl2mt+iUycqKvu5qOhFHsufdM0D901yMPWdkthpPxvAVoQIPWPjhgRswFzTmtJu4/LsNYnGEyx+ZW7rfbI6nJdGkVm18mCG7wEc4BA4V/+wo4cqMT3yl0pamPikY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758703809; c=relaxed/simple;
	bh=YQ/V3GxNdCKDVvP21IBZI5OOmH5zEylWSqIoRUAp79k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P0oUzobftSITdDe+sIsYPZnQJt5G/+pPNSOudd7wO41y9hTvMAf5RsZCv36b9P+h9TKrucfA7Uw8N3YPe8EtpEzHimhPx+y5S6P0gCiwyPX6Sj0XxB5wkNR4kQ6u5w7834gsKM5+QUMhB7LmYrK8RmZznzYLYPEaAVnHmCC3lt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 0B36A602CC; Wed, 24 Sep 2025 10:50:05 +0200 (CEST)
Date: Wed, 24 Sep 2025 10:50:05 +0200
From: Florian Westphal <fw@strlen.de>
To: Eric Dumazet <edumazet@google.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	eric.dumazet@gmail.com
Subject: Re: [PATCH nf] netfilter: nf_conntrack: do not skip entries in
 /proc/net/nf_conntrack
Message-ID: <aNOwvVaDy8mv8bFY@strlen.de>
References: <20250924072709.2891285-1-edumazet@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250924072709.2891285-1-edumazet@google.com>

Eric Dumazet <edumazet@google.com> wrote:
> diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
> index 1f14ef0436c65fccc8e64956a105d5473e21b55e..708b79380f047f32aa8e6047c52c807b4019f2b9 100644
> --- a/net/netfilter/nf_conntrack_standalone.c
> +++ b/net/netfilter/nf_conntrack_standalone.c
> @@ -317,6 +317,9 @@ static int ct_seq_show(struct seq_file *s, void *v)
>  	smp_acquire__after_ctrl_dep();
>  
>  	if (nf_ct_should_gc(ct)) {
> +		struct ct_iter_state *st = s->private;
> +
> +		st->skip_elems--;

I'll route this via nf-next, I don't think there is
a need to add it to nf this close to release.

Thanks Eric!
