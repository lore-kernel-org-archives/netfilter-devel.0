Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9571A0BFD
	for <netfilter-devel@vger.kernel.org>; Thu, 31 Oct 2024 14:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730385464; cv=none; b=u27IcwDxRwGix+xFEP+tTDppyDOHQ0TkxWwJwmTlH+HPOKrAKLTPBrOq+iom23QuHNhXDWfqseuyfFtEUltkzFUvYHTYDt+wU0qQOwpEz1zfHsjEH9LINTKi4NPQE9Fjm32BniLpclWdS6/XyiFwSedwcKDnVTxGVt78hA4w/Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730385464; c=relaxed/simple;
	bh=SOK0D9Bxmz/UJrDpU7w2brGnJr5eskwXFVdlVaOCoWI=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gr3PtWNW+nmzj5JpfTAQW8JfcEcsZN40WmB11oIyFOrvFKyqVwt7y0581MJCcBtNWtIy2t+/AaMhrkKH8Rpt126aC5QVAS/H7wNmnJVjnDTiz/DpedvzpiZpMcmU2y8KbiuLLQoAvWZhZ3Tp/uEyROr6j51NsuAR4wumLtK1x2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1t6WIq-0006pJ-29; Thu, 31 Oct 2024 15:37:36 +0100
Date: Thu, 31 Oct 2024 15:37:36 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
Subject: Re: [nf-next PATCH v3 06/16] netfilter: nf_tables: Tolerate chains
 with no remaining hooks
Message-ID: <20241031143736.GA25657@breakpoint.cc>
References: <20240912122148.12159-1-phil@nwl.cc>
 <20240912122148.12159-7-phil@nwl.cc>
 <20241031140104.GA21912@breakpoint.cc>
 <ZyOR-X0c6ToIR90y@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZyOR-X0c6ToIR90y@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)

Phil Sutter <phil@nwl.cc> wrote:
> AFAIR, we did just that in the past with such cases. I agree, it pretty
> much breaks any efforts at making the testsuite usable with stable
> kernels.
> 
> > Should the dump files be removed?
> 
> Maybe "feature flag" it and introduce a mechanism for test cases to
> revert to a different dump file?

What could be good enough:
1. fix dump files
2. add feature flag, if feature not present -> exit 77/skip to elide
dump compare.

Would you explore this?
Thanks!
