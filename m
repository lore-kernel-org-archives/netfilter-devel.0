From: Eric Leblond <eric@inl.fr>
Subject: Re: Multiple Address specification or match
Date: Thu, 30 Sep 2004 11:54:51 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1096538091.4406.12.camel@porky>
References: <003301c4a6cc$069e3fb0$2201010a@bluereef.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-/6uTefYCwH3LuhFZXuek"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <003301c4a6cc$069e3fb0$2201010a@bluereef.local>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--=-/6uTefYCwH3LuhFZXuek
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2004-09-30 at 11:01, Temp02 wrote:
> thanks for your feedback but neither of these solutions are particularly
> elegant.

iptables/netfilter has to be efficient, rules generation script has to
be elegant. Having 3 rules is as efficient as your masked "or" rules if
it was coded and 3 separate rules are more simple than your global one
so in a way this is more elegant.

BR,
--=20
Eric Leblond <eric@inl.fr>
INL

--=-/6uTefYCwH3LuhFZXuek
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQBBW9fqnxA7CdMWjzIRAn6WAJ4mMN1EHN2VC7xH54gLTLgJUdtdbQCfXtq6
QZTV9g9xmBYCti9mM36lyrw=
=9p/w
-----END PGP SIGNATURE-----

--=-/6uTefYCwH3LuhFZXuek--
