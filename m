Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592A33BF696
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Mar 2026 11:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773315222; cv=none; b=AIX/fooONxqN/DaG4YfaWI+3JeueEecdFXjsuMGQme9hx6kAxRQIx7NcISeD9CEEvzcGdW07YUMEJz7MxAqlknYW7eUZtUVZuWM7juclttaRpqIDSlr7g+S3o1ApKiiYTDAbyiKJrPLDGvLCjaXyHnamhSyIln0y1POZMeIP7Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773315222; c=relaxed/simple;
	bh=rgHr+KoQz7K6fhDTCYe5aculG4Ekdjgv0fs64XDE0ZA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dh1ete2cDg+x8Ve1VGN6ROOrKyKI0+ZINoFv3BGzJiJya9P9eyz/lhSqbRnjw2eaCLwCSCBQR1E+/4WZ6M8Joy9erBBTq7IwhaqAArVSj5T0Cex5JZMI64NLp6N00ZNvi/YnjkKX3F0KlieYWQ5E2+7ZsWZFBoQMdDlewweDqC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=SDjT+M9X; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="SDjT+M9X"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id E84A460264;
	Thu, 12 Mar 2026 12:33:37 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1773315218;
	bh=H2RyQSUvjYxesPKTFA90NIIFYpmw8nqAgJabIGn8v6Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SDjT+M9XXiHccAfDS70vrKIPzY7/mEcJTjsWyWbpdI3B34Tq2fe0Jjqe/PbwPSVWo
	 /q0OtHXXVEKS3JqD+yx+hcrhfj0BISTcExzKXd2II62YEsBd5W6bA3+UHkQSgqyp1m
	 m+0ZQmbYHxJO15I1VcWZoOa+HZcMDCsVohaSqHiISWWnAno65/bD279YyWFB+WU5j5
	 F8j0hvMB5hO1JbSiTvfnZdUtYOkGUawuwWX2II9UsZJZaCPbyEeATzQxwjeJ9YcRGm
	 mo5IEhQJceqFt/iQKBdMJfmqU8WumU014A5SZEcjVbjymIzC2jjVEiU21Etsz93Z6F
	 UGHU+s9HBLZ/w==
Date: Thu, 12 Mar 2026 12:33:35 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] nf_tables: nft_dynset: fix possible stateful
 expression memleak in error path
Message-ID: <abKkj6BaaD0xZp9B@chamomile>
References: <20260312101120.3512073-1-pablo@netfilter.org>
 <abKdTesNowf_-h3F@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <abKdTesNowf_-h3F@strlen.de>

On Thu, Mar 12, 2026 at 12:02:37PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > If cloning the second stateful expression in the element via GFP_ATOMIC
> > fails, then the first stateful expression remains in place without being
> > released.
> > 
> >    unreferenced object (percpu) 0x607b97e9cab8 (size 16):
> >      comm "softirq", pid 0, jiffies 4294931867
> >      hex dump (first 16 bytes on cpu 3):
> >        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> >      backtrace (crc 0):
> >        pcpu_alloc_noprof+0x453/0xd80
> >        nft_counter_clone+0x9c/0x190 [nf_tables]
> >        nft_expr_clone+0x8f/0x1b0 [nf_tables]
> >        nft_dynset_new+0x2cb/0x5f0 [nf_tables]
> >        nft_rhash_update+0x236/0x11c0 [nf_tables]
> >        nft_dynset_eval+0x11f/0x670 [nf_tables]
> >        nft_do_chain+0x253/0x1700 [nf_tables]
> >        nft_do_chain_ipv4+0x18d/0x270 [nf_tables]
> >        nf_hook_slow+0xaa/0x1e0
> >        ip_local_deliver+0x209/0x330
> > 
> > Pass NULL to nft_set_elem_expr_destroy() given stateful expressions do
> > not require context at this stage.
> 
> static void nft_connlimit_do_destroy(const struct nft_ctx *ctx,
>                                      struct nft_connlimit *priv)
> {
>         nf_ct_netns_put(ctx->net, ctx->family);
>         nf_conncount_cache_free(priv->list);
>         kfree(priv->list);
> }
> 
> I think minimal fake context could work though, the clone wasn't
> exposed to other cpus yet.
> 
> Other than this patch looks correct to me.

It is following this path:

static void nft_connlimit_destroy_clone(const struct nft_ctx *ctx,
                                        const struct nft_expr *expr)
{
        struct nft_connlimit *priv = nft_expr_priv(expr);
 
        nf_conncount_cache_free(priv->list);
        kfree(priv->list);
}

But I will post a v2 setting nft_ctx anyway.
