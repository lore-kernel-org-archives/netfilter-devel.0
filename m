From: Harald Welte <laforge@netfilter.org>
Subject: Re: [Q] Please answer me about modifying sk_buff( or packet anywayz...)
Date: Thu, 11 Dec 2003 14:08:25 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031211130825.GC22826@sunbeam.de.gnumonks.org>
References: <000501c3bc9f$74e3e460$8926f6a5@ghacker>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7WMexqIhC8AwFtpM"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ghacker <ghacker@super.inha.ac.kr>
Content-Disposition: inline
In-Reply-To: <000501c3bc9f$74e3e460$8926f6a5@ghacker>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--7WMexqIhC8AwFtpM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 07, 2003 at 05:52:33PM +0900, Ghacker wrote:
> How can I solve this problem..?  Thanx again.. for reading..

maybe by considering that the IP header is covered by a checksum that
has to be altered if the header is altered?

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--7WMexqIhC8AwFtpM
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/2GxJXaXGVTD0i/8RArE0AJ0f4s/EJEUzyfZ7/7Ks3ueJNp1g2QCeLROz
zJepeu7LjnLqCP2fpbJTnJg=
=wGnC
-----END PGP SIGNATURE-----

--7WMexqIhC8AwFtpM--
