From: Eric Leblond <eric@regit.org>
Subject: Re: pgsql-ulogd2
Date: Sat, 14 Jul 2012 23:22:39 +0200
Message-ID: <1342300959.6098.8.camel@tiger.regit.org>
References: <50002CEF.508@googlemail.com>
	 <1342194935.11019.12.camel@tiger.regit.org>
	 <50016D84.5080207@googlemail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-JlYqHI+Y/uJ4+cAy/KVw"
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:37547 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285Ab2GNVX1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 14 Jul 2012 17:23:27 -0400
In-Reply-To: <50016D84.5080207@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-JlYqHI+Y/uJ4+cAy/KVw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

Le samedi 14 juillet 2012 =C3=A0 14:00 +0100, Mr Dash Four a =C3=A9crit :
> > No work is planned on that but it is a good idea.
> >  =20
> Yeah, I thought as much.
>=20
> >> If not, I think I have enough PostgreSQL experience and could alter th=
at script to include such implementation, though I might need help with the=
 NFLOG/ULOGD2 part as I am fairly new to this.
> >>    =20
> >
> > I'm here to help ;)
> >  =20
> OK, for now I have some general queries with regards to ulogd2. When I=
=20
> gain more knowledge (and experience) my queries will become more=20
> specific. For now though I have to sort out the following:
>=20
> In the manual there is a very good example on how to use NFLOG (as a=20
> iptables target), but I have no idea how to apply and select NFACCT and=
=20
> NFCT. How do I use this?

For NFCT, you simply need to have nfnetlink_conntrack loaded.

Things are more complicated for NFACCT and I've just wrote a page
dedicated to this point:
https://home.regit.org/2012/07/flow-accounting-with-netfilter-and-ulogd2/


>=20
> OK, I defined 2 stacks which use both NFCT and NFACCT, but how do I tell=
=20
> iptables how to use them? I presume this is in a similar way to NFLOG=20
> (with a target), but in that manual there are no examples (or even=20
> hints) given on how to use that.
>=20
> Also, there are quite a few plugins which I have just a vague idea what=
=20
> they do (they are not documented in the manual - I presume because they=
=20
> were recently introduced) - GPRINT springs to mind, NACCT is the other.=
=20

GPRINT is a one line per item textual log. NACCT is an tab separated
output format dedicated to NFACCT data and that can be used to import
data in other tools (Astaro does so).

> Is there a description on the purpose of these and their configuration=
=20
> parameters, if any?

To now which keys are used and whch config var are available, you can
use the -i option of ulogd:

ulogd -i libexec/ulogd/ulogd_filter_MARK.so=20
Name: MARK
Config options:
        Var: mark (Integer, Default: 0)
        Var: mask (Integer, Default: -1)
Input keys:
        Key: ct.mark (unsigned int 32, optional)
        Key: oob.mark (unsigned int 32, optional)
Output keys:
        No statically defined keys


> Probably my last 2 queries for now: when I define a stack, I use a=20
> series of plugins to define a chain - from the source of where the=20
> packet originates, to a cascade of "filters" and then the output plugin.
>=20
> Does the order of "filter" plugins matters (in other words, are they=20
> traversed from left-to-right in the order they are specified in the=20
> "stack" statement in ulogd.conf) or is this order irrelevant?

This is read from end to start. All that matter is that for a plugin the
needed keys are exported by another plugin on the left.
=20
> And the second query: usually every plugin, when defined in a stack=20
> statement has its own section when the various plugin parameters are=20
> defined. Say, "emu1" has its own "[emu1]" section in ulogd.conf and=20
> there I could define various parameters related to the LOGEMU plug in.
>=20
> There are some plugins though, which do not have such section, which=20
> follows me to conclude that either defining that section is not=20
> mandatory (in which case I presume the plugin "assumes" default values)=
=20
> or, the plugin in question does not have any values to be specified, so=
=20
> no such section is needed. Am I correct in this assumption?

Yes, there is default value. But for at least INPUT plugins, you need to
specify a section. I really don't remember why but this is the case.

>=20
> >> The idea I have is that the ulogd2 daemon should only be allowed INSER=
T permissions (nothing else) to the log tables, so that even if someone is =
able to hijack the ulogd2 connection to PostgreSQL somehow, they won't be a=
ble to see what has been logged, let alone alter it or delete it.
> >>    =20
> >
> > That's a sane setup.
> >  =20
> I will dig much more deeper into this once I know how ulogd works as my=
=20
> knowledge of ulogd2 is not that great (yet!). My initial instinct is=20
> that I may have to alter this script slightly, because from what I=20
> gather ulogd2 is "sensing" the structure of the logging table by reading=
=20
> the "description" of it in PostgreSQL. That particular operation usually=
=20
> requires higher-than-needed privileges and in order to avoid that I=20
> might need to find other ways to impose the "insert-only" restriction,=
=20
> which, lets be clear, is what ulogd needs. Again, I might be wrong with=
=20
> this, but that is what my initial observations with the script and ulogd=
=20
> suggest.

Yes, there's a discovery system that may require some tuning. But it can
be made on a separate table use for the only purpose of describing the
variables.

> > INL company is dead but I'm sure that Pierre is still reading this ML
> > from another mail ;)
> >  =20
> Ah, that explains it! Well, if he reads this thread, I would love to get=
=20
> some feedback when I am confident enough to start digging into that=20
> script. ;-)
>=20

BR,
--=20
Eric Leblond=20
Blog: http://home.regit.org/ - Portfolio: http://regit.500px.com/


--=-JlYqHI+Y/uJ4+cAy/KVw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlAB4yAACgkQnxA7CdMWjzJYUACfS6AaNZoVXpEWfimYXKaRKQZD
WUQAmQFnkANxV8a2MyztSpUzaiY2eax6
=w5R8
-----END PGP SIGNATURE-----

--=-JlYqHI+Y/uJ4+cAy/KVw--

