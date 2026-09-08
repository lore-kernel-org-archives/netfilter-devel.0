Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A006054DAD4;
	Tue,  8 Sep 2026 13:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788873927; cv=none; b=iLBuo/GXUWSDE7ZNrUPIv7sFI6ek+HGRP10QFhAhZrmHOKEUQstPyNMXweMWzieaABDLDCR1M0lD9RpU+4tbK9hdGqjbC6IpDhCLrhXUrYVgS4lfQF4y4lhNUh8O/VjX788yFQD0XFrwgQwWopQKwNUqMk0OzhEFSt00KWcepWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788873927; c=relaxed/simple;
	bh=uN4lvdFxbED3DM91BJZNZFCBmNtJPw5u2R8V2RpYR2k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y9uH0zcn8XhMKztpyN0a9Oeu/pa/Sp7kDRtRY/yuN9hG8jDr6NqrN66vkJD3HSvG4Y6Vf1zC3ecOxA6ODD4gZNc6T4NGblkIGCfW3mb19+p7IRAoMIEx6sY74NT1rp8XhjMXSUyDoxddYLuzAr1dN7//Z3QMEXob2ZpIPbS3Th0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 5C1AA6059E; Tue, 08 Sep 2026 15:25:14 +0200 (CEST)
Date: Tue, 8 Sep 2026 15:25:13 +0200
From: Florian Westphal <fw@strlen.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: netfilter-devel@vger.kernel.org, kadlec@netfilter.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH nf-next v4 01/13] rhashtable: add
 rhashtable_flush_and_free helper
Message-ID: <aqAMuQhG4l2mMLw2@strlen.de>
References: <20260904185321.30313-2-fw@strlen.de>
 <ap-ZOyOS6j_K5gmZ@gondor.apana.org.au>
 <ap-dYotn2QqdTVqf@strlen.de>
 <ap_PlDqTNOnB0Y83@gondor.apana.org.au>
 <ap_budC8D-k4k67v@strlen.de>
 <aqACH2VVNGmgW-5B@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqACH2VVNGmgW-5B@gondor.apana.org.au>

Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > No, remove all elements. Concurrent insertion is not disabled.
> 
> So what's the desired semantics for insertions that occur while
> you're flushing the table?

In current ipset home-grown hashes:

If the insertion is into a region not yet scanned -> will be dropped
If the insertion is into a region already scanned -> will exist after flush.

i.e. no guarantee that table is empty after flush, but all
elements that existed before the flush are gone.

For the rhashtable variant I had proposed:

If the insertion is before the moment future_tbl is updated: will be dropped
If the insertion is after future_tbl update: will exist after flush

which I think is matches existing semantics of ipsets homegrown hash
tables (that I'd like to replace with rhashtable/rhltable).

Thanks,
Florian
