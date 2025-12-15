Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0842BDC16;
	Mon, 15 Dec 2025 12:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765802184; cv=none; b=sJD7mnF+USk4JxDHIX/ePoA4+HzEXmMx+CHXEUn1+DTxQmM9TQwW8KR3nXDAIlI6b2Edn2xPNRECPyLTXIa/eIKtPPKINAKLgAi0xjzoUyQvE22dC5e2QeVo07otAIZHBL+iLGiGbI2lgtrUTGQBBUtBFSfCF/kG+8Pum/do6jY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765802184; c=relaxed/simple;
	bh=2iLwU1B8g4fKF9LusolbR9/frSK+ketV110+oJiOu2U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FghJGmEdjM9vzow/R8MvMXZlW++b4SkRMRG6AMupub2/H4+k19T/RmXdgG1PyOZKy5xBb5qE0dHNi3RmTfuuEXkx4QBvCl5ySoLG8/2ENh5cWBekqzhstcTUAsJBzcuX4vNsz/4/2GIsDBt4dU/ycKy/z2iMLxptI9v0KB6dO3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id ABB7F60366; Mon, 15 Dec 2025 13:36:13 +0100 (CET)
Date: Mon, 15 Dec 2025 13:36:11 +0100
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
Subject: Re: [PATCH] netfilter: nft_counter: Fix reset of counters on 32bit
 archs
Message-ID: <aUAAuyGGhDjyfNoM@strlen.de>
References: <20251215121258.843823-1-anders.grahn@westermo.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20251215121258.843823-1-anders.grahn@westermo.com>

Anders Grahn <anders.grahn@gmail.com> wrote:
> nft_counter_reset() calls u64_stats_add() with a negative value to reset
> the counter. This will work on 64bit archs, hence the negative value
> added will wrap as a 64bit value which then can wrap the stat counter as
> well.
>=20
> On 32bit archs, the added negative value will wrap as a 32bit value and
> _not_ wrapping the stat counter properly. In most cases, this would just
> lead to a very large 32bit value being added to the stat counter.
>=20
> Fix by introducing u64_stats_sub().
>=20
> Fixes: 4a1d3acd6ea8 ("netfilter: nft_counter: Use u64_stats_t for statist=
ic")
> Signed-off-by: Anders Grahn <anders.grahn@westermo.com>
> ---
>  include/linux/u64_stats_sync.h | 10 ++++++++++
>  net/netfilter/nft_counter.c    |  4 ++--
>  2 files changed, 12 insertions(+), 2 deletions(-)
>=20
> diff --git a/include/linux/u64_stats_sync.h b/include/linux/u64_stats_syn=
c.h
> index 457879938fc1..9942d29b17e5 100644
> --- a/include/linux/u64_stats_sync.h
> +++ b/include/linux/u64_stats_sync.h
> @@ -89,6 +89,11 @@ static inline void u64_stats_add(u64_stats_t *p, unsig=
ned long val)
>  	local64_add(val, &p->v);
>  }
> =20
> +static inline void u64_stats_sub(u64_stats_t *p, unsigned long val)
> +{
> +	local64_sub(val, &p->v);
> +}

That still truncates val on 32bit.  Maybe use "s64 val"?
