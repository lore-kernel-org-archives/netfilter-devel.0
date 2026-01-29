Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7053233F373;
	Thu, 29 Jan 2026 10:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769682405; cv=none; b=MHbRyri2m9TVQ/qYpDWBsEU2Y+lcbvFevOHgtXFLJi5Fq1J7SCMDiBcSKQ6QRuErUXkpHMJWF+W2DhnHDc+thKIUr0vBtXcZuPU2TXM6TY3m+98nWMAdojI4Y9Bm6iWRMvMc8aretJtEfxWbFj0//LLlYH7QM5Cu1nqWF0AlCso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769682405; c=relaxed/simple;
	bh=PaWsHU+8cRdKGdgZqY3gXg1yYksYh5e0JEAeAcvPv5U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cRR3HYbPgLRjl45WVJKttOYT26gDXr24aSWYeBwZaZb8JKYa3mjr1GwZnwl12lzwGPliNQRpo2pEp5N9/9TY7KEhN4+FMuAeGtFs76paNIdJKDcnJyavg6sG9+K1zyraMevRNtWjkgFqB5bQmW2WkUw/lz1CRzJed5rcrIfvjQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 74CEC60516; Thu, 29 Jan 2026 11:26:41 +0100 (CET)
Date: Thu, 29 Jan 2026 11:26:41 +0100
From: Florian Westphal <fw@strlen.de>
To: Qingfang Deng <dqfext@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>
Subject: Re: [PATCH nf-next] netfilter: flowtable: dedicated slab for flow
 entry
Message-ID: <aXs14ZJGN3lDnMDc@strlen.de>
References: <20260129101213.74557-1-dqfext@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129101213.74557-1-dqfext@gmail.com>

Qingfang Deng <dqfext@gmail.com> wrote:
> The size of `struct flow_offload` has grown beyond 256 bytes on 64-bit
> kernels (currently 280 bytes) because of the `flow_offload_tunnel`
> member added recently. So kmalloc() allocates from the kmalloc-512 slab,
> causing significant memory waste per entry.
> 
> Introduce a dedicated slab cache for flow entries to reduce memory
> footprint. Results in a reduction from 512 bytes to 320 bytes per entry
> on x86_64 kernels.

Ok, but please use KMEM_CACHE(), we've had a bunch of patches
that removed kmem_cache_create() in several places, I would like
to avoid a followup patch.
