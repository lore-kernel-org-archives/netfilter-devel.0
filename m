From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH pom-ng] H.225 parser for h323-conntrack-nat
Date: Fri, 1 Apr 2005 07:58:19 +0200
Message-ID: <20050401055819.GH19835@sunbeam.de.gnumonks.org>
References: <20050317032405.GA7200@roonstrasse.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DN8g+DOX2TxGxleI"
Cc: netfilter-devel@lists.netfilter.org,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Max Kellermann <max@duempel.org>
Content-Disposition: inline
In-Reply-To: <20050317032405.GA7200@roonstrasse.net>
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


--DN8g+DOX2TxGxleI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 17, 2005 at 04:24:05AM +0100, Max Kellermann wrote:
> Hi,
>=20
> this patch implements a "real" H.225 parser, replacing the old "brute
> force" algorithm. This parser is not complete yet; it currently only
> handles CONNECT packets, although that seems to be enough for most
> H.323 clients. I tested with ohphone, MS Netmeeting and gnomemeeting
> (plus a nfsim test which I will publish soon). NAT works well.

First of all, thanks for your excellent work on this.  However, I'm not
sure whether to apply the patch, since I don't have any test setup for
h.323.

Jozsef: what do you think of that patch? h.323 helper is your code,
after all.

If your nfsim patch could be merged, that would help a lot.

> I havn't written a H.245 parser yet, that's the next item on my todo
> list.

Great, need to read through the rest of my two week email backlog in
order to see whether that was already finished and sent to the list :)

> (I guess the linux-2.6.11 branch is obsolete since the
> h323-conntrack-nat/linux-2.6.11 directory was introduced by Harald)

exactly.

> Max
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--DN8g+DOX2TxGxleI
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCTOL7XaXGVTD0i/8RAu14AJoCrIavlwha5XpaOGheL6VVFPX7jgCgkyz5
GT8SGYmMFetettZAG31uofM=
=8ekN
-----END PGP SIGNATURE-----

--DN8g+DOX2TxGxleI--
