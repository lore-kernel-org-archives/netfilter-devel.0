From: Harald Welte <laforge@netfilter.org>
Subject: Re: New Version (1.13) of PPTP conntrack/nat helper
Date: Wed, 24 Sep 2003 12:13:29 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030924101329.GW31401@sunbeam.de.gnumonks.org>
References: <20030923144924.GM31401@sunbeam.de.gnumonks.org> <3F707404.5080107@able.be>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CuZtzLgFeSWyzOuB"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Netfilter Mailinglist <netfilter@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Wim Ceulemans <wim.ceulemans@able.be>
Content-Disposition: inline
In-Reply-To: <3F707404.5080107@able.be>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--CuZtzLgFeSWyzOuB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 23, 2003 at 06:25:40PM +0200, Wim Ceulemans wrote:
=20
> If I switch CONFIG_IP_NF_NAT_LOCAL off, the forwarding to a pptp server=
=20
> behind the firewall works.
> If switch it on, I don't see any gre packet behind the firewall, so it=20
> does not work.
>=20
> However, with CONFIG_IP_NF_NAT_LOCAL on I have had two freezes (firewall=
=20
> completely stuck and I had to switch it on and off).

So to summarize:  It works perfectly of it is OFF, but you have problems
with DNAT and crashes, if it is ON.  That is surprising - it seems like
the problems have just been reverting :(

Did you do anything in particular when the firewall hang happened? (like
unloading/loading a module, ...)?

> Regards
> Wim

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--CuZtzLgFeSWyzOuB
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/cW5JXaXGVTD0i/8RAtJsAJ9u9O+8+lqmeuQ9VnT6VfKzUu3gVQCfTGyy
+9Kkm7EykwwyKaQ+Y/351Y4=
=5sBL
-----END PGP SIGNATURE-----

--CuZtzLgFeSWyzOuB--
