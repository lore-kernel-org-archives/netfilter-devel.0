From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH] make multiple invocations of do_command() behave sane
Date: Mon, 02 Feb 2004 20:01:15 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1075748474.19762.51.camel@tux.rsn.bth.se>
References: <1075671804.19762.23.camel@tux.rsn.bth.se>
	 <20040202150545.GE24449@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-pow5gGLjGX2jqr3bZFSz"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040202150545.GE24449@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-pow5gGLjGX2jqr3bZFSz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2004-02-02 at 16:05, Harald Welte wrote:
> On Sun, Feb 01, 2004 at 10:43:24PM +0100, Martin Josefsson wrote:
> > Hi
> >=20
> > While writing a small script for managing my firewallrules I ran into a
> > small problem with iptables-restore.
> > The problem is that it doesn't respect the order of matches in a rule.
>=20
> Thanks a lot, this is indeed an important issue.   I wonder why nobody
> has complained about this in the past.

I wondered the same when I found the problem. I thought that someone
must have noticed it before.

I noticed it since my script compares the running config (retrieved with
iptables-save) with my config-files and updates the running config to
match (updates rules, deletes and creates chains as neccessary, all
atomically with iptables-restore and keeps all counters).

Running updates with a varied mix of rules gave me strange results, the
second time I ran the script without any config-changes it wanted to
update a lot of rules again to make them match the configfiles.

> > If noone screams too loud I'm going to merge the patch into cvs sometim=
e
> > soon.
>=20
> please do so.

Since noone's screamed yet I'll merge it later today in order to give it
wider testing, maybe then someone screams.

--=20
/Martin

--=-pow5gGLjGX2jqr3bZFSz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBAHp56Wm2vlfa207ERAig4AJ47z4cyP+VNwwJlr/sBrX8i9FJwKwCffpYf
uHQXcmWGTtLNHHqLMgQEptc=
=PdT+
-----END PGP SIGNATURE-----

--=-pow5gGLjGX2jqr3bZFSz--
