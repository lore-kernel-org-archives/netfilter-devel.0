Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A5C3126C0
	for <netfilter-devel@vger.kernel.org>; Wed, 13 May 2026 14:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778681625; cv=none; b=BP+tFnNmYTdvw7FzDOnDzYy0tIr4t/Tf8xab/lsC2TSHTGK5aA1Cf/VlRu4YmGBZGDAtlovn0ec6eRjC0XfL3jOwirDj2GsohkLq1srXagNoLaH7TuBOTWzXGWTaLp0ZNKbFIBkWybojTz01h0LCQBnLLErwJ2meKUMFdd3VGw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778681625; c=relaxed/simple;
	bh=ttzpDJhVmpyNGB2eMU89VmfUuWsmFT/BiZg0U5aoIRg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WHaROOh5KH2VjzWU0F1ZStI3ketCGjltnuc2PhHnpB9YM7K/oFSPehnsydf//yjzCMlet0ohyJh/+Xe0bQQhaR8Oc63WzzXlPhYiyqPJVPhK0hbSHokka7krzOuQNTdRm8AbgitXi3r/S2YDi+fkM2gLZLoIv1L3HVTbxhX/e1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id EF04E609A6; Wed, 13 May 2026 16:13:40 +0200 (CEST)
Date: Wed, 13 May 2026 16:13:35 +0200
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, phil@nwl.cc,
	pablo@netfilter.org,
	Alejandro Olivan Alvarez <alejandro.olivan.alvarez@gmail.com>
Subject: Re: [PATCH nf] netfilter: nf_conncount: prevent connlimit drops for
 early confirmed ct
Message-ID: <agSHD2ZVclEeKSJC@strlen.de>
References: <20260513121547.6434-1-fmancera@suse.de>
 <agRygM7hHtKs8jQB@strlen.de>
 <7fbd428e-93b7-4e17-8360-5434f0d1f6bc@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7fbd428e-93b7-4e17-8360-5434f0d1f6bc@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> About IP_CT_ESTABLISHED, I added it because it was not clear to me that 
> IPS_ASSURED_BIT is always set. I guess yes for TCP/UDP but what about 
> other protocols? (Are we supporting other protocols???) Anyway, I have 
> tested it and confirmed that for TCP/UDP it is safe to drop it.

SCTP is the only other relevant one for this use-case, I think.

> And please note that the idea is to be cautious when returning --EXIST. 
> If IPS_ASSURED_BIT is set we can for sure skip the tracking BUT if not, 
> we run a GC skipping the skip optimization..

6 months from now I will no longer know wtf this assured check is
doing.  Please consider rewriting the existing comments so that this
makes some sense.

> Is it that bad? I mean, it has some back and forth and I apologize for 
> that but overall this is fixing some real use cases.

I know, this isn't your fault. Conncount is used in all kinds of cases
that it wasn't designed for and thus we have this esoteric breakage in
first place.

No way we can avoid it.  I think your patch is the best we can do here.
