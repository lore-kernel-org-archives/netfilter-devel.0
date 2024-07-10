Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D298194AD6
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2024 14:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720620115; cv=none; b=s5L6tCJL+JmS8OjIXLSqZs8sJ/7lejGP5qWC0aFHzC0Fg3x6l5fpPaPqc0Kjw26n4Uy+xA3F8YCDfw9avSXsT7BFKKQve7CluHdvue3NscuXMDDoyQql6xap5KyKToFFhGht+y2Bi31LYcNTh8fbrsHYabatxxdbjxjCK5ldtn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720620115; c=relaxed/simple;
	bh=qEPBAfdEprD52cutWPsk+3qWvS0oILeX4WOLtvskr9c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WSr4wcsSDMGIH+6qdHBsPykb+KKE7pnLkkrA2T15ig1+hrsJGMx1QbZKMVnr/XGvWVKCKF1CG0jADjrVbnh4LDHTaGu9X5BmDUeLtgdZwHaa3tiojiEHXQPM7FvbHZwHjA8J4qbm33RNRA0qRvbNMlfyive8sfSQ32RGhoAimTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=51198 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sRXt7-00GcoF-Hs; Wed, 10 Jul 2024 16:01:43 +0200
Date: Wed, 10 Jul 2024 16:01:40 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] libnftables: fix crash when freeing non-malloc'd
 address
Message-ID: <Zo6URPsJHEmT-gBo@calendula>
References: <20240710133146.14287-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240710133146.14287-1-fw@strlen.de>
X-Spam-Score: -1.9 (-)

On Wed, Jul 10, 2024 at 03:31:44PM +0200, Florian Westphal wrote:
> dirname may return static pointer:
> munmap_chunk(): invalid pointer
> 20508 Aborted  nft -f test

LGTM, thanks Florian
