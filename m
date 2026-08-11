Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B52D63EC808;
	Tue, 11 Aug 2026 19:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786477476; cv=none; b=V0nEggMxZ3AB2yYsLTPuqoT1KmsNNbxELQz7rhHE4eCobUxS8U3pt5NXBVO5sbPviVtbkzxyR5eoDQXKk48yrGyd5Zas7zWbid0OI3fhAWrEoFGSpSYVAtZuRmG9swoprKdu/1TxYCxaG/HgU7zlXVwlsHX9mCClObTPzldDnGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786477476; c=relaxed/simple;
	bh=gim926k0BTYj9ZgLe5B3oKTzJGH3QjSz6JJQ7Quu3Go=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p64sk1j/B9nJr3A5rI7bLX9NVv2GIfl79is41v5NlhaZRrI4m7PsS2XO2YvfhXvFuH0JQeGX7qaJuZAuuAHJbx/LGFCVGk69nV2gVUqGpjNBTFDbCmycEMISZmHQeC25pzWKK4/3nZC9pHG+7QiT3wEKbzGJw9aHLNpOIhPBu6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mCrBa47I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mCrBa47I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 151B01F000E9;
	Tue, 11 Aug 2026 19:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786477475;
	bh=gim926k0BTYj9ZgLe5B3oKTzJGH3QjSz6JJQ7Quu3Go=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=mCrBa47Iw86pH4Sv1ly4eNONmzCjaUlfgn8Ly4BZmC98huYvxeopbAWxNgHsBWVKc
	 eO/FwexruRshS+vV6Cpmr/PvTjsvSMAzcxcAD96aEHXO0VDY5CO+O+VGGdmwRUr8ef
	 jj0GPKjAg/VVROAxAEJYCMeioTSbAWmdmvuACo3MSVwnxTOALRscSC/poEOYk2AG26
	 TJmRacxajdCGf2rAbfAyUh+mwxtAnkkUlTsFan8tCXYcqf/sixLl38zwvcg/qdLEPB
	 joBshObEUj1ypnjZcu/4ZC2bX6y46bunBEtOxF+vRLL35Dj1qrtwnmBeIgWQxTkuMU
	 NHlY+qQLX4X0A==
Date: Tue, 11 Aug 2026 12:44:34 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
 horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net 00/13] Netfilter/IPVS fixes for net
Message-ID: <20260811124434.76ab55d9@kernel.org>
In-Reply-To: <20260810190621.894119-1-pablo@netfilter.org>
References: <20260810190621.894119-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 10 Aug 2026 21:06:08 +0200 Pablo Neira Ayuso wrote:
> The following patchset contains Netfilter/IPVS fixes for net. Still
> large batch for this late -rc cycle but at least have of these fixes in
> this batch have been cooking for several weeks before:

Does any of the AI-detected issues seem concerning?

https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260810190621.894119-4-pablo@netfilter.org
