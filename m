From: Harald Welte <laforge@netfilter.org>
Subject: Re: IPTables API & documentation
Date: Thu, 16 Oct 2003 10:10:44 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031016081044.GI14807@obroa-skai.de.gnumonks.org>
References: <20031016033411.51850.qmail@web13111.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J+eNKFoVC4T1DV3f"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Daniel Fonseca <danielonline_2@yahoo.com>
Content-Disposition: inline
In-Reply-To: <20031016033411.51850.qmail@web13111.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--J+eNKFoVC4T1DV3f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 15, 2003 at 08:34:11PM -0700, Daniel Fonseca wrote:
> Hi Harald,
>=20
> I am involved in a project for CS undergrad
> qualifying, it's about a new protocol being developed
> by IETF called midcom. Have you heard about it?

yes.  I was following MIDCOM at some point in the past, but haven't
looked at it's proceedings for at least a year.

> I would like to know how can firewall (packet filter)
> and NAT rules be added, removed and read from the
> iptables configuration in a programming (C/C++)
> environment. Is there an API or something similar? If
> so, do you have any documentation for it, or happen to
> know references where I can search or ask more about
> it?

no, we don't have such an API.  It will  be added in the future, there
is some work on libpkttables - but I won't expect a stable API to be
ready within the next 6 months or so.

> So far, I have found a lib called libiptc, and a HOWTO
> ("Querying libiptc HOWTO") describing its function
> calls with some examples. Those calls were also
> mentioned in the netfilter hacking HOWTO, but neither
> document describe them in the necessary depth for one
> to add and remove both filters and NAT.

libiptc was _NEVER_ meant as a public interface.  It's a bunch of
routines used by iptables internally.  We do not guarantee stability of
that interface, and in the 2.7 (and maybe 2.6 at some point) kernel it will
be removed without replacement.

This has been mentioned so often on the netfilter developer mailinglist,
that it should be very obvious to find in the list archives.

I've now also added it as an FAQ.

> Thanks in advance,
> Daniel Fonseca

> PS: I have been told you know brazilian portuguese.
> Isso e verdade? (Is that true?)

sim, falo um pouco de portugues.  morava para um meio ano em curitiba,
trabalhando para a conectiva.  Agora eu nao tenho muito possibilidade de
praticar.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--J+eNKFoVC4T1DV3f
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/jlKDXaXGVTD0i/8RAr7tAKCArvZYOmFFB1ZBTv19TpEiuQ5/hACfXFZc
beplainH8TzQgbNrdjndN98=
=8qyA
-----END PGP SIGNATURE-----

--J+eNKFoVC4T1DV3f--
