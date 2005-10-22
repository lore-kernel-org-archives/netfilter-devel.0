From: Harald Welte <laforge@netfilter.org>
Subject: [ADMIN] new netfilter.org mail filtering in place
Date: Sat, 22 Oct 2005 11:25:27 +0200
Message-ID: <20051022092527.GM27778@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yO52jeZL+8sEiVPY"
Cc: netfilter-workshop@lists.netfilter.org,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	netfilter-failover@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Mailinglist <netfilter@lists.netfilter.org>
Content-Disposition: inline
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


--yO52jeZL+8sEiVPY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

To reduce the amount of spam in @netfilter.org inboxes, as well as the
amount of manual list moderation for our listmaster, I've implemented a
couple of additional filters.

The biggest part is charset-based filtering.  Since the mailinglists and
all communication within the project is in english anyway, I see no
point in allowing chinese/korean/japanese (sorry, Yasuyuki) mails to
netfilter.org in the first place.

This seems rude (and it is), and I would never recommend using such
filters for a generic mail server.  But for a dedicated system like
netfilter.org, I think it is fine.

Doing some rough statistics, the charset-based filtering can save us
more than 90% of the spam that currently passes spamassassin.

In addition, we already did some heuristics-based HTML filtering, which
does only work for quoted-printable/ascii encodings, but not for base64.
We're now doing HTML filtering on the decoded mime content (as well as
the mime type of the individual parts) and thus should catch almost all
HTML junk.

Please direct complaints to coreteam@netfilter.org

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--yO52jeZL+8sEiVPY
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDWgWHXaXGVTD0i/8RAp7QAJ9iHi/u3xPhLdd7xIEeG7hC9nwq9wCfR6mG
QP6qjEbePJQTMQZIaISub4s=
=FLXz
-----END PGP SIGNATURE-----

--yO52jeZL+8sEiVPY--
