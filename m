Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE21F2D8385
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Sep 2026 13:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789565839; cv=none; b=HC+43n1+enJNtfIKh92gza+/PVnme0owjcYSrI4lZr2m380Ow1QukxyD2bZSNWqlgcZlFxYvaLpOHzpA+dbhUofv+Myw1SJmykF5DdTbvOHcn7oyS6MDRRdS6Q78uWh93EI1AoZKF21eLE4SdeZaJFLJB2n7ca/rtjaWQLHB2Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789565839; c=relaxed/simple;
	bh=ZLRK81DuCBuMineVX4SMGNoKOo07CIODxoquIypC8wM=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n4j1iLHtna5i9s8vE8WltsBn9BpaOHIBiPMBUFJfUcfV4Gw/idxtiSm9fyYUHf8MJPFr8gYQBqwpXEb/MWn7HLsjc7EeLjbiLzjv0ui6tJSZCqwtYfJ5MwQ8mmyST/6J9P5VH0EU516FexgaerRzCMOhrZtJ3FseQqK0frY0j0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3AFCC6067F; Wed, 16 Sep 2026 15:37:14 +0200 (CEST)
Date: Wed, 16 Sep 2026 15:37:13 +0200
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v5 0/6] ipset: replace internal hash table with
 rhashtable
Message-ID: <aqqbiUdRKZi7QWKL@strlen.de>
References: <20260916125151.28062-1-fw@strlen.de>
 <aqqZJ8mgGIS48TJt@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqqZJ8mgGIS48TJt@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> Florian Westphal <fw@strlen.de> wrote:
> > v5: add Herbert Xu's new rhashtable_flush_and_free() to rhashtable, this
> > replaces my own version from v4.  I also dropped a few follwup patches
> > with further changes/cleanups, not strictly required for initial
> > conversion.
> 
> I hate this world.  More LLM mumbojumbo.  No idea I can ever get
> this in a mergeable state.

Giving up on this series, I don't know how to fix this and to pacify LLM
