Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5465C282F3A;
	Mon, 25 May 2026 21:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779744510; cv=none; b=MVYGyFwW55ra7C9eJ9zB0NXsXcpy5LVaI71+iKJ/qT+DbQO0Xc/cvtyWFj8tKASWz+ai9B8B7ogJ4PMW6okf2Sb6NxAW4w04FQr5r7R01OSVkz2DW1EjXvp7UHehgV89zpjGX84YypWTsPMHdGWdhqLmh3cJQal+aJ02ljpvGs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779744510; c=relaxed/simple;
	bh=NxfKHXKFzTRr4Oqqb2sCTYtuUY7xmavYX+nFDIByQ2s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Eq5fY3ZeIwBFQeDnRevOr7YjrwM5mp8uPWGQe35W6MrLhL1gR54H67vbs2NVvS36IUb59sDcsOjezNofJpPoTiznEnS29VEryuggAI4qjEwY2G/pN12c2s16m3DJ2vm+8mRQqgMfLfVoLTOWcXOabNm8+Qy6u7JTW1DhE2svI1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 15F6B602AB; Mon, 25 May 2026 23:28:26 +0200 (CEST)
Date: Mon, 25 May 2026 23:28:25 +0200
From: Florian Westphal <fw@strlen.de>
To: Kacper Kokot <kacper.kokot.44@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] netfilter: TCPMSS: fix dropped packets when MSS option
 is unaligned
Message-ID: <ahS--cPlhv6NHAcO@strlen.de>
References: <20260525201116.407338-2-kacper.kokot.44@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260525201116.407338-2-kacper.kokot.44@gmail.com>

Kacper Kokot <kacper.kokot.44@gmail.com> wrote:
> Padding TCP options with NOPs is optional, so it is legal to send an
> MSS option that is not aligned to a word boundary and therefore not
> aligned for checksum calculation. The current TCPMSS target is not
> robust to this: when the MSS option is unaligned it produces an
> invalid checksum, and the packet is dropped.

Is this an actual, real world bug?  This code is 20+ years old, all that
this hints at is that they are always aligned in reality?

(Not disputing theoretical problem).
