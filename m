From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] ip6tables-save and udp port range
Date: Thu, 2 Oct 2003 21:47:17 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031002194717.GZ5758@sunbeam.de.gnumonks.org>
References: <3F701080.80203@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xrsGu0vEhUChmKYg"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Thomas Woerner <twoerner@redhat.com>
Content-Disposition: inline
In-Reply-To: <3F701080.80203@redhat.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--xrsGu0vEhUChmKYg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 23, 2003 at 11:21:04AM +0200, Thomas Woerner wrote:

> ip6tables-save is not saving an udp port range if one of the ports is=20
> 0x0 or 0xFFFF. This is aleady fixed in the ipv4 version.

thanks, patch applied.

> Thanks in advance
> Thomas Woerner

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--xrsGu0vEhUChmKYg
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/fIDFXaXGVTD0i/8RAjOeAKCByHHsHc6gR29nNab3TNjVgnVLJgCgitDi
2E2ABiIuI/J/psJN7QeC1Ik=
=WwyC
-----END PGP SIGNATURE-----

--xrsGu0vEhUChmKYg--
