From: Volker Sauer <volker@volker-sauer.de>
Subject: Re: Problem with new --physdev-out style
Date: Wed, 24 Oct 2007 14:06:22 +0200
Message-ID: <20071024120622.GB27593@volker-sauer.de>
References: <20071024071854.GA18581@volker-sauer.de> <471EF68A.702@trash.net> <471F00DC.9070001@snapgear.com> <471F03B1.3090909@trash.net> <471F0AD5.2050202@snapgear.com> <471F136D.6090907@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yEPQxsgoJgBvi8ip"
Cc: Philip Craig <philipc@snapgear.com>, netfilter@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <471F136D.6090907@trash.net>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


--yEPQxsgoJgBvi8ip
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mi, 24 Okt 2007, Patrick McHardy <kaber@trash.net> wrote:

> You're right.

Yes, he's right but only for 5 of my rules which indeed bridge between
bridges (-i $BR_GUEST -o $BR_INT).

Let me summarize the discussion so far:

The warning message means, that --physdev-out can not be used, if the
packet is actually forwarded (instead of bridged) between two interfaces
even if both interfaces are bridges. In this case you either need
proxy-arp or you need to filter by other things than physdev or yo need
some magic with marking the packets.
Okay, so far so good. I can live with that, since bridging between two
bridges is only an exemption. Usually I have only one bridge inside the
firewall with physin and physout rules. This is the case for all my
firewalls except the one I took the example from and this can easily be
fixed by removing --physdev-out and using -s or -d or something like
this. It's just the firewall of my testing site.

Coming to the real point:

99% of my rules on all my firewalls are like that:

$IPTABLES -A FORWARD -i $BR_INT -m physdev --physdev-in $IF_INT
--physdev-out $IF_DMZ -s $ZAPHOD -j ACCEPT

IF_INT (eth1) and IF_DMZ (vlan3) are both members of BR_INT (br-intern):

fw1: ~ # brctl show
br-intern               8000.000d88cd28c1       yes     eth1
                                                        vlan3

This means, that all rules like that are valid even with the new concept
of netfilter, right?? But why do I get error messages like quoted in my
first mail for these rules - it *is* bridged traffic inside *one*
bridge!
And: I don't see how --physdev-is-bridged should help, since it's a
match and not a command to the kernel saying: "this *is* bridged
traffic". It the kernel does not see this by itself,
--physdev-is-bridged doesn't help.


=46rom all your answers, I still do not get, why this rule is supposed
not to work anymore!!


If my arguments are correct, I suggest the following improvement:

In case someone is using physdev in OUTPUT, display the message like it
is now: "using --physdev-out in the OUTPUT chains for non-bridged traffic
is not supported anymore".

In case it is used inside FORWARD, check if all physdev interfaces are
members of the same bridge. If yes, accept the rule, because then it is
allowed to use it!!!  (Which is the case all the thousands of rules in
my firewalls except the 5 that I sent to this list :-().
If no, display a message like this:

"physdev match: using --physdev-out in the FORWARD chains is only=20
allowed if all physical interfaces are members of the same bridge."


What do thing about that?

Regards
Volker


--=20
  Volker Sauer  *  Poststrasse 1/601   *   64293 Darmstadt  *   Germany
  E-Mail/Jabber: volker(at)volker-sauer.de * http://www.volker-sauer.de
  PGPKey-Fingerprint: DB26 11C7 B12E 0B27 3999 2E4F 7E35 4E4D 5DD5 D0E0
  http://wwwkeys.de.pgp.net/pks/lookup?op=3Dget&search=3D0x7E354E4D5DD5D0E0=
=20

--yEPQxsgoJgBvi8ip
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHHzU+fjVOTV3V0OARAjUNAKDYVWlkbxmp8skHGPBOWcHrOPxxvACeLK6I
YBY4/uhu/kOtf1nvM0yE9G4=
=E5VV
-----END PGP SIGNATURE-----

--yEPQxsgoJgBvi8ip--
