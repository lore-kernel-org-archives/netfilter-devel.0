From: Harald Welte <laforge@netfilter.org>
Subject: Re: netfilter http request filter patch
Date: Wed, 30 Apr 2003 18:06:01 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030430160601.GG685@sunbeam.de.gnumonks.org>
References: <1444106507.20030428121142@yahoo.es> <767034681.20030429103220@yahoo.es>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pyE8wggRBhVBcj8z"
Cc: lista de correo netfilter <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: macadanet@yahoo.es
Content-Disposition: inline
In-Reply-To: <767034681.20030429103220@yahoo.es>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--pyE8wggRBhVBcj8z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 29, 2003 at 10:32:20AM +0200, macadanet@yahoo.es wrote:
>         I send you this mail with a NETFILTER patch made for me.
>         This patch (http request filter) find in a http request,
>         bad and dangerous http request like nimda, red code,
>         unicodes attacks. Then this patch drop, log ,etc. this packet.
>        =20
>         my patch is finished but i want your opinion about this.

A couple of issues:

1) please don't send compressed tar archives to the list, use plaintext
unified diffs as attachment

2) you seem not to be aware of /usr/src/linux/Documentation/CodingStyle,
since about everything inside your kernel module is violationg the
kernel coding style: indentation, language, c++-style comments, ...

3) the module is not very useful, since you will only match a request
that is contained within a single packet.  You would need tcp stream
reassembly to catch http requests spread over multiple packets.  For
a fast implementation of in-kernel pattern matching with tcp stream
reassembly, look for libqsearch of the prelude project.

>        macada.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--pyE8wggRBhVBcj8z
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+r/RpXaXGVTD0i/8RAqYCAKCvm1aMyj/CiugzOR0rlpApsUU8UgCeKWaw
qsarvFwGTMYAiEB09HfcKkE=
=u24T
-----END PGP SIGNATURE-----

--pyE8wggRBhVBcj8z--
