Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA293876A1
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Sep 2026 14:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789740916; cv=none; b=D0DhJS4IOqF3dJiN697BmFUphvmKjMEaxKL5WgsohxqNgPgrycaJQwxgRNWwfisvPZaiB3lAbSiG/SrqV+SIzIW92HmiBM8b467lVS4nHNesBaKURcgBXcAjvBWE1aR6qeC6ttjGIljHjJX79CBMfCzwqinbvjWLZrjCGPCDGJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789740916; c=relaxed/simple;
	bh=YRX4SkQl1L7jQdWfmknXODoAeKQ7EC+YNXu3H8L55xw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IeOH9X53924Jb/iLQ8rynx61cm+tyB+JqKvkXLc96qFzmnd6qm1IyJ8X982dG3HMSFi9hKJKnfviW7WbmwKYCXGSzc7V2j8CiszVd9YuENlKkpS2XLouVchnBf5xaVxNvwYsiT9Jw+hHjy9dFQf9i9JzhCo8EPaP7FABZ5Uo4vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 8B6B160468; Fri, 18 Sep 2026 16:15:11 +0200 (CEST)
Date: Fri, 18 Sep 2026 16:15:05 +0200
From: Florian Westphal <fw@strlen.de>
To: Ren Wei <weir@nebusec.ai>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, phil@nwl.cc,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, horms@kernel.org, kaber@trash.net,
	vega@nebusec.ai, petalzu987@gmail.com
Subject: Re: [PATCH nf 0/1] netfilter: nf_ip6_checksum: validate checksum
 offset
Message-ID: <aq1HaYS96SNn7HJY@strlen.de>
References: <cover.1789660425.git.petalzu987@gmail.com>
 <aq0UpHHbvxjR2jLb@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aq0UpHHbvxjR2jLb@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> > We will provide detailed information about the bug in this email,
> > along with a PoC to trigger it.
> 
> patch is fine, but could you make another patch that either fixes
> ipv6_find_hdr() or ip6_packet_match() / nft_set_pktinfo_ipv6() as well?

To clarify, I agree with this patch, I don't mean that the other
patch should replace this one. I see them as separate issues, so:

Acked-by: Florian Westphal <fw@strlen.de>

> If I read this right then ipv6_find_hdr() returns nexthdr 'TCP',
> but its clear packet is malformed and that header isn't there.

ipv6_skip_exthdr() may have the same issue.
