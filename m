Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B251327FD
	for <netfilter-devel@vger.kernel.org>; Fri,  5 Apr 2024 20:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712349554; cv=none; b=DVAt/VuFw4SL6QZScahJm/OeMsGb3ZqFf1j5rW1MuaWwniqcZEmpMfQjOuA+D6k9vjuRuf/JMy0oNiniVa7N8GlQjzpa6jqN81vxB7ERelkE92ZJnNNcn8YFQNwpfC4vDCux27/CCGrTJzSs9Nb46lC+5iZ8WzTKOzpiROyUfqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712349554; c=relaxed/simple;
	bh=2q1hcGm4DsCOrQQbsdzT37pwMJebAcfrPo6Ptweum2Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oGjX6tGDrE1UgZpcggRYymSFZVfrVMP38tZMywzKpdnk9/MCpYU8gQxGUHb6a3NFGMLb7WzqLYfo2TwJMaF0ClfwcbhtOBhfUKlmQYDZ5wCtxlZ/1Ykt4xXkGeVYMACK2x7n7y58jAjDyFiXvUSJb1VqxkjrodVi/ue3BxniVlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=UvjB8MG3; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="UvjB8MG3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=f71rrOWB3jxvxRf4CpMqAXWFwVnwtaqBqB0wu7bfwWI=; b=UvjB8MG3Ibeu6HLF016F2Hrbno
	C2Uq/58XObHn3IxuVaI/EuldKcYYlMsJeyMJbkd/zzYcZuU94mPqh6v1/JghJWvNoKvVAVSMEjzUB
	3wwEDfbogrdN1yne9icKpECjbB10Qb7zdClo3YypE5YJ8Zn1VBfOEaaFEqPbL5/yEzUwFEo1fJcvv
	HFMRRmuo8GO/aniTSJXUl4FbJrt3nbtJs6955fvrydAZ7Z1dfC6G9wQxmnidBV3V93Ww/XZlTN37r
	BjxOKxFE3XNdD2jCE8TnFmmrExVLJxi+daIhqFlhkUEaxcqXSyqhgJ/uYXUxWmm6Z7WufElXamVUp
	qUBbRyxg==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1rsqKv-0022lq-28;
	Fri, 05 Apr 2024 21:38:57 +0100
Date: Fri, 5 Apr 2024 21:38:56 +0100
From: Jeremy Sowden <jeremy@azazel.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft v2 0/2] Support for variables in map expressions
Message-ID: <20240405203856.GB1083504@celephais.dreamlands>
References: <20240403120937.4061434-1-jeremy@azazel.net>
 <Zg6NUHYLHYbIgKtq@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="4l05OZYazoDqyPfp"
Content-Disposition: inline
In-Reply-To: <Zg6NUHYLHYbIgKtq@calendula>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false


