Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09BE423372C
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Oct 2025 22:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761861752; cv=none; b=G68P+Ev87FZ7X5GJ0N0P7odlYuNysx58cAuqkSSpJ+tfNOY/lC8bvaFQVEESYItc6w9r4GTdnchWNxpUZpHcYwWRUnregLwo9H/HWoOQNPYRpSSX47JCwJfyDrj+KaEk2HpTJaVFlsGwtZVaeAQPgg7T8y1bo3SPzYlvZpqNUVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761861752; c=relaxed/simple;
	bh=48X0wkEaCPylgLH63AuB+rk0ixxL50uMO0tDKD102oQ=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iThdMMTwKGEYjxnHzVdUGxIBWN8oniKgJcDTZzq2Ej5/gYvd+G1iFSZ3b8YqGCnMk5081ijWprUkwHf/GZkNeMn1HSMFEQumIplaWc9fiQNTxuuRomi4SY83AA1yLV8dhsgVjUHatnsaVegT9VXniW7BaOcm1o9/f4DR0AaM7hA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=e+AW6aki; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="e+AW6aki"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 29E0760253;
	Thu, 30 Oct 2025 23:02:28 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1761861748;
	bh=U33mjWKSdHmZa4H08auS6PGNvlDZkPq4MC5WvIzFH18=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=e+AW6akiaHBMDeMz7fHoY4PGxXMQcSSy9RCMZH2p55peaMZ068m9S1+fN2U7m6LU1
	 IgLOierwnfYz51TGycrRqBandGg3LPnFEnoKqAf2S2ns7ccplZFHAIGlK2JZ8eLYtf
	 swUEXvUY1JbKf2qgcHeJ9azV/mxZCBKPfhXMtcThZ7LHP9wjpMcWETDt0uzVapQ68W
	 D3ZNaZJvyqmtLn92VB7NUNNfWvcqBHtXJDhT7wYH6aG1CPM3iZKpfTagWjIaeApSPG
	 Kpc3PXPY6Gq2jZBTc//kps/X0CpNGwnj81D77zSLoNeKY/JMSfWkBT5aORcjnsIXRz
	 jrIGE2y72sLVg==
Date: Thu, 30 Oct 2025 23:02:25 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 12/28] netlink: Zero nft_data_linearize objects when
 populating
Message-ID: <aQPgcSO75pz3iCxE@calendula>
References: <20251023161417.13228-1-phil@nwl.cc>
 <20251023161417.13228-13-phil@nwl.cc>
 <aQJe44ks8cDYQcBC@calendula>
 <aQNHJhDYPIqPMXh5@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aQNHJhDYPIqPMXh5@orbyte.nwl.cc>

On Thu, Oct 30, 2025 at 12:08:22PM +0100, Phil Sutter wrote:
> On Wed, Oct 29, 2025 at 07:37:23PM +0100, Pablo Neira Ayuso wrote:
> > On Thu, Oct 23, 2025 at 06:14:01PM +0200, Phil Sutter wrote:
> > > Callers of netlink_gen_{key,data}() pass an uninitialized auto-variable,
> > > avoid misinterpreting garbage in fields "left blank".
> > 
> > Is this a safety improvement or fixing something you have observed?
> 
> Patches 19 and 20 add fields to struct nft_data_linearize ('byteorder'
> and 'sizes'). Having these memset() calls in place allows for setting
> (bits in) these fields only if needed, default value becomes zero when
> it was random before.
> 
> One could avoid it by making sure the new fields 'byteorder' and 'sizes'
> are fully initialized by called functions. Are you concerned about the
> performance impact?

No, I just was expecting you clarify in the commit message that this
is just extra-safety initialization that is not fixing anything,
otherwise it is not obvious what the intention with this is.

But it is too late to discuss this now.
