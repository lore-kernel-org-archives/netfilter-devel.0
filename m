From: aton <aton@packetdropped.org>
Subject: Re: netfilter_queue reinjecting packets
Date: Sun, 12 Mar 2006 20:21:33 +0100
Message-ID: <20060312202133.08f8d8ee.aton@packetdropped.org>
References: <1142119489.2987.61.camel@localhost>
	<20060312151054.5a2020ad.aton@packetdropped.org>
	<441433C2.6010901@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
	micalg="PGP-SHA1";
	boundary="Signature=_Sun__12_Mar_2006_20_21_33_+0100_EkELykz9.kY=LQQc"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <441433C2.6010901@trash.net>
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

--Signature=_Sun__12_Mar_2006_20_21_33_+0100_EkELykz9.kY=LQQc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, 12 Mar 2006 15:44:18 +0100
Patrick McHardy <kaber@trash.net> wrote:

> aton wrote:
> > has anyone used netfilter_queue and successfully re-injected packets in=
to the net?
> >=20
> > i want to write sort of a userspace routing application.=20
> >=20
> > host A is my workstation, it has host B as default gateway.
> >=20
> > on host B my routing application runs.=20
> > it receives packets from netfilter_queue using libnetfilter_queue.
> > this works very well and i can display the whole packets.
> >=20
> > now i just want to send them back into the net, so that they reach thei=
r destination.
> >=20
> > i modified the main loop in the source of nfqnl_test.c in the libnetfil=
ter_queue package:
> >=20
> > 	while ((rv=3Drecv(fd, buf, sizeof(buf), 0)) >=3D 0)
> > 	{
> > 		printf("pkt received:\n");
> > 	=09
> > 		printf("sending packet back\n");
> > 	=09
> > 		if ((sv=3Dsend(fd, buf, sizeof(buf), 0))=3D=3D-1)
> > 		{
> > 			perror("send");
> > 			exit(EXIT_FAILURE);
> > 		}
> > 		printf("done\n");
> > 	}
> >=20
> > this should send every packet back to... where?=20
> > it seems the packets are just sent into nirvana, i cannot sniff them, a=
nd i dont get an error from send().
>=20
> nfnql_test already reinjects packets by the call to nfq_issue_verdict.
> It seems you need to read the documentation ..
>=20
>=20

sorry, but i cannot find any call to nfq_issue_verdict in this file.
perhaps you mean nfq_set_verdict(qh, id, NF_ACCEPT, 0, NULL); ?

i thought nfq_set_verdict was used to specify a handling routine for the pa=
ckets... in the case of nfq_test.c set the handling routine for packets to =
the print_pkt() function.
am i wrong?

what documentation? i would _love_ to read some documentation about libnetf=
ilter_queue.=20
i have looked through http://netfilter.org/documentation/index.html#documen=
tation-howto but i cannot find anything specific about libnetfilter_queue...

greetings, aton

--Signature=_Sun__12_Mar_2006_20_21_33_+0100_EkELykz9.kY=LQQc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFEFHTb3tb8MHRI6dcRAr8/AKCfTCVS98+MTKcED3sCVqT3wUlFxACglpft
f0XioHKPWzbSKAYHlUwusUc=
=S/Ks
-----END PGP SIGNATURE-----

--Signature=_Sun__12_Mar_2006_20_21_33_+0100_EkELykz9.kY=LQQc--
