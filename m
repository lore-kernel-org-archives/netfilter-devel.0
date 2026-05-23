Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9850A1F4174;
	Sat, 23 May 2026 12:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779540948; cv=none; b=KG/Axxs/PUItjP6PfV+tzHXBOz0bOxax3lJ/AFKn9MzWiLhQBrPGkCqmbjripXY4IsTb+wE3ptX1djWtNZZwDi70OBH/1HKN9YS5Q6BxDa4Lf//Ol78T4xfE/kp1puv/g5Pdg0RgkIvoGikKMFbjEIHMd2N0Vo0ybOgfbPxH+20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779540948; c=relaxed/simple;
	bh=xI2mQG19C97hLgz/nBtY5I/gJclaCJtQ5o0rHOJTrOQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Drr0FI+/NKuuNr+gGrskBa5reQZivTlKdMhXc8zqxC8LCS2ipP8qjzXLYi7vwTYuqFlEcqe1toFVsEjmZ6RIYAwtsJGzrRTzgnbKmF/XzgaoVBMOygPxJTQZpCsruMrQMu3zEhHQzuW2Ul6UE0/bdjOasi0NyB5qNZQP3sIKE/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 96F5060345; Sat, 23 May 2026 14:55:38 +0200 (CEST)
Date: Sat, 23 May 2026 14:55:38 +0200
From: Florian Westphal <fw@strlen.de>
To: netdev@vger.kernel.org
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org
Subject: Re: [PATCH net 00/10] netfilter: updates for net
Message-ID: <ahGjygRgiDzkpwc0@strlen.de>
References: <20260522104257.2008-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522104257.2008-1-fw@strlen.de>

Florian Westphal <fw@strlen.de> wrote:

TL;DR: please ignore sashiko findings.

> 5) Disable netfilter payload mangling in user namespaces (nft_payload.c
>    and nf_queue).
>    TCP option mangling via nft_exthdr.c remains enabled.
>    There will be followups here to restrict resp. revalidate
>    headers.

sashiko says this breaks existing deployments, but we have little other
choice at this time.  Revalidation is being worked on, but it will take
time (and wll not be perfect either).

> 6) Fix an out-of-bounds read in ebtables's compat_mtw_from_user function.

AI complains about futher issues but this will be turned off for userns in
-next and then removed some time later this year. Given this is off in both
debian and fedora kernels for long time already I think noone will miss it.

> 10) Fix destination corruption in shift operations when source and destination
>     registers overlap.  Reject partial register overlap for all operations
>     from control plane.  From Fernando Fernandez Mancera.

sashiko says there is similar bogosity in nft_byteoder but that code is
queued up for removal in -next already.
