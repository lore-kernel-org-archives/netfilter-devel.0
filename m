From: Eric Leblond <eric@inl.fr>
Subject: Re: new match extension to implement port knocking in one
Date: Tue, 17 Oct 2006 16:05:12 +0200
Message-ID: <1161093912.20036.3.camel@localhost.localdomain>
References: <c0db55360610160810s164cbf26lf58390b818cdf443@mail.gmail.com>
	<4534309F.8000200@netfilter.org>
	<c0db55360610170519h5d2b1e21me5716b1b8ea7967b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-2yxxuCDvdhQrGhm98cIf"
Cc: netfilter-devel@lists.netfilter.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "J. Federico Hernandez" <fede.hernandez@gmail.com>
In-Reply-To: <c0db55360610170519h5d2b1e21me5716b1b8ea7967b@mail.gmail.com>
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


--=-2yxxuCDvdhQrGhm98cIf
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable

Le mardi 17 octobre 2006 =E0 09:19 -0300, J. Federico Hernandez a =E9crit :
> On 10/16/06, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > J. Federico Hernandez wrote:
> > >> On Oct 14, 2006, Michael Rash wrote:
> > >>
> > >> Well, I agree that having an implementation that builds some port
> > >> knocking capabilities directly into iptables is a good thing for the
> >
> > Perhaps I'm just influenced by my first impression but I think that thi=
s
> > thing should be in userspace. We are providing the appropiate netfilter
> > netlink subsystems (nfqueue, nflog...) to implement this as a userland
> > daemon.
> >
>=20
> When all you want is to open a port after a correct sequence of
> knocks, instead of sending from the kernel all the knocks to the
> userspace, and then setting a new iptables rule so the kernel firewall
> takes an action, it would be better to leave the whole work to the
> kernel and avoid the transition kernel->userspace->kernel.

kernel->userspace->kernel is really not a problem for nowadays computer.
Simply think about snort-inline which is able to handle a great amount
of traffic.

> In other more complex situations, you can recognize the knocks in the
> kernel and let a userspace app take an action using netlink sockets,
> as you say, but you should never allow a port knocking app to add or
> remove firewall rules on the fly.

I don't think this was Pablo's intention : you can queue packet for all
port including the one that must pass through and when the port knocking
sequence is complete, allow packet to go through target port from
userspace.

BR,
--=20
=C9ric Leblond, eleblond@inl.fr
T=E9l=E9phone : 01 44 89 46 39, Fax : 01 44 89 45 01
INL, http://www.inl.fr

--=-2yxxuCDvdhQrGhm98cIf
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBFNOMYnxA7CdMWjzIRAgwyAJ940Z/Tc5PWvSswx7l1dzA1GzInMgCfVYgR
nJk/83pzhNrDEGVuG7aUld4=
=fjd2
-----END PGP SIGNATURE-----

--=-2yxxuCDvdhQrGhm98cIf--
