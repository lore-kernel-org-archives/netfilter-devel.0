From: Harald Welte <laforge@gnumonks.org>
Subject: Re: MAC and iptables-save
Date: Mon, 6 Jan 2003 14:00:18 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030106130018.GG9467@sunbeam.de.gnumonks.org>
References: <200212271451.14532@fbunet.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H2kTGx6mr3R59oXC"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Fridtjof Busse <fridtjof.busse@gmx.de>
Content-Disposition: inline
In-Reply-To: <200212271451.14532@fbunet.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--H2kTGx6mr3R59oXC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 27, 2002 at 02:51:14PM +0100, Fridtjof Busse wrote:
> Hi
> "iptables-restore" doesn't work if "iptables-save" saved a rule with "-m=
=20
> mac --mac-source"

thanks for reporting this bug.  It has already been fixed in CVS for
ipv4 mac, although slightly different than your solution.

I have now changed the ipv6 mac match, too.

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--H2kTGx6mr3R59oXC
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+GX3iXaXGVTD0i/8RApCaAJwINyd2+cEIM+av0ILts3iYYFOewwCeKStc
gznYeC9HKxuyjdaQr1mVLBw=
=Kubl
-----END PGP SIGNATURE-----

--H2kTGx6mr3R59oXC--
