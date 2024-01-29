Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8436415956C
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Jan 2024 22:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706566352; cv=none; b=R+Up0vMtBCfJ8420MFrBx0NOVhH3vBt7ptfrkvr9V7vC16Z1g8ITygsgXwZrrRH5/MTLhu5aGetCLd4FWv0laWiiaCBC7kFvA5ah31MdqTwMz3yCO2K3YucMKAtNRi0GxTkQxHVlXEl5pHewvh6bz5cMFhkX37Hk7Z2iC4CsOSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706566352; c=relaxed/simple;
	bh=1gzJ3ZqHegI1a77TFXAwZv77TD1mbUBwCrDATg0Hk4w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hhER2GaHQ2fzSezQmx6mqa0Zelqxf8gXL9hg638cD/fS+psnP6nepyN5rXSCblI0NGk6bzee9hRsJQCDV5P+BHF/tDqLJBMhKyqiAQt+PARNf/nexiCERxt6hK3AMVjtU1udOPy1Nizff3rU3DVYCYaPzaZddnvWozwKpdi1Idg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.41.52] (port=52878 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rUZrc-00EFsg-P8; Mon, 29 Jan 2024 23:12:26 +0100
Date: Mon, 29 Jan 2024 23:12:23 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: Re: [PATCH nf] netfilter: nft_ct: bail out if helper is not found
 for NFPROTO_{IPV4,IPV6}
Message-ID: <Zbgix0Fl6yCmGHZM@calendula>
References: <20240129190538.147822-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240129190538.147822-1-pablo@netfilter.org>
X-Spam-Score: -1.9 (-)

On Mon, Jan 29, 2024 at 08:05:38PM +0100, Pablo Neira Ayuso wrote:
> Otherwise, this assigns the NULL helper. Bail out from control plane path
> if the kernel does not provide this helper.

Scratch this, help4 and help6 are set to NULL, the existing
!help4 && !help6 is sufficient.
