From: Harald Welte <laforge@gnumonks.org>
Subject: Re: mac_len uninitialized in ipt_ULOG.c
Date: Wed, 30 Oct 2002 09:59:32 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021030095932.V8635@sunbeam.de.gnumonks.org>
References: <3DBC5F7D.3FC31A48@cohaesio.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3M+s3upKwjqB7kL8"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Anders K. Pedersen"@harrier.cohaesio.com,
	mailnews+linux-netfilter-devel@news.cohaesio.com
Content-Disposition: inline
In-Reply-To: <3DBC5F7D.3FC31A48@cohaesio.com>; from "Anders K. Pedersen"@harrier.cohaesio.com on Sun, Oct 27, 2002 at 10:49:49PM +0100
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--3M+s3upKwjqB7kL8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 27, 2002 at 10:49:49PM +0100, "Anders K. Pedersen"@harrier.coha=
esio.com wrote:
> Hello,
>=20
> I recently startet using the ulogd daemon to log traffic from a PPPoE
> interface (have used it on regular ethernet interfaces for long). In the
> resulting logs, the MAC address was filled with (what seemed to be)
> garbage like the following entry:

> When using the regular LOG target, the MAC field was empty. I traced
> this back to the ipt_ulog_target function in
> net/ipv4/netfilter/ipt_ULOG.c in the kernel, where pm->mac_len in the
> ulog_packet_msg_t struct is left uninitialized, when there is no MAC
> address.

thanks, I will submit your bugfix soon.
> Regards,
> Anders K. Pedersen

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--3M+s3upKwjqB7kL8
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9v590XaXGVTD0i/8RAnaEAJ4y9nuFBvFNbVjzR/SqltV7+syaFwCcDCee
b1PlqdRccifrV8dBQQCQfTM=
=NPXh
-----END PGP SIGNATURE-----

--3M+s3upKwjqB7kL8--
