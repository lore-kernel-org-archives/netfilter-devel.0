Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A786C1114;
	Thu, 17 Jul 2025 13:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752757324; cv=none; b=H0hXUsj0aXc4wEMg0ClvwyA9kTtOQwJ6sokQti5Pe7Q78jb4SnLApwb8cvbgO0PTZbKzXutRo95J08wCwvAt3A7pSLUCeSSi6o+QeV0xQ/7PU3TAQXpS3MdwUcW+CEZguuzzF19mqTPuDXvMXWD6we9kTYEbEp3Wn1kD3HlRPuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752757324; c=relaxed/simple;
	bh=G93qgr2A5Gbxo1X7VvtZmMkSVmCsNR+6FdHIsB9a8d0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rdZfetvNdVGrKQVJJ7dPLZBxQONFm4G8MMWZdtNMMPs5o75sU28oi5GwT4BzVJO1j/IdXwf9BKKrJ5H+Q+LLYqqlQb4w1z5vkogoHGTx7eLGb4IzYD6+UF6FJ9TlUxWLjqvIHh9uz09Xoym+8q7OPWvaht3BjQCo4lI48yelJWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 8FE8760B33; Thu, 17 Jul 2025 15:01:53 +0200 (CEST)
Date: Thu, 17 Jul 2025 15:01:53 +0200
From: Florian Westphal <fw@strlen.de>
To: Paolo Abeni <pabeni@redhat.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com,
	horms@kernel.org
Subject: Re: [PATCH net,v2 0/7] Netfilter fixes for net
Message-ID: <aHj0QSJkzexEKE2T@strlen.de>
References: <20250717095808.41725-1-pablo@netfilter.org>
 <33ce1182-00fa-4255-b51c-d4dc927071bc@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33ce1182-00fa-4255-b51c-d4dc927071bc@redhat.com>

Paolo Abeni <pabeni@redhat.com> wrote:
> The first run of the newly introduced conntrack_clash.sh test failed on
> nipa:
> 
> # timeout set to 1800
> # selftests: net/netfilter: conntrack_clash.sh
> # got 128 of 128 replies
> # timed out while waiting for reply from thread
> # got 127 of 128 replies
> # FAIL: did not receive expected number of replies for 10.0.1.99:22111
> # FAIL: clash resolution test for 10.0.1.99:22111 on attempt 2
> # got 128 of 128 replies
> # timed out while waiting for reply from thread
> # got 0 of 128 replies
> # FAIL: did not receive expected number of replies for 127.0.0.1:9001
> # FAIL: clash resolution test for 127.0.0.1:9001 on attempt 2
> # SKIP: Clash resolution did not trigger
> not ok 1 selftests: net/netfilter: conntrack_clash.sh # exit=1
> I think the above should not block the PR, but please have a look.

No idea whats happening, I get 100/100 ok :-/

I'll send a revert or $ksft_skip for now if I can't figure it out.
