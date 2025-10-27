Received: from smtpfb2-g21.free.fr (smtpfb2-g21.free.fr [212.27.42.10])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C023A2DFA31
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Oct 2025 22:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.27.42.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761604858; cv=none; b=NLBeFW7yL51yfl0oSTXRz6jYsl+rWwbRHP36eyuesz5qe4aVkUINvHqVCsn6/CNy/sw7UFh0htGbc53pvwDE/py58W3SAaCfBN5otd8K2QqF1YivZK/+S0rWmx7po5v8huIpUJ/vLOhAt9PorYDpn/duMFdJhjpMvGTmzlgP6Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761604858; c=relaxed/simple;
	bh=t/xOUHxI30whEdwK8uc5QBvrXNw4uidswqYEiYdXwg4=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:Subject:MIME-Version:
	 Content-Type; b=bGcKuEr9jKlk3w0i6bMfGx8pjIhs/g3RwCyDkgGbGg4POA4phmg8nJtoKR4Q3SZ0WwZ3zaRHXcm4ohIcTxsmh+DSNGP6Kerd85hvrSFdI2viiRaUOVZ/CZcqcISVxTzkxKfERjYrbqJdPNpoGWD62rcWgUkzffXNZaEKoh4BGec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=free.fr; spf=pass smtp.mailfrom=free.fr; dkim=pass (2048-bit key) header.d=free.fr header.i=@free.fr header.b=M16pMWTu; arc=none smtp.client-ip=212.27.42.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=free.fr header.i=@free.fr header.b="M16pMWTu"
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5])
	by smtpfb2-g21.free.fr (Postfix) with ESMTP id CA38E4CC92
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Oct 2025 23:40:45 +0100 (CET)
Received: from zimbra62-e11.priv.proxad.net (unknown [172.20.243.212])
	by smtp5-g21.free.fr (Postfix) with ESMTP id D22045FFAA;
	Mon, 27 Oct 2025 23:40:37 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=free.fr;
	s=smtp-20201208; t=1761604837;
	bh=t/xOUHxI30whEdwK8uc5QBvrXNw4uidswqYEiYdXwg4=;
	h=Date:From:To:Cc:In-Reply-To:Subject:From;
	b=M16pMWTuxclUQxtQOUi/GQ2lCm8iFvcfrNyKQcvCmyepWrXbsbUP64GN9cfhBcrj8
	 20ViKIF5KNIEYII1x48TdpB9OKE2Tk3aWoK/q0IEdNLpXOUXY872EjnW9s5jcKL/oj
	 n4YlCm12c2zJo+v6T3qadU4svWYm3Mlr4SSCVQh/rrZBINrPgrVJaOaDYy7xwD4kv8
	 Fx66IYrHEU8Moinx5TqUdgHD+oWn9dkC301HfYSZ+H50pnbGD/cjc3Mekm3X4TezdY
	 l7DbT2CGbdpnooAtaGgaW4v4pa1Gkk1F8jjLMyfNLWAUIVsHNk3XHAJvtSHvdUk2Cr
	 9AEIwNLmHp2MQ==
Date: Mon, 27 Oct 2025 23:40:37 +0100 (CET)
From: "Antoine C." <acalando@free.fr>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>, 
	Eric Woudstra <ericwouds@gmail.com>
Message-ID: <628074913.12181179.1761604837771.JavaMail.root@zimbra62-e11.priv.proxad.net>
In-Reply-To: <aP-76gB9axgCebpL@strlen.de>
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


----- Florian Westphal <fw@strlen.de> a =C3=A9crit=C2=A0:
> Antoine C. <acalando@free.fr> wrote:
> >=20
> > This bug does not seem to get a lot of attention but may be it
> > deserves at least to be filed ?
>=20
> Its a design bug and so far not a single solution was
> presented.
>=20
> And no one answered any of the questions that I asked.
>=20
> So, whats YOUR opinion?
>=20
> > > Should "ip saddr 1.2.3.4" match:
> > >=20
> > > Only in classic ethernet case?
> > > In VLAN?
> > > In QinQ?
> > >=20
> > > What about IP packet in a PPPOE frame?
> > > What about other L2 protocols?

As a user, my answer would be of course that "ip xxx" rules=20
work seamlessly whatever the encapsulation is above. I have
been trying to do for a few weeks with iptables what I just
did with nft (for reasons  external to this problem) and I
can only praise how this was easy and elegant with nft,=20
despite of this bug (to give more context: I am converting
a huge access control list with L2/L3/L4 fields to=20
NFT/iptables rules).

Of course, this is just my personal use case and I fully=20
understand that my wishes come after under-the-hood=20
constraints or main cases optimizations. But at least,
I would expect an error or a warning if I ask nft=20
something ending up in undefined behavior.

Antoine
