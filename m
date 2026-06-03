Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370004DBD9D
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Jun 2026 23:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780528280; cv=none; b=MCCH6hVrfhT2c5uYp2UJMpc3fbhki/MhYeLPb2qwT/DcxBlorN6WWdrGJyx8IFQCoeGEZ/V5yIXWBW9ftMxDUtLwelLKlftAnGPZxJpkl8L7ekZ9/OXQ2pMT1MHM2nstemMQks4RrYX9i2EA7v93OW6FedCefShMUXTosD5ydfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780528280; c=relaxed/simple;
	bh=uWarN7LlTNFYGKssswnOZvPTwHs8s6uqyzQ1yQ7iIHM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b+W5H6cdPhw//trcPcIodNJBsF/rsAQ6cE8X1s5Lb489mJ3INTv6DGN+IfY3ZMuJVbkMig9CCLFlb4qbwG+0Gqixr7chmTaJBi5HS9DmaglH7nhBwfpYmAiRkr8len76YGGzz3sW7tJnHeIkH8gCI7Y0dOVChhdAmjE6p4AkSp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 58D5A6078A; Thu, 04 Jun 2026 01:11:17 +0200 (CEST)
Date: Thu, 4 Jun 2026 01:11:17 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [RFC nf 0/2] netfilter: add restrictions/validations for packet
 rewrites
Message-ID: <aiC0lYKyD5UDQgLS@strlen.de>
References: <20260527121147.22076-1-fw@strlen.de>
 <aiCrpdgRNCC7LkaA@chamomile>
 <aiCtz2nBZL1Q-gmL@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiCtz2nBZL1Q-gmL@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > If anyone is breaking with ilegals field, they should come here to
> > explain? Data plane validation might look safer ... but it will just
> > drop packets and it will take a bit more time to the user to debug.
> > But your approach is more conservative, it just leave the packet
> > untouch, so it is basically ignoring the invalid mangling.

Yes, ignore resp. BREAK verdict.

> Hm. Actually, it is harder than it seems to do this from control plane
> because dscp needs to deal with bitwise to ensure that ihl and version
> are not modified.

Yes, there are cases like those where control plane valition is not
possible.  I will address the AI comments and resubmit w.o. RFC tag.

Thanks for reviewing.
