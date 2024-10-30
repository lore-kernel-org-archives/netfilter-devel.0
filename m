Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B08EA1E3DF7
	for <netfilter-devel@vger.kernel.org>; Wed, 30 Oct 2024 11:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730289143; cv=none; b=PTOABlpQhapBR8+XXLMWNZmby82Qj7NBh1B+Nn6tx8OUOKwWufN1VFRrRx0E824RgwJYRyuShSoB65uzSUi4VvtnvSRU7XV+2Tbxy/mfTbU0XNuQ1yVueepPQHVSxNu9+WR4spkea3U2uJEAQjQly6IY790GLLWDkw5ap2SGQrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730289143; c=relaxed/simple;
	bh=d1uqlkkE7irV/O5RghYCxCan9DjPyX9cGQxziWrzlQQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nfHn87KrKLih6v8rZVy4WGE3cYvgUbucf5B9D4rWVcMPooSnKNm0BKKn2r0k8HsGpVK60h9VCEyNZW8Cj3UorXrzCUdeTEbmdgPzkG1yldA5h/1tNeiS3qHePFjgOwLIuqSLVbhjUUs4bumOt5hsz+LHPNm2KpJgfZJrRZhuVrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=dRXWMCsT; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="dRXWMCsT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Q2q2PHkWKcU2z7eFU6L47fOwHjIXczlQ21srhgQuqns=; b=dRXWMCsTRLhunURpvSxNgqipc+
	70tCFglHWQn1W0a7QLSyFzULV3nWKzsNNrwJiO47p6buWD3j30gNd1pRa+R7vqIj73gC0VPlt5jJ2
	cMNKWQm01vEH/4ETwnCPWErNru/y8SJmPPbpmGsIDYqA64xygKGTPWw2n88euNC5JoXBt7kiERykP
	ywHfJIWlc+jQzj24D7lFH+YviHBCOmJRSkTusziyxtC95djDMB0y5B3bo43WhGG45/mNH55nYilj6
	BUq1eUg3+JS7fcq4dF+UgUkaWTwnIpO8+aODSTRbKYk1WtmQVJIPJcfM924RFbxgv4MPvOgE143MP
	on+jV7wQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t67FE-000000006pN-3TGy;
	Wed, 30 Oct 2024 12:52:12 +0100
Date: Wed, 30 Oct 2024 12:52:12 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Jan Engelhardt <ej@inai.de>
Subject: Re: [libnftnl PATCH v2] Use SPDX License Identifiers in headers
Message-ID: <ZyId7EGcFpvVyDNc@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Jan Engelhardt <ej@inai.de>
References: <20241029222622.25798-1-phil@nwl.cc>
 <ZyIX3MpPKPT2t_Zq@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZyIX3MpPKPT2t_Zq@calendula>

On Wed, Oct 30, 2024 at 12:26:20PM +0100, Pablo Neira Ayuso wrote:
> On Tue, Oct 29, 2024 at 11:23:04PM +0100, Phil Sutter wrote:
> > Replace the copyright notice in header comments by an equivalent
> > SPDX-License-Identifier string as separate comment in line 1. Drop
> > resulting empty lines if duplicate or at the bottom of the comment.
> > Leave any other header comment content in place.
> > 
> > This also fixes for an incomplete notice in examples/nft-ruleset-get.c
> > since commit c335442eefcca ("src: incorrect header refers to GPLv2
> > only").
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> 
> Reviewed-by Pablo Neira Ayuso <pablo@netfilter.org>

Patch applied.
