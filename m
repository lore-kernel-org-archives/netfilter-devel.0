Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811882D9ECD
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Jul 2025 12:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751633824; cv=none; b=q5Ai/fK6Qs1hP/TMovzwx3ySW4U6wdn8vyfRln8Z/oLIlQeZoSyFzVrG+hsq4faDkXdWdCGHOnKZStBTH46ifGy6aGbrgwv1p3YSHl1fsBbybcFf5iCcKatUyh6mY3fQ1fFvAucbk4SNwvI8nONiysb10EGtQQ5PaRL/NSWIIDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751633824; c=relaxed/simple;
	bh=NiWIqQEtTK/SRqUSRiETg4XgpkHAUpaiTBBm7OS0zaE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cv8jGwCTsakZIyC7GumtHmiP1tE8MB64aXJvLgGPRISAS95CjDFXjC/sKms0Utg3modiw1HFFtwpdM8kN3Q/AlnHAeAJKOTl6MDWc/PDjyclHVCalnDO6zK6eILqPnN0ICHs0hTphQ0ZHnXu3N6fpv3q6PrnXLQyLaVl589Ks3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=HIU4oyy8; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="HIU4oyy8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=g/C5hTri53IR58cTnu1BxTAsH/8YoIfTR4NKtiE0NCo=; b=HIU4oyy8gUDobOAwRHDAYE1wHH
	ztjx1HHkSS4xTBYUSN/JcyLMW55XEYxypBS28omlcV6g6+lPYrBReWJZHekR9GaetnCC9D3qvXqYw
	/Y+xxb3TzzwxDIMi/JSPPSNSn+aT/2p3K+aM9s1tT3GaO8UizTOdcK2ReS0sRqvcY1r+5LmjZEeJJ
	TlPojvfIVmbX++YAeBKXNEQOr1okRh+57dQLAKTCfYLX4dMizjC+WZhwRTzaCiZO6gGtuO3gdbUb4
	Jnv1Svd5KmHRrCnApqzFEzdW248xNEZMCb/y/yUILb57mdBfgwnBU+7gDFAg4VFQVceMHecyp7rR2
	CJj+tIzg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uXfyO-000000001Pu-38Mu;
	Fri, 04 Jul 2025 14:57:00 +0200
Date: Fri, 4 Jul 2025 14:57:00 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] extensions: sctp: Translate bare '-m sctp' match
Message-ID: <aGfPnIR90h-FQL65@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20250702144741.2689-1-phil@nwl.cc>
 <aGeRWYyd9clH9-A_@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aGeRWYyd9clH9-A_@strlen.de>

On Fri, Jul 04, 2025 at 10:31:21AM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > Just like with TCP and UDP protocol matches, emit a simple 'meta
> > l4proto' match if no specific header detail is to be matched.
> > 
> > Note that plain '-m sctp' should be a NOP in kernel, but '-p sctp -m
> > sctp' is not and the translation is deferred to the extension in that
> > case. Keep things stu^Wsimple and translate unconditionally.
> 
> Reviewed-by: Florian Westphal <fw@strlen.de>

Patch applied, thanks!
