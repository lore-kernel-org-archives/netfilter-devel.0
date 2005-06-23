From: Harald Welte <laforge@netfilter.org>
Subject: Re: Linux 2.6.12/iptables 1.3.1+CLUSTERIP issues
Date: Thu, 23 Jun 2005 10:38:31 +0200
Message-ID: <20050623083831.GV4551@obroa-skai.de.gnumonks.org>
References: <876ef97a0506201904a05582a@mail.gmail.com>
	<20050622121509.GG4551@obroa-skai.de.gnumonks.org>
	<42B9D299.1080902@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BlkQeOBdElZ1aiuH"
Cc: Tobias DiPasquale <codeslinger@gmail.com>,
	nf-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <42B9D299.1080902@eurodev.net>
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


--BlkQeOBdElZ1aiuH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 22, 2005 at 11:05:29PM +0200, Pablo Neira wrote:
> Hi Harald,
>=20
> Harald Welte wrote:
> >>2. I installed this rule just to test things out:
> >>
> >>iptables -A INPUT -d 192.168.1.3 -i eth0 -p tcp --dport 3000 -j
> >>CLUSTERIP --new --hashmode sourceip-sourceport --clustermac
> >>01:23:45:67:89:AB --total-nodes 2 --local-node 1
> >>
> >>I then tried to remove it (I didn't update iptables rules again since
> >>then) by switching the -A to a -D and that failed. I tried all sorts
> >>of combinations of the arguments to -j CLUSTERIP but they all failed.
> >>Eventually, I was forced to remove the rule by using the iptables rule
> >># (e.g. iptables -D INPUT 10). I feel that this is in error, but I've
> >>seen at least two patches to CLUSTERIP that claim to fix rule
> >>deletion. Am I doing something wrong?
>=20
> fix-del-with-userspacesize-target.patch:

thanks, Committed revision 3989.


> http://people.netfilter.org/pablo/patches/fixes/kernel/pending/fix-layout=
-CLUSTERIP.patch

yes, I re-sent it yesterday.


--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--BlkQeOBdElZ1aiuH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFCunUHXaXGVTD0i/8RAvbrAKCRt5PRJjDTUSw+fap4EJl0cR+otwCfeONQ
MgSy44u2TkGjCddpXkCZ3tM=
=5eUY
-----END PGP SIGNATURE-----

--BlkQeOBdElZ1aiuH--
