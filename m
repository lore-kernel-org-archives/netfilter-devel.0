Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6977EDD
	for <netfilter-devel@vger.kernel.org>; Sat,  9 Mar 2024 11:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709984677; cv=none; b=JmRm/DtZmRkOQgzsPOrG8v7lc96KVfBwxM/YtvMda17pjsdr2KEMtjJcHHqk3JDwzUIadKaToa5OxyXQTmu6RYXKdnmcyJxJWsLLQF9RW7WPRYO71piuFNqyx0ND/tLn10f21Gc/JrKxH3Zm7ECz87+RnsW/6MeqLdiBbgr0B00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709984677; c=relaxed/simple;
	bh=tJdD/JxrzhBAMc6CgcXZ7iI14n50U48Q56EPgRVzDTU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ITZuAqkayUT2Ai1u2KvOW0NY7RNrJ+petmuCGycXMgULo5lEiy50L755t1+yuI3HIC8AufWmVLSqvgO0QWZW8MP3pWCZ6OUPsmY74uiqC+LFGnQc0mKBKlrNH3MP22ekkypgrVyO+LSYiWwC4HvLuyYI4vUmgwVWRvbbQSN/rps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=oO0qZyC4; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="oO0qZyC4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=dFPBFi13QeUO7zBFOQ7QH8/xc+XFzsimdHvoJkDtqyk=; b=oO0qZyC4JVvcX9bYTVPwKJoBx+
	peczOiJoBUKnBj0nPPmCBXPF1fnHQ5apRFE+aeu/On0ioUedrkx3xRZ1TYBCPIIJwzxZ4eBcUGEG/
	qEmVBzJIrF8yVHbOWU7gScExaTsLXTtNb657Z2aKyS3s9X2wrWBOLbZ4M7wtLuXU6M0tJCQ6gE31v
	uwJlA4pJJvvBCgB0xPc6oJParHtoK9wEFFenne2nZRa3FIn+ryf7PEFVIcb1Jc+ZkLKnTyEUOVo2N
	+XTRdk6SP7wQ1ynjXZlYla3dTj//Q1jN6C29g25PT2ep5l3yxQuMk86HIUkK7Zqev0QSEPHRaJoW/
	hwKS6NVQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1riv7y-000000003qO-03XE;
	Sat, 09 Mar 2024 12:44:34 +0100
Date: Sat, 9 Mar 2024 12:44:33 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 1/7] tests: shell: maps/named_ct_objects: Fix for
 recent kernel
Message-ID: <ZexLobZhl9KBOcKM@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20240309113527.8723-1-phil@nwl.cc>
 <20240309113527.8723-2-phil@nwl.cc>
 <20240309113920.GP4420@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240309113920.GP4420@breakpoint.cc>

On Sat, Mar 09, 2024 at 12:39:20PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > Since kernel commit 8059918a1377 ("netfilter: nft_ct: sanitize layer 3
> > and 4 protocol number in custom expectations"), ct expectations
> > specifying an l3proto which does not match the table family are
> > rejected.
> 
> > -		l3proto ip
> > +		l3proto inet
> >  	}
> 
> This can't be right, the kernel must reject this.
> 
> 99993789966a ("netfilter: nft_ct: fix l3num expectations with inet pseudo family")
> 
> was supposed to fix this up.

Ah, thanks for the catch! My testing VM currently runs nf-next kernel
which doesn't have that commit. :(

I'll drop this patch from the series.

Cheers, Phil
