From: Harald Welte <laforge@netfilter.org>
Subject: Re: netfilter bugzilla bug 56....
Date: Sun, 2 Nov 2003 16:02:03 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031102150203.GW1536@sunbeam.de.gnumonks.org>
References: <20031101095212.GA31121@santito.elpisito>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="e1+sTVyxRliB/aPL"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: El Santo <el_santo@arrakis.es>
Content-Disposition: inline
In-Reply-To: <20031101095212.GA31121@santito.elpisito>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--e1+sTVyxRliB/aPL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 01, 2003 at 10:52:12AM +0100, El Santo wrote:
> hi Harald!

Hi, please consider posting to the mailinglist in the future, according
with http://netfilter.org/contact.html

> i red your report at bugzilla.netfilter.org.... i mean bug 56.... you
> wrote a path in your report....
>=20
> i have a problem... i hope you can help me...
>=20
> i'm using a gateway/firewall machine with kernel 2.4.22, and patchomatic
> 20030912.... only a few patches as h323 support...
>=20
> well... when i run xmule in a machine connected to that gateway, the
> /proc/net/ip_conntrack begins to grow and grow and grow... until it
> flood the nat table...

does it have the nfnetlink-ctnetlink patch applied?  It had a different
bug that would also make the box appear as running out of conntrack
entries.  However, there are not any superfluous entries, it's just the
counter that is wrong.

> althoug mi kernel is newer than 2.4.20 (the one i htink your patch is
> supposed to be applied against to)  i apply your patch anyway
> (manually), but the problem is still there....

yes, because your problem has a different cause than bug #56.  The patch
won't help, I assure you that that was fixed in 2.4.21.

> my question is.... is "safe" to let it patched, or should i unpatch and
> recompile.... (its a very slow machine)

The patch doesn't hurt, you can leave it in.

> thanx!
> s.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--e1+sTVyxRliB/aPL
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/pRxrXaXGVTD0i/8RAuSFAKCQtGCKlqOg4lMMtxGEHOW0wEK1agCfdDAo
+oepCFDSLoLKfrhIMWm84b0=
=oHzC
-----END PGP SIGNATURE-----

--e1+sTVyxRliB/aPL--
