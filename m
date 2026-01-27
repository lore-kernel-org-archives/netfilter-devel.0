Received: from mail-4319.protonmail.ch (mail-4319.protonmail.ch [185.70.43.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D0E30B536;
	Tue, 27 Jan 2026 13:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769520183; cv=none; b=csVv3DIE9UTpoJF6PVXsBR9uHffr4KneKNQtWkFrcgdbfAXulARGfmrLANywNGqm7U83eo3aXLqyROs5GkW9IZIHsbzS+BtNEJrefNLZdqQFRLHMtdOqHGEnQz40NlOITCNgs4UgrYgVKZsyXDTt7yuvdt908Qk4rcYGaPvlDFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769520183; c=relaxed/simple;
	bh=7rGQy8U1nL27WhYm+OTT9cv+PGaH7TTLwzqe+/DV90s=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VmuJdtmQslRQG9NSvNHK9NDD10sMR1bPspZvzLxVJsq7yQeWjMDldkbBbDwIVdTQ9RKAs1rcmIXRlENw3n4e+xZq/VDeQ6DOORwLJO+PIsdlRsoEKYwMoASyEpCrdNhZLwrGMpHIQ+/vFC8UpzgOJTo+Shbghay3EzECG0wcMkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=EGeV/H00; arc=none smtp.client-ip=185.70.43.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="EGeV/H00"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1769520172; x=1769779372;
	bh=7rGQy8U1nL27WhYm+OTT9cv+PGaH7TTLwzqe+/DV90s=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=EGeV/H00we3mfnmOO2zKPJd6l4MI9KLLhsoG4l3Cvr1vre/BhHkYej8Ksb565PGUs
	 jjL1sVDMQ2zmXieM5BuBYiDS52pQdmj/hmeaNX48/Rq6MrDCwD1ReWc1N38wENFBk3
	 sj22ngyg6NhtmsJjer0Vx2lHGhYsSk7DbO9j7qGFPOh3VHjeIE4eU8Vpf/2Ntp+oCh
	 yrVqUNi/oSYwFg4w2zch3Z3DSJ3uxxHtz+f8v9Eu9bRR6uJmvK/S67hHB1iHK1XeIr
	 MZNdWaEdF14I5xt0/osd+hf8B4eVi2X45WFwIMIO/ROoyxMBuAiRj1SAn0crJe7uIr
	 qN2CuT7KSxY/g==
Date: Tue, 27 Jan 2026 13:22:47 +0000
To: Florian Westphal <fw@strlen.de>
From: "Remy D. Farley" <one-d-wide@protonmail.com>
Cc: Donald Hunter <donald.hunter@gmail.com>, Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>, Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH v6 5/6] doc/netlink: nftables: Add getcompat operation
Message-ID: <UQH3L3tF4h7c1fSG9jiwLDOlbwlsoqbmP_3oKD-sjVhUZB0YoSEy0TUD5DZ09eLwxVu55xOuEJ5wDx5pWBROF0VAWQvwdYNmw8KEGxzvvnA=@protonmail.com>
In-Reply-To: <aXi26_vIXqQPhopG@strlen.de>
References: <20260121184621.198537-1-one-d-wide@protonmail.com> <20260121184621.198537-6-one-d-wide@protonmail.com> <aXiiYOxuXVn5YhXG@strlen.de> <Y2VtJPFWA2Kgxe16KslviULQU9LRZsdYFsoUD6VZ9CH-49a2P2fwiQ9B03i3Rmfq6tUczD-oiGpWCCs9aPGwwD2N-vVzy4cFIZT7F7-83Fc=@protonmail.com> <aXiwkXKg7uvIon4p@strlen.de> <2mi8BfZGa57pxicf4pXNT_oDJ3bvV7pByJOBhG8e7u_3eBbjubS3YJ88xHp4oDiMi3iY20zcG6FgF8_m5nsJJ_3CYHNftjAL_4EAqN5zeU0=@protonmail.com> <aXi26_vIXqQPhopG@strlen.de>
Feedback-ID: 59017272:user:proton
X-Pm-Message-ID: b7a9d5e5c2619d314fc092bb1c7c183696c737ff
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tuesday, January 27th, 2026 at 13:00, Florian Westphal <fw@strlen.de> wr=
ote:

> Remy D. Farley one-d-wide@protonmail.com wrote:
>=20
> > > Its used by compatibility mode, it requires an nft binary linked
> > > to libxtables, native nftables doesn't need it.
> > >=20
> > > I would prefer not to mention its existence.
> >=20
> > Ah, I see. Netlink-bindings have a tool to decode netlink communication=
, so
> > it's a bit awkward to show a bunch of unkown-operations on a common com=
mand.
> > I'm fine keeping it downstream.
>=20
>=20
> No, showing unknown-operations is even worse.
> Maybe just document in commit message that this is to avoid
> clutter and present something more readable.
>=20
> And perhaps mention that this is only for iptables-nft in the yaml file t=
oo.
> (nft uses it on 'nft list' only if it encounters a rule added by iptables=
-nft).

Do you mean to still add getcompat operation to spec in the kernel tree?
In case I misrepresented it, netlink-bindings is not a kernel project. And
AFACT, this issue isn't relevant for ynl C library, as it would only try to
decodes messages from operations you sent.

https://github.com/one-d-wide/netlink-bindings
