Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3983156B81
	for <netfilter-devel@vger.kernel.org>; Wed, 14 May 2025 08:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747210768; cv=none; b=pyTCYIiml2BVet0rB79vVZBGzZcxgiTKO4pHtLhJVIKlwDGGcoZgb2AGmZwKutV8hr6Xm4gXGzKrd5gkOsB0uc/Ou8rsByAYunwuLqNcZDSEMv3g8PZhg9W/JMiab4/tQvff7gYdWtNFCFJkYdDXKmsaz2SQkKuXb9uZIfi2y1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747210768; c=relaxed/simple;
	bh=FIOhBPl5qWEn79zHaywgGdt3PneaU80lA78tQDcjCWo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zf3xLQ16h7aka+3Y/KbyL0H2jZPR2kUpsT5kTygYZKUsGzvM1YtrXorYJBB9tfnM12njG/hgGeAi/vaevLcS8owmp+kJNVLp458likOlHVZceetUoCoyx43sZDiqf3YqsPn/AnSHNl60nQ/Zc9A9s830BPSOqU0R1CsPuQhueRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=DhFe4W1P; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=pO3tZ6sr; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="DhFe4W1P";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="pO3tZ6sr"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 565DD606AD; Wed, 14 May 2025 10:19:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747210757;
	bh=gdT0mxlzvXifTjy5BmRL0g1g4YGD6TRAXSv9Q3N7rAw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DhFe4W1P1NBJ3Qgsn/7x4CutCi2isMpN6B5xxf+FXhIPOw1ZuD+E21MICjqauT5pE
	 kF4rfBmURN/KLY8p9T5ELtIO5E1b+Xfc1lDedARAX56hGNmIanmmiIy7R0yuintAfs
	 zLY36Ttt9oKMB78M5raBYX0B/AOzDrHKywyiDUWxyFO1e73/3qKsL0zldBNCYiHZrB
	 0LW81IRDh3OGftmHEaK8mPY3pN2LZ6KfvpsvcxZ5aM3vqL4snIJgaWpnN541tpNz5+
	 Me58OObEYDZbx3fR65M2pfJ3gpTC66tQSMl6B1KooBB15qhJfnu1DsnroWzLrK4cJm
	 EdUt/d3SfsSsA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1C1BA606A8;
	Wed, 14 May 2025 10:19:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747210756;
	bh=gdT0mxlzvXifTjy5BmRL0g1g4YGD6TRAXSv9Q3N7rAw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pO3tZ6sraXpO4zRJNepyRFmfIku1wOsyEjAHCxE5cRucMC1uQ6McrambN5msd69xI
	 +toSjSB0dhP110dhXBPdGTucH1BYt66787aC3nAAbmXV7Qlw8/RvOXLuhpBWc9Rl6p
	 6gEB3XOdEDX3MHMjLd4rxQxroyK/Xqqg6sKOnhcA2L+V6uxczT0JJ/7VPFk9rL7+lp
	 TAU6AcHmP4eM5o4Ms+D0g4DkFqnm1L3Uai5BoJxCeR+E1gFd0bGPHbPRzxfPDT8ByF
	 Zhzkj0MsxV2lCs2y1PNJzrbIp2g+wC7wt4bPe3udeWD+ema6pKj0kf1e4rE6wBBn17
	 k3lRKNpwQ3s2g==
Date: Wed, 14 May 2025 10:19:12 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Shaun Brady <brady.1345@gmail.com>
Cc: netfilter-devel@vger.kernel.org, ppwaskie@kernel.org, fw@strlen.de
Subject: Re: [PATCH v3] netfilter: nf_tables: Implement jump limit for
 nft_table_validate
Message-ID: <aCRPkxvH5LCtc7Bi@calendula>
References: <20250513020856.2466270-1-brady.1345@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250513020856.2466270-1-brady.1345@gmail.com>

Hi,

On Mon, May 12, 2025 at 10:08:56PM -0400, Shaun Brady wrote:
[...]
> Add a new counter, total_jump_counter, to nft_ctx.  On every call to
> nft_table_validate() (rule addition time, versus packet inspection time)
> start the counter at the current sum of all jump counts in all other
> tables with the same family, as well as netdev.

What about the bridge family? If bridged frames are passed up to the
IP stack, then these hooks can have basechains with jumps too.

Maybe it is better to have a global limit for all tables, regardless
the family, in a non-init-netns?

> Increment said counter for every jump encountered during table
> validation.  If the counter ever exceeds the namespaces jump limit
> *during validation*, gracefully reject the rule with -EMLINK (the same
> behavior as exceeding NFT_JUMP_STACK_SIZE).
> 
> This allows immediate feedback to the user about a bad chain, versus the
> original idea (from the bug report) of allowing the addition to the
> table.  It keeps the in memory ruleset consistent, versus catching the
> failure during packet inspection at some unknown point in the future and
> arbitrarily denying the packet.

Agreed, I also prefer to enforce this limit from control plane.

Thanks
