Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25E0305044;
	Thu,  6 Nov 2025 23:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762472848; cv=none; b=KnQOxj5trtNVT12rnkYSXdRHuqoeWltfGLbCSYvaoL4iDRiloK1IO0GwNuBW3D9nhOuGfG4arw/EGvg9oN+geaSmN+QfJ3qWKOvWAC6BTvrzC+4RsXSZRe0X3Te1LMlozKprF2Ncg1zmA14UKZBfZoOXq2wy2Q/ZgwbU5Dxnh9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762472848; c=relaxed/simple;
	bh=0yDBKr3QbihLy9egvMgBK8fZ1PK4/GQnwnszzzE4DNg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SOA+cj/l5Jy9JvhDcFZJWa2ecHjXUHnAbbt2IFwxF229GR7JgJI/9ca6YBKJOe2VtGUBZrvhpJmID0PYgGCn7xlpqv81LTfdW0fHfjpL6eUWEij8BGunTk80WhycUoy1YpsB7CV7c8WDw8Z2JhiKvwfQ+Gbcc+9ZdUzMkOdvdEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 452C46021B; Fri,  7 Nov 2025 00:47:25 +0100 (CET)
Date: Fri, 7 Nov 2025 00:47:25 +0100
From: Florian Westphal <fw@strlen.de>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	bridge@lists.linux.dev, netdev@vger.kernel.org
Subject: Re: [PATCH v16 nf-next 3/3] netfilter: nft_chain_filter: Add bridge
 double vlan and pppoe
Message-ID: <aQ0zja96khMMZfsq@strlen.de>
References: <20251104145728.517197-1-ericwouds@gmail.com>
 <20251104145728.517197-4-ericwouds@gmail.com>
 <aQohjDYORamn7Gya@strlen.de>
 <114f0b33-2c5f-4ae8-8ed8-e8bc7ef3dd2c@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <114f0b33-2c5f-4ae8-8ed8-e8bc7ef3dd2c@gmail.com>

Eric Woudstra <ericwouds@gmail.com> wrote:
> >> +		return NF_ACCEPT;
> >=20
> >=20
> > Hmm.  I'm not sure, I think this should either drop them right away
> > OR pass them to do_chain without any changes (i.e. retain existing
> > behavior and have this be same as nft_set_pktinfo_unspec()).
> >=20
> > but please wait until resend.
> >=20
> > I hope to finish a larger set i've been working on by tomorrow.
> > Then I can give this a more thorough review (and also make a summary +
> > suggestion wrt. the bridge match semantics wrt.  vlan + pppoe etc.
> >=20
> > My hunch is that your approach is pretty much the way to go
> > but I need to complete related homework to make sure I did not
> > miss/forget anything.
>=20
> I understand. I've send this, because from v5 to v15 it moved towards
> matching in the rule, but it all started with the fact that
> nft_flow_offload_eval() uses nft_thoff().
>=20
> At a bare minimum I need to address having pkt->thoff set correctly to
> implement the software bridge-fastpath.

Sorry, fail to see how thats related.

If the header is incomplete, then with your approach the packet isn't
even seen by nft_flow_offload_eval() (-> NF_ACCEPT'd).

Whats the problem with passing the skb to nft_do_chain in its
'original' form?
