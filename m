From: Eric Leblond <eric@regit.org>
Subject: Re: Libipq and invalid packet_id
Date: 26 Jun 2003 09:06:34 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1056611194.32622.20.camel@porky>
References: <Mutt.LNX.4.44.0306261040110.11825-100000@excalibur.intercode.com.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-MqqLJ/NlmttBjyT1JaU1"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: James Morris <jmorris@intercode.com.au>
In-Reply-To: <Mutt.LNX.4.44.0306261040110.11825-100000@excalibur.intercode.com.au>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-MqqLJ/NlmttBjyT1JaU1
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable

Le jeu 26/06/2003 =E0 02:40, James Morris a =E9crit :
> On 26 Jun 2003, Eric Leblond wrote:
> > 	- Is this a wanted feature ?
>=20
> No.

So I've got other related questions :
	- How is memory managed, ie what's happen if we queue a lot of packet
without setting any verdict ?
	- In particular, what's happened if we do successive call to
ipg_getmessage ? Do ipg_getmessage reuse address space after each call ?

BR,
--=20
Eric Leblond <eric@regit.org>

--=-MqqLJ/NlmttBjyT1JaU1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQA++pt5nxA7CdMWjzIRAq2wAJ9T2qwbcIaLo5Pq/5eYb8B8jMCtJQCfZfhH
S3rET0ONj75CLLyNgxazCiI=
=XRes
-----END PGP SIGNATURE-----

--=-MqqLJ/NlmttBjyT1JaU1--
