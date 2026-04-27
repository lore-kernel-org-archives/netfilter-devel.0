Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0CD2857C1
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Apr 2026 16:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777307632; cv=none; b=XfL3RGkRyBmu91yMck8eC/iZEZ0bAyaab/jXdNsdJB1vKWOo/CKwW8x7pzK8hEHUyCEkdfsHaJTD9+Xv0cFQQfYw2SHs4NldptYYXpnRvORhfR/Fl13rns2vC+ENzwgAo7fs1hN2DTxfcn1KtUxnqnxE5WT4E4HZzlMnZqHtalQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777307632; c=relaxed/simple;
	bh=Y3MlRHtbpbkQmiXyz86S3OC6LiU9FCiRrC794aO2ygI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pVI7P08gVgirhZU8XCLy5yayACFsCDdlzxnDQKZYOHS9vpLQjntjva1YOHYX/DxljzZK2clizFsga8nXTxrtC7T6YKenoavcEfx6S1gJMxrAmXpEjFK/AtlJhG/AZvaDE8dsuxJW9NllKSpryqIn8qNcu9bt9Vvmuvdu8UubyDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1188060640; Mon, 27 Apr 2026 18:33:43 +0200 (CEST)
Date: Mon, 27 Apr 2026 18:33:37 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Fernando Fernandez Mancera <fmancera@suse.de>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	phil@nwl.cc
Subject: Re: [PATCH 3/3 nf v4] netfilter: xtables: fix L4 header parsing for
 non-first fragments
Message-ID: <ae-P4Sbl-0vpFrUY@strlen.de>
References: <20260427112720.5128-1-fmancera@suse.de>
 <20260427112720.5128-3-fmancera@suse.de>
 <ae-MRZ47QurmXY7z@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae-MRZ47QurmXY7z@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> -               if (!(pkt->flags & NFT_PKTINFO_L4PROTO))
> +               if (!(pkt->flags & NFT_PKTINFO_L4PROTO) || pkt->fragoff)
>                         return false;

What is NFT_PKTINFO_L4PROTO supposed to mean?
I thought it meant there is an l4 header but its set unconditionally
for ipv4.  Only the ipv6 handling makes sense to me.
