Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9E182BE031
	for <netfilter-devel@vger.kernel.org>; Fri, 17 Oct 2025 09:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760693971; cv=none; b=lfxri7tj/oi/wBF9ZoE9N6WzZlHMIhoO4gcfx2VD0q1m9WtrlN9k2zYqCCZo8rl8Q2Dcje6PKKpjVbk6gofvOrnGGozcaYIREjMY1lCewFEn+bm3QVmQg2W/1wJFGqLYq1C6B8lo7hmz7t9yL2uNeSkPFPBAaoazELD/lBnDFOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760693971; c=relaxed/simple;
	bh=WoDYtXJZedoP5wjFy9N1G1CriQV7nqsMfRoLtdAM0AA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dszOfIUaNi0WvP2+wOeZptmAEs7Bs7huttCOmeH9YNRSWcWyDCIMViYTY2B298ZLdxeb74zhrbCwYqVaHRcbxAlZsJ4s5UeGhiBcnwSxhiagwmx76jv/ke7o/IAsMZqBFmI9FCvHmFoD0XJN3FjdXAQ5KWjirFHToWHalmhU9us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 4564860324; Fri, 17 Oct 2025 11:39:26 +0200 (CEST)
Date: Fri, 17 Oct 2025 11:39:21 +0200
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 0/4] nft tunnel mode parser/eval fixes
Message-ID: <aPIOyXFJPEPOfX9m@strlen.de>
References: <20251016145955.7785-1-fw@strlen.de>
 <1d7b09a6-c2b1-4fb8-be84-af0c4f1fd1a6@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d7b09a6-c2b1-4fb8-be84-af0c4f1fd1a6@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> On 10/16/25 4:59 PM, Florian Westphal wrote:
> > This series addresses a few bugs found with afl fuzzer, see individual
> > patches for details.
> > 
> 
> Sorry for making you waste time here. I will follow up with the 
> improvements mentioned on the other emails.

No time wasted.  I rebased and retested the fuzzer patch
for nftables so it was good it found some stuff :-)

Thanks for reviewing, I've pushed the patches to nftables.git.

Also thanks for following up with better error messages.

> In addition, I want to set up afl fuzzer too :)

Great, I will send the patch in a few minutes.
