From: Harald Welte <laforge@netfilter.org>
Subject: Re: PPTP conntrack for kernel 2.6
Date: Thu, 19 Aug 2004 13:23:24 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040819112324.GL3921@sunbeam.de.gnumonks.org>
References: <cfdmen$3hu$1@sea.gmane.org> <4121C8BD.5030203@microbus.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/aHqdxxe3Vo3WJ36"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Robbie Dinn <robbie@microbus.com>
Content-Disposition: inline
In-Reply-To: <4121C8BD.5030203@microbus.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--/aHqdxxe3Vo3WJ36
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 17, 2004 at 09:58:37AM +0100, Robbie Dinn wrote:
> Laurens Blankers wrote:
> >Could someone please port the pptp conntrack module to kernel 2.6?
>=20
> I thought I would have a go at this. It is a bit harder to do
> than I thought.

Thanks for picking this issue up.

PPTP is actually the only helper that can be ported to 2.6.x without the
big hazzle of implementing pattern matching on nonlinear skb's, so it
can done in a safe way (as opposed to lots of other helpers).

> I think I might have spotted something that looks a bit strange,
> maybe even a bug? Please bear in mind that I don't understand the
> code.

It's not that difficult.  We're trying to assure that a certain part of
the skb can be written to. (linearized, non-shared/cloned,...)

> Both udp_manip_pkt() and tcp_manip_pkt() make a call to
> skb_ip_make_writable(). It is the second parameter passed to
> skb_ip_make_writable() that I am worried about.
>=20
> In udp_manip_pkt() it is called like this:
>=20
>      if (!skb_ip_make_writable(pskb, hdroff + sizeof(hdr)))
>=20
> where hdr is a pointer to a struct udphdr

that is indeed a bug.  It has to be sizeof(*hdr)

> In tcp_manip_pkt() it is called like this:
>=20
>      if (!skb_ip_make_writable(pskb, hdroff + hdrsize))
>=20
> where hdrsize may have a value of sizeof(tcphdr)

yes, depending on tcp options, ..

Bugfix is in
patch-o-matic-ng/updtes/18_linux-2.6.8.1-udp-nat-nonlinear.patch

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--/aHqdxxe3Vo3WJ36
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBJI2sXaXGVTD0i/8RAvlcAJ0Tb30vN4zG5BofFz/PIOkK5HtIWQCfWBRh
ZHd2ITg05Tc+cFZ43inRSAc=
=3wJ/
-----END PGP SIGNATURE-----

--/aHqdxxe3Vo3WJ36--
