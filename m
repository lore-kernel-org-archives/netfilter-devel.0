Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C6E37F8CC
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Sep 2026 13:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789565300; cv=none; b=UtLodiS6X0vBZORgkDEXyYegbWqDQl7yG8NOE4R1WAb8rEiXXqct9yOBwxzsfYmWyTcqLoIBgfU21PUnyZB3EO9FeRPhc+nN4uE2HtKDb+MaRGtF9rJOZ88ttXGCNqp4P9nidZoOoDxuZ4DN2k2Nuoi+2MGi9GO7oQuJHtamnFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789565300; c=relaxed/simple;
	bh=2ZTaS7Da3jgSsjtHKJAYkfxE6JpQdlysYBwVPPKQouQ=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VQNszNYRFshXLpRNGZ78q2deMSsOCLFN8mq929jaCSQ0HChRkui+P7lfvOnhF491Jatjt4KIK+SMSE2OZ0xBxzuUewRLQHBgUtPTK6JDTpBGL8/d+l/nVHsJVaUvNr6/OqIvoDvIVMSTdo48JCe9/lRQ44iK7dHeBUkBek5xv9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 04CB760456; Wed, 16 Sep 2026 15:28:16 +0200 (CEST)
Date: Wed, 16 Sep 2026 15:28:16 +0200
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v5 0/6] ipset: replace internal hash table with
 rhashtable
Message-ID: <aqqZcI0loN5OPmA6@strlen.de>
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

And to add: No longer sure its worth the pain.
