From: Eric Leblond <eric@inl.fr>
Subject: Re: [ULOGD PATCH 0/8] Allow reuse of plugin instance (and misc
	fixes)
Date: Tue, 25 Mar 2008 16:36:10 +0100
Message-ID: <20080325153610.GE12027@khasse.inl.fr>
References: <12051021893015-git-send-email-eric@inl.fr> <47E8CDF5.4010200@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="S1BNGpv0yoYahz37"
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:46430 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755555AbYCYPgN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 11:36:13 -0400
Content-Disposition: inline
In-Reply-To: <47E8CDF5.4010200@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--S1BNGpv0yoYahz37
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tuesday, 2008 March 25 at 11:03:33 +0100, Pablo Neira Ayuso wrote:
> Eric Leblond wrote:
> > Hello,
> >=20
> > This patchset starts with some cleaning:
> >  - Add hook to list of fields in database for packet logging.
> >  - Introduce RAWSTR type to avoid confusion in future developement.
> >  - Fix indentation in ulogd_inppkt_NFLOG.c
> >=20
> > Latest patches introduce a modification of plugin behaviour. It was not
> > possible with existing code to reuse a plugin instance. For example, it
> > is not possible to do :
> > stack=3Dlog1:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,print1:PRINTP=
KT,emu1:LOGEMU
> > stack=3Dlog1:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,print1:PRINTP=
KT,emu2:LOGEMU
>=20
> I'd appreciate a patch with a more realistic example that I can apply to
> SVN.

I've tried to add an example in the example configuration file but I've
found that some matching examples seems already available. Follow an excerp=
t of=20
ulogd.conf.in (taken from my last patchset):

# this is a stack for NFLOG packet-based logging to PCAP
#stack=3Dlog1:NFLOG,base1:BASE,pcap1:PCAP

# this is a stack for logging packet to MySQL
#stack=3Dlog1:NFLOG,base1:BASE,ifi1:IFINDEX,ip2bin1:IP2BIN,mac2str1:MAC2STR=
,mysql1:MYSQL

Furthermore, I think the behaviour obtained with that patchset is what user=
s are
waiting from ulogd2. IMHO, it is not necessary to add long explanation
in the configuration file.

But, just to be sure it is written somewhere, I've added a more detailled e=
xplanation
of multiple usage of an instance in my ulogd configuration page:
	http://software.inl.fr//trac/wiki/ulogd2/user

BR,
--=20
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--S1BNGpv0yoYahz37
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFH6RvqnxA7CdMWjzIRAhecAKCO09XNlyh1qXgUBzn6CT23l6qgMACfTkQd
yGZhxd3QwC+FejCLJTo27hE=
=pT5+
-----END PGP SIGNATURE-----

--S1BNGpv0yoYahz37--
