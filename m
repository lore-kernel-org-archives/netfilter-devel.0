Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=82.195.75.110
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793346346;
	b=hQWUf2Cua9lo26zTzLSyjCcP9NtfehqRaWiPKM+6fQcl13B8qQowz3tu8bg0VtoNbIqj
	 JwU7Aq9YoIq7prtkcas55I9lnhkTdRCLGBCIQ/zpVBSe5jvaHElZ6lOOiI1Vd+QGXupRd
	 Hu35IWbHU/suuP4WreWUq2p8IJomF+PfPKmd3bsuS8XdWupCDh6DaXWY2xOJAxS6loqv8
	 h0M1wOQiRfU//inp/jTKLaS+wwz24jhARbhy3tWqjZN6yKHRlDWnV0zFBxG1lkceVn0FC
	 DrxwZ0GGSap858KtCZaMfKV6vHur6zWH0OXgUN3YV09Mo7s/mp8wW0hYTtt78xGF43Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793346346;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=9RdLM63PcgtDNQn2t4uhC8H5IHmK+2XZeL09IWTjtBs=;
	b=qlSNcqYNTM5AJH/JdAPoN5cum7wDD+5RH+XctZ8WO+pjl6X7H9KWOstRbCzmSOh6Szuf
	 20ReyZWRs9mp9czTGK+hedU20ngHYW4+pnEEn6hndK///WnTMqz6GKqQSYHlj+urBZzmU
	 +fncwpVN9w5FsB6Ma1RRokXP0lQKZljFARfDKkrAqmp726oM1AV9nAdpiHmNdTQ7xTKHE
	 VLr2igzGT0UCj6bNzewJDP1bhACeQOYB57FuX4nq21/iETZI0/Ik9TbCOmBtALDu+Cm51
	 +kUofAQHOoGyM8Rf+gVYFZtBVMN90xxp8LdEtRS/ELA0Vw2u21cqX6+rew8Qj9uiq2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=debian.org;
	spf=none smtp.mailfrom=master.debian.org;
	dkim=pass header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.master header.b=vDVtjuRe;
	arc=none smtp.remote-ip=82.195.75.110
Received: from master.debian.org (master.debian.org [82.195.75.110])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82BB7606A320
	for <netfilter-devel@vger.kernel.org>; Fri, 30 Oct 2026 07:45:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 82BB7606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.master header.b=vDVtjuRe
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.master; h=In-Reply-To:Content-Type:MIME-Version:References:
	Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description;
	bh=9RdLM63PcgtDNQn2t4uhC8H5IHmK+2XZeL09IWTjtBs=; b=vDVtjuReY73vkLpLVyA3cig6hW
	lGFBkeaC9+F/Q6oKPoaGDRBV6XZU2NrjN0+m8Gc53Yyn/JGJFiF8VEIudKVrGASn7pksmM5IRQZQ1
	PKe85ODQRM6rQHTEcyhNDVrvq41ot/w20eE81puOGkAmz3GL9EC7Yl9SNNDObe9NWwkdQwDdr/T/C
	O7mFzf7kHSNmdFP6pV9S6s8EyzJIxHT6Y+VAI7xE3PDoeLhcBqnnvy7weiTFbA7V2AO/qXjE09DFV
	LVxv5x2xY1PDMD+ovERCKv8RBXEmiOOs0nhcQ0pGGEQc4KvXKQ7Q90ySZLpT5YGLzh6FwNuPfyKkU
	Mq0nldMA==;
Received: from ukleinek by master.debian.org with local (Exim 4.96)
	(envelope-from <ukleinek@master.debian.org>)
	id 1xMhIs-006pOY-16;
	Fri, 30 Oct 2026 07:45:34 +0000
Date: Fri, 30 Oct 2026 08:45:30 +0100
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <ukleinek@debian.org>
To: Philip Dodd <orange.spyderman@gmail.com>, 1149525@bugs.debian.org
Cc: Florian Westphal <fw@strlen.de>, 
	Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
Subject: Re: Bug#1149525: invalid pointer in nf_conntrack
Message-ID: <auRJp3wtNw4yaWXK@monoceros>
References: <179076304109.1376.1522422117778282591.reportbug@bellecote.private.montagnes.net>
 <59d64272-e162-486c-99c2-6f61feead01b@gmail.com>
 <auDhy6OW5SrGg3jv@monoceros>
 <auMgBQDEedGU8iiT@strlen.de>
 <179076304109.1376.1522422117778282591.reportbug@bellecote.private.montagnes.net>
 <e80f4fde-ec36-4fc3-9386-7b8c1053e1bf@gmail.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="afizrgmilfjjmzzj"
