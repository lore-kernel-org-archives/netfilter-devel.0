From: Harald Welte <laforge@netfilter.org>
Subject: Re: NAT problem with related connections
Date: Mon, 3 Nov 2003 12:12:57 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031103111257.GE5081@sunbeam.de.gnumonks.org>
References: <DAELKAPIKOFAFFKELNHOAEAHCAAA.listuser@epygi.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Xm/fll+QQv+hsKip"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Nikolai Dahlem <listuser@epygi.de>
Content-Disposition: inline
In-Reply-To: <DAELKAPIKOFAFFKELNHOAEAHCAAA.listuser@epygi.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Xm/fll+QQv+hsKip
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 30, 2003 at 11:31:19AM +0100, Nikolai Dahlem wrote:

> Is there a way to know/reserve ports that nat uses for a certain
> connection ? or is there a way to tell nat which port to use ?

yes, by calling ip_conntrack_change_expect() to change the port number
of the to-be-expected connection.  in the nat helpers expectfn(), you
then call ip_nat_setup_info() with a per-proto (l4) range of exactly one
port number.

the ftp helper shows this for the DNAT case.

> kind regards
> Nikolai Dahlem

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Xm/fll+QQv+hsKip
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/pjg5XaXGVTD0i/8RAr/LAKCfj9/JED4qBKsErpH7uIHkf9nb8ACdFEru
KUAHfc18IEpW8qboko3a7go=
=gtp/
-----END PGP SIGNATURE-----

--Xm/fll+QQv+hsKip--
