Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98611DB92E
	for <netfilter-devel@vger.kernel.org>; Mon,  5 May 2025 11:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746443942; cv=none; b=I11rXEG/Eujxx510PNFrZiHJ2AW8/P2LSMu5upDA52o4e9uXZXWe9VE86KanoLcGrwVMVdzmeBI8lAhei784Ekq5YQr4bUgNP11GPbcqIG8TWRALR8IDRmbBfGrS9BiO05Q7CdVwxyLo4bF4MRuhfiQa7NVYFkJYwEUkvF23Lqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746443942; c=relaxed/simple;
	bh=u9cxrtYtSQBe3t9Qd7y1wp0CcE/7E75+Ar55NxHWvbU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mkVskrkGUir5J2+CuW/gxEELV3obyZ0cnfCsVdmcO8CZTlTivMtMB4tyiMXl28GeNQ71lSE9bioGyMVav//VB5g7C0nJOUOYRkq1+u/mexu/lMhj4orIWVD8cOaV0dHCTXzJKFVSUrF99sraDmGaZBBSjNLatoRRKlOlZEBAicE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=OSsVXqir; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=b9816D25; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="OSsVXqir";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="b9816D25"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 0562D602F0; Mon,  5 May 2025 13:18:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1746443939;
	bh=WD5q6HP5KnNqyuVMTYKmBEcMRxgdeQ304bKHaxb75Ac=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OSsVXqiraZ1TeQvjPO1Kh/4iBzxclXbtLJe9ntfTmK++U5xg++c5BuHeGqXsCijEG
	 9xEGE9XcPXgFQUJhX0IFnzMtifpkgWXMy2bmNUFXX4Dk83slp+Cga9weXAdEQdpMY/
	 +NFcDPnuh9T8FTinMysEJ55yOjMFsNSe/iwidQcjozqLBNsBotBUENmaR0HY74021V
	 8dm3vWdxRu00hewFFhu0PWezD0QEIhsQKmkU8o3kY9r0oYPT0MUkp8xjMmUIXEQNUq
	 SyQIfIw7lc6rOREhCeqjsIpzrZhgB230Jk1bU49VZCc5BMQgoL330lX0H6JTdgMcca
	 g9kvhllhxLcJg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 7B645602E8;
	Mon,  5 May 2025 13:18:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1746443938;
	bh=WD5q6HP5KnNqyuVMTYKmBEcMRxgdeQ304bKHaxb75Ac=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b9816D258gyQzXyasDjKKYHHoU2zO/JJXLDqafBIAR8+0ecSbt5sARhhwaYmURN/P
	 RDRpQfnnif35/E8Q3gcSdF/XkScajf/CJrbHt80s1Tcs6IgqPdFxafKy+u7EMV8RKf
	 B6fzCOMw9YslgOsRfcs/zN+OKh4TZdszeFPEGdqi/88e9jUALEQ+7Fyq4eQ+H64Sp7
	 mFHsgPXcHii+OspzI2HGl3/Nk/vZ9Es707s77i7sSkiJIOKgv5ibLEx3JAHyqvFlGB
	 sBiGSRBJm8ryKlftfWuzCf6K4MWOiJE8NrY+NNLuOPeTH2U1sgWd96A4zQ3M6gB+pJ
	 1utpwdPDUnb8A==
Date: Mon, 5 May 2025 13:18:56 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Stefano Brivio <sbrivio@redhat.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next,v2 1/2] netfilter: nft_set_pipapo: prevent
 overflow in lookup table allocation
Message-ID: <aBieoCrFQqRh84i9@calendula>
References: <20250422195244.269803-1-pablo@netfilter.org>
 <20250423110502.38218b6b@elisabeth>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250423110502.38218b6b@elisabeth>

On Wed, Apr 23, 2025 at 11:05:02AM +0200, Stefano Brivio wrote:
> On Tue, 22 Apr 2025 21:52:43 +0200
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> 
> > When calculating the lookup table size, ensure the following
> > multiplication does not overflow:
> > 
> > - desc->field_len[] maximum value is U8_MAX multiplied by
> >   NFT_PIPAPO_GROUPS_PER_BYTE(f) that can be 2, worst case.
> > - NFT_PIPAPO_BUCKETS(f->bb) is 2^8, worst case.
> > - sizeof(unsigned long), from sizeof(*f->lt), lt in
> >   struct nft_pipapo_field.
> > 
> > Then, use check_mul_overflow() to multiply by bucket size and then use
> > check_add_overflow() to the alignment for avx2 (if needed). Finally, add
> > lt_size_check_overflow() helper and use it to consolidate this.
> > 
> > While at it, replace leftover allocation using the GFP_KERNEL to
> > GFP_KERNEL_ACCOUNT for consistency, in pipapo_resize().
> > 
> > Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> Thanks for the follow-up!
> 
> Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

Applied to nf-next, thanks Stefano for reviewing.