Content-Disposition: inline
In-Reply-To: <e80f4fde-ec36-4fc3-9386-7b8c1053e1bf@gmail.com>


--afizrgmilfjjmzzj
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: Bug#1149525: invalid pointer in nf_conntrack
MIME-Version: 1.0

Hello Philip,

On Fri, Oct 30, 2026 at 08:00:31AM +0100, Philip Dodd wrote:
> On 29/10/2026 11:29, Florian Westphal wrote:
> > Uwe Kleine-K=F6nig <ukleinek@debian.org> wrote:
> > > this is about a bug report filed against the Debian 7.2.12 kernel. Fu=
rther
> > > context can be found at https://bugs.debian.org/1149525.
> > >=20
> > > Note this is an arm64 machine, and the problem doesn't reproduce on 7=
=2E3.
> > >=20
> > > On Mon, Oct 26, 2026 at 08:36:01AM +0100, Philip Dodd wrote:
> > > > 7.2.12+deb14-arm64 is affected in the same way, reproduced by just =
loading
> > > > the nf_conntrack module shortly after boot.
> > > >=20
> > > > After the failure:
> > > >  =A0 =A0 nf_conntrack module use count: 0
> > > >  =A0 =A0 net.netfilter.nf_conntrack_count: 0
> > > >  =A0 =A0 nf_conntrack hashsize: 65536
> > > >  =A0 =A0 /proc/sys/kernel/tainted: 128
> > > >=20
> > > > No nf_nat or xt_* modules were loaded.
> > If thats the case, why is there a conntrack entry in the first place?
> > Is 'enable_hooks' modparam used?
>=20
> No, I'm not explicitly using |enable_hooks|. Simply running |sudo modprobe
> nf_conntrack|is sufficient to trigger the oops.
>=20
> For context, I originally encountered the oops shortly after boot during
> normal operation. I narrowed it down to occurring shortly after
> |tailscaled|started, but subsequently found that even with Tailscale
> disabled, simply loading |nf_conntrack|triggers the same oops almost
> immediately; and since I've reproduced this on all the 7.2.x kernels I've
> tested (the versions mentioned earlier in the Debian bug report), but also
> kernels compiled directly from upstream sources.
>=20
> The same |modprobe nf_conntrack|command does not trigger the oops on 7.1.x
> or 7.3.x kernels; Prior to upgrading to the first 7.2.x kernel, this host
> had also been running Tailscale with |nf_conntrack|loaded for weeks (at
> least) without any problems=A0and yesterday, I installed the 7.3.x kernel
> packages from Debian experimental and ran Tailscale for an extended period
> without encountering any issues.

Given that you know how to compile kernels for your machine, can you
please test plain 7.2? Depending on that being good or bad, I'd ask you
to do a bisection either between 7.2 and 7.2.12 (to find the breaking
commit) or between 7.2 and 7.3 (to find the fixing commit). If you
report the state of 7.2, I can prepare more detailed instruction for the
bisect if needed.

Thanks
Uwe

--afizrgmilfjjmzzj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmrkSw4ACgkQj4D7WH0S
/k5Pqgf/TCgMdE6QItpstXQIsjEd83TG2nDMsI3HjQt/oDNPKua8zrlXm1nJwDxO
EXoXFC/92KlxGrAC6rR3NJcD7EnyvThd9l4g7EGzi6Xgx8YdomBVhv+V/RgJmPNl
gmJ0SZL5hGUHEs0mQeHzJgo/a7bDa5uPbEhXhH//bXXxtCADj6u50HtC03/QjiFQ
wpPNIbsExdSllOfjmxCXjBona8agXVPvk19RSm4btjhEoGLKOPPxlwhlUdQ2cuMK
8LvCbr4X99ukju3y5zO1nhnvJb3liDX4K5WWmv9f6KtdrmYIhBsm9X+jcBNRETR6
SoAJucL4gL82asqePecv+iQBiXjhpA==
=RcLc
-----END PGP SIGNATURE-----

--afizrgmilfjjmzzj--
