From: Harald Welte <laforge@gnumonks.org>
Subject: Re: Reg Connection Tracking
Date: Fri, 31 Jan 2003 12:20:44 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030131112044.GO9073@naboo.cybercafe42>
References: <1042791460.1694.38.camel@knoppix> <20030120055531.62252.qmail@web41505.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lZZ4ablUVnt2XgAh"
Cc: Ranjeet Shetye <ranjeet.shetye2@zultys.com>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Amit Kumar <amitkumargupta_wip@yahoo.com>
Content-Disposition: inline
In-Reply-To: <20030120055531.62252.qmail@web41505.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--lZZ4ablUVnt2XgAh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 19, 2003 at 09:55:31PM -0800, Amit Kumar wrote:
>=20
> HI List,
> Thanks for ur suggestions List.
> Well, Now Again I tested the firewall and this time without NAT.
> So it means that connection tracking is used only for the iptables
> cases. Even in that case i have the same problem. My first setup has
> worked flawlessly and only second one has problems. Another thing is I
> am using standard PING utility.

please use a more recent version of the linux kernel.  Even I am unable
to reacall what number of bugs 2.4.3 had in the netfilter code, and how
we have solved them since then.

If this is impossible, please try to [at least] use one of the older
patch-o-matic versions [like iptables-1.2.5 or something] which still
support 2.4.3.  Apply all 'pending' patches (which includes the
'submitted' ones).

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M-=
=20
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)

--lZZ4ablUVnt2XgAh
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+OlwMXaXGVTD0i/8RAtJKAJ9tB77XyuOziIpgx8lTAio7uIj8oACgmvuS
j62P11wAZOSRZFBy7+1AQ0s=
=DuE+
-----END PGP SIGNATURE-----

--lZZ4ablUVnt2XgAh--
