Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27E4258ED4;
	Fri, 26 Dec 2025 21:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766784559; cv=none; b=CSQd3lxQ+zjPSvoFZf90JnMewT8A9vTbHPcqZRUopDz+wHvO8x+vBbGeyLXMTHV62iO+33YPGEVZN0EL/TLAgBAqqP52AeGSUDwXTRgcJfX8zzpddirUCsOhbZX6ck6UwkxjIRZeqogh1krLIzcPcEfu2alkKeIdTkIvAY1M5UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766784559; c=relaxed/simple;
	bh=6cAr43+4il2emm1fbFlAIm8vKcpk+gGyM27b0uTQNZc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pbvBFDcKGNdT4FzdkDz2Ciq+vpdm60NrzfonH+iDorVPKlCzn11xfItmZh0+FOf+M9LebrlhKdrDn2Wo2O7K87oZGHOZBLfTkrl9bNvBXGXwRCAc1cr+eOPLteiJYvCx9DFJenGSpGnO/ndWT5uQocol6EpmIpDFKBrnFgyCYbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 36CA2601EB; Fri, 26 Dec 2025 22:29:07 +0100 (CET)
Date: Fri, 26 Dec 2025 22:29:01 +0100
From: Florian Westphal <fw@strlen.de>
To: Anders Grahn <anders.grahn@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Anders Grahn <anders.grahn@westermo.com>,
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] netfilter: nft_counter: Fix reset of counters on
 32bit archs
Message-ID: <aU7-HRMQjgyZTzLA@strlen.de>
References: <20251215153253.957951-1-anders.grahn@westermo.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215153253.957951-1-anders.grahn@westermo.com>

Anders Grahn <anders.grahn@gmail.com> wrote:
> nft_counter_reset() calls u64_stats_add() with a negative value to reset
> the counter. This will work on 64bit archs, hence the negative value
> added will wrap as a 64bit value which then can wrap the stat counter as
> well.
> 
> On 32bit archs, the added negative value will wrap as a 32bit value and
> _not_ wrapping the stat counter properly. In most cases, this would just
> lead to a very large 32bit value being added to the stat counter.
> 
> Fix by introducing u64_stats_sub().

Looks fine but:
WARNING: From:/Signed-off-by: email address mismatch: 'From: Anders Grahn <anders.grahn@gmail.com>' != 'Signed-off-by: Anders Grahn <anders.grahn@westermo.com>'
