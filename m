Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A64B20C001;
	Thu, 28 Aug 2025 12:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756385290; cv=none; b=KIpdmfkuG8ywQAw4noBAZa9+zse6JZjs7xw66YaQlwjJdsLRnzaPt6G/sRB3BLgLitZkdz+gwf/wvIgZQatnMZ7F85ZDDEczsInShgXefr82Z0KbShYtQVQHTsxEReTd61uszicAFteK9rT3tRBDJLIOZr+KJwoHyHXTbEWR0U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756385290; c=relaxed/simple;
	bh=cMz+tU3WHpQP5vHSjM9aW7FEHHmiCBwbcwUWvLOWgcc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bTDsqMFbPFfcHPID78FYUxnv64gjaIXvoi8zGLBQCN0nYSxvo1TbHjKZhNR1ML0GylPtwPPa35snuOnM+DUb6in9cOIdnH8Ey/KNwgxkZ2Okt5gkSle96yu5jgXFJFjVWrsdPUETipSbsxT0GL9rCGIbY4W0lPmSE/oPJRUgGf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 15F30605F7; Thu, 28 Aug 2025 14:48:05 +0200 (CEST)
Date: Thu, 28 Aug 2025 14:48:04 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Fabian =?iso-8859-1?Q?Bl=E4se?= <fabian@blaese.de>,
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	"Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH v3] icmp: fix icmp_ndo_send address translation for reply
 direction
Message-ID: <aLBQBPdYE9pNmXOy@strlen.de>
References: <20250825203826.3231093-1-fabian@blaese.de>
 <20250828091435.161962-1-fabian@blaese.de>
 <aLBE2Ee7pUBzUupH@calendula>
 <aLBIeS4_x7dbrL-j@strlen.de>
 <aLBMktniIkqsfWQY@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLBMktniIkqsfWQY@calendula>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > So I believe its needed, concurrent update of ->status is possible and
> > KCSAN would warn.  Other spots either use READ_ONCE or use test_bit().
> 
> There are a more checks for ct->status & NAT_MASK in the tree that I
> can see, if you are correct, then maybe a new helper function to check
> for NAT_MASK is needed.

I think it would make sense to add a helper, yes.
Independent of this patch of course.
