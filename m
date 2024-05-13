Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE5E7BB12;
	Mon, 13 May 2024 20:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715630608; cv=none; b=azypqwUleXKeKQg3c92lZinLwZr8IS4rOTnRAtcRRRWC3DORXj0PG06eKv0nLONHafiZJ2oNOFgm+V5BwC6iTwW6Pyo8xABIhyIC20Ci3gL5gY7IIeSieeyFu9bE6dl8sw5ifBcTUZHcZlRDoRC9ncaDQBiycmg6vN3tG1+/hxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715630608; c=relaxed/simple;
	bh=sChpBwz/GIVxO3bkCx14toVajbEAHzSqEbvLDl9M9CA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fXaFvAWVcUmr1GVtKUelVa8hzPyR01RnMZ3cP/DPE3oyscg5ZqPmvqSzpfi4YRq2xKKoPjdYKLCuNYF/7e9IdrzUqHYQ9b2e5lUmRcaNEDZaLku/7x0GQzScFIitmFoq2iRROwovtl4y5IQ79f0QfOnWEd+hil8AkGFVc8dn+vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1s6btC-00044H-1j; Mon, 13 May 2024 22:03:14 +0200
Date: Mon, 13 May 2024 22:03:14 +0200
From: Florian Westphal <fw@strlen.de>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
	fw@strlen.de
Subject: Re: [PATCH net-next 16/17] selftests: netfilter: add packetdrill
 based conntrack tests
Message-ID: <20240513200314.GA3104@breakpoint.cc>
References: <20240512161436.168973-1-pablo@netfilter.org>
 <20240512161436.168973-17-pablo@netfilter.org>
 <20240513114649.6d764307@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240513114649.6d764307@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Jakub Kicinski <kuba@kernel.org> wrote:
> Hi Florian, I installed packetdrill in the morning and the test..
> almost.. passes:

Thanks a lot!

> # packetdrill/conntrack_synack_reuse.pkt            (ipv6)                    packetdrill/conntrack_synack_reuse.pkt:33: error executing `conntrack -L -p tcp --dport 8080 2>/dev/null | grep -q SYN_RECV` command: non-zero status 1

Grrr, my fault, I used a more ...forgiving version of conntrack tools.

I bet its because of missing "-f ipv6" flag, so changing the line to
include "-f $NFCT_IP_VERSION" like in the other files should make it
work.

I intend to wait for a few months before adding more test cases to
see how stable these tests will be wrt. changes elsewhere in the stack,
there are a few other corner cases that would be nice to have coverage
for.
