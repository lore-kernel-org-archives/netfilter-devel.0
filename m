Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F5030C62D
	for <netfilter-devel@vger.kernel.org>; Mon, 25 May 2026 18:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779735549; cv=none; b=WltWVThBtEBgwd095kX01JW84eqXUgq1PRkEIDMqntd/4bcKA2GY+gtIpnv0fkh3GFXmFiHCCJq9nMgb0m3uUA7ZwCX39bGcEqY89tNyUvmvSnyoW77RjCuerWBNjG7w7UG1AIEq38SxYumgdy1anpkXpS6D2Fb9DhoRKBtVvUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779735549; c=relaxed/simple;
	bh=KlCweyRzsHZfvYV85nhTDd3KTKV9JsTCXZtxpxJK4AU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cr4RG4YUiiVg5h9ukhAXuQ5FvhyXY0k6N1t7BpauF3Il1KrpKvKyzXgNGm2H/v69nnxRUpq1PrZab2KFeNnEXCDTn5qJXcG1v6pmvh2zxTZ8Wzr79L80EqJkfje7mxdFMvYZceTiL56FrTiaDMb4NRRsYDlOXI7Ne9+0ciiayKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E253D609E3; Mon, 25 May 2026 20:59:05 +0200 (CEST)
Date: Mon, 25 May 2026 20:59:05 +0200
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	pablo@netfilter.org, phil@nwl.cc
Subject: Re: [PATCH 4/4 nf v2] netfilter: synproxy: fix possible write to
 stale pointer
Message-ID: <ahSb-UU8n9o1aHoI@strlen.de>
References: <20260525124450.6043-1-fmancera@suse.de>
 <20260525124450.6043-5-fmancera@suse.de>
 <df64cebb-1279-4e66-afa7-3d8ffca4928f@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df64cebb-1279-4e66-afa7-3d8ffca4928f@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> On 5/25/26 2:44 PM, Fernando Fernandez Mancera wrote:
> > skb_ensure_writable() is called to guarantee that the TCP options area
> > can be safely modified when adjusting the timestamp. As it expands or
> > linearize the skb head it might reallocate the data buffer.
> > 
> > This makes the th pointer passed by the caller stale. The following
> > writes to the TCP header might be done to a stale pointer.
> > 
> > Recalculating the th pointer after skb_ensure_writable() prevents this
> > issue from happening.
> > 
> > Fixes: 48b1de4c110a ("netfilter: add SYNPROXY core/target")
> > Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
> 
> LOL. I just realized I already reviewed this at:
> 
> https://lore.kernel.org/netfilter-devel/20260522104257.2008-3-fw@strlen.de/T/#u
> 
> *facepalm* sorry for the noise, Florian could you ignore this patch but 
> consider the other 3 fixes?

I know its tiresome, but would you mind sending a new version that also
fixes up the other things pointed out by sashiko?

https://sashiko.dev/#/patchset/20260525124450.6043-1-fmancera%40suse.de

In particular, seqadj and concurrent registration.  As these bugs aren't
as severe as patch 4, I think nf-next would be fine as well.

