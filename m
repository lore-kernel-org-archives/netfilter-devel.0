Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4791C6FF6
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Jul 2025 13:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751980796; cv=none; b=RWrxqm6k4aq9a4yGXBNZA875xm9jLDMrpkJ7P3ccNM0m0KLiI2d9TQ2l3Y+Iw2nt2QcSAitgwTyYj1CfspvAddq3bK3xzRtZWTv+9rwcdmH6rHBW89cZbI5YkNXoK3E419gls+ssAQ4HgRU0xSvQhZe+b4j1gPisFvLoK6xZz7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751980796; c=relaxed/simple;
	bh=2hhnK25DkNTU7OryeqrjjehKQjavSrS1+RQmo0dcs0w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eXoYcRTYHku3s/B0KtVb++4F3VK/dGWMoV9feMbEIXleSfcKyB8rHkAKdHPPTYV3OfJEVC9+85cFtsn0wU4zkRB4GmPhESFSFUmfww2EDYvTCUH+EgsPlr7I7Uig4iCVptdErA1tJGLGRyI7Q3V+HBGYfcQfuUX+ttSTsBORFtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id DA12E604A5; Tue,  8 Jul 2025 15:19:45 +0200 (CEST)
Date: Tue, 8 Jul 2025 15:19:45 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH 1/2] netfilter: nfnetlink: New
 NFNLA_HOOK_INFO_DESC helper
Message-ID: <aG0a6FmFdjQFoBba@strlen.de>
References: <20250708130402.16291-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250708130402.16291-1-phil@nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> Introduce a helper routine adding the nested attribute for use by a
> second caller later.
> 
> Note how this introduces cancelling of 'nest2' for categorical reasons.
> Since always followed by cancelling of the outer 'nest', it is
> technically not needed.

Reviewed-by: Florian Westphal <fw@strlen.de>
