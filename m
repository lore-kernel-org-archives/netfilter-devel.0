Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0022D2390
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Aug 2025 06:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755066979; cv=none; b=IVJM4ccfB4hI3lWWu1zzsNymXTN/PQ5BVFC420OWFDk1cIoKEQ3G4sjXUaT+yP6DByBj5UFk7sshjXfWID6plMcgWJOWMHWqKylCn4NSsT+YObhaJ7eURIj1WI7172Hqq08ZchhBuO+Hx9nHhgGkZqdTMjDVm6K25INxmyltckI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755066979; c=relaxed/simple;
	bh=y+QROA7LbXYz1Mo34huThmvfIKUOe2UUzRIwGv3VGRI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PK7tAf7zdzl7aQxbCEqjDgF8VnI8O1DV0TNdi3NYkj8ZDxQdBYlhUAb1HmLjsxE/ddpvr71kikISemNgAzmnrPTQvkdjH5MsFGmpiE/ZpK81yh21J+ugp5Yh3GbXNxR+fx6AMlKWwGGhmboKMcrVFXn1v1nGy3+QNWaTblN7C/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 5AA58605CE; Wed, 13 Aug 2025 08:36:13 +0200 (CEST)
Date: Wed, 13 Aug 2025 08:36:07 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: reject duplicate device on
 updates
Message-ID: <aJwyV7P5fqiENxB-@strlen.de>
References: <20250813003850.1360-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250813003850.1360-1-pablo@netfilter.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> A chain/flowtable update with duplicated devices in the same batch is
> possible. Unfortunately, netdev event path only removes the first
> device that is found, leaving unregistered the hook of the duplicated
> device.
> 
> Check if a duplicated device exists in the transaction batch, bail out
> with EEXIST in such case.
> 
> WARNING is hit when unregistering the hook:
> 
>  [49042.221275] WARNING: CPU: 4 PID: 8425 at net/netfilter/core.c:340 nf_hook_entry_head+0xaa/0x150
>  [49042.221375] CPU: 4 UID: 0 PID: 8425 Comm: nft Tainted: G S                  6.16.0+ #170 PREEMPT(full)
>  [...]
>  [49042.221382] RIP: 0010:nf_hook_entry_head+0xaa/0x150

Thanks Pablo.

Just to confirm: this doesn't result in anything other than
the unreg splat, correct?

Or does this leak memory too?

FTR, i placed this in nf.git:testing.
