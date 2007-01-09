From: Eric Leblond <eric@inl.fr>
Subject: Re: [RFC] libnfnetlink and iface conversion to string
Date: Tue, 09 Jan 2007 03:50:26 +0100
Message-ID: <1168311026.12298.28.camel@localhost>
References: <1167257854.31765.21.camel@localhost>
	<45940145.3020003@netfilter.org> <1167349247.15420.13.camel@localhost>
	<20070107142607.GC13543@prithivi.gnumonks.org>
	<1168296086.12298.6.camel@localhost> <45A2E78A.8090402@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-f+9idptJNjRiVp55ka1v"
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	Patrick McHardy <kaber@trash.net>, Vincent Deffontaines <vincent@inl.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <45A2E78A.8090402@netfilter.org>
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


--=-f+9idptJNjRiVp55ka1v
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi,

Le mardi 09 janvier 2007 =E0 01:53 +0100, Pablo Neira Ayuso a =E9crit :
> Eric Leblond wrote:
> > It is not correct to do a dump (and send a netlink message) for each
> > ifindex resolution. Thus, libnfnetlink needs to listen to netlink
> > interfaces message. A permanent "task" is thus needed to have the job
> > done : It can be a dedicated thread or a carefully hidden select.
> /* create a table ifindex to interface */
> struct nfnl_ifindex2name_table *nfnl_ifindex2name_open();
> /* destroy table */
> void nfnl_ifindex2name_close(struct nfnl_ifindex2name_table *);
>=20
> /* returns a socket descriptor to listen to interface events */
> int nfnl_ifindex2name_events_open();

Speaking as NuFW's developper and thus libnetfilter_queue user, this
clearly mean that I need to modify select part of my code, not just add
some functions calls. It forces the developper to use directly
libnfnetlink. This goes against my way to see libnetfilter_queue and
other libnetfilter* libraries.

> /* process data available for the socket and update the table */
> int nfnl_ifindex2name_process_event(int, struct nfnl_ifindex2name_table *=
);
> /* close socket */
> void nfnl_ifindex2name_events_close(int); /* close the socket */
>=20
> Another alternative could be the use of libnl, although this introduces
> a new library dependency for every libnetfilter_queue application.

I think that ifname resolution is necessary for an application if it is
a linked with wanted features. If it has to use it, application can link
to libnl (or something else) and have it done. If it don't need it then
libnetfilter_queue is enough.

route netlink message is not a part of Netfilter, we should'nt use it in
Netfilter code if it is not transparent :
      * It duplicates code
      * It changes the "spirit" of libnetfilter* libraries

BR,
--=20
Eric Leblond <eric@inl.fr>
INL

--=-f+9idptJNjRiVp55ka1v
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQBFowLynxA7CdMWjzIRAnVrAJ0cX+0MIKJy9rprrGsD0xDXzo2rNACeMv74
BwP3X0/c1sMgaKD8V0mRsvc=
=JP3h
-----END PGP SIGNATURE-----

--=-f+9idptJNjRiVp55ka1v--
