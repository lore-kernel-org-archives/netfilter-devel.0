Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F7E3F9F55;
	Thu, 14 May 2026 14:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778768661; cv=none; b=efM+EHr1vRMP/JlsEsA0NIqgEHas9hn15cWG++aYlaLcFpkQJ1sm32yeVU2IAghwkupczGeAQPO7naK4LX3kdHWf/4RCWQioDo51bczK8aw+v/9Mnbo/32Y+gzb+lbE8ecRjMUDJXkUCMLxKQedBYDxejGbgOgHcXES3pqMeXI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778768661; c=relaxed/simple;
	bh=KfS8rctgTCv+zW5ml+hsbbU5dduwnEtsWWD5sMI5RrU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nU8oap6odOETqwakVrpVdCnrZqphQ4ZjiMYu0viXJGm1oiInPBmMwJ6kR2Eezt4u8G7qiVpnk43DYLgqkmKBDMpjf/cYJOc1QTHeA/GMXG9ZIZqtn7dT+5Oq/qqUfKWFWZ4JBqKA5gZXBEp5wKfJSVa2vwS0Kkko4SYN1pQSpRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LMz5yEuu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LMz5yEuu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A96C2BCB3;
	Thu, 14 May 2026 14:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778768661;
	bh=KfS8rctgTCv+zW5ml+hsbbU5dduwnEtsWWD5sMI5RrU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LMz5yEuuXCa61X1B1vFfMwVEoFqJEs7Sce+zpMpp7WOr0dMSSyzyj8IlicKCuyAb0
	 pgJM3j819S2ow+4TD/qljo2p2p5t+qJMQi4qkfpD7UDP0kcQXMkuWRwgkrW5oVmznJ
	 vWGxfiyP25PyrCKgxBcp7md2l9qIJJ+OodQqQZ47GyzCqNJKglzaJRLQPluQlIiqzr
	 refIrN0qK0xdECwp6XcJMeh3WhHM5+bAL4icsHuy1BPGPLgIBiiLhodHd/HtCREc7Q
	 xpju84PbS5guJJXtUNM+m5OMxvR5JONo+wxbhpWuQ0tXcP5GmIeU4jGK5OCMWZGbAe
	 mgKItwSQx7nXQ==
Date: Thu, 14 May 2026 16:24:18 +0200
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Bart De Schuymer <bdschuym@pandora.be>,
	Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	bridge@lists.linux.dev
Subject: Re: [PATCH net v3] net: neigh: Reallocate headroom if necessary in
 neigh_hh_bridge()
Message-ID: <agXbEs03zO48f10r@lore-desk>
References: <20260513-nf-neigh_hh_bridge-fix-v3-1-8ec9353c0909@kernel.org>
 <20260514081403.GA482081@shredder>
 <agW6zjwDHB3dTiZC@lore-desk>
 <agXRLM6esULBG4al@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="dbl4ZuXZ6kJq2OX1"
Content-Disposition: inline
In-Reply-To: <agXRLM6esULBG4al@strlen.de>


--dbl4ZuXZ6kJq2OX1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On May 14, Florian Westphal wrote:
> Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> > > Personally I would use 'goto free_skb' after releasing the neighbour,=
 to
> > > be consistent with the other paths that free the packet.
> >=20
> > ack, I do not have a strong opinion about it, but in this case we would=
 need to
> > even move "ret" since the current codebase always returns 0. What do yo=
u prefer?
>=20
> I think It can return 0 unconditionally, there are no code paths in
> that function where skb doesn't disappear (ownership change or freed),
> and its prerouting so there is no use for an error code either.

ack, I will fix it in v4.

Regards,
Lorenzo

--dbl4ZuXZ6kJq2OX1
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCagXbEgAKCRA6cBh0uS2t
rCvoAP4zY5aXQeDlGpsfI+Jk5Tee251LeQId+erBQyv0s5HO/gD/RHqL2yt3wp8H
RIu9zxE2N+TSUGRLSVNvxKyFLftSdgw=
=4Q+b
-----END PGP SIGNATURE-----

--dbl4ZuXZ6kJq2OX1--
