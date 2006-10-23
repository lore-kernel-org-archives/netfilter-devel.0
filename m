From: Eric Leblond <eric@inl.fr>
Subject: Re: new match extension to implement port knocking in one
Date: Mon, 23 Oct 2006 21:46:52 +0200
Message-ID: <1161632812.5359.8.camel@localhost>
References: <c0db55360610160810s164cbf26lf58390b818cdf443@mail.gmail.com>
	<4534309F.8000200@netfilter.org>
	<c0db55360610170519h5d2b1e21me5716b1b8ea7967b@mail.gmail.com>
	<1161093912.20036.3.camel@localhost.localdomain>
	<c0db55360610171732nfcd4118mfd89cea1c1aad457@mail.gmail.com>
	<45363E4C.4030201@netfilter.org>
	<c0db55360610230631u4acce3bft3f020916341caf0f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-YmyJmzQCdPBwtDY3wROm"
Cc: netfilter-devel@lists.netfilter.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "J. Federico Hernandez" <fede.hernandez@gmail.com>
In-Reply-To: <c0db55360610230631u4acce3bft3f020916341caf0f@mail.gmail.com>
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


--=-YmyJmzQCdPBwtDY3wROm
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Le lundi 23 octobre 2006 =E0 10:31 -0300, J. Federico Hernandez a =E9crit :
> On 10/18/06, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > J. Federico Hernandez wrote:
> > > On 10/17/06, Eric Leblond <eric@inl.fr> wrote:
> > >> >
> > >> > When all you want is to open a port after a correct sequence of
> > >> > knocks, instead of sending from the kernel all the knocks to the
> > >> > userspace, and then setting a new iptables rule so the kernel fire=
wall
> > >> > takes an action, it would be better to leave the whole work to the
> > >> > kernel and avoid the transition kernel->userspace->kernel.
> > >>
> > >> kernel->userspace->kernel is really not a problem for nowadays compu=
ter.
> > >> Simply think about snort-inline which is able to handle a great amou=
nt
> > >> of traffic.
> > >
> > > the fact that nowadays computers have much more power, doesn't mean
> > > that you can forget about a simple, less complex and correct design.
> >
> > I'm unsure that putting things in kernel implies less complexity and
> > correct design, it depends on the case.
> >
>=20
> Putting things in kernel doesn't mean less complexity, but on port
> knocking case means a correct design and better performance.
>=20
> WIth traditional port knocking applications you have to switch
> kernelspace ->userspase->kernelspace several times. Furthermore, you
> have to load the regex engine for parsing the firewall logs and you
> have to access the hard disk each minute for parsing logs files. In
> our opinion, this is not a correct design.

We do not understand each other about the way I (and pablo I think)
propose you to do because the solution I thought off do not use log
analysis...

Let's say port knocking is 4138 2345 4577 to open port 22

Then just do=20
iptables -A INPUT -p tcp -m multiport --dports 4138,2345,4577,22 -j QUEUE

Your userspace application wait for packets coming from queue, drop them
when they come from knocking ports (but store the knock) and accept
packet to port 22 if we just had a correct knocking sequence before.

This is simple, do not use complex algorithms and should fit on all
small routers.

BR,
--=20
Eric Leblond <eric@inl.fr>
INL

--=-YmyJmzQCdPBwtDY3wROm
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQBFPRwsnxA7CdMWjzIRAgWbAJ9yAxaVtaAQUwmD8RsIcPYZSSnGZQCcDIWx
C4y6KAE+38mEEsP/0MTo2Sw=
=MR7R
-----END PGP SIGNATURE-----

--=-YmyJmzQCdPBwtDY3wROm--
