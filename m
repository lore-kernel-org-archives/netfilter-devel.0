From: Harald Welte <laforge@netfilter.org>
Subject: Re: the solution to synflood on netfilter (~{V#~}~{4+~}~{2(~})
Date: Fri, 26 Dec 2003 09:18:35 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031226081835.GC9391@obroa-skai.de.gnumonks.org>
References: <20031226052637.5955.69361.Mailman@netfilter-sponsored-by.noris.net> <48C150C9-3769-11D8-8C63-000A95B170F8@mail.goldenhope.com.cn>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MnLPg7ZWsaic7Fhd"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: zhongyu <xxx@mail.goldenhope.com.cn>
Content-Disposition: inline
In-Reply-To: <48C150C9-3769-11D8-8C63-000A95B170F8@mail.goldenhope.com.cn>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--MnLPg7ZWsaic7Fhd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 26, 2003 at 02:03:53PM +0800, zhongyu wrote:
> There was a syn-cookie firewall patch for linux-2.2 ipchains.  I had=20
> hacked it to 2.4 kernel.
> But it was very dirty and had problems under bridge mode... Is there a
> clean way to write a syn-cookie firewall in iptables framework?

maybe you could publish your 'dirty' solution and we can see where the
problems are, and how we could possibly modify it to become more clean.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--MnLPg7ZWsaic7Fhd
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/6+7bXaXGVTD0i/8RAs8+AJ9jHidGSk43czYPt+3nY/ACGw/OhQCgkeVm
pvvYskwrTPRgDUlpeIDfCSk=
=i3cl
-----END PGP SIGNATURE-----

--MnLPg7ZWsaic7Fhd--
