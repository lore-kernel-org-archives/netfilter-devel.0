Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA041E47B9
	for <netfilter-devel@vger.kernel.org>; Wed, 30 Oct 2024 11:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730287592; cv=none; b=rW5X8u4n2xlNpT9+89J7Uw2+S6mmUzvzLeCNEvvm3cdWF7AJrt5PU0JD/YZi6nhz6NP39P011XVW7yE7g0Ws5dPCC2LykLnBl7mrlZ2+78sRfC/mP96548G8yLug0n/N02beCFLyB0vxP7/kPt2t4Gi4xxYuh5pOVQikM7vkeoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730287592; c=relaxed/simple;
	bh=S0oj/Ocv2MMwkGnNhxRIeoq7K9qlnomouyLvKVx6/3o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=omwCFPFlxV/yzNrWFdVn9saQbV1XNbkHG9VSHEx5k99JpijG7Xp6jcB5psJ8yENpcYRptMNCJwccsAO7ofvyVTDyg1Sdj6CZDYwt6ob0WPDlCwfBky77uFpgEGXS9dvO1pFEppcDaEjJ1w91NAP8/w/nmI4HU/goiP2HySe7QPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=44102 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t66qD-00B3On-5u; Wed, 30 Oct 2024 12:26:23 +0100
Date: Wed, 30 Oct 2024 12:26:20 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, Jan Engelhardt <ej@inai.de>
Subject: Re: [libnftnl PATCH v2] Use SPDX License Identifiers in headers
Message-ID: <ZyIX3MpPKPT2t_Zq@calendula>
References: <20241029222622.25798-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241029222622.25798-1-phil@nwl.cc>
X-Spam-Score: -1.9 (-)

On Tue, Oct 29, 2024 at 11:23:04PM +0100, Phil Sutter wrote:
> Replace the copyright notice in header comments by an equivalent
> SPDX-License-Identifier string as separate comment in line 1. Drop
> resulting empty lines if duplicate or at the bottom of the comment.
> Leave any other header comment content in place.
> 
> This also fixes for an incomplete notice in examples/nft-ruleset-get.c
> since commit c335442eefcca ("src: incorrect header refers to GPLv2
> only").
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Reviewed-by Pablo Neira Ayuso <pablo@netfilter.org>

Thanks.