--4l05OZYazoDqyPfp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2024-04-04, at 13:21:52 +0200, Pablo Neira Ayuso wrote:
> On Wed, Apr 03, 2024 at 01:09:35PM +0100, Jeremy Sowden wrote:
> > The first patch replaces the current assertion failure for invalid
> > mapping expression in stateful-object statements with an error message.
> > This brings it in line with map statements.
> >=20
> > It is possible to use a variable to initialize a map, which is then used
> > in a map statement, but if one tries to use the variable directly, nft
> > rejects it.  The second patch adds support for doing this.
>=20
> Thanks. I can trigger crashes, e.g.
>=20
> define quota_map =3D "1.2.3.4"
>=20
> table ip x {
>         chain y {
>                 quota name ip saddr map $quota_map
>         }
> }
>=20
> src/mnl.c:1759:2: runtime error: member access within misaligned address =
0x000100000001 for type 'struct expr', which requires 8 byte alignment
> 0x000100000001: note: pointer points here
> <memory cannot be printed>
> src/netlink.c:121:10: runtime error: member access within misaligned addr=
ess 0x000100000001 for type 'const struct expr', which requires 8 byte alig=
nment
> 0x000100000001: note: pointer points here
> <memory cannot be printed>
> AddressSanitizer:DEADLYSIGNAL
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =3D=3D150056=3D=3DERROR: AddressSanitizer: SEGV on unknown address 0x0000=
9fff8009 (pc 0x7f58e67d8624 bp 0x7ffd57d17eb0 sp 0x7ffd57d17c40 T0)
> =3D=3D150056=3D=3DThe signal is caused by a READ memory access.
>     #0 0x7f58e67d8624 in alloc_nftnl_setelem src/netlink.c:121
>     #1 0x7f58e67c3d12 in mnl_nft_setelem_batch src/mnl.c:1760
>     #2 0x7f58e67c45d9 in mnl_nft_setelem_add src/mnl.c:1805
>     #3 0x7f58e687df1e in __do_add_elements src/rule.c:1425
>     #4 0x7f58e687e528 in do_add_set src/rule.c:1471
>     #5 0x7f58e687e7aa in do_command_add src/rule.c:1491
>     #6 0x7f58e688fdb3 in do_command src/rule.c:2599
>     #7 0x7f58e679d417 in nft_netlink src/libnftables.c:42
>     #8 0x7f58e67a514a in __nft_run_cmd_from_filename src/libnftables.c:729
>     #9 0x7f58e67a639c in nft_run_cmd_from_filename src/libnftables.c:807
>     #10 0x557c9d25b3b0 in main src/main.c:536
>     #11 0x7f58e5846249 in __libc_start_call_main ../sysdeps/nptl/libc_sta=
rt_call_main.h:58
>     #12 0x7f58e5846304 in __libc_start_main_impl ../csu/libc-start.c:360
>     #13 0x557c9d258460 in _start (/usr/sbin/nft+0x9460)
>=20
> AddressSanitizer can not provide additional info.
> SUMMARY: AddressSanitizer: SEGV src/netlink.c:121 in alloc_nftnl_setelem
> =3D=3D150056=3D=3DABORTING
>=20
> I think this is lacking more validation.

Agreed.  Should have done more testing.  Apologies!  Will follow up.

J.

--4l05OZYazoDqyPfp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmYQYVgACgkQKYasCr3x
BA0b4xAAzyAEgUem7eGXJKoDOd5AqMbXFbhzXxir5MN1kRqjsuZHvy7RhR+jIxQU
jHjesvigw9zxWj2wA8QfxKs+BEs2x9wdGI4ZBsUuh5JeqP7F8d97OH86utiFS2x7
AbHiKY3iDKEzW820u8mfJyri3KNtToCqPhDXEXJHHnkgDtLG11UMVwFQYpa2rm65
+70d5TmG5e9F+UXCTawT97xSoHRHKsuyJJCRbjYOHTk7B5EZP5izgKjiShB9oQVw
wOT64JJK0KzNeM+bOnNoA02H6pR+j0sp2xFPij/vR98goIiQ2HPGfOmKDpWA/Ray
36V90M3bF6eToZEDmjCwObzVyFyDknQS4t+p3Jt6MHLfybRisarCvmPsdKU5ofFr
z1ijECut2QjgkhNKtbc/sopRzmV/XQ2TdWHgBy3JTrzMKqroLx3FoXwak4LzN9hn
19YOROsAEF5OUoyo4neBF+1uPiP7uG+ElKYBvddlW43dE+AaWUZJZUfZxLul52df
8KNa9XITnmzX5QnhDSMPC9a6J6ToF86tKne9OjSZhuu3xaUyJEiY8CgovgvvBT3w
aSvobUQFPSFYx5dt2+EIJsdriolTjtI5SZNsdxSL7HrzxD7o/PZU0mh759cF9cjh
LVrfBUJDOnvMKCyyRDXVzm0LMJo87Obdf0Dpfthb5eaCoIpUTO8=
=NVss
-----END PGP SIGNATURE-----

--4l05OZYazoDqyPfp--
