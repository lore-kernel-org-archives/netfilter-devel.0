Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0808A32D7F1
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Mar 2026 11:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774007149; cv=none; b=R4yekoRaWG1Y0pUihrKKkdXeua/W77mLaL550mXYngGKDDwHADrXFol9Hpishlunl2em7PTrIr92XTCmroqx6KpZm+OBhNn7mIY12t7tEuov0aYY+clXoaaQTBUtab91+Bez0K2qKjfUh4uM8B7ev/IPmCHzRWVTctmBm3Orb48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774007149; c=relaxed/simple;
	bh=GEm5sUj4nrEbv3kDFX7nYRCQQFN58scq/V7IzQdDSTE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pi7AZZfoq8zk+9WFqwxcKkocjNh7BB2zeqrm2Z7Ic6E38LLp28kb9RMyiBPBa0OdrWNioOeEOkkojw7wakBmoNcsRzdhF8z8AEZCdiwcSopMliHomvvkJ9UgjqSPUXMLv3vH/7+Je0p+vUhXQKoIQA3C8L+BTiT30Zt8jAHIRs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D12426080C; Fri, 20 Mar 2026 12:45:44 +0100 (CET)
Date: Fri, 20 Mar 2026 12:45:44 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH] netfilter: nfnetlink_hook: Dump nat type chains
Message-ID: <ab0zaHOd9j-c0lyF@strlen.de>
References: <20260313153220.19662-1-phil@nwl.cc>
 <abwegj2TijkaQVLz@strlen.de>
 <abwraHUuxizN4krg@orbyte.nwl.cc>
 <abwtAkSF8-SmH684@strlen.de>
 <abxlzn7lymOxWUFa@orbyte.nwl.cc>
 <abyTyJBv47f3v9gd@chamomile>
 <ab0enMtOAFiG0mSN@orbyte.nwl.cc>
 <ab0rbTfE7LWIk7f-@orbyte.nwl.cc>
 <ab0tB2o90FukwQxU@strlen.de>
 <ab0u4JS4Z7THrP6B@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab0u4JS4Z7THrP6B@orbyte.nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> >                 list_add(&b->list, &hook->list);
> > 
> > ?
> 
> Sure, but <=nftables-1.1.6 will still get it wrong. Can we tolerate
> that?

Well, its a bug.
