Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C014409
	for <netfilter-devel@vger.kernel.org>; Fri, 28 Mar 2025 14:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743172431; cv=none; b=X4jS1swn5TE2SyyAm2ZnbFE5+RCjgCLUcCC9WUBp8c2iBPt2yu4BKz6OLrzxV2DubuzGF4rZ+dua5CV05acGXAyUvPRhRRyRKyKwPjlsP8foS9uQVkSRONMuV8wME84S8l/EOF+XRgwINMN7WLCRWuoqnEZ4BWI7gCba3ea/+UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743172431; c=relaxed/simple;
	bh=qp9b8MCdy0sE/OSgRYPtNepXWuwKGdnoSH4YvYolD5Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OOjKB7onkTxPJuZ5ov4MreWCx1gT/ruCpVfUoJfHrCMo6ufj9fPPE/4HtfY65+dSANg0nufhqRaAopPrTUMSUxobauWwxx3sY3Sd57qvPzYDfuxJ3rPFD3wau5C/p6BtpwXKzMPfIHc/GSABUivBy0rTjiGIE17mUAsKrKahKT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tyAmH-0007HT-Na; Fri, 28 Mar 2025 15:33:45 +0100
Date: Fri, 28 Mar 2025 15:33:45 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] tests: shell: Fix owner/0002-persist on aarch64
Message-ID: <20250328143345.GA27940@breakpoint.cc>
References: <20250328140921.15462-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250328140921.15462-1-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)

Phil Sutter <phil@nwl.cc> wrote:
> Not sure if arch-specific, but for some reason src/nft wrapper script
> would call src/.libs/lt-nft and thus the owner appeared as 'lt-nft'
> instead of the expected 'nft'. Cover for that by extracting the expected
> program name from /proc.

I've seen this as well before, thanks for investigating and fixing it.

Acked-by: Florian Westphal <fw@strlen.de>

