Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98D5219ED
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Jul 2025 02:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753149916; cv=none; b=CBYnhvw7Oz6W+NqzKFgEr0dJ1/RynKsfh5XinFwyq5AMYz9pumoL7OWz5giduGcm7wb6/sLlhz3MUh89sS5TVpKOuFcraAPLVWtKZ0H729BDUHXMF6MhHQeOi49sbdKaq+bF0teq1CbXg3IDNm32E/1LwZQUuPEHYhg5VTAzjas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753149916; c=relaxed/simple;
	bh=EV9cCJV0r3rbdn6g8nxth2AAB4HA/ImrXkpEbasx3RI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=crp9S4X0tp4BhWr99zeiqBAcw87fsSAu2ctXxA0GHrcX0amgKxJHUcoHChz3YlwyYTH9kO+ijssMgH2drKLVi579c4g3TCFgyJmt5BN6TnxXgvBlrLP8UGo6oOw4aFX7im6Z2XXZPQCPFJkXsxxo335Fr705YknfVjadgIg+Nv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=wTv5bBq7; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=wTv5bBq7; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="wTv5bBq7";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="wTv5bBq7"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id B3D616028A; Tue, 22 Jul 2025 04:05:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753149911;
	bh=pUdWv9h739l4HF82iam+eL0vDQpvTepB1pHJBF3Fnr0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=wTv5bBq7DJBTai/bFmFaoBVGzkKdD7F3Q+D8Gx/Hpy/pkcXLg1F+cKwLd8Yxwr9Z7
	 ap2OfgP7iw1FkwFhpMU+kro82LCnvCzvgSZO7OEdA1kMkW94ZJ1/ksZ1jXEcMDx7ek
	 ssQp6iaNwt/QVuTu/8qNsKO3BcBo4EuiWltLK+xZgw/uD04+74w3WE+CtTwTh1mAr2
	 KDLTCmQNfPn6pBKvnWUck+yS+uyqSCnzFMGF/4GxwSPu9PaCpsxZelKyyjqhMZLvEc
	 gIyN/OK3ilqAHQQHzQKBbMMVU0paFV7eHPh8+o7TfCM/DNrg9DdbwFV+63RbayyIte
	 F3VOqDbH2UGlA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E747F60288;
	Tue, 22 Jul 2025 04:05:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753149911;
	bh=pUdWv9h739l4HF82iam+eL0vDQpvTepB1pHJBF3Fnr0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=wTv5bBq7DJBTai/bFmFaoBVGzkKdD7F3Q+D8Gx/Hpy/pkcXLg1F+cKwLd8Yxwr9Z7
	 ap2OfgP7iw1FkwFhpMU+kro82LCnvCzvgSZO7OEdA1kMkW94ZJ1/ksZ1jXEcMDx7ek
	 ssQp6iaNwt/QVuTu/8qNsKO3BcBo4EuiWltLK+xZgw/uD04+74w3WE+CtTwTh1mAr2
	 KDLTCmQNfPn6pBKvnWUck+yS+uyqSCnzFMGF/4GxwSPu9PaCpsxZelKyyjqhMZLvEc
	 gIyN/OK3ilqAHQQHzQKBbMMVU0paFV7eHPh8+o7TfCM/DNrg9DdbwFV+63RbayyIte
	 F3VOqDbH2UGlA==
Date: Tue, 22 Jul 2025 04:05:07 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] evaluate: maps: check element data mapping matches
 set data definition
Message-ID: <aH7x02JC0l2u3bn0@calendula>
References: <20250721105721.2512-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250721105721.2512-1-fw@strlen.de>

On Mon, Jul 21, 2025 at 12:57:07PM +0200, Florian Westphal wrote:
> This change is similar to
> 7f4d7fef31bd ("evaluate: check element key vs. set definition")
> 
> but this time for data mappings.
> 
> The included bogon asserts with:
> BUG: invalid data expression type catch-all set element
> nft: src/netlink.c:596: __netlink_gen_data: Assertion `0' failed.
> 
> after:
> internal:0:0-0: Error: Element mapping mismatches map definition, expected packet mark, not 'invalid'
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
