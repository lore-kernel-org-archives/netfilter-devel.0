From: Harald Welte <laforge@gnumonks.org>
Subject: Re: RFC: conntrack hash function comparison
Date: Tue, 21 Jan 2003 11:09:16 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030121100916.GN15225@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.33.0301201113510.17671-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="00hq2S6J2Jlg6EbK"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0301201113510.17671-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--00hq2S6J2Jlg6EbK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 20, 2003 at 11:26:33AM +0100, Jozsef Kadlecsik wrote:
> Hello,
>=20
> Using Patrick's cttest utility I have finished the testing of different
> hash functions for connection tracking:
>=20
> http://www.kfki.hu/~kadlec/sw/netfilter/ct/

Thanks a lot for this thorow analysis.

> My short conclusion is that we have to adopt the abcd or abcdx hash
> as the conntrack hash function.

I cannot comment anything else.  My personal favourite is the abcdx
hash.

> Regards,
> Jozsef

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--00hq2S6J2Jlg6EbK
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+LRxMXaXGVTD0i/8RAgJ/AJ9IeHxoqAyfXexGaaNn7yDR/i/AEwCgk7pQ
/iZqnREb+pl8fDKqFgJPIG0=
=+ZyD
-----END PGP SIGNATURE-----

--00hq2S6J2Jlg6EbK--
