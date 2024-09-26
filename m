Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5D3193408;
	Thu, 26 Sep 2024 10:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727347072; cv=none; b=qtRHyM2pCVRDU+WXfYBzFJPhcw/0cNCLeJ/dcjlDuk0E7Sk55az8unkOObYbJTf78GaVhG4oIH2eq7JAOz78wScNFS5NoKm83rWADkcP3FzQd2RXQuMivuxaVuPM+bWlawsP49kT00vuKdj6hGUMsZtu80lb7kbMnt/cLwHCZ5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727347072; c=relaxed/simple;
	bh=X2vBJFY0hZPFCJ6keS/bJM+c+/s3iDB1KXj9JppfoxQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d5CPeiZVY4CNM25Dex7hI9/EAK5CI8eZnLStWxaKRSCeEmBYsMIKL7l5xNaOjYTI4Bw6kf7MMUeEdVKD7jFy2zct3WIbyaUx7LvhkTzP4YogcxGsiZXaK6XyvE5jUU/mX9BfdxsTpHQfHiN9YTrszhNChnuMoHnMOXLOSQ8Amog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1stlsP-0004G6-44; Thu, 26 Sep 2024 12:37:37 +0200
Date: Thu, 26 Sep 2024 12:37:37 +0200
From: Florian Westphal <fw@strlen.de>
To: Paolo Abeni <pabeni@redhat.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, fw@strlen.de, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com
Subject: Re: [PATCH net 00/14] Netfilter fixes for net
Message-ID: <20240926103737.GA15517@breakpoint.cc>
References: <20240924201401.2712-1-pablo@netfilter.org>
 <c51519c0-c493-4408-9938-5fb650b4ed8b@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c51519c0-c493-4408-9938-5fb650b4ed8b@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Paolo Abeni <pabeni@redhat.com> wrote:
> On 9/24/24 22:13, Pablo Neira Ayuso wrote:
> > The following patchset contains Netfilter fixes for net:
> > 
> > Patch #1 and #2 handle an esoteric scenario: Given two tasks sending UDP
> > packets to one another, two packets of the same flow in each direction
> > handled by different CPUs that result in two conntrack objects in NEW
> > state, where reply packet loses race. Then, patch #3 adds a testcase for
> > this scenario. Series from Florian Westphal.
> 
> Kdoc complains against the lack of documentation for the return value in the
> first 2 patches: 'Returns' should be '@Return'.

:-(

Apparently this is found via

scripts/kernel-doc -Wall -none <file>

I'll run this in the future, but, I have to say, its encouraging me
to just not write such kdocs entries in first place, no risk of making
a mistake.

Paolo, Pablo, what should I do now?
