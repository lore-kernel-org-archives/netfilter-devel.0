Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF85520C46A
	for <netfilter-devel@vger.kernel.org>; Tue, 18 Mar 2025 13:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742304509; cv=none; b=ZjRxzgeVfpzGL/AX88YV9cEhye9MoYLP+nonRjRtcIIPRuDIqoD624bFj5SrQB6ZmHIJO3QxvNc2SAOabQfdBRtg1X8yQnQz/QRfEPMCGcjppT/hQULA20KJd6eOPkK9CdT+xHHYMyVQHxVF014oRqaLaeQkcLKLdwLOGOghaeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742304509; c=relaxed/simple;
	bh=T3ubbbO/lFKy6go2Z0epkTqYVeXiSBFdsUmU58q2PWU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qHKcXC3kl3eb3FLsdT/6NVX/0wWzXp+aoM0RKfHVgMd7GJeZz6jROvjDZr6wG9drWqncRfXfW5rVWtxgE5eR2GzZLkgCLuvOw25G67eEa5z/EDXzZDRRF197R+X73CPO/mgQQ3piHioOwILM1I0prXUAB6wMFfXGBeo6sEJT/tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tuWzW-0005Vt-4A; Tue, 18 Mar 2025 14:28:22 +0100
Date: Tue, 18 Mar 2025 14:28:22 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] src: print set element with multi-word description
 in single one line
Message-ID: <20250318132822.GC20865@breakpoint.cc>
References: <20250313214313.1147829-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250313214313.1147829-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> If the set element:
> 
> - represents a mapping
> - has a timeout
> - has a comment
> - has counter/quota/linux
> - concatenation (already printed in a single line before this patch)

Formatting is much saner after this, thanks for changing this.

Acked-by: Florian Westphal <fw@strlen.de>
