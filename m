From: Toralf =?iso-8859-15?q?F=F6rster?= <toralf.foerster@gmx.de>
Subject: Re: netfilter modul ipt_recent hickup with suspend to ram
Date: Thu, 19 Apr 2007 19:20:03 +0200
Message-ID: <200704191920.05567.toralf.foerster@gmx.de>
References: <200704161846.05908.toralf.foerster@gmx.de>
	<4624E196.7060004@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart9062166.E1vCjyPasf";
	protocol="application/pgp-signature"; micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4624E196.7060004@trash.net>
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

--nextPart9062166.E1vCjyPasf
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Dienstag, 17. April 2007 17:02 schrieb Patrick McHardy:
> Toralf F=F6rster wrote:
> > I'm wondering why after a "suspend to ram" or a "suspend to disk" the a=
mount of
> > ip adresses increases drastically w/o removing old addresses.
>=20
>=20
> Probably some software running at wakeup.
>=20
> > I'll attach the content of /proc/net/ipt_recent/UDP got at 17:35 (file =
1) and at
> > 18:37 (file 2), I suspended to ram at 17:36 at waked up the system at 1=
7:49, after
> > wakeup I restarted the ppp0 interface and got a new ip address.
>=20
>=20
> So you made a new internet connection and waited for another 48 minutes?
> That is a really bad test, who knows what happend in between.
>=20
> Try: cat /proc/net/..., suspend, wakeup, cat /proc/net/... again,
> without doing anything else in between.
Ok, without suspend I did:


tfoerste@n22 /proc/net/ipt_recent $ sudo /etc/init.d/net.ppp0 stop
 * Stopping ppp0
 *   Bringing down ppp0
 *     Stopping pppd on ppp0                                               =
                                                   [ ok ]

tfoerste@n22 /proc/net/ipt_recent $ wc *
0 0 0 ICMP
879 9422 81007 TCP
569 4627 39211 UDP
1448 14049 120218 total

tfoerste@n22 /proc/net/ipt_recent $ date
Thu Apr 19 19:09:29 CEST 2007

tfoerste@n22 /proc/net/ipt_recent $ wc *
0 0 0 ICMP
879 9422 81007 TCP
569 4627 39211 UDP
1448 14049 120218 total

tfoerste@n22 /proc/net/ipt_recent $ date
Thu Apr 19 19:17:57 CEST 2007

Might be I misunderstand something but shouldn't the recent module delete e=
ntries after 60 seconds or so ?

=2D-=20
MfG/Sincerely

Toralf F=F6rster

--nextPart9062166.E1vCjyPasf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGJ6TFhyrlCH22naMRAgmpAJ9OaZMGnRI6QRRJ/CuRTwS/Pn2uQwCggd1s
NjPagzC0yh0N1hRuMXnLHvQ=
=PGr2
-----END PGP SIGNATURE-----

--nextPart9062166.E1vCjyPasf--
