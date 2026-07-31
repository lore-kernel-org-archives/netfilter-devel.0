Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E28836C5A9
	for <netfilter-devel@vger.kernel.org>; Fri, 31 Jul 2026 11:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785497599; cv=none; b=pq0CcDnJYATDBdDF2/7sxq4SfFwcL/v5SOxYsrAmWiJIdHlZqMpRVNoXoLXulwx+dKQ4JYdHfSNMm+OR62WuuswfqxMCqEVvhv7YtRX/YTzvzTLLi27MvmUvBmhjnVC2kC0DQYMpg4uxZmyU867Q3u0BHAupurNa+hzpvwdeUEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785497599; c=relaxed/simple;
	bh=LFhb7JRCRzvbMJ4oq0a+67tHX12t/i7Kt33FG+cPsg0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DM99uvgRV5ts9X5MpM7Hl9W1eO7IkZsjbROrbj/NDptCo7RGn1pVoyp/3AEe0Ud7jwbMLC6GkffdqxT5hg46c+Ry0e3puDQxI1O3KfWHOBFWhZJGjaof9wKDzEXZ5T7bJXwUPA6zn6fj5VePzCRck37+TPzx7GdSM/O1azEczng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=qW9Jpisi; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="qW9Jpisi"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 24CC660191;
	Fri, 31 Jul 2026 13:33:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785497595;
	bh=+rqM6xGwcaYvxa4oChlKR3UWz+vz+vGqexGVHKbMUZo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qW9JpisiUleSzcDs8j4BfJwguw34nJaA7PIj/yg7gg3qgquE11KXt/S6YHYTBHv1/
	 SUI1ccRgVA6E93E477W5CEsqUhqtBz8hOCyhxZtvKas3u16lvmIVHU08ssJaY1KvOn
	 joAlsnqni2C1VTD0CG+gJloIJhMnrWo9xyacn8qqiI2qwRsjF6Wt4hHX6FDHHXd3/4
	 pIC/bQLGlQY9Lj/5/+LlUZkUKRvR7i5vEt6AHtSTfPKpXT8qCfdU0mq8Pcn7gIR1zi
	 gN5E2k0vhGmGTI94yX8/EsBqPFivJg249O81fK2Gb1URTQDRtbmF/LQM3lhnLHtqFc
	 iUmLpGR9mnvFQ==
Date: Fri, 31 Jul 2026 13:33:12 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Omkhar Arasaratnam <omkhar@linkedin.com>
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"phil@nwl.cc" <phil@nwl.cc>, "fw@strlen.de" <fw@strlen.de>
Subject: Re: [PATCH iptables] nft: bridge: fix among buffer overflow when set
 has no size
Message-ID: <amyH-DnOnds5cOAf@chamomile>
References: <LV0SPRMB0026C00DF7CAE003665E672FA1C62@LV0SPRMB0026.namprd21.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <LV0SPRMB0026C00DF7CAE003665E672FA1C62@LV0SPRMB0026.namprd21.prod.outlook.com>

On Fri, Jul 17, 2026 at 06:56:58PM +0000, Omkhar Arasaratnam wrote:
> The among match parser sizes its pair buffer from NFTNL_SET_DESC_SIZE:
> 
>         cnt = nftnl_set_get_u32(s, NFTNL_SET_DESC_SIZE);
>         ...
>         size = cnt * sizeof(struct nft_among_pair);
>         match->m = xtables_calloc(1, size);
>         ...
>         set_elems_to_among_pairs(among_data->pairs + poff, s, cnt);
> 
> NFTNL_SET_DESC_SIZE is the hash-table size hint, which is only present
> when the set was created with an explicit "size". A set created without
> one (e.g. via plain nft: add set bridge filter s { type ether_addr; })
> carries no NFTA_SET_DESC_SIZE, so nftnl_set_get_u32() returns 0. The
> buffer is then allocated header-only while set_elems_to_among_pairs()
> still walks every element of the set and writes one nft_among_pair each,
> overflowing the allocation on the first element. Listing such a ruleset
> with ebtables-nft -L (or ebtables-nft-restore) corrupts the heap.

I assume this is triggered by a crafted set not created by iptables-nft.

Fortify instead set_elems_to_among_pairs() so it does not crash
instead.

> Size the buffer from the actual number of set elements instead, i.e.
> exactly what set_elems_to_among_pairs() iterates over. Sets created by
> the among match itself are unaffected: their element count equals the
> NFTNL_SET_DESC_SIZE that was used before.
>
> Fixes: 26753888720d ("nft: bridge: Rudimental among extension support")
> Signed-off-by: Omkhar Arasaratnam <omkhar@linkedin.com>
> ---
>  iptables/nft-ruleparse-bridge.c | 22 +++++++++++++++++++++-
>  1 file changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/iptables/nft-ruleparse-bridge.c b/iptables/nft-ruleparse-bridge.c
> index aee08b13..fc877d43 100644
> --- a/iptables/nft-ruleparse-bridge.c
> +++ b/iptables/nft-ruleparse-bridge.c
> @@ -306,6 +306,23 @@ static struct nftnl_set *set_from_lookup_expr(struct nft_xt_ctx *ctx,
>         return NULL;
>  }
> 
> +static uint32_t set_elem_count(const struct nftnl_set *s)
> +{
> +       struct nftnl_set_elems_iter *iter = nftnl_set_elems_iter_create(s);
> +       uint32_t cnt = 0;
> +
> +       if (!iter)
> +               xtables_error(OTHER_PROBLEM,
> +                             "BUG: set elems iter allocation failed");
> +
> +       while (nftnl_set_elems_iter_next(iter))
> +               cnt++;
> +
> +       nftnl_set_elems_iter_destroy(iter);
> +
> +       return cnt;
> +}
> +
>  static void nft_bridge_parse_lookup(struct nft_xt_ctx *ctx,
>                                     struct nftnl_expr *e)
>  {
> @@ -328,7 +345,10 @@ static void nft_bridge_parse_lookup(struct nft_xt_ctx *ctx,
>                                     &is_dst, &have_ip))
>                 return;
> 
> -       cnt = nftnl_set_get_u32(s, NFTNL_SET_DESC_SIZE);
> +       /* NFTNL_SET_DESC_SIZE is unset for sets without an explicit size, so
> +        * count the actual elements instead of trusting it.
> +        */
> +       cnt = set_elem_count(s);
> 
>         for (ematch = ctx->cs->match_list; ematch; ematch = ematch->next) {
>                 if (!ematch->ismatch || strcmp(ematch->u.match->name, "among"))
> --
> 2.34.1
> 
> — oa
