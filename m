From: Harald Welte <laforge@netfilter.org>
Subject: Re: any plan for firewalling before the packet socket hooks?
Date: Fri, 12 Sep 2003 23:31:31 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030912213131.GI4398@obroa-skai.de.gnumonks.org>
References: <3F5E9340.9040908@sympatico.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wZdghQXYJzyo6AGC"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Chris Friesen <chris_friesen@sympatico.ca>
Content-Disposition: inline
In-Reply-To: <3F5E9340.9040908@sympatico.ca>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--wZdghQXYJzyo6AGC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 09, 2003 at 10:58:08PM -0400, Chris Friesen wrote:
>=20
> I'm interested in filtering packets before the packet socket gets a copy
> of them, and after the packet socket writes them but before it gets to
> the device.
>=20
> Would it be sufficient to add a new NF_HOOK call (for
> PF_PACKET/NF_PACKET_PRE_ROUTING or something similar) in
> netif_receive_skb() to handle the incoming side?
>=20
> Is there anything else required to allow me to create a module to bind
> in at that hook and do my filtering?

Sure, you can certainly do that.  However, you can not just attach an
iptable to your newly created PF_PACKET hook... PF_PACKET hooks receive
all kinds of packets (not just IP)... and iptables is something ipv4
only.

> Thanks,
> Chris

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--wZdghQXYJzyo6AGC
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/YjsyXaXGVTD0i/8RAgkdAJ99J1KCHcwobexZVCkk/MmMZWdX8wCgjbJ/
I2qfagK7zwos7kQClWd2kjc=
=IGxJ
-----END PGP SIGNATURE-----

--wZdghQXYJzyo6AGC--
