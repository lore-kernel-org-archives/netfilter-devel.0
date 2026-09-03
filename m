Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A1A499F1C
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Sep 2026 14:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788444226; cv=none; b=OempO9CUPirFXYnDdpsI5MzFtM9ouP7gdey138qGOIqi1p/bgUzfWGzOnI07ng6tM8mGrudBxZ1Jj7+RKs2jZzeSUSmXkZH1uWKe0l+XkuylTFE343gGcBLi+AB6CRrwPn0+eSQYne4lestRJMzuUW6G8MgNZAM84WsU6az5QR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788444226; c=relaxed/simple;
	bh=/HJQ0y9JLAH5F3V4Q3pitNAfYSs4Bq3+6Aq7lN7m6a4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cMYyW/PWbMR0HQyrFBE/cqDUuopmvczmLpjh/30eobsF9HJlnYIZ4J3y9OR7k5kS6NPQ/1gsjpEpfFoPXTeNLZHW1eEMbbCy4uFNwAwtTARATClsnwZgKJV2mAzLE/4cJ1ogqLqLStVWiiYPC64c8hInNKa7ymxRp2KLxB/vv7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7F29E6035B; Thu, 03 Sep 2026 16:03:27 +0200 (CEST)
Date: Thu, 3 Sep 2026 16:03:26 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [conntrack-tools PATCH v2] conntrack.8: Document --stats counters
Message-ID: <apl-LmT_S_ZhSpAd@strlen.de>
References: <20260730091858.1982235-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730091858.1982235-1-phil@nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> Provide a brief description of each counter's meaning based on
> code-analysis in kernel's nf_conntrack_core.c and feedback from
> netfilter-devel list.

Reviewed-by: Florian Westphal <fw@strlen.de>

> +Number of entry insert clashes resolved. These happen frequently with DNS

Maybe 'Number of insertion clashes', but up to you. No need for a v3 in
any case.
