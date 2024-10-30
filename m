Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1161BD9F1
	for <netfilter-devel@vger.kernel.org>; Wed, 30 Oct 2024 18:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730314481; cv=none; b=iR61JP3MFyCtdAP6PfRknQiXwgfszGChh2zh5iFIdkkoooVjYfK3INmrjH8AR9R1Q4EwZ2kEUaRd5EPRNvkiW8Er/w/ODETf+EKLCMT3VOr0Uylc9EpDkgbLbk0EYvKalju/BYX7+0cRp/GPMWywUc5uLtGkrnacmxhmmE82FFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730314481; c=relaxed/simple;
	bh=xws0PgMgSSLRaGjYnaJmtFw+u2B9yXuXqE/55SI9KBE=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jPTs0GCJfkBWt+Xl5cWaQWYuT5/2CeoXEpCYy+OFS77JJrw9O0TNLGIfTxgmBTdK1H0HtWOrnJZVy3ehnDG8BzPaIeq/Ahsweg0YjuykxZ1fNCSE0URo0XeEn4dV+etQ3GheOztJb69FgqeynLw6/zUqCkp+8qVFZ8NV9dhT9sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1t6Dq0-0005yq-Rd; Wed, 30 Oct 2024 19:54:36 +0100
Date: Wed, 30 Oct 2024 19:54:36 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: monitor: fix up test case breakage
Message-ID: <20241030185436.GA22935@breakpoint.cc>
References: <20241029201221.17865-1-fw@strlen.de>
 <ZyJ4w02pdiv2LpvW@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZyJ4w02pdiv2LpvW@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)

Phil Sutter <phil@nwl.cc> wrote:
> This is odd: Why does monitor output reverse input? If nft reorders
> input, the test ("make sure half open before other element works") is
> probably moot anyway.

No idea.  It happens since 20f1c60ac8c8
