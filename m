Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 134C7279DCE
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Dec 2025 21:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764626291; cv=none; b=u8Wx7gp9uMIZvPjyedIbpGYOK6HtD1NUgFvXsXU2Nj1hf8P23sPAVLb8gDvWvh6MuDYdJs7dqNJJUFu4Z7nd6gKrBaWHi08pwHeKLscFc+YBLCxEoBMvL0XhBSCcnzIuMLFe7aTxLmM2OHneRufnJg6YVmvGMMUgYFQp66ViDMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764626291; c=relaxed/simple;
	bh=fygSOAFJE+MyFjtlY0qCLrRqXg2U+Xm4oqYLYta2Mgo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lw0XE6Aed4XltI4VYBdC1whbWvDCa5Ti3iCYiN1e/lfnD1q8BUN1gdA7m1VGqVRKbgq38Ij7LtSA51KybYhqJVzV6e+tJ5X9dVHwXO/QTffExGUdEO28NRco0muIEOhkree+XJJNOQDcG+20IRgtCKN0QL18EnKSHuHiexEaEPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id C4AC360308; Mon, 01 Dec 2025 22:57:58 +0100 (CET)
Date: Mon, 1 Dec 2025 22:57:58 +0100
From: Florian Westphal <fw@strlen.de>
To: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: nf_tables: avoid chain re-validation
 if possible
Message-ID: <aS4PZsEfUC3mJZYD@strlen.de>
References: <20251126114703.8826-1-fw@strlen.de>
 <20251129012211.GA29847@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <aSpNHzxDh-nN7GRX@strlen.de>
 <20251201194829.GA8476@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251201194829.GA8476@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>

Hamza Mahfooz <hamzamahfooz@linux.microsoft.com> wrote:
> On Sat, Nov 29, 2025 at 02:32:15AM +0100, Florian Westphal wrote:
> > I'll resubmit in a few weeks when -next opens up again.
> 
> Makes sense, in any case this patch significantly reduces the soft
> lockup rate, so feel free to add:
> 
> Tested-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>

Thanks for testing!

Now that you mention this: you could try to revert
314c82841602 ("netfilter: nf_tables: can't schedule in nft_chain_validate")
to get rid of all softlockup warnings:

As of a60a5abe19d6 ("netfilter: nf_tables: allow iter callbacks to sleep")
the iterator-cant-schedule no longer applies.

If i'm right you could submit a bug fix revert for nf tree.

Thanks!
