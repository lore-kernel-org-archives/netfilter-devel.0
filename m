From: Harald Welte <laforge@gnumonks.org>
Subject: Re: ip_conntrack performance issues
Date: Fri, 31 Jan 2003 12:28:16 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030131112816.GQ9073@naboo.cybercafe42>
References: <200301180113.04460.alchemyx@uznam.net.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BHMq0+oGliEfCAkH"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Micha? Margula <alchemyx@uznam.net.pl>
Content-Disposition: inline
In-Reply-To: <200301180113.04460.alchemyx@uznam.net.pl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--BHMq0+oGliEfCAkH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 18, 2003 at 01:13:04AM +0100, Micha? Margula wrote:
> Hello!
>=20
> First of all I would like to apologize if issue I am writing about, was=
=20
> discussed here before. I wasn't looking trough archive, because it is abo=
ut=20
> 63 MB of pure mbox, I was only googling.
>=20
> The problem is that I have Linux box, that is making NAT for few hundreds=
 of=20
> workstations. I am using 2.4.18 but it also happens on 2.4.19 or 2.4.20. =
I=20
> need to run identd daemon for those workstations behind NAT. I am using=
=20
> oidentd for that purpose. Oidentd reads /proc/net/ip_conntrack to identif=
y=20
> connections.
>=20
> My /proc/net/ip_conntrack has about 100 000 entries. Sometimes less,
> sometimes more but near that value.=20

This is definitely _not_ what you want to do.  oidentd might work as
long as you have  a couple of hundred connections, but not at this size.

> Oidentd parsing that file "eats" almost whole CPU=20
> time. Running more than one instance of oidentd is simply a suicide. But =
that=20
> is not main problem - when parsing /proc/net/ip_conntrack my network goes=
=20
> weird. Packet lossess on every interface increase, round trip time behave=
s=20
> funny (jumping from 10 ms to 300). Network flow is also affected in a sam=
e=20
> way (file transfers "hangs" for a while).

yup. This is known for a very long time and is not considered a bug.
ip_conntrack is more like a debugging interface than something to be
polled regularly by userspace applications.

We have developed 'ctnetlink' for exactly this purpose.  It is not in
the stock kernel yet, but can be easily added by patch-o-matic.

> Friend of mine created "dirty hack" which consist of kernel module=20
> (ip_conntrack_identd) and patched version of oidentd, but he says that he=
=20
> won't make it public, because that solution is very bad and shouldn't be =
done=20
> this way.

true.  There have also been talks of an ip_nat_ident.o kernel module
which would NAT the ident request back to the real machine behind the
firewall.  It's a bit tricky, but it can be done with heuristics in most
cases.

> So question is - what now? Are there any ideas to improve performance of=
=20
> /proc/net/ip_conntrack=20

no. I don't think that there is any way of doing this via /proc

> or maybe replacing that with some calls to internals of the kernel? It
> is quite important issue, because using ident daemon on boxes with
> huge amounts of traffic is impossible.

please see the nfnetlink-ctnetlink patch in patch-o-matic.

for userspace, see CVS:

iptables2/libnfnetlink/ (you just need to compile it)
iptables2/libctnetlink/ (you will need this API for oidentd)
iptables2/libctnetlink/ctnltest.c (example application using libctnetlink)

> Micha? Margula, alchemyx@uznam.net.pl, http://alchemyx.uznam.net.pl/ +)

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M-=
=20
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)

--BHMq0+oGliEfCAkH
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+Ol3QXaXGVTD0i/8RAiZHAJwJ1EOp4whRVo6PZ7lKlNeZEpkKJgCcC23u
2HUak0LeC6vy/WzHt1V3Xis=
=4Atf
-----END PGP SIGNATURE-----

--BHMq0+oGliEfCAkH--
