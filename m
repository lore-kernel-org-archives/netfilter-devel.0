From: Eric Leblond <eric@regit.org>
Subject: Re: pgsql-ulogd2
Date: Sun, 15 Jul 2012 22:52:08 +0200
Message-ID: <1342385528.8476.2.camel@tiger.regit.org>
References: <50002CEF.508@googlemail.com>
		 <1342194935.11019.12.camel@tiger.regit.org>
		 <50016D84.5080207@googlemail.com>
	 <1342300959.6098.8.camel@tiger.regit.org> <5002B688.4070907@googlemail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-2wqQxRHG2mZrKJAm25ez"
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:44409 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab2GOUw5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 15 Jul 2012 16:52:57 -0400
In-Reply-To: <5002B688.4070907@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-2wqQxRHG2mZrKJAm25ez
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

Le dimanche 15 juillet 2012 =C3=A0 13:24 +0100, Mr Dash Four a =C3=A9crit :
> > For NFCT, you simply need to have nfnetlink_conntrack loaded.
> >  =20
> I did, but I also made the mistake of including a few filters in that=20
> stack, which were incompatible and that was the reason I did not get any=
=20
> NFCT logs. Once that was corrected I started seeing connection tracking=
=20
> logged.
>=20
> I have another question with regards to this: Is it possible to limit=20
> (by a separate filter or otherwise) the reporting and restrict it, to=20
> say, a specific set of interfaces or specific source/destination IP=20
> addresses/subnets?
>=20
> Currently, NFCT reports absolutely everything, which is not what I=20
> really want as I have to sift through thousands of logs, not to mention=
=20
> that by reporting everything the system load is much higher.
>=20
> So, is there a way for me to do that, somehow?

Not now but I'm working on it: Pablo has made a filter system in
libnetfilter_conntrack. I will used it to filter.
>=20
> > Things are more complicated for NFACCT and I've just wrote a page
> > dedicated to this point:
> > https://home.regit.org/2012/07/flow-accounting-with-netfilter-and-ulogd=
2/
> >  =20
> Very helpful, thanks! I don't see it as complicated at all, certainly no=
=20
> more complicated than the existing accounting techniques.

Yes, not that complicated, documentation was just lacking.

>=20
> >> Is there a description on the purpose of these and their configuration=
=20
> >> parameters, if any?
> >>    =20
> >
> > To now which keys are used and whch config var are available, you can
> > use the -i option of ulogd:
> >
> > ulogd -i libexec/ulogd/ulogd_filter_MARK.so=20
> > Name: MARK
> > Config options:
> >         Var: mark (Integer, Default: 0)
> >         Var: mask (Integer, Default: -1)
> > Input keys:
> >         Key: ct.mark (unsigned int 32, optional)
> >         Key: oob.mark (unsigned int 32, optional)
> > Output keys:
> >         No statically defined keys
> >  =20
> Or look at the source code, which is what I did at the end.

:)

>=20
> >> I will dig much more deeper into this once I know how ulogd works as m=
y=20
> >> knowledge of ulogd2 is not that great (yet!). My initial instinct is=
=20
> >> that I may have to alter this script slightly, because from what I=20
> >> gather ulogd2 is "sensing" the structure of the logging table by readi=
ng=20
> >> the "description" of it in PostgreSQL. That particular operation usual=
ly=20
> >> requires higher-than-needed privileges and in order to avoid that I=
=20
> >> might need to find other ways to impose the "insert-only" restriction,=
=20
> >> which, lets be clear, is what ulogd needs. Again, I might be wrong wit=
h=20
> >> this, but that is what my initial observations with the script and ulo=
gd=20
> >> suggest.
> >>    =20
> >
> > Yes, there's a discovery system that may require some tuning. But it ca=
n
> > be made on a separate table use for the only purpose of describing the
> > variables.
> >  =20
> Yep, the pgsql plugin makes extensive use of pg_namespace, pg_class and=
=20
> pg_attribute which are system tables. These contain definitions of every=
=20
> single object registered on that database server and is a major security=
=20
> risk (as I pointed out, if that ulogd connection to the database server=
=20
> is hijacked, then the attacker could find out what is on that database=
=20
> without any problems, which is not good).

You're right.

> I had in mind exactly what you've suggested above - use a separate,=20
> manually-registered table containing the table columns and their mapping=
=20
> to ulogd2 parameters - much less risk and everything is configurable,=20
> though the downside is that the two tables need to be synchronised if=20
> the structure of the main ulogd table changes (columns renamed or added).

It seems the safest way.

BR,
--=20
Eric Leblond=20
Blog: http://home.regit.org/ - Portfolio: http://regit.500px.com/

--=-2wqQxRHG2mZrKJAm25ez
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlADLXkACgkQnxA7CdMWjzLyMACfUP4PuRwBQKRxd1ViSzRzxOLv
7JQAn3jkDKEWWGZJloG9PG1S9a83cY7b
=Sv1M
-----END PGP SIGNATURE-----

--=-2wqQxRHG2mZrKJAm25ez--

