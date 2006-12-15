From: Martin MAURER <martinmaurer@gmx.at>
Subject: Re: libnetfilter_queue and libnetfilter_log
Date: Fri, 15 Dec 2006 13:55:30 +0100
Message-ID: <1166187330.4015.2.camel@localhost>
References: <1166116491.3905.14.camel@localhost> <4582722D.8010304@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-wTCh1BYkd94VGmr5E9Fu"
Cc: netfilter-devel@lists.netfilter.org, FireFlier <fireflier@gibraltar.at>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4582722D.8010304@trash.net>
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


--=-wTCh1BYkd94VGmr5E9Fu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2006-12-15 at 11:00 +0100, Patrick McHardy wrote:
> Martin MAURER wrote:
> > Hi,
> > ...
> > libipq_compat.c(ipq_read). This function never returns positive for me
> > (which the former implementation did on new packets.=20
> > I guess it might have to do something with ipq_netlink_recvfrom being
> > commented out?
>=20
> Yes, it was never finished and it pretty useless currently.
> nfnetlink_log and nfnetlink_queue are the future and provide
> a few benefits over the old implementation (easily extendable,
> multiple queue instances, address family agnostic). The downside
> is that if your application should also run on old kernels you
> need to support both implementations (compatibility in the
> other direction would be more useful IMO, so you could use the
> nfnetlink_queue API with both the old and new implementation).
>=20
ok. so I will go for supporting both APIs. Thanks for your information.

greetings
Martin


--=-wTCh1BYkd94VGmr5E9Fu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFgptCXHsqb5Up6wURAm1LAKDJXLFhoMk6MsqWa2ypdR59jF0TPACeKLkt
7HLmfEJFEe4JZdut1Cx6V4A=
=bQO5
-----END PGP SIGNATURE-----

--=-wTCh1BYkd94VGmr5E9Fu--
