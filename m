From: Harald Welte <laforge@netfilter.org>
Subject: Re: Small profile of a fileserver
Date: Wed, 26 Mar 2003 15:56:57 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030326145657.GU21953@sunbeam.de.gnumonks.org>
References: <1047937471.1521.40.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MWF3YmTHhoLNIVQC"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <1047937471.1521.40.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--MWF3YmTHhoLNIVQC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 17, 2003 at 10:44:34PM +0100, Martin Josefsson wrote:
> the nat code uses a lot of cpu even though I don't have _any_ rules in
> the nat-table. It does have some traffic on the ftpserver on port 21 and
> ip_conntrack_ftp and ip_nat_ftp is compiled into the kernel.

yes.  This has been discussed before, IIRC.  Never load iptable_nat if
you don't use any nat.  I don't consider this as a problem.

The same goes for compiling it into the kernel.  Don't compile it in if
you don't need it.

> /Martin

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--MWF3YmTHhoLNIVQC
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+gb+5XaXGVTD0i/8RAuIMAJ9l+5NAIfBK7mdqN/oMUv3F/iaEoACbB9nt
gFBCXQ4S1BwN857xJBfTCWI=
=P3+/
-----END PGP SIGNATURE-----

--MWF3YmTHhoLNIVQC--
