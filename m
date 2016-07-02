From: Nick Vinson <nvinson234@gmail.com>
Subject: Re: [PATCH 1/1] nft: configure.ac: Replace magic dblatex dep.
Date: Sat, 2 Jul 2016 11:40:49 -0700
Message-ID: <b75d6d02-3cc6-6058-4022-bde1e70a8aa8@gmail.com>
References: <20160625162809.11877-1-nvinson234@gmail.com>
 <20160701141546.GA8164@salvia>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="tt70wLTsDE6dPl0f6kOT4j6BtHu3Ekibo"
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33596 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbcGBSkv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Jul 2016 14:40:51 -0400
Received: by mail-pf0-f194.google.com with SMTP id c74so12769450pfb.0
        for <netfilter-devel@vger.kernel.org>; Sat, 02 Jul 2016 11:40:51 -0700 (PDT)
In-Reply-To: <20160701141546.GA8164@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tt70wLTsDE6dPl0f6kOT4j6BtHu3Ekibo
Content-Type: multipart/mixed; boundary="mbDn39qaroiSvrRtPvwbnKd07eJLQ6xiu"
From: Nick Vinson <nvinson234@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Message-ID: <b75d6d02-3cc6-6058-4022-bde1e70a8aa8@gmail.com>
Subject: Re: [PATCH 1/1] nft: configure.ac: Replace magic dblatex dep.
References: <20160625162809.11877-1-nvinson234@gmail.com>
 <20160701141546.GA8164@salvia>
In-Reply-To: <20160701141546.GA8164@salvia>

--mbDn39qaroiSvrRtPvwbnKd07eJLQ6xiu
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

I reversed the logic.  I'm also considering this thread closed.  The new
thread can be found with the subject "[PATCH 1/1 rev.1] nft:
configure.ac: Replace magic dblatex dep."  If anyone could direct any
further questions or comments to that thread, it would be much appreciate=
d.

Thanks,
Nicholas Vinson

On 07/01/2016 07:15 AM, Pablo Neira Ayuso wrote:
> On Sat, Jun 25, 2016 at 09:28:09AM -0700, Nicholas Vinson wrote:
>> Add a configure switch to enable and disable PDF document generation.
>> This switch is to replace the current method of automatically detectin=
g
>> dblatex and building the PDF documentation when present.
>=20
> I know I mentioned it was better to default this to yes on the
> bugzilla report, but I noticed this will just break many existing
> automated build infrastructure for everyone that have silently skipped
> building this.
>=20
> So could you reverse the logic? I'd suggest something like:
>=20
>         --enable-pdf-doc
>=20
> so the PDF documentation building is disabled by default.
>=20
> Thanks.
>=20


--mbDn39qaroiSvrRtPvwbnKd07eJLQ6xiu--

--tt70wLTsDE6dPl0f6kOT4j6BtHu3Ekibo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXeAqxAAoJEAQpRPZaa5gqo/IP/36e85WJQqbsdvjpt3AjldBJ
M3h0+i/vtpUDLiHVkCvQTHm5unyFhHP3hGnqlM2qQMM4iUhiRlTzNRPdGiMHih+v
OyZqy5rWK2VzEhN3/sh6fez7j+9Lh5rsNlp/6ULMTbA710ie5LJYoI1GzuvwStfY
UqcD9zULv4EnpBUfY2IO/XG+M8X1VPJvWN8TNLFnZyB+FQHL3BxC67JZMJCP8IzW
nyzELj5m2UC/WcuA1IZnBfaYZwXchkSXEp3JUrUCHdYpbKMajMJXtbHjCqrCxJwR
xF4WcUC69b0780Z5pwzbKxHomia/x4JUEk/YKwWFuDVNGKWPr5a2UkM4JP0pXLSt
q9dE1R6iI/b59z449PZE0G4TSdk9siEw6LiPblRBfsJoq2D5XC1DRZ5I1DqAruXI
u7tw6ALiwqaPNn77uDY+DDaoTsZgdoBgxsoSsYv35AJoV1egsPjWyHP3FcQPxLDo
M7a3UofveRJ9HgPIZ/g7bipQofuEROBfoYgekg94Ui7tG5URuzB3VfTE2W8mCiF2
LPABAFzHBB94nmJD7nG9H76bNkE1fxChi9gmW9EIdKhz3aOTYGCrROaj3fcjxxOu
uS5X1NVQV5R5Pb4adk2fmd/hzUZjJUFJlqpcfJX8zrcBicfllTEV4DAMBOp9bbvc
lz7TzKJrKp6by8msy72b
=4CHj
-----END PGP SIGNATURE-----

--tt70wLTsDE6dPl0f6kOT4j6BtHu3Ekibo--
