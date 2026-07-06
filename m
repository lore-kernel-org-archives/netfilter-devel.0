Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0372F3DFC67;
	Mon,  6 Jul 2026 08:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783326385; cv=none; b=S4047LrDmXeqteUEFiAf/KK3+ZyyDrtvLzGFHfb7B6Q/1pA3o4grIsLZx6KtxPr4QpmhRboaI3aI4Yc2W602II0/6dHQgPBG+aNpSR7Qu4qO+6Nle8RteFZzuTsU11T4Xv5C4NSDJKYrK6qQ2BL0IuERagjAsOQ8fszy3LHnlAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783326385; c=relaxed/simple;
	bh=5XqDRuIe/B1ygd12dXDlZ/lOV6rSPqNPQ9E0MksFaQU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CBlu/MRqAAh/EiindKrtt5KMWlx6TBzDww/Nm+opfy7yL4w1jJjERYmpokGJURyOCg5jd/920scDE1L4f0OtpnIuNFhtKiOTlDGj9cG18RcygZ33rOXfWfUU6fYsOPz4JfZ0qgnXFzH9qEPD9tZe3Okqu+isGltkyuNdocclFHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A831C60491; Mon, 06 Jul 2026 10:26:15 +0200 (CEST)
Date: Mon, 6 Jul 2026 10:26:15 +0200
From: Florian Westphal <fw@strlen.de>
To: netdev@vger.kernel.org
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org
Subject: Re: [PATCH net 0/9] netfilter: updates for net
Message-ID: <aktmp2JwAoY-kBre@strlen.de>
References: <20260703125709.16493-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260703125709.16493-1-fw@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> The following patchset contains Netfilter fixes for *net*, all
> for ancient problems.  Patch 7 raised drive-by sashiko findings,
> but those are not related to the change itself.

There more unrelated findings, those will be addressed in a future PR.
