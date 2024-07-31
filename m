Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F9F1A4B49
	for <netfilter-devel@vger.kernel.org>; Wed, 31 Jul 2024 07:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722410095; cv=none; b=kYrCIjz/yAtUdWNjRI3xYIFIC7ftRfwJopJgAiGHcliOweK/L9wra/Q91q9iB3TblqZbv6ogRcIqsTo9OyCzscUVhfd/fzemuZ8IseeW6XKDGX5PCffL6u/YjFel5gTDe2nwjeAWKeq7pGHDU7zeyO48KrFjqM0QjRZ5cDydaI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722410095; c=relaxed/simple;
	bh=CKDFy0NhGW4sYEAHVJLtFwwtFxN9L5u/HJJH6MWa88E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DkohUEVsmRw9pJPdWZWZ/ctO6k3DIZ8TPN5NYJ2R3AiwlVXSOWtrRhw0RYD2m5H/Xs3gwRUQw5dODRq7ncvuCbrAOocVQ74/D/sIwSu1wJWlM5t1IJLw8L9BurVdMLSrRkPSCvlemYPQoORyRMg6B6gYulD0OJgWoKFjlz4TjJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=B9Xi7MHm; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="B9Xi7MHm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=7uDkCcwt413s1YYR7gNqhaHo9kCWSwzCZsED94qNQ6w=; b=B9Xi7MHmMwCqrwRIaObakWXXtL
	K+0M4Iw/VvxdPBY5fZy6hFw/FlwbZtZQbkS5MHRZQ8+EqnnjaZeu5rnHl2xHMPRRJEjE1CdUFHjUp
	KbsdReU+KCFD7mSD8a6x4EoRXF+P5qVsBg4ssk/FDcVV7CyvfES81dITD5FobnvkXampw3RI87s5p
	eYtjDIAnKUkSYoJyAf4IEYmPLsWtHMxn6KUONT0tBLHC3mRTKvseKZT3XCRV21gDzV9vt4LhGnwfj
	tQV+lrihK7i7SvuVB22Co7Lt6O53P3tYEpQDep42vTzAz1MZ6SnrjSFkKk4tuTbdcBD0vRU96qk2I
	/XsdTsYw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sZ3Xo-000000007VB-3Uv2;
	Wed, 31 Jul 2024 09:14:44 +0200
Date: Wed, 31 Jul 2024 09:14:44 +0200
From: Phil Sutter <phil@nwl.cc>
To: Danielle Ratson <danieller@nvidia.com>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, fw@strlen.de,
	mlxsw@nvidia.com
Subject: Re: [PATCH libmnl] src: attr: Add mnl_attr_get_uint() function
Message-ID: <ZqnkZM1rddu3xpS4@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Danielle Ratson <danieller@nvidia.com>,
	netfilter-devel@vger.kernel.org, pablo@netfilter.org, fw@strlen.de,
	mlxsw@nvidia.com
References: <20240731063551.1577681-1-danieller@nvidia.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240731063551.1577681-1-danieller@nvidia.com>

On Wed, Jul 31, 2024 at 09:35:51AM +0300, Danielle Ratson wrote:
> NLA_UINT attributes have a 4-byte payload if possible, and an 8-byte one
> if necessary.
> 
> There are some NLA_UINT attributes that lack an appropriate getter function.
> 
> Add a function mnl_attr_get_uint() to cover that extract these. Since we
> need to dispatch on length anyway, make the getter truly universal by
> supporting also u8 and u16.
> 
> Signed-off-by: Danielle Ratson <danieller@nvidia.com>

Patch applied, thanks!
