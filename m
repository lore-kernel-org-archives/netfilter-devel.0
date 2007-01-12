From: =?windows-1252?q?R=E9mi_Denis-Courmont?= <rdenis@simphalempin.com>
Subject: Re: [Patch 0/2] Avoid direct connections between NATed hosts
Date: Fri, 12 Jan 2007 19:11:45 +0200
Message-ID: <200701121911.48617@auguste.remlab.net>
References: <1168621167.28615.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart6779187.2CZJgKIXvJ";
	protocol="application/pgp-signature"; micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <1168621167.28615.14.camel@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

--nextPart6779187.2CZJgKIXvJ
Content-Type: text/plain;
  charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Le vendredi 12 janvier 2007 18:59, Eric Leblond a =E9crit :
> Some algorithms can be used to established direct connections between
> NATed hosts. Skype is one of the programs using this kind of
> "feature".

NAT are not *security* devices; NATs are meant to *improve* IP usability=20
by allowing as many protocols as possible to operate even though there=20
are not enough public IP addresses. Making it more difficult for P2P=20
apps to operate through is hence completely not only non-sensical, but=20
a plain contradiction.

NATs are sufficiently broken and annoying already to handle for software=20
development; please do not make them worst. Also, this patch goes=20
completely against work-in-progress NAT standards.

In this particular case, your approach is a completely associal=20
short-term solution. In the long run, it will simply cause people with=20
normal/correct NATs to have to relay even more traffic when they should=20
not have to, because of people like you. And it certainly won't prevent=20
Skype from running on your network either.

=2D-=20
R=E9mi Denis-Courmont
http://www.remlab.net/

--nextPart6779187.2CZJgKIXvJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBFp8FUw+xtvt1tEr0RAnn8AJ0Wv1zRrMnpRFkDYIysl9QAW8Z9DQCghXxD
GYCUMwdjFHjdPIzOalsgSNs=
=YW+e
-----END PGP SIGNATURE-----

--nextPart6779187.2CZJgKIXvJ--
