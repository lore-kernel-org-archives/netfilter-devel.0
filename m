From: Harald Welte <laforge@netfilter.org>
Subject: Re: the definition of function iptc_init
Date: Fri, 13 Jun 2003 17:18:12 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030613151812.GE32593@sunbeam.de.gnumonks.org>
References: <00c801c330b5$8b68c960$0b00a8c0@haf>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JZV+hE4cb0ibQYPB"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jack <jack@cosmism.com>
Content-Disposition: inline
In-Reply-To: <00c801c330b5$8b68c960$0b00a8c0@haf>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--JZV+hE4cb0ibQYPB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 12, 2003 at 03:37:49PM +0800, Jack wrote:
> Sorry for disturbing you all
> I just begin to study the source code.
> I could not find the definition of function iptc_init.=20
> Please give me a hint.

cvs:userspace/libiptc/libiptc.c (IPTC_INIT, as a preprocessor macro from
libip4tc.c translates the name...)

> thanks
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--JZV+hE4cb0ibQYPB
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+6es0XaXGVTD0i/8RAnjLAKCcRt6aZPkswdkYuE7om01UfFi5WwCfReIi
FYNL4VDT+ZYR3+bKRkpGSSE=
=TROB
-----END PGP SIGNATURE-----

--JZV+hE4cb0ibQYPB--
