Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A12E754654
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Oct 2025 23:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760053048; cv=none; b=KjjNNdxF9cvxi5VQMWRDolgBh6Srn5ytddH4lwlFAcL4DHakY8AhWotDPW13Dgf+gKVmL3zaRtUYO5zI1y56IvrvuSf1tthDsYpoB1CcGmmYbXdN0LsNfKx4IKnVyarN4/JATjjMovzVYLEqTcy9iieFCpZIZQj0k/RePMYIktU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760053048; c=relaxed/simple;
	bh=/drxYU7FcXyngnONMSdrAFynA16lx+UKez0grvnfPg0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BhcH6pIALPEm+SJLsMZulNlzSPDw8KMuHtcwoGMXtAyWZ0DOuEvgEzatZOe3TK7g07L05IOxpqVnhm0wX3p8H6IGFvBFddlfLuYGAR06RI/qadslilg5MlJVn01l51enNGp3APUg8E9zfwVK9tdRp4lvoNTeBMuZN9LAEA9359c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 2D27360183; Fri, 10 Oct 2025 01:37:23 +0200 (CEST)
Date: Fri, 10 Oct 2025 01:37:22 +0200
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH nft] tests: shell: add packetpath test for meta ibrhwdr
Message-ID: <aOhHKOiWd9E18Jc0@strlen.de>
References: <20251009162439.4232-1-fmancera@suse.de>
 <315ffc1a-86ee-4173-adeb-69a4611cd892@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <315ffc1a-86ee-4173-adeb-69a4611cd892@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> > +# cbd2257dc96e ("netfilter: nft_meta_bridge: introduce NFT_META_BRI_IIFHWADDR support")
> > +# v6.16-rc2-16052-gcbd2257dc96e
> 
> I just noticed this version is wrong. Probably I need to wait until 
> 6.18-rc1 and resend this. Anyway, feedback on the test is more than 
> welcome :-)

No worries, this looks good!

Do you think it makes sense to also add a counter-hook in ipv4 input?
