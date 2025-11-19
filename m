Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBAFA7260F
	for <netfilter-devel@vger.kernel.org>; Wed, 19 Nov 2025 15:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763567800; cv=none; b=HRKwzQEZaRmjIwL4tlNySXmnufrMBg3CXH117tG6F0XEiJJI1PvN5PxS3mT2g61x3m7/0hLzPsYtmgEpfOYRtkOQomUTEBSj+88I6nPNqVeX+tVeUNChdAfZDGQaA/d2sKXJzmFHmAFgUz/J7DjeiWXqPmiQRt+4m4LPc5ALR9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763567800; c=relaxed/simple;
	bh=XWAmHB7Kd/2Lu1bd5ZCdkgYerdACRJAGElrfkIiDXhc=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AzTBFonTDtKSunHzwJ9irrQxzIn89Kpk238jWVPrrlAP/Yy1D3Z/5tBnMiCgnB539M5p1PCKFHeI0ZqBTtrBaLlg8xYAKwXQnkEX1S6lrDtB6kqOuRxrHjbNVZt2Vh7tp9Ytk9F0BJ7BvsB94nDEjmrS+VgXbEO3Wlrc5z9VWUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 77CD560216; Wed, 19 Nov 2025 16:56:34 +0100 (CET)
Date: Wed, 19 Nov 2025 16:56:34 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 0/3] netfilter: nft_set_rbtree: use cloned tree
 for insertions and removal
Message-ID: <aR3osq6hSxh7JwVm@strlen.de>
References: <20251118111657.12003-1-fw@strlen.de>
 <9a4e63da-6d36-4365-8c08-547961c9bfa7@suse.de>
 <aR29ddgmrjWcayAV@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aR29ddgmrjWcayAV@orbyte.nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> > 200K elements ~ avg. time insertion before 510ms after 744ms
> > 500K elements ~ avg. time insertion before 5460ms after 7730ms
> 
> I wonder if nft_rbtree_maybe_clone() could run a simpler copying
> algorithm than properly inserting every element from the old tree into
> the new one since the old tree is already correctly organized -
> basically leveraging the existing knowledge of every element's correct
> position.

Yes, but I doubt its going to help much.

And I don't see how this can be done without relying on implementation
details of rb_node struct.

> Or is there a need to traverse the new tree with each element instead of
> copying the whole thing as-is?

What do you mean?
