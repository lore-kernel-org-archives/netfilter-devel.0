From: Eric Leblond <eric@inl.fr>
Subject: Re: ULOGD2 PostgresSql errors
Date: Sat, 12 Apr 2008 11:49:25 +0200
Message-ID: <20080412094925.GG20469@bayen.regit.org>
References: <200804111605.39957.anton.vazir@gmail.com> <20080411193312.GE20469@bayen.regit.org> <200804121243.08408.anton.vazir@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ieNMXl1Fr3cevapt"
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Anton <anton.vazir@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:44386 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757051AbYDLJta (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Apr 2008 05:49:30 -0400
Content-Disposition: inline
In-Reply-To: <200804121243.08408.anton.vazir@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--ieNMXl1Fr3cevapt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Saturday, 2008 April 12 at 12:43:08 +0500, Anton wrote:
> Erik,
>=20
> Seems it fixes ICMP inserts.

Ok, fine.

> Just for testing I tried MYSQL=20
> logging too - it works without errors in log file, and=20
> looks it logs more data than PGSQL.=20

Yes, we're working on this issue. It seems PGSQL do not manage to find
the called SQL function due to type detection problem. This cause PGSQL
to loose some packets.

BR,

>=20
> Regards,
> Anton.
>=20
> On Saturday 12 April 2008 00:33, Eric Leblond wrote:
> > Hello,
> >
> > On Friday, 2008 April 11 at 16:05:39 +0500, Anton wrote:
> > > Hello!
> > >
> > > ulogd.log output is below:
> > >
> > > Fri Apr 11 16:00:10 2008 <7> ../../util/db.c:185 no
> > > connection to database, attempting to reconnect after 2
> > > seconds Fri Apr 11 16:00:10 2008 <5> ulogd.c:488 error
> > > during propagate_results Fri Apr 11 16:00:12 2008 <1>
> > > ulogd_output_PGSQL.c:99 SELECT nspname FROM
> > > pg_namespace n WHERE n.nspname=3D'public' Fri Apr 11
> > > 16:00:12 2008 <1> ulogd_output_PGSQL.c:109 using schema
> > > public Fri Apr 11 16:00:12 2008 <7>
> > > ulogd_output_PGSQL.c:295 execute failed (ERROR:=20
> > > function insert_packet_full(unknown, unknown, integer,
> > > unknown, integer, unknown, unknown, integer, unknown,
> > > unknown, integer, integer, integer, integer, integer,
> > > integer, integer, integ er, integer, integer, integer,
> > > bigint, integer, unknown, unknown, unknown, unknown,
> > > unknown, unknown, unknown, unknown, unknown, unk nown,
> > > unknown, unknown, unknown, unknown, unknown, unknown,
> > > unknown, unknown, unknown, unknown, unknown, unknown,
> > > integer) does not exist at character 8
> > > HINT:  No function matches the given name and argument
> > > types. You might need to add explicit type casts. )
> >
> > This one is already spotted, we will try to work on this
> > next week.
> >
> > > Fri Apr 11 16:00:14 2008 <7> ../../util/db.c:185 no
> > > connection to database, attempting to reconnect after 2
> > > seconds Fri Apr 11 16:00:14 2008 <5> ulogd.c:488 error
> > > during propagate_results Fri Apr 11 16:00:17 2008 <1>
> > > ulogd_output_PGSQL.c:99 SELECT nspname FROM
> > > pg_namespace n WHERE n.nspname=3D'public' Fri Apr 11
> > > 16:00:17 2008 <1> ulogd_output_PGSQL.c:109 using schema
> > > public Fri Apr 11 16:00:17 2008 <7>
> > > ulogd_output_PGSQL.c:295 execute failed (ERROR:=20
> > > smallint out of range CONTEXT:  SQL function
> > > "insert_icmp" statement 1 SQL statement "SELECT=20
> > > INSERT_ICMP( $1 , $2 , $3 , $4 , $5 , $6 , $7 )"
> >
> > This one is new, could you try the attached patch ? It
> > should fix this last problem.
> >
> > BR,
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--ieNMXl1Fr3cevapt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIAIWlnxA7CdMWjzIRAnXWAJ9eHMMMD/nVHzUDCp0mQEJOLoO+QwCePpxD
bCFB3+5rRTvyv5aQWLLDYQk=
=Nj0J
-----END PGP SIGNATURE-----

--ieNMXl1Fr3cevapt--
