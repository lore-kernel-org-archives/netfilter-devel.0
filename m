From: Harald Welte <laforge@netfilter.org>
Subject: Re: Extremely slow network with e1000 & ip_conntrack
Date: Thu, 11 Dec 2003 08:26:08 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031211072608.GF22826@sunbeam.de.gnumonks.org>
References: <C6F5CF431189FA4CBAEC9E7DD5441E0102CBDD1F@orsmsx402.jf.intel.com> <20031204213030.2B75.MUKANSAI@emailplus.org> <20031205122819.25ac14ab.davem@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qp4W5+cUSnZs0RIF"
Cc: Stephen Lee <mukansai@emailplus.org>, scott.feldman@intel.com,
	netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
Content-Disposition: inline
In-Reply-To: <20031205122819.25ac14ab.davem@redhat.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--qp4W5+cUSnZs0RIF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 05, 2003 at 12:28:19PM -0800, David S. Miller wrote:

> The culprit is net/ipv4/netfilter/ip_conntrack_standalone.c,
> in ip_refrag(), it does this:
>=20

Sorry for getting back to you so late, but as indicated before, I was
offline while travelling during the last week.

Thanks for spotting and fixing the bug.

> Some auditing is definitely necessary wrt. TSO and netfilter.  In particu=
lar
> I am incredibly confident that we have issues in cases like when the FTP
> netfilter modules mangle the data.  Another area for inspection are the
> cases where TCP header bits are changed and thus the checksum needs to
> be adjusted.

yes, this is certainly a problem - but not with conntrack, only with
nat.  So maybe we should add a safeguard, preventing
iptables_nat/ipchains/ipfwadm from being loaded when TSO on any
interface is enabled?  Or at least print a warining in syslog?

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--qp4W5+cUSnZs0RIF
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/2BwQXaXGVTD0i/8RAhTnAJ9qseTfbSGiGhmZG8xTAFImx9fBGQCgjq8V
OB8LsLrfb4l0RUqNrNAiAfM=
=2TJW
-----END PGP SIGNATURE-----

--qp4W5+cUSnZs0RIF--
