Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C96495ADD
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Sep 2026 21:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790629729; cv=none; b=gu3+tQ1zvUtP9Gk0F3upP36WOMYS/nbknZACyLTlu23XN0dCXRhrw35qYDducPFgOfGw+iWPKfqYBm4Hq2f95cPH9cKJKHOQyoKe9NbNQ6F4HGaZML4OI24akLLuSBv/Gx7jyZH+irf7vle8sihEYkmg/kB1QV2y2x/ezPiafao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790629729; c=relaxed/simple;
	bh=NGQLwVM3Y/SRPoh9ayTniPJYcVpKpERvFUelUuMhRUU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FL1dHeHqwP27p+8x/hCFTu+wogxa8z/pPX0ORwB/9TQOlYxyNXxspIEp0jgmWpavg460lXECNeY4wO38ZHWAirfPr4KRuV2d1LllVqXvt8c6yIXdhSeeV3C6aOSdGN01pG//ve8QaDThDv+w/JAYdLlFzeTDnATaTa86VWP6sB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 377606094F; Mon, 28 Sep 2026 23:08:36 +0200 (CEST)
Date: Mon, 28 Sep 2026 23:08:35 +0200
From: Florian Westphal <fw@strlen.de>
To: Matthieu Baerts <matttbe@kernel.org>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>,
	Netfilter Coreteam <coreteam@netfilter.org>
Subject: Re: Netfilter: match "tcp option" with the same type present
 multiple times
Message-ID: <arrXOOODs-EeMnNC@strlen.de>
References: <a391d81c-0bce-41e6-886e-a558765c6891@kernel.org>
 <arpn7_v8156iSc85@strlen.de>
 <cc29ad91-bb10-4b82-813b-2acea5dab3a7@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc29ad91-bb10-4b82-813b-2acea5dab3a7@kernel.org>

Matthieu Baerts <matttbe@kernel.org> wrote:
> Yes, or with a raw payload expression with NFTables.

If you expect identical layout every time, yes, that works too.

> Should there be a note somewhere in the doc about this limitation?
> Because it looks like it will never be possible to match such subtype.

Yes, not without extra code on the kernel side.

> There are other MPTCP suboptions that can be used with DSS, e.g. MP_PRIO
> and MP_FAIL. But also MP_RST that can be used with FAST_CLOSE.

Right.  I did not consider that this stops at first mptcp option
encountered.

> > passes here.
> > Even tried adding 'tcp option timestamp exists...' to the test, also
> > passes.
> 
> Arf, my bad, I still had debugging code, sorry... :/

Phew :-)
