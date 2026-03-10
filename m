Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CFF13B8BCE
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Mar 2026 21:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773178801; cv=none; b=vA/egD5jq2goKbOMCG4ZfNDWzZApWVmsGQLTwSMSAi/Ne6usUC5gToNDW2ZEppH+Afx8SxmbIoe1R4pRu4ju/NOi/jbIOvYkveOXwJJ/IqvAZPQATQRzmgD3KuAgAkGbQHdKE0JYnxYjY7qwiaLC+/Dm+2NPj/Xd15elkFHF8kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773178801; c=relaxed/simple;
	bh=uJS/hSfOwPP3/teZd25xjabYeXkEA2AV69sB+2/KdSs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tg9uUc30h8YqvwpnF4CgSSiSwD6sCtd+XfXdGgo6gSxiH1dmzGM7mcORtsWqR0q8vHgNgyRHi3dBzpuD7jDxMzromzjPcbzu5xOaoS3PBXqAJm7rapYLgVFTEdBL+zvajzRj+Igy7JiMzN898e7VLlzuRoCjV9ugT25shO5gKV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=GAmlinr1; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="GAmlinr1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=R8eVZ9Vtu6vwE3MT3SbErzQtgpfc4wVScMSXuvP0zos=; b=GAmlinr1hDRspP6s9WPaHzISK3
	PIekaxq700Krz6mkrUl3Hi4U5nDKzkuCZl//+g2hgAWVteua7rRA0QrGPk+envdxyqH23zwHlQyK8
	vWJNwOZJlWo8d4iNt6IXAnvOnoYP2G/21RGcnJwo5pcttl6IcdlpcdM+NUqjD6F1UFMK2CN1r5l5r
	Qls4/rdw1e0z5+EnfkdOFE1UY7GQTq2i0uTRGxXH9+4CF1CVmvXyCaxRKMJnUt6T/Mxwp7OayH3AZ
	k1QrCk5qpdnBajL3M7yP2hXgmEoADXgzOcpwCcFdn2BGQkx4HB5ArNuQl+6hPW41wEtV++LHtd8pC
	98P2TrUQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1w04o0-000000003PX-3ydF;
	Tue, 10 Mar 2026 22:39:56 +0100
Date: Tue, 10 Mar 2026 22:39:56 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] xtables-translate: Return non-zero if
 translation fails
Message-ID: <abCPrKdqjPwrjWVL@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20260310171853.26362-1-phil@nwl.cc>
 <abBWyuHDm7MT9JC3@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abBWyuHDm7MT9JC3@strlen.de>

On Tue, Mar 10, 2026 at 06:37:14PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > Untranslated parts in output are easily overlooked and also don't disrupt
> > piping into nft (which is a bad idea to begin with), so make a little
> > noise if things go sideways:
> 
> Makes sense to me.
> 
> Acked-by: Florian Westphal <fw@strlen.de>

There is a downside: Previously, you could check "translatability" of an
entire dump. With my patch, you have to drop/comment out problematic
rules in order to continue.

It is not exactly a trivial change but maybe worth the effort to
implement a "keep going" flag, what do you think?

Cheers, Phil
