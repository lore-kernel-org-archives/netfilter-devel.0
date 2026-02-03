Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F393446A7;
	Tue,  3 Feb 2026 12:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770123387; cv=none; b=O36Dc0umYrnmDU3hJe2OknkqGFTbg0vRW3kKS7cQzhUhe32GWFSTnldtt3OOr73uMkqTWC5cZHj7+47XlBCvjstdJ+GLFW+RkZv+FnWK2OM1E6j+ayXKgQZRJlnNrg8Jj2aiEjow9PmEUJhk1Pycx6zjmYJB0WiqdSkTfFpc0ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770123387; c=relaxed/simple;
	bh=GuNXZn2/PYMfEowFIyfUtN0qZu5OAzXxbdqecwOx16U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dYkxO2jvAUdIlAzh7Ir96UpjEDlWSfqMqAJaumTMoDCmRfsLfhNCx34lc4zu3ZEC+u1d4p/aaIKLSOE9/bdnGgzL3Tc5fWVvhWyQiZ/flfNzjiRLi7TKkpKYgOxgBP0M+oqO//uorukkNGVBScWHQ9eUZWatXOUEfHgqNdjWnf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id EBCEE6033F; Tue, 03 Feb 2026 13:56:23 +0100 (CET)
Date: Tue, 3 Feb 2026 13:56:23 +0100
From: Florian Westphal <fw@strlen.de>
To: Sun Jian <sun.jian.kdev@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org, bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: bpf: add missing declaration for
 bpf_ct_set_nat_info
Message-ID: <aYHwd2mMaVp-qFlp@strlen.de>
References: <20260203084323.2685140-1-sun.jian.kdev@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260203084323.2685140-1-sun.jian.kdev@gmail.com>

Sun Jian <sun.jian.kdev@gmail.com> wrote:
> When building with Sparse (C=2), the following warning is reported:
> 
> net/netfilter/nf_nat_bpf.c:31:17: warning: symbol 'bpf_ct_set_nat_info'
>  was not declared. Should it be static?
> 
> This function is a BPF kfunc and must remain non-static to be visible
> to the BPF verifier via BTF. However, it lacks a proper declaration
> in the header file, which triggers the sparse warning.
> 
> Fix this by adding the missing declaration in
> include/net/netfilter/nf_conntrack_bpf.h inside the CONFIG_NF_NAT
> conditional block.

Didn't Alexei tell you to not send more fixes like this?

https://lore.kernel.org/netfilter-devel/CAADnVQ+j8Q5+2KSsaddj3nmU1EkuRAt8XwM=zcSrfQfY+A1PsA@mail.gmail.com/

"No. Ignore the warning. Sparse is incorrect.
We have hundreds of such bogus warnings. Do NOT attempt to send
more patches to "fix" them."

I'm not applying patches when a subsystem maintainer already
said no.
