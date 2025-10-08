Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1348242D69
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Oct 2025 10:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759919982; cv=none; b=GeasKkIkmpnoivlDoGXM91BQrcOkJgWTw0auL9A8YDKmNLN7a0CTgnBPg0B6mVNUQZOeHVZurIJgH0E+wteSNOfRsP4wKiVIA3HKrR0Z23TqkgICr21LtmTPyOvODN7ZaZ6jhTgdTZtSEPD34xQc+ft/68BbauZLKGLEaOHNUCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759919982; c=relaxed/simple;
	bh=A1VpIUOJfL4YFA7IZPSCPUoofuEZ8MsOjKmHttFisUw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SiprWVBwiO0MH0WcShsRsMSaqQx3F2TJDTvr1pBOrxvEF26a82kyoik+/LSDSzukXQVwNuq/7hDU09Edc6/FCA3vyQYElovluTRbWM58j9m/rU2AcWnZAsVNDXYi6d+G2+qK2wMeeQBhYA+dtilqdneJyTWUXSe87/2Kwz4i8R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id C45F3602B1; Wed,  8 Oct 2025 12:39:37 +0200 (CEST)
Date: Wed, 8 Oct 2025 12:39:37 +0200
From: Florian Westphal <fw@strlen.de>
To: Nikolaos Gkarlis <nickgarlis@gmail.com>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, fmancera@suse.de
Subject: Re: [PATCH v3] selftests: netfilter: add nfnetlink ACK handling tests
Message-ID: <aOY_aaXGr0E2WvSs@strlen.de>
References: <aOJZn0TLARyv5Ocj@strlen.de>
 <20251005125439.827945-1-nickgarlis@gmail.com>
 <aOY8UolnTfclgU40@strlen.de>
 <CA+jwDRmj2ZEjzByADXRQ1JGySqyHEZi9=Hr3mGCiOcM+LUgV9w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+jwDRmj2ZEjzByADXRQ1JGySqyHEZi9=Hr3mGCiOcM+LUgV9w@mail.gmail.com>

Nikolaos Gkarlis <nickgarlis@gmail.com> wrote:
> > ... and a few other nits that should be resolved too.
> 
> Apologies, I will submit a new version ASAP.

No need, please wait until the discussion has completed
so we know if the selftest can be taken as-is or if it has
to be adjusted (no-batch-end-ack-on-error).
