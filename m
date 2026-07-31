Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED9E41A4F5
	for <netfilter-devel@vger.kernel.org>; Fri, 31 Jul 2026 11:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785497841; cv=none; b=aOQ7zWHlzEea0erjbr5COcaISQNRT3kjNQmOJ6ieR9/T43r/FpDJt7On1+sr1Otl2r6wtYAlkspo/PY8JXXUK1ha+hHyYxeEmvW1JhJoP53hMalIHg3e5IS7ZUP2yFmTz2sgMfgNndZ/KklbSzgR73X1exvQOLCgIUWLkMQxu+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785497841; c=relaxed/simple;
	bh=VKGfWV2Ng/L3MOn9dgi6HNRveR1x5kReVzYyTBNJp0I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=THPU2BCGfMMYqjKNRCpLN13jFymF6mA9wPNKdHotidNOZZ1awMGg+eD+DGOtmsQ1ig8gDGyEOOTIYiQCIlTEV66c+koKuOtEXm0HrdE2qlYYNzIQmzX54lASya3P52ENzvHJdkoqDQV5zFNCb3TAX5K86JRM4qKUnXWRDr9hSz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=PfSU5qCo; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="PfSU5qCo"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 9D0426019B;
	Fri, 31 Jul 2026 13:37:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785497833;
	bh=Hu6yzhEIEA+GzfGMiAI2ralk2CJp04Tm9L3fpRe+voA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PfSU5qCoVEUriY0Ww8mgRi3mp5oo0Ua1XK32c6MgRy1CE410bLZzP0w7jK74sESlS
	 MnVwSV5wnUKQxJM6afOsSKF0wxGsUNeV/UQsXmwxot1tM3RO0tRriI+1YkU49EMq11
	 RAKvTWGzeIBPEpArGLSCVQ8TM1SoMo/ITi3vTxhMn49+nUnLyOB77udBtUSdEyRFhe
	 Pn5ySK5zdscKgPgHbovyBaO3s1eDEJaV2TXWnj9cyHXuICJeXpqUALDUUON2+sP+8q
	 8hs2Iowqf97dW7Ryfx1eOpy7cfkg6rZaeirmTRD22X//gnnN9e/nTMPCyfVA9x6rE0
	 MZJ9GLY63NTyg==
Date: Fri, 31 Jul 2026 13:37:10 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Omkhar Arasaratnam <omkhar@linkedin.com>
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"phil@nwl.cc" <phil@nwl.cc>, "fw@strlen.de" <fw@strlen.de>
Subject: Re: [PATCH iptables] nft: fix out-of-bounds read listing an
 old-revision match
Message-ID: <amyI5pPa_4a7v2VP@chamomile>
References: <LV0SPRMB0026AFC6E85D19E90A2C3CBAA1C62@LV0SPRMB0026.namprd21.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <LV0SPRMB0026AFC6E85D19E90A2C3CBAA1C62@LV0SPRMB0026.namprd21.prod.outlook.com>

On Fri, Jul 17, 2026 at 06:59:27PM +0000, Omkhar Arasaratnam wrote:
> nft_parse_match() sizes the xt_entry_match buffer from the wire blob
> length reported by the kernel:
> 
>         m = xtables_calloc(1, sizeof(struct xt_entry_match) + mt_len);
>         memcpy(&m->data, mt_info, mt_len);
> 
> but selects the print/save/compare extension purely by name via
> xtables_find_match(), which returns the highest supported revision. When
> the kernel stored an older, smaller revision of the match, mt_len is
> smaller than the resolved extension's userspacesize, and the print
> callback -- and compare_matches(), which memcmp()s userspacesize bytes
> -- read past the mt_len-sized allocation.
> 
> For example a conntrack match stored as xt_conntrack_mtinfo1 (152 bytes)
> is printed by the rev3 callback conntrack_dump(), which reads
> xt_conntrack_mtinfo3 fields (info->origsrc_port_high at offset 154), two
> bytes past the buffer. Listing such a ruleset with iptables-nft -L reads
> out of bounds.

Is this a hypothetical crash? How can this happen in practise? These
revisions are very old, you would need to pick a very old iptables
version which possibly does not supports nftables to trigger this?

> Size the allocation to the resolved extension when its blob is larger,
> just as nft_create_match() and __nft_create_target() already do, so the
> print and compare paths stay in bounds. Matches whose stored blob is at
> least as large as the extension are unaffected.
>
> Fixes: cdc78b1d6bd7 ("nft: convert rule into a command state structure")
> Signed-off-by: Omkhar Arasaratnam <omkhar@linkedin.com>
> ---
>  iptables/nft-ruleparse.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/iptables/nft-ruleparse.c b/iptables/nft-ruleparse.c
> index 26a605cf..2c5aa9ce 100644
> --- a/iptables/nft-ruleparse.c
> +++ b/iptables/nft-ruleparse.c
> @@ -638,7 +638,10 @@ static void nft_parse_match(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
>                 return;
>         }
> 
> -       m = xtables_calloc(1, sizeof(struct xt_entry_match) + mt_len);
> +       /* Kernel blob may be smaller than the resolved extension (older
> +        * revision); size to the extension so print/compare stay in bounds. */
> +       m = xtables_calloc(1, sizeof(struct xt_entry_match) +
> +                             (mt_len < match->size ? match->size : mt_len));
>         memcpy(&m->data, mt_info, mt_len);
>         m->u.match_size = mt_len + XT_ALIGN(sizeof(struct xt_entry_match));
>         m->u.user.revision = nftnl_expr_get_u32(e, NFTNL_EXPR_TG_REV);
> --
> 2.34.1
