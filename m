Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A53110F2;
	Wed, 30 Apr 2025 07:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745997108; cv=none; b=g9OxwfQIXN9HwLrR96/6pdE8aKfYRKTdW9LGiOZr+SQ/gVwwcPNyIs3KMfu1uBfPNMmZi7sR/+0OYeUxi0wJ05aK4lPIJxtoTFj8+nEHNI5GQA5wkzwl4UdJqBHKKM/R76CvdtmQcySWXBqPVvdEYk3SZZuHrFHxleYPgwZQMuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745997108; c=relaxed/simple;
	bh=3GhpYODfrQ+5AMMAbEASJ5M8V1DSSBv5XM5MM+x0hTU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jaJXu+uPhwEneLm7I2aSV6jNnW0Zjhr45l0siktpzEAAEjaKIVVEC0zb9APKVmJqb4dGIwOJWGXZ844tl51cHj5dMIbrWpaXRLZGCo/oeZ+Cmefe8gn/pDX4STF/hCcNjdHUea81nOCnUNN9tOVm599oWzya9WLEgQT2KeZGkso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1uA1bY-0007hX-24; Wed, 30 Apr 2025 09:11:40 +0200
Date: Wed, 30 Apr 2025 09:11:40 +0200
From: Florian Westphal <fw@strlen.de>
To: avimalin@gmail.com
Cc: vimal.agrawal@sophos.com, linux-kernel@vger.kernel.org,
	pablo@netfilter.org, netfilter-devel@vger.kernel.org, fw@strlen.de,
	anirudh.gupta@sophos.com
Subject: Re: [PATCH v2] nf_conntrack: sysctl: expose gc worker scan interval
 via sysctl
Message-ID: <20250430071140.GA29525@breakpoint.cc>
References: <20250429132921.GA4721@breakpoint.cc>
 <20250430064342.62592-1-vimal.agrawal@sophos.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250430064342.62592-1-vimal.agrawal@sophos.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

> v2: Don't allow non-init_net ns to alter this global sysctl

Looks good.

>  include/net/netfilter/nf_conntrack.h    | 1 +
>  net/netfilter/nf_conntrack_core.c       | 4 +++-
>  net/netfilter/nf_conntrack_standalone.c | 9 +++++++++
>  3 files changed, 13 insertions(+), 1 deletion(-)

Sorry, I forgot about

Documentation/networking/nf_conntrack-sysctl.rst

Can you add a short description to that file?

I don't think anything else is missing after this.

Thanks.

