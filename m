From: Harald Welte <laforge@netfilter.org>
Subject: Re: iptables for multicasting?
Date: Sat, 31 May 2003 19:15:16 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030531171516.GA29312@sunbeam.de.gnumonks.org>
References: <3ED5C652.637565C6@ie.cuhk.edu.hk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i/VKSWANvDZSIhsB"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Philip Ho <cbho@ie.cuhk.edu.hk>
Content-Disposition: inline
In-Reply-To: <3ED5C652.637565C6@ie.cuhk.edu.hk>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--i/VKSWANvDZSIhsB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 29, 2003 at 04:35:30PM +0800, Philip Ho wrote:
> Dear all
>=20
> A short question: Can I utilize iptables architecture to duplicate and
> forward packet? Yes, just like IP multicasting.

you can use the iptables architecture, you would just need to implement
something like a COPY target for the mangle table.

As I have no idea about your application/project, I cannot tell whether
this implementation based on iptables would make any sense.

> Regards,
> philip

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--i/VKSWANvDZSIhsB
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+2OMkXaXGVTD0i/8RAhLOAJ4naOqq+krpU9z6DJfdhgvq7OiwOwCfXRqi
FwIRZz81buIeZcvzTOxsubs=
=3lQy
-----END PGP SIGNATURE-----

--i/VKSWANvDZSIhsB--
