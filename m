Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A331F3B9E;
	Tue, 24 Jun 2025 11:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750765319; cv=none; b=RBq3nKKBX+rxc6uNbI3ar5KfrW7xUPmvsuarok5Fx5MjnIpS/pE6Ud3qVa4YxSd0CBa+Av+JagjRi0T/Rm50k9H6BgXnRW9mKjw7mLW+JE5Zg/nb1kfInPIvfNM9XlFQ6OUrGHpDyrTMhuBgARy8B8kbMsYbhGLUAQYvepvShFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750765319; c=relaxed/simple;
	bh=96Mu6LHGuPrLTID2M4vvKvVacaBioN3MbfnDn8hILLo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jv7C9mN+H9ro3IeS02m12kRDJnahP7+VwvYB9XtT/F0ESYkVSppxr/4zO5lzjShSe5TKLmrpS5tLHf0rKjraXxTKtg7JYuRxoqBVJpd3WCVl4cr9i4oJMCXFl3AP/R7yZ2QDCWz/HonUASVuOvCrpN6Oa4OF2OzskVMtR7tpa0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7495A60164; Tue, 24 Jun 2025 13:41:54 +0200 (CEST)
Date: Tue, 24 Jun 2025 13:41:54 +0200
From: Florian Westphal <fw@strlen.de>
To: Fedor Pchelkin <pchelkin@ispras.ru>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org,
	Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: Re: [PATCH nf] netfilter: nf_tables: adjust lockdep assertions
 handling
Message-ID: <aFqPAvN1yBpckUTZ@strlen.de>
References: <20250624111216.107844-1-pchelkin@ispras.ru>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250624111216.107844-1-pchelkin@ispras.ru>

Fedor Pchelkin <pchelkin@ispras.ru> wrote:
> It's needed to check the return value of lockdep_commit_lock_is_held(),
> otherwise there's no point in this assertion as it doesn't print any
> debug information on itself.
> 
> Found by Linux Verification Center (linuxtesting.org) with Svace static
> analysis tool.

Acked-by: Florian Westphal <fw@strlen.de>
