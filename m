From: Eric Leblond <eric@inl.fr>
Subject: Re: conntrack clarification
Date: Mon, 06 Aug 2007 10:38:28 +0200
Message-ID: <1186389508.3738.5.camel@khasse.inl.fr>
References: <4736426.181186389101858.JavaMail.root@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-jXPGf5ixxIUi/r7l4WcQ"
Cc: netfilter-devel@lists.netfilter.org
To: Andrew Hall <temp02@bluereef.com.au>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4736426.181186389101858.JavaMail.root@localhost>
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


--=-jXPGf5ixxIUi/r7l4WcQ
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

Le lundi 06 ao=C3=BBt 2007 =C3=A0 18:31 +1000, Andrew Hall a =C3=A9crit :
> Hi Pablo,
> The problem I've found with the conntrack tool (using 'conntrack -F' to
> flush the entries) is that even though the entry "appears" to get removed
> for the TCP session, the entry gets re-added immediately by the session
> which is still open. This is kind of counter-intuitive as once the entry =
is
> removed I had assumed this meant the session was no longer known to be
> "established" and therefore the next packet should be unrelated and dropp=
ed?
> Is this correct or is there something wrong with the tool?

This is linked with your ruleset. The point to consider is that for the
conntrack NEW is not equivalent to SYN packet for TCP. If you only
filter on NEW, then packet from the previously existing connection will
be classified as NEW and trigger the creation of a new valid entry.

BR,
--=20
=C3=89ric Leblond, eleblond@inl.fr
T=C3=A9l=C3=A9phone : 01 44 89 46 39, Fax : 01 44 89 45 01
INL, http://www.inl.fr

--=-jXPGf5ixxIUi/r7l4WcQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD4DBQBGtt4EnxA7CdMWjzIRAnbvAJY7cRmZHN7qa+WxtBHLh1vkOhWrAKCTWRMF
efLPafFyeBaxWEKDndlFmw==
=7sC+
-----END PGP SIGNATURE-----

--=-jXPGf5ixxIUi/r7l4WcQ--
