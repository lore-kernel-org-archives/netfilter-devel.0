Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0141F3D56
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2025 20:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761252316; cv=none; b=ISBkCKkzCyewNK+rTZ9PgVK7AGnrwlDDYgpW0cAYg0f6MSQe4VYbpylXJ0JApxkS8Jk7CYN3tCY/+8n5q9vAt3wWoO04GHdpiVZNyNfKin1pbgHCqWGPio0y9FAN/R66XSvAbrV6wKxj3hPsiec/89S853cjan39JAvw6rGcjc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761252316; c=relaxed/simple;
	bh=1+GMR4D6dP+311SjYSsXFwl4wo9a48/WR3cCbDhHFc8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jXB7OI6IVzyLVRZNdJa9BHN/lVE8tiWF9tFDsKxGkDVuQAE7Q4ngx9hdoi5GMNIU/aSI1pJZzPdtk6NZShIGutjIuDDKUpLuDrf/ET7VMhG3gsjioEMm8raANT3XaoxiT9iS+OsPeSUbb3q1oIIQIwZKX63iahI9o2pVEU/Fe4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 90A4C6037A; Thu, 23 Oct 2025 22:45:10 +0200 (CEST)
Date: Thu, 23 Oct 2025 22:45:10 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 00/28] Fix netlink debug output on Big Endian
Message-ID: <aPqT1mTgJv-Ni0cJ@strlen.de>
References: <20251023161417.13228-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251023161417.13228-1-phil@nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> Make use of recent changes to libnftnl and make tests/py testsuite pass
> on Big Endian systems.
> 
> Patches 1-7 fix existing code, are valid without the remaining ones but
> required for the target at hand.

Please push those out, thanks.

> Patches 8-12 are a mixture of fixes and preparation for the remaining
> ones.

I think they are fine too, so just flush them out.

I'll go over the rest tomorrow.
