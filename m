From: Bastian Blank <bastian@waldi.eu.org>
Subject: Re: iptables/extensions/libipt_time.c missing include
Date: Tue, 27 Jan 2004 12:41:52 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040127114152.GA2530@wavehammer.waldi.eu.org>
References: <wazza.877jzj8ll6.fsf@message.id> <20040123095234.GA4595@wavehammer.waldi.eu.org> <20040127105745.GG11761@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qxx1br4bt0+wmkIi"
Cc: Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20040127105745.GG11761@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 27, 2004 at 11:57:45AM +0100, Harald Welte wrote:
> > You should use <stddef.h> instead of <linux/stddef.h>.
> At least on my debian machines /usr/include/stddef.h doesn't exist.

It don't exists there, because it is shipped with the gcc.

Bastian

--=20
Phasers locked on target, Captain.

--Qxx1br4bt0+wmkIi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iEYEARECAAYFAkAWToAACgkQLkAIIn9ODhHo/ACgmyKEkqzTrI9qF7cbUxnzmmKB
eIUAoN7EQyIITeG9+DLOQkyoBLXdGlwZ
=UeWC
-----END PGP SIGNATURE-----

--Qxx1br4bt0+wmkIi--
