Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD9F38389;
	Fri, 22 Nov 2024 13:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732283157; cv=none; b=PY+5YM620JZxrnWjOut5L+tHd4RkAonLm1IrQGnOsimXibed1doKEF3rZo0S3zPTMEh28xP0Aeornfco9d0vcGZGIvbuskdG1wUdOJv2FoZUXmTZK4FhvriV+bGMsmQpDKb/cjYfSsd9iW1IYIh0uk003xTQ84n3pEb5IbroFNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732283157; c=relaxed/simple;
	bh=my1Lv+AVAEzcHuOm7l1VgiwLutqzxS4skKNgNVfJ2s4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GAo2/tlTm0rHzRn64NegbZTHECr8bXaY8dNE+YMQ3c38uO/wWKV9pMfz3MxEW353Xz56yOjaXDyuc5b67KWV2JWUBugihaedV1L5/d7n20iPpZQboNUCyq8szw8Qyvn8PWx7nIHvCwXnVsjuKq1ps1wc2ZjoHrAyyZUdJ4oASZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tETyT-0005kg-Hd; Fri, 22 Nov 2024 14:45:29 +0100
Date: Fri, 22 Nov 2024 14:45:29 +0100
From: Florian Westphal <fw@strlen.de>
To: Pei Xiao <xiaopei01@kylinos.cn>
Cc: pablo@netfilter.org, kadlec@netfilter.org, davem@davemloft.net,
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+84d0441b9860f0d63285@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] netfilter: nf_tables: Use get_cpu_ptr in nft_inner_eval
Message-ID: <20241122134529.GB17061@breakpoint.cc>
References: <673fca0e.050a0220.363a1b.012a.GAE@google.com>
 <804e05fe4615cfd51f0cc72307f578ea34a701b4.1732281838.git.xiaopei01@kylinos.cn>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <804e05fe4615cfd51f0cc72307f578ea34a701b4.1732281838.git.xiaopei01@kylinos.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pei Xiao <xiaopei01@kylinos.cn> wrote:
> syzbot complain about using smp_processor_id in preemptible.
> use get_cpu_ptr to preempt_disable.

> Reported-by: syzbot+84d0441b9860f0d63285@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=84d0441b9860f0d63285
> Fixes: 0e795b37ba04 ("netfilter: nft_inner: add percpu inner context")
> Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
> ---
>  net/netfilter/nft_inner.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nft_inner.c b/net/netfilter/nft_inner.c
> index 928312d01eb1..ae85851bab77 100644
> --- a/net/netfilter/nft_inner.c
> +++ b/net/netfilter/nft_inner.c
> @@ -248,7 +248,7 @@ static bool nft_inner_parse_needed(const struct nft_inner *priv,
>  static void nft_inner_eval(const struct nft_expr *expr, struct nft_regs *regs,
>  			   const struct nft_pktinfo *pkt)
>  {
> -	struct nft_inner_tun_ctx *tun_ctx = this_cpu_ptr(&nft_pcpu_tun_ctx);
> +	struct nft_inner_tun_ctx *tun_ctx = get_cpu_ptr(&nft_pcpu_tun_ctx);
>  	const struct nft_inner *priv = nft_expr_priv(expr);

This can't be right, where is it re-enabled?

Not related to your patch:
Why is this percpu?  How is this softirq safe?
