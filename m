Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DEAC346A15
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Jun 2026 23:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780357932; cv=none; b=GVilLnbP5iADKHQ2MYJO3w879fx5CUeciLfemLRLUnuOVc4+BfX4w7HxdAZI3mQ8qaj0n0iDhKTj1xfKYV+AiGvnYa1HLVb3c8GOwBRs+l4hr/ts9t20xjOAgpyf39yW1aQB71rraQQMuCv0crd7osHTjzoP1e1OPDbXqWQKOk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780357932; c=relaxed/simple;
	bh=4kw1qsnqnRBT5PzT3Jz5eYWQVWqmTLmTyljlsVurshc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D13S4qmOrgNvNAMZqV7CmgUqWg4/ed2mOT2JctyQutK964Z4N9XWEngqNJHCZ/MgArJMVL9ygMpzy24ejWmq0SYrTIrjiMk1vqMlWnNRVRnmpnFTV1o8EbbnJesUTqRbQpLOjtsbT4SL4T+NiQ7Z+GPqBjecm6FI1j2IH+lyzis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 80A44604DC; Tue, 02 Jun 2026 01:52:07 +0200 (CEST)
Date: Tue, 2 Jun 2026 01:52:06 +0200
From: Florian Westphal <fw@strlen.de>
To: boz baba <bababoz943@gmail.com>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: [BUG] netfilter: nft_set_pipapo_avx2: rp not reset on goto
 next_match retry after expired/inactive last-field element
Message-ID: <ah4bJmm6z6ytowqD@strlen.de>
References: <CAAB7JCLAzOAZ0CA5CMSkmzwCLY2+DgHSEZe15omAW2-WBTPhbQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAB7JCLAzOAZ0CA5CMSkmzwCLY2+DgHSEZe15omAW2-WBTPhbQ@mail.gmail.com>

boz baba <bababoz943@gmail.com> wrote:
> While auditing the pipapo set lookup in v6.1.133 (the bug is also present
> on current mainline as of this writing) I noticed a logic error in the

Why are you auditing ancient kernel releases?

> Affected file / function
> ------------------------
> 
>   net/netfilter/nft_set_pipapo_avx2.c :: nft_pipapo_avx2_lookup()
> 
> Relevant excerpt (line numbers from v6.1.133):
> 
>   1137 :  const u8 *rp = (const u8 *)key;
>   ...
>   1175 :  nft_pipapo_avx2_prepare();
>   1176 :
>   1177 :  next_match:
>   1178 :  nft_pipapo_for_each_field(f, i, m) {
>   1179 :      bool last = i == m->field_count - 1, first = !i;
>   ...
>   1188 :      NFT_SET_PIPAPO_AVX2_LOOKUP(8, 1);     /* consumes rp */
>   ...
>   1223 :      if (ret < 0)
>   1224 :          goto out;
>   1225 :
>   1226 :      if (last) {
>   1227 :          *ext = &f->mt[ret].e->ext;
>   1228 :          if (unlikely(nft_set_elem_expired(*ext) ||
>   1229 :                       !nft_set_elem_active(*ext, genmask))) {
>   1230 :              ret = 0;
>   1231 :              goto next_match;            /* <-- restarts loop */
>   1232 :          }
>   1233 :          goto out;
>   1234 :      }

This looks very different in mainline. AFAICS this bug was fixed?
