From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: Fixed some memoryleaks in ip(6)tables.c
Date: Tue, 18 May 2004 22:27:32 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1084912051.969.41.camel@tux.rsn.bth.se>
References: <Pine.LNX.4.44.0405182143100.10300-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VTwIYzjmu7XmPl0OpAmD"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0405182143100.10300-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-VTwIYzjmu7XmPl0OpAmD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2004-05-18 at 21:47, Henrik Nordstrom wrote:
> On Tue, 18 May 2004, Martin Josefsson wrote:
>=20
> > I converted an application from direct libiptc fiddling to use
> > do_command() from iptables.c instead (why use the horrible lowlevel
> > interface of libiptc when you don't have to?) and found some
> > memoryleaks. These changes has been running in a small testprogram unde=
r
> > valgrind and seems to work fine.
>=20
> Then there is more good news for you. You can now easily complete the
> migration to not at all link the application directly to iptables by usin=
g
> a iptables-restore session. iptables-restore is essentially the same
> interface as do_command with only some nice syntactical sugar added.

Heh, I know, iptables-restore accepts all commands iptables does. I use
that heavily in a rule-management script I made to sync the rules in
kernel to match the configfiles in a single atomic update.
I should document it and post it some day, it's very simple but so nice
to have.

I link it since that's what this application did earlier, don't want to
rewrite the world, just clean it up a bit :)

> > People with large iptables-restore "sessions" might notice a decrease i=
n
> > memory-usage.
>=20
> Thanks!

Let me know if you see any leaks, crashes or slowdowns. I don't have any
really large setups to play with.

--=20
/Martin

--=-VTwIYzjmu7XmPl0OpAmD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBAqnGzWm2vlfa207ERAokMAJ9fPElPZtGcN8zbrajH1F67xsSxXwCglpm7
HDBu2v6q8EFqexO8+ikdchQ=
=tn5M
-----END PGP SIGNATURE-----

--=-VTwIYzjmu7XmPl0OpAmD--
