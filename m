Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE6FC4414;
	Tue,  2 Sep 2025 00:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756771478; cv=none; b=WX4Mlp0oFO0kxw6GB8CzLsynZPfeAwGG/qc40gXDhLGpdWbspe4qhKGHuF5ALkkKdALCjQ95+TJlF3vU+9tdn3x816gEQt77McIG+CTGt55fdRW0cju/4KBgy7VIAXVOvgLNXL6VJnvMivUjGOlE82EPaHSzNIYOYJRX9WoMBzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756771478; c=relaxed/simple;
	bh=s0WhuQGgk7aenw4c7alDd/ujFAtUvOBf1ybOC3WaFIk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pv1qDn5yH+Mz/H9KYULOf//hME+7N7bR+WNBkpcKbZwwpv40dvc+4Zb+ddPgR+8MXdgPpjCj86Hojl37TfsyRVlxbC2wLHXxmm+CEStpLZbvGJrORslVqnAKNHEvGMwpFJIVkTmKz1rniVJjXvbUVP6Tq8nnN0iQVOahJGwplCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 77C8260688; Tue,  2 Sep 2025 02:04:33 +0200 (CEST)
Date: Tue, 2 Sep 2025 02:04:22 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next 5/8] netfilter: nf_tables: Introduce
 NFTA_DEVICE_PREFIX
Message-ID: <aLY0hh8aBWJpluMI@strlen.de>
References: <20250901080843.1468-1-fw@strlen.de>
 <20250901080843.1468-6-fw@strlen.de>
 <20250901134602.53aaef6b@kernel.org>
 <aLYMWajRCGWVxAHk@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLYMWajRCGWVxAHk@calendula>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, Sep 01, 2025 at 01:46:02PM -0700, Jakub Kicinski wrote:
> > Why is this not targeting net? The sooner we adjust the uAPI the better.

I considered it a new feature rather than a bug fix:

Userspace can't rely on the existing api because kernels before
6.16 don't special-case the names provided, and nftables doesn't
make use of the 6.16 "accident" (the attempt to re-use the existing
device name attribute for this).

The corresponding userspace changes (v4 uses the new attribute)
haven't been merged yet.

But sure, getting rid of the "accident" faster makes sense,
thanks for suggesting this.

> I think there were doubts that was possible at this stage.
> But I agree, it is a bit late but better fix it there.

Alright, I'll send a new nf-next PR with this one dropped in a few hours
and a separate nf.git PR with this patch included.

If you prefer to just apply this series sand this patch that worls for
me too, I'll just follow this changesets' patchwork state.
