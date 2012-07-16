From: Eric Leblond <eric@regit.org>
Subject: Re: pgsql-ulogd2
Date: Mon, 16 Jul 2012 08:33:07 +0200
Message-ID: <1342420387.8476.20.camel@tiger.regit.org>
References: <50002CEF.508@googlemail.com>
			 <1342194935.11019.12.camel@tiger.regit.org>
			 <50016D84.5080207@googlemail.com>
		 <1342300959.6098.8.camel@tiger.regit.org>
	 <5002B688.4070907@googlemail.com> <1342385528.8476.2.camel@tiger.regit.org>
	 <500345F1.3050407@googlemail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-cBXODJeseM+ULejG59mq"
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:47139 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab2GPGd4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Jul 2012 02:33:56 -0400
In-Reply-To: <500345F1.3050407@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-cBXODJeseM+ULejG59mq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

Le dimanche 15 juillet 2012 =C3=A0 23:36 +0100, Mr Dash Four a =C3=A9crit :
> >> Currently, NFCT reports absolutely everything, which is not what I=20
> >> really want as I have to sift through thousands of logs, not to mentio=
n=20
> >> that by reporting everything the system load is much higher.
> >>
> >> So, is there a way for me to do that, somehow?
> >>    =20
> >
> > Not now but I'm working on it: Pablo has made a filter system in
> > libnetfilter_conntrack. I will used it to filter.
> >  =20
> This would be some awesome feature. I think this new filter which=20
> implements "custom" restrictions should not be for a particular input=20
> filter, but rather be universal.

Yes and no ;) (maybe maybe)

>  In other words, to be able to=20
> customise, say, certain IP addresses/subnets, certain ethernet=20
> interfaces etc, and then used anywhere in stack statements - NFCT, NFLOG=
=20
> and so on.

If this universal filter is an excellent idea, it will suffer from some
performance issue. The NFCT filter I'm currently implementing does the
filtering inside the kernel which is really efficient. For NFLOG, kernel
filtering can be done via iptables.
Implementing a userpsace filter is indeed a good idea but I don't think
it is possible to do a kernel filtering ulogd module. The ulogd
architecture will hardly deal with that because you will not be able to
access to the constructor (in the input plugin) from the filter module.


>=20
> If this is implemented, it will certainly make ulogd2 very powerful and=
=20
> flexible at the same time - a bit like what syslog-ng is to the old=20
> syslog ;-)

lol, the stack system is already a really big improvment.

>=20
> The specific reason I raised this issue is because on the main firewall=
=20
> we have here, if I deploy ulogd2 and use NFCT at its present form, I=20
> will get the logs from all 7 interfaces, and it would make it an=20
> absolutely huge task to sift through all these logs and "match" the=20
> various entries (OK, doing it through the database will help up a bit,=
=20
> but not a lot).
>=20
> If I am able to place a "custom" filter with different "filter" values=
=20
> in each separate stack, redirecting input to different places, then I=20
> would be able to track down what I want quite easily.

You should be able to do a per-network filtering with my current work. I
should have a patch ready today.

>=20
> >> I had in mind exactly what you've suggested above - use a separate,=
=20
> >> manually-registered table containing the table columns and their mappi=
ng=20
> >> to ulogd2 parameters - much less risk and everything is configurable,=
=20
> >> though the downside is that the two tables need to be synchronised if=
=20
> >> the structure of the main ulogd table changes (columns renamed or adde=
d).
> >>    =20
> >
> > It seems the safest way.
> >  =20
> It looks that way, doesn't it? In the coming days I'll look at the PGSQL=
=20
> implementation code to see whether SSL connection to the database server=
=20
> is a possibility with this plug in - it will be another good security=20
> feature if that is possible to be implemented.

Fine!

BR,
--=20
Eric Leblond=20
Blog: http://home.regit.org/ - Portfolio: http://regit.500px.com/

--=-cBXODJeseM+ULejG59mq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlADtaMACgkQnxA7CdMWjzJosgCfftarN2HlrA2PznDqeGB9ofgS
IN4AnR17QvrwPwpzqPa6FJL8dpMHLUXo
=OjFt
-----END PGP SIGNATURE-----

--=-cBXODJeseM+ULejG59mq--

