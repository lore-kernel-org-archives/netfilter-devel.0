From: Harald Welte <laforge@netfilter.org>
Subject: Re: ip_contrack table full ?
Date: Mon, 17 Feb 2003 14:03:28 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030217130328.GA9541@sunbeam.de.gnumonks.org>
References: <18436282631.20030216234147@habitat-b.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: DarKRaveR <DarKRaveR@habitat-b.de>
Content-Disposition: inline
In-Reply-To: <18436282631.20030216234147@habitat-b.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 16, 2003 at 11:41:47PM +0100, DarKRaveR wrote:
> Hello list,
>=20
>   I got an issue with ip_contrack module. I have a router here, with
>   ip_contrack enabled, because I need the REDIRECT target. Earlier
>   this day, the system wrecked, because the ip_contrack table was
>   obviously full. How could this happen, with just 6 users ?

1) the system doesn't just crash because the table is full.  The system
   can run out of memory, ip_conntrack_max is too big and you don't have=20
   enough (free) memory.
2) this is not a develoment question (but the development list)
3) see http://www.netfilter.org/documentation/FAQ/netfilter-faq-3.html#ss3.6

> Best regards,

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+UN2gXaXGVTD0i/8RAqORAJ9VmhzBmfq5cbxh7AQdefCWiyTxFACePT/5
bLgLH/uE5yMyW4IeQMJTn78=
=SoxT
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
