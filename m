From: Harald Welte <laforge@netfilter.org>
Subject: Re: ip_conntrack_ftp.c kernel source more ports
Date: Wed, 21 Jan 2004 09:19:29 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040121141929.GV8642@obroa-skai.de.gnumonks.org>
References: <001101c3df28$5a342ac0$0100a8c0@hak>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dpynvXbW/eW9Tpc3"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: HakRz1 <HakRz1@punkass.com>
Content-Disposition: inline
In-Reply-To: <001101c3df28$5a342ac0$0100a8c0@hak>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--dpynvXbW/eW9Tpc3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 19, 2004 at 11:38:08PM -0800, HakRz1 wrote:
> Hello,
>     im trying to make a big security flaw in my network but i want to try
> anyways ...what im trying to do is make ip_conntrack_ftp monitor all non
> standard ports instead of defualt 21

what is your definition of 'all non-standard ports' ?

>  i know ip_conntrack_ftp.h is where it gets port 21 defined
> is there anyway to make it monitor all FTP ports without typing in all po=
rts
> manually

no, and there's a good reason for that: You add a huge performance
penalty to any kind of traffic on those poerts.

After ftp, you would start to look for any kind of other protocol, like
h.323, irc, ...  and then you would end up running all helpers on all
ports.  =20

If you do that, performance cannot be important to you anymore.

Thus, you should use a transparent proxy for this kind of stuff.

> Thanks

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--dpynvXbW/eW9Tpc3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFADopwXaXGVTD0i/8RAtHRAJ0bAu6qSo+YneYp4WC/h69jI1ZJwgCeLZOy
zco1ZBG4GRrdoBrAkAjHQKg=
=bp9U
-----END PGP SIGNATURE-----

--dpynvXbW/eW9Tpc3--
