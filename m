From: Bastian Blank <bastian@waldi.eu.org>
Subject: Re: iptables/extensions/libipt_time.c missing include
Date: Fri, 23 Jan 2004 10:52:34 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040123095234.GA4595@wavehammer.waldi.eu.org>
References: <wazza.877jzj8ll6.fsf@message.id>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UugvWAfsgieZRqgk"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <wazza.877jzj8ll6.fsf@message.id>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 23, 2004 at 03:06:45AM +0100, laurent.ml@linuxfr.org wrote:
> Tell me if I'm wrong, it seems an include is missing in
> extensions/libipt_time.c from iptables cvs.
> (line 302 : offsetof)

You should use <stddef.h> instead of <linux/stddef.h>.

Bastian

--=20
	"... freedom ... is a worship word..."
	"It is our worship word too."
		-- Cloud William and Kirk, "The Omega Glory", stardate unknown

--UugvWAfsgieZRqgk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iEYEARECAAYFAkAQ7uIACgkQLkAIIn9ODhGhQQCgv2hXjOzN74R1LQwNu/afMYSV
+rAAmgLFcSAjbBmj4ILoO+3EOvXt+HEZ
=3ksV
-----END PGP SIGNATURE-----

--UugvWAfsgieZRqgk--
