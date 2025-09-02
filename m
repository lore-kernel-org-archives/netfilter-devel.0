Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C299341641
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Sep 2025 17:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756832852; cv=none; b=uhPXcYY4W5qwHYD9WLw2Jh2kLC3ZMkWv2E1HX1SFxMh3bfAyAD+xd0Y6zIj535fH7LH/KwzsTQGpOgZn302MkBj0J0FrzLJg0OFCd1tQTJfsIp1DEtaZIcmzdwNR5sfzsQpxBFyHvkxDknBDk5jnID1tkpPpzXTZDQPcm2dmDA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756832852; c=relaxed/simple;
	bh=oDVkyNJOtaykOFudLohf85IYPzDF3WySjv1MB29IFZQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XmJ/jP1otXL3LzxpIGFQWF+J3cUXfNTXFpdf64o5wp9TLs5ytmq6RezE6wfU45eKco9DFRKUBtxu28dC1rgqnms6jl7t87fgc1OqJl+sOMibhP+moPXUZesSkMGm8C5wbt7eS1/C+og5i17jXJ/gvQofpW/bFnsA3kacwlxJSx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id BCC6460288; Tue,  2 Sep 2025 19:07:26 +0200 (CEST)
Date: Tue, 2 Sep 2025 19:07:22 +0200
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH nf-next] netfilter: nft_meta_bridge: introduce
 NFT_META_BRI_IIFHWADDR support
Message-ID: <aLckSg5hyCI6YJXQ@strlen.de>
References: <20250902112808.5139-1-fmancera@suse.de>
 <aLbeVpmjrPCPUiYH@strlen.de>
 <aLcBOhmSNhXrCLIh@calendula>
 <e2c78075-e3b7-4124-a530-54652910a2d5@suse.de>
 <aLcUJ5U0LWW_-Vo8@calendula>
 <aLccQ9MN20VExE-4@strlen.de>
 <3aa6619f-e085-4acb-ac47-2aeb545578df@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3aa6619f-e085-4acb-ac47-2aeb545578df@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> On 9/2/25 6:33 PM, Florian Westphal wrote:
> > Fernando, if you have some cycles, would you make a packetpath shell test
> > for this to exercise the datapath?
> > 
> Sure, I can do it. I will create a new test on selftests covering this.
> Should I send a v2 series including the new commit or just send an
> independent series with the selftest changes?

You can send the shell-test as standalone item.
No need to resend.
