Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77C922652D
	for <netfilter-devel@vger.kernel.org>; Fri, 28 Nov 2025 15:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764342897; cv=none; b=CEJSQE5II0t5aSavUWeMOg3mnKnTDatx2tyVsPaZSXoHGH1GgDWbAIEWqyK2YquM25iAGwOe08TbHsbnULVDJxLyOU8s6oHl3W7slWwPIUkVZTAdvdL0e4uZvNZQ51KkboJ6g2gSgPqLiY1bNakWgekgHA+KD7dfpbvzpcobTyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764342897; c=relaxed/simple;
	bh=0kicyfFxDy0nUdXCMCHPJWaZ/QF31cA3+JrWtlQ1wNk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s5CddQvaOLv1o0PV2rf2KYvImKvCF27AtJi44BkmxykNcqh+6Sa/J94hvaCbkeiEjZr+fai1uG5wNbRI+5dNABYSl6zuB7h4IsA4K9wiYhSH+6UybywoNZTUmw34JTh+kngAIyCfoj5+PRVhQOemCyJNx4SqBBbzOED7AXfk3dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 053A060308; Fri, 28 Nov 2025 16:14:52 +0100 (CET)
Date: Fri, 28 Nov 2025 16:14:53 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH RFC 3/6] parser_bison: Introduce tokens for osf ttl
 values
Message-ID: <aSm8bVvASZCuZI9i@strlen.de>
References: <20251126151346.1132-1-phil@nwl.cc>
 <20251126151346.1132-4-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251126151346.1132-4-phil@nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> Eliminate the open-coded string parsing and error handling.

Reviewed-by: Florian Westphal <fw@strlen.de>
