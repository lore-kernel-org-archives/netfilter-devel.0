From: Harald Welte <laforge@netfilter.org>
Subject: Re: Sequence number translation explanations.
Date: Sun, 28 Mar 2004 20:36:43 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040328183643.GW7039@sunbeam.de.gnumonks.org>
References: <4065A500.8060107@netlab.hut.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+rRWuC8ZLvVekNoN"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Emmanuel Guiton <emmanuel@netlab.hut.fi>
Content-Disposition: inline
In-Reply-To: <4065A500.8060107@netlab.hut.fi>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--+rRWuC8ZLvVekNoN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 27, 2004 at 06:00:01PM +0200, Emmanuel Guiton wrote:
> Hi!
>=20
> I need to translate sequence numbers between the two networks that are=20
> separated by the firewall. In fact, I just need to translate on of them=
=20
> (so tcph->ack_seq in one direction, and tcph->seq in the opposite=20
> direction).
> I found the ip_nat_seq stucture and the ip_nat_seq_adjust function but I=
=20
> do not understand them. Particularly this "correction_pos", what is it?
>=20
> Could someone provide me with some explanations?

It is for inserting/removing bytes from a TCP stream, as needed with NAT
of protocols like FTP (IP address printed in ASCII has different length,
compare strlen('1.1.1.1') to strlen('255.255.255.255').

correction_pos is the position (sequence number) where the
addition/subtraction occurred, and offset is the number of bytes added
(positive) or removed (negative).

>             Emmanuel

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--+rRWuC8ZLvVekNoN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAZxs7XaXGVTD0i/8RArhfAKCTvRN+luGujLhTc1VmBF3E+D0OKwCfdHzr
twbB3sPj9GooCxAkjuWT9/s=
=Mwfv
-----END PGP SIGNATURE-----

--+rRWuC8ZLvVekNoN--
