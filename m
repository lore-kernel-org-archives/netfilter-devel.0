From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] nf_conntrack port of conntrack-event-api
Date: Thu, 4 Aug 2005 23:43:33 +0200
Message-ID: <20050804214330.GA4100@rama.de.gnumonks.org>
References: <20050803213816.GA3819@rama.de.gnumonks.org>
	<42F13C09.6090106@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y0ulUmNC+osPPQO6"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <42F13C09.6090106@trash.net>
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


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 03, 2005 at 11:50:01PM +0200, Patrick McHardy wrote:
> Harald Welte wrote:
> > Hi! I've just committed the following patch to the nf_conntrack branch
> > of my netfilter-2.6.14 tree:
> >=20
> > [NETFILTER] port conntrack-events from ip_conntrack to nf_conntrack
> >=20
> > This adds a notifier chain based event mechanism for nf_conntrack state
> > changes.  As opposed to the previous implementations in patch-o-matic, =
we
> > do no longer need a field in the skb to achieve this.
>=20
> The event cache also needs the fixes I sent in the "atomic counter
> underflow" thread two hours ago.

Yes, I'm aware of that.  While I fully trust you on your changes, I
first want to understand them, then port them to nf_conntrack.  Since
I'm still officially on holidays visiting my parents, my time is quite
limited, but I expect it to be done by tomorrow (friday) evening.

cheers,
	Harald
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--y0ulUmNC+osPPQO6
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC8owCXaXGVTD0i/8RAtnfAJ4kvvcEpelda59T7Ph96SC7bqt3pgCdGe41
zHP6zzforQq+sKFCr0sKJcY=
=JFX7
-----END PGP SIGNATURE-----

--y0ulUmNC+osPPQO6--
