Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22F12D7DC4
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Oct 2025 18:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.27.42.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761589623; cv=none; b=QAFMoCLCBrGE3ZOJD3kUiayoDifPTUbqb0kQwLtf9QXXhnRGSjslsKv0TH5JDq0cQjmOByGNNGWFP0aJPOHXfU/3dS9KF/7Ilzt0f9MKAJtEuR86IOPvuk9imJGSCgKcxTDp03IzOBje+tQVYRsyGcBUmA6A/im+0Kbhj6+oNdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761589623; c=relaxed/simple;
	bh=h6uaSiBNogAL9oC+5fzy3e2+FvzhZZtWPqYwZQhWr20=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:Subject:MIME-Version:
	 Content-Type; b=ajKsPdKH0q8dQV6kTL1QKJsRkZS8DERYHFXUq6hHEkRmMTtxfRE2goJkD6K/3RZ3Nuk/qJGweuaseb8P2+VGieCdLAZ056KgFVnfuLZXHCpbJnSGF4fUjuZo0MeCbgp+BXtRg+JK7MsbQ1N26jG2g6zOKzlSVYK3gaBB/iKw0d8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=free.fr; spf=pass smtp.mailfrom=free.fr; dkim=pass (2048-bit key) header.d=free.fr header.i=@free.fr header.b=jaGKZX1x; arc=none smtp.client-ip=212.27.42.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=free.fr header.i=@free.fr header.b="jaGKZX1x"
Received: from zimbra62-e11.priv.proxad.net (unknown [172.20.243.212])
	by smtp4-g21.free.fr (Postfix) with ESMTP id A42A719F5C3;
	Mon, 27 Oct 2025 19:26:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=free.fr;
	s=smtp-20201208; t=1761589612;
	bh=h6uaSiBNogAL9oC+5fzy3e2+FvzhZZtWPqYwZQhWr20=;
	h=Date:From:To:Cc:In-Reply-To:Subject:From;
	b=jaGKZX1x0vW8vQrQuyv7ujM1VI4IV0oN37IbbD5/bu5s24VqbX16pEyokvO5PgRMi
	 FAv4sqZ20aH6DA9eVFDMvN+UuOEJoYkzmh7/yHVZ1CFlN9jqiBQIt3P4f42an0Dii6
	 hx/ToYZrTDnINeb89jm3cmV3TQiAFyV5/Jw5FAPNUoK2dgza2bWrZue0W+gUMxQ1XM
	 1D8HE3P4207IfBrkGizbYdJ7FTeLGQxQsL4gAw0xaoktfMKo4Sw6goNHuLH+MEodrO
	 I4AUIIYcAedZHIf6GwHIyRMDxUKlGlVcKNL24YKFyN7iSnKM9zaDsCGxCc50N2GyhK
	 eGmCxxxe3s+ww==
Date: Mon, 27 Oct 2025 19:26:52 +0100 (CET)
From: "Antoine C." <acalando@free.fr>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>, 
	Eric Woudstra <ericwouds@gmail.com>
Message-ID: <1676410308.11476569.1761589612512.JavaMail.root@zimbra62-e11.priv.proxad.net>
In-Reply-To: <aOwhNIqlsbmeyTPA@strlen.de>
Subject: Re: bug report: MAC src + protocol optiomization failing with
 802.1Q frames
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Mailer: Zimbra 7.2.0-GA2598 (zclient/7.2.0-GA2598)
X-Authenticated-User: acalando@free.fr


This bug does not seem to get a lot of attention but may be it
deserves at least to be filed ?

I have tried to do it myself after requesting an account on=20
bugzilla but I do not have the necessary permissions.

Thanks,
Antoine


----- Florian Westphal <fw@strlen.de> a =C3=A9crit=C2=A0:
> Antoine C. <acalando@free.fr> wrote:
> > Following the mails I sent on the user mailing list, it seems that
> > there is a bug occurring with the first rule below (the second is
> > fine):
> >=20
> > # nft list table netdev t
> > table netdev t {
> >         chain c {
> >               ether saddr aa:bb:cc:dd:00:38 ip saddr 192.168.140.56 \
> > log prefix "--tests 1&2 --"
> >               ip saddr 192.168.140.56 ether saddr aa:bb:cc:dd:00:38 \
> > log prefix "--tests 2&1 --"
> >         }
> > }
> >=20
> > It is translated this way:
> > netdev t c
> >   [ meta load iiftype =3D> reg 1 ]
> >   [ cmp eq reg 1 0x00000001 ]
> >   [ payload load 8b @ link header + 6 =3D> reg 1 ]
> >   [ cmp eq reg 1 0xddccbbaa 0x00083800 ]
> >   [ payload load 4b @ network header + 12 =3D> reg 1 ]
> >   [ cmp eq reg 1 0x388ca8c0 ]
> >   [ log prefix --tests 1&2 -- ]
> >=20
> > The MAC source and the protocol are loaded at the same time
> > then checked... but with an 802.1Q packet, it is actually=20
> > wrong: the ethertype will be 0x8100 and the protocol (here=20
> > IPv4, 0x0800), will be 4 bytes further. And it that case,
> > the second test above will succeed because the protocol=20
> > is loaded independently.
> >=20
> > I just tested with latest versions of libmnl/libnftnl/nft=20
> > and I get the same behavior.
>=20
> The question is what these rules should actually match, there
> are no consistent semantics in nftables for bridge and
> netdev families: The existing behaviour is undefined resp.
> random.
>=20
> Should "ip saddr 1.2.3.4" match:
>=20
> Only in classic ethernet case?
> In VLAN?
> In QinQ?
>=20
> What about IP packet in a PPPOE frame?
> What about other L2 protocols?
>=20
> Pablo, I can't come up with any good answer for this; I think
> an explicit dissector expression is needed to populate l3 and l4
> information into nft_pktinfo structure for bridge/netdev families so
> "ip saddr" would only ever match plain ethernet (no vlans, no pppoe).
>=20
> This also means the existing skb->protocol based dependencies
> need to die resp. check for offloaded vlan headers.
>=20
> Whats your take?
>=20
> This is also related to Eric Woudstras work to add qinq+pppoe
> automatching.

