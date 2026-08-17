Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 939392C11DE
	for <netfilter-devel@vger.kernel.org>; Mon, 17 Aug 2026 15:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786981698; cv=none; b=QOdjHkK2DUuQ2I2Ppfr2ky5+IPxzP4Neu5zLFOqwB2lD+I84wJdB0cStnW8AdVQFH3s47Vmiph8P8cuCB6wUh1+KZoeVSWO9JtLWtQgV79F2Kegaasl4/E79cfimcFnoSsGv1Bxf8+aoZlYwl45QasEMl9F+2UwXk8R7bfePFS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786981698; c=relaxed/simple;
	bh=7MlbQz6bvD6Hhvkq6//9pYEpsEdsrjzzGp3T94RGIs8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F7cbNe5Gj5F6AMxZpscvVbEEWALB8l6DOScIf0rg+SsQBkNunPdiGLFbsBJgacCluAavZoweovwjlBzVCJ71+6ZgNKkrgV5N5FWyZyFNdP7YxLCzRWcPazUy7+CDcAnalUEhA69kwm3eRiMvQb9mQNQoezs66t0cr/Chi6Vm60E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=CghCW0wi; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="CghCW0wi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786981691;
	bh=rkrgzzTvy0aGsnubeERywUcofsJZAfZ2x/T9vIaG/NA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CghCW0wi1uRORq4OH1aAQPH0dETqCRO4dcoL4dWsQ0p9eAWkyBm10m2w+RQPB/Oz9
	 golRtJSO1Qt2DUgImnWqk1NLZIjjQcqjpFSB+vIIwj6S+WNgahAh1plYqAcfHFEBIl
	 K5DLwGcFQ2wSOxCpID9yvlVo+wVIIbKP8ze7EEYOkqFKbZmayKR3IKPPQ65RPEBoXy
	 PWb3iuMTL4M40LmgQqinTsmXH1fKdJ3Ppsz0NsrdOlIhJXxEXPxDB/hawAG/fzgo1L
	 +kuwAYGr1MdLCq+waFA9NhQ7Fre0UxNvAvh8IOlsN+0BoFy70ZPyjGb6dvWEvG/noY
	 7SlxTcxBNMnSw==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id CCD6D60081;
	Mon, 17 Aug 2026 17:48:11 +0200 (CEST)
Date: Mon, 17 Aug 2026 17:48:09 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: ZhilingZouzhilinz@nebusec.ai
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, phil@nwl.cc,
	davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
	horms@kernel.org, kaber@trash.net, vega@nebusec.ai,
	zhilinz@nebusec.ai
Subject: Re: [PATCH nf 1/1] netfilter: xt_string: account textsearch configs
Message-ID: <aoMtOeAlywLdU5Pl@chamomile>
References: <cover.1786970189.git.zhilinz@nebusec.ai>
 <9b7e9680b6908b65318a6f68b4228845eec38553.1786970189.git.zhilinz@nebusec.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9b7e9680b6908b65318a6f68b4228845eec38553.1786970189.git.zhilinz@nebusec.ai>

On Mon, Aug 17, 2026 at 08:44:55PM +0800, ZhilingZouzhilinz@nebusec.ai wrote:
> From: Zhiling Zou <zhilinz@nebusec.ai>
> 
> string_mt_check() creates a textsearch configuration for every string
> match with GFP_KERNEL. Algorithm-private data, including Boyer-Moore
> tables,

Why the reference to Boyer-Moore? It looks a bit gratuitous? :-)
How does it relate to this issue at all? Knuth-Pratt-Morris
implementation also performs an internal memory allocation from
->init() path.

> [...] remains allocated for as long as the rule is installed.
> 
> The xtables table blob is memcg accounted, but the textsearch
> configuration is not. A user with CAP_NET_ADMIN in a user and network
> namespace can therefore retain kernel memory outside its memory limit
> by installing many string matches.

This is news to me that you consider this a security issue... but fair
enough. We have taken many patches like this for net-next in the past.

We have more paths that could use GFP_KERNEL_ACCOUNT in x_tables, but
some of them need careful look because they might break existing
setups.

net/netfilter/x_tables.c:       table = kmemdup(input_table, sizeof(struct xt_table), GFP_KERNEL);
net/netfilter/xt_CT.c:  ct = nf_ct_tmpl_alloc(par->net, &zone, GFP_KERNEL);
net/netfilter/xt_IDLETIMER.c:   info->timer->attr.attr.name = kstrdup(info->label, GFP_KERNEL);
net/netfilter/xt_IDLETIMER.c:   info->timer->attr.attr.name = kstrdup(info->label, GFP_KERNEL);
net/netfilter/xt_LED.c: ledinternal->trigger_id = kstrdup(ledinfo->id, GFP_KERNEL);
net/netfilter/xt_dccp.c:        dccp_optbuf = kmalloc(256 * 4, GFP_KERNEL);
net/netfilter/xt_hashlimit.c:   hinfo->name = kstrdup(name, GFP_KERNEL);
net/netfilter/xt_repldata.h:    tbl = kzalloc(term_offset + sizeof(*term), GFP_KERNEL);

I can post a patch to address this, no need for you to post it.

> Use GFP_KERNEL_ACCOUNT for the textsearch configuration so it is
> charged with the rest of the rule state.

textsearch_prepare also in net/sched/em_text.c uses GFP_KERNEL, maybe
you want to "fix" all textsearch_prepare() prepare callers?

Maybe you can just remove the allocation flag for textsearch_prepare()
and use GFP_KERNEL_ACCOUNT inconditionally.

> Fixes: 7567662ba896 ("[NETFILTER]: Add string match")

GFP_KERNEL_ACCOUNT came later than lib/textsearch.c, so this was never
converted to use it.

This Fixes: tag cannot be right.

> Cc: stable@vger.kernel.org
> Reported-by: Vega <vega@nebusec.ai>
> Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
> ---
>  net/netfilter/xt_string.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/xt_string.c b/net/netfilter/xt_string.c
> index 8ce25bc9b2775..52c1deb02cdc6 100644
> --- a/net/netfilter/xt_string.c
> +++ b/net/netfilter/xt_string.c
> @@ -54,7 +54,7 @@ static int string_mt_check(const struct xt_mtchk_param *par)
>  	if (conf->u.v1.flags & XT_STRING_FLAG_IGNORECASE)
>  		flags |= TS_IGNORECASE;
>  	ts_conf = textsearch_prepare(conf->algo, conf->pattern, conf->patlen,
> -				     GFP_KERNEL, flags);
> +				     GFP_KERNEL_ACCOUNT, flags);
>  	if (IS_ERR(ts_conf))
>  		return PTR_ERR(ts_conf);
>  
> -- 
> 2.43.0
> 
