From: Harald Welte <laforge@netfilter.org>
Subject: Re: Future of CONNMARK (was Re: MASQUERADE: Route sent us somewhere else (was Re: Fw: Rusty's brain broke!)
Date: Tue, 20 Jan 2004 08:01:22 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040120130122.GC8642@obroa-skai.de.gnumonks.org>
References: <20040119231501.GB1142@eychenne.org> <Pine.LNX.4.44.0401200023120.17422-100000@filer.marasystems.com> <20040120011305.GD1142@eychenne.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oTHb8nViIGeoXxdp"
Cc: Henrik Nordstrom <hno@marasystems.com>, Julian Anastasov <ja@ssi.bg>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Herve Eychenne <rv@wallfire.org>
Content-Disposition: inline
In-Reply-To: <20040120011305.GD1142@eychenne.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--oTHb8nViIGeoXxdp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 20, 2004 at 02:13:05AM +0100, Herve Eychenne wrote:
> > It is impossible for the man page to correctly reflect all possible=20
> > combinations.
>=20
> Yes, as it is always some kind of "static".
> You'll note that the reason why I prefer a program to a "static" (even
> if generated at iptables compile time) manpage is that the manpage will
> not reflect your current combination (at least durably), again.

I don't think that we should spend too much time developing such a
program for iptables.  I'd rather move any big new (sub-)projects or
changes to 2.7/pkttables.  (Yes, there's now some movement again... look
at my cvs commits/changes in the libpkttables directory).

However, if somebody wants to take the full job of=20
- adding the respective information to the sourcecode
- generating netfilter-extension-HOWTO snippets in docbook XML
- generating the respective manpage snippets=20

then I wouldn't refuse applying the patch.

My position on this whole discussion is:

'man iptables' should reflect what the iptables userspace command has
built in.  So making the manpage dependent on what extensions are
compiled at iptables compile time is fine with me.

And yes, I prefer the 'squid' way, listing all matches/targets and their
options, but mark unavailable ones with a comment.  This comment could
refer to a special section at the bottom of the page, where we list
possible causes why it is disabled, and which steps one might need to
take to make it available.

> Usually, in such a case, most users get an obscur error and write to the
> mailing-list. Pretty clear and quick, isn't it? ;-)

we have no more verbose error reporting due to the getsockopt/setsockopt
interface.  I don't see a way how this could change :(

> People in real life (read "not developer life") often upgrade their
> kernel and iptables command via packages, and if they get to know the
> existence of p-o-m, they have only little time to keep tracking down if
> their favorite p-o-m modules have been included into mainstream or removed
> (from kernel, or cvs).

If they only use vendor packages, it's fine.  The vendor would compile
iptables against the matching kernel sources and thus end up with a
manapge that either
a) lists only the available matches/targets
b) lists all matches/targets and marks unavailable ones as unavailable

if they use their own kernel, they shoud also use their own iptables or
otherwise expect some inconsistency in the documentation.

> I do not understand. A manpage with every extensions will only tell
> you what you could have, and you would have to experiment quite much
> (with uninformative error messages) to know what you can really _use_.

As long as it makes a comment about what is available/unavailable in the=20
iptables userspace program you are currently running, I see this as an
advantage.

> And this is all to be done again when you upgrade the kernel...
> Sigh...

> Besides, this situation is a nightmare for automatic programs (upper
> layers) which try to take advantage of a maximum of extensions.

this is why we now have /proc/net//ip_*_names
=20
>  Herve
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--oTHb8nViIGeoXxdp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFADSahXaXGVTD0i/8RAqpjAKCsTBzorzcr5WWuZ9RdH2EPcl5WRACeL5Ut
ZUESRI6q7kuF2dOJSy3k1Lc=
=1rFA
-----END PGP SIGNATURE-----

--oTHb8nViIGeoXxdp--
