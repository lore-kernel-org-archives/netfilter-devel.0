From: Harald Welte <laforge@netfilter.org>
Subject: Re: RTP Support in iptables
Date: Wed, 21 Jul 2004 16:42:26 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040721204226.GN27487@obroa-skai.de.gnumonks.org>
References: <003e01c45167$3a167c50$248610ac@pc.ccse.kfupm.edu.sa>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zOcTNEe3AzgCmdo9"
Cc: Netfilter List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Muhammad R. Sami" <sami@ccse.kfupm.edu.sa>
Content-Disposition: inline
In-Reply-To: <003e01c45167$3a167c50$248610ac@pc.ccse.kfupm.edu.sa>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--zOcTNEe3AzgCmdo9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 13, 2004 at 07:55:25PM +0300, Muhammad R. Sami wrote:
> Is there support for RTP and RTCP in iptables. If yes can I mark
> packets on the basis of sequence number and time stamp.

no, at least not directly.  You might be able to use the u32 match (or
the u32 classifier from tc) to do so.

> regards
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--zOcTNEe3AzgCmdo9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFA/tUxXaXGVTD0i/8RAgZgAJ9+zEoOVKW/NZBYYSbJpbUoqKZc2ACeLed/
h/zIGSqOVRrwdOaivF6rmMY=
=gMV7
-----END PGP SIGNATURE-----

--zOcTNEe3AzgCmdo9--
