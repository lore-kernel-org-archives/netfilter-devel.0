Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0A92DC764
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Mar 2026 11:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773316593; cv=none; b=T8I3cRbkFMZTVt1IDhz1AE2qM8sNMcBeyRk7hCOI8T4NJo8Vonf61zJr/xXL286rrkcB/pWG+8AyNRZ/eFunSQsQvMf1FvZjlnn1LhE61QyNyIZldCU0evLj/GcLEJi7bhTbwjM4SVibwvOClaxrmHoUl/rAqdlqBrH8xNlZHjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773316593; c=relaxed/simple;
	bh=2W3BII0zaLLoQyF8BVeF6LFIV7hkGaMCFMd0uNXRQqE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fpjRc9XBlJ4l5WgsY8fCzZ/3KhO+Uk1CQCdmQlYJO2qtSYOn5pRMKP+GkMkkjvuYJ0mmUvPBgIhhULwfs1+fJlT4qT0yOMmG0a52nC3HUvciOd9plifBErdMEkdWfaCVBl8S1WF09liw2vYfVK0VvMDmZt6XPQQ4n0htiPM+KLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B91E860709; Thu, 12 Mar 2026 12:56:29 +0100 (CET)
Date: Thu, 12 Mar 2026 12:56:31 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] nf_tables: nft_dynset: fix possible stateful
 expression memleak in error path
Message-ID: <abKp7-ES9haxX3S-@strlen.de>
References: <20260312101120.3512073-1-pablo@netfilter.org>
 <abKdTesNowf_-h3F@strlen.de>
 <abKkj6BaaD0xZp9B@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <abKkj6BaaD0xZp9B@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Mar 12, 2026 at 12:02:37PM +0100, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > If cloning the second stateful expression in the element via GFP_ATOMIC
> > > fails, then the first stateful expression remains in place without being
> > > released.
> > > 
> > >    unreferenced object (percpu) 0x607b97e9cab8 (size 16):
> > >      comm "softirq", pid 0, jiffies 4294931867
> > >      hex dump (first 16 bytes on cpu 3):
> > >        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > >      backtrace (crc 0):
> > >        pcpu_alloc_noprof+0x453/0xd80
> > >        nft_counter_clone+0x9c/0x190 [nf_tables]
> > >        nft_expr_clone+0x8f/0x1b0 [nf_tables]
> > >        nft_dynset_new+0x2cb/0x5f0 [nf_tables]
> > >        nft_rhash_update+0x236/0x11c0 [nf_tables]
> > >        nft_dynset_eval+0x11f/0x670 [nf_tables]
> > >        nft_do_chain+0x253/0x1700 [nf_tables]
> > >        nft_do_chain_ipv4+0x18d/0x270 [nf_tables]
> > >        nf_hook_slow+0xaa/0x1e0
> > >        ip_local_deliver+0x209/0x330
> > > 
> > > Pass NULL to nft_set_elem_expr_destroy() given stateful expressions do
> > > not require context at this stage.
> > 
> > static void nft_connlimit_do_destroy(const struct nft_ctx *ctx,
> >                                      struct nft_connlimit *priv)
> > {
> >         nf_ct_netns_put(ctx->net, ctx->family);
> >         nf_conncount_cache_free(priv->list);
> >         kfree(priv->list);
> > }
> > 
> > I think minimal fake context could work though, the clone wasn't
> > exposed to other cpus yet.
> > 
> > Other than this patch looks correct to me.
> 
> It is following this path:
>
> static void nft_connlimit_destroy_clone(const struct nft_ctx *ctx,
>                                         const struct nft_expr *expr)
> {
>         struct nft_connlimit *priv = nft_expr_priv(expr);
>  
>         nf_conncount_cache_free(priv->list);
>         kfree(priv->list);
> }

Oh, I see -- you are right, this follows the destroy_expr special case.

> But I will post a v2 setting nft_ctx anyway.

Thanks, I find it hard to assert correctness otherwise.
