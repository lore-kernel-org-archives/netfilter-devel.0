From: Oliver Kurth <oliver.kurth@cyclades.de>
Subject: Re: [Cybr.rdsw] [Cy.rdsw] serious problem with 2.4.24
	combined	with KVM switch (fwd)
Date: Fri, 06 Feb 2004 11:11:32 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1076062292.23823.68.camel@tammuz>
References: <200402060207.i1627Ui05561@singularity.tronunltd.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-I6Cvys+lOJ8Gx4ryvgdk"
Cc: Marcelo Tosatti <marcelo.tosatti@cyclades.com>, Andreas Stempfhuber <andreas.stempfhuber@cyclades.de>, Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ian Latter <Ian.Latter@mq.edu.au>
In-Reply-To: <200402060207.i1627Ui05561@singularity.tronunltd.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-I6Cvys+lOJ8Gx4ryvgdk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2004-02-06 at 03:07, Ian Latter wrote:
> Hello Oliver,
>=20
>   For tftp broadcasts to be in use, I'd assume that this is a network
> bootstrapping scenario - where the TFTP RRQ is broadcast, and=20
> where multiple servers are permitted to respond (TFTP DATA/ACK)

Right.

>   Is it possible that the Netfilter expectation is being satisfied by one
> response (server sending back a TFTP DATA), then being satisfied
> again, by another?

Yes, this is possible. We have more than one tftp server here. Though in
a test scenario we switched off all but one (and the gateway crashed),
but maybe we missed one.

>   You said below;
>=20
> > The problem occurs when:
> > - a client broadcasts a tftp request, with source IP 192.168.160.255
> > - server in the same physical network, but logical network
> > 192.168.10.0/24 replies
> > - the reply is routed through the gateway (which has an alias IP
> > 192.168.160.1 netmask /24 on the same physical network, if this is
> > relevant)
> > - gateway blocks with REJECT. This message ist still in the logs, but
> > soon after that the kernel panics.
>=20
>=20
> While it shouldn't crash (regardless), it should also not be activating=20
> the helper and REJECTing.    Is it possible the the REJECT log entry is
> on an INPUT rule, while the helper is being triggered on a PREROUTING
> rule, due to the architecture of the network you've described (or vice=20
> versa)?

The REJECT is in an INPUT rule. But I do not think that a PREROUTING
rule is involved. I just looked at the rules, and PREROUTING is only
done for other physical networks.

Greetings,
Oliver

> ----- Original Message -----
> >From: "Oliver Kurth" <oliver.kurth@cyclades.de>
> >To: "Harald Welte" <laforge@gnumonks.org>
> >Subject:  Re: [Cybr.rdsw] [Cy.rdsw] serious problem with 2.4.24 combined=
	with KVM=20
> switch (fwd)
> >Date: Wed, 04 Feb 2004 15:05:53 +0100
> >
> > On Tue, 2004-02-03 at 23:00, Harald Welte wrote:
> > > On Tue, Feb 03, 2004 at 05:24:57PM +0100, Oliver Kurth wrote:
> > > > Hi Harald,
> > > >=20
> > > > > > We are having a problem with 2.4.24 on cyclades germany, the bo=
x
> > > > > > (firewall) is crashing in the netfilter code.
> > > >=20
> > > > Anything new about that problem? Do you need more information?
> > >=20
> > > sorry, I lost that issue because I'm extremely overloaded at the mome=
nt.
> > >=20
> > > It seems like it crashes in the following piece of code (from
> > > ip_conntrack_core.c)
> > >=20
> > >         /* If the expectation is dying, then this is a looser. */
> > >         if (expected
> > >             && expected->expectant->helper->timeout
> > >             && !del_timer(&expected->timeout))
> > >                 expected =3D NULL;
> > >=20
> > >=20
> > > To be more precise, it cannot dereference helper->timeout, since help=
er
> > > is NULL.  I am extremely puzzled how you would end up with a conntrac=
k
> > > expectation (which can only be caused by a helper) that has not assig=
ned
> > > a helper.
> >=20
> > I looked over the code, and could not find anything either, but I am no=
t
> > familar with it at all.
> >=20
> > > Could you please tell me, which conntrack and/or NAT helpers you were
> > > using on that machine?
> >=20
> > The problem occurs when:
> > - a client broadcasts a tftp request, with source IP 192.168.160.255
> > - server in the same physical network, but logical network
> > 192.168.10.0/24 replies
> > - the reply is routed through the gateway (which has an alias IP
> > 192.168.160.1 netmask /24 on the same physical network, if this is
> > relevant)
> > - gateway blocks with REJECT. This message ist still in the logs, but
> > soon after that the kernel panics.
> >=20
> > So, if a helper is causing the problem, it is probably the tftp helper.
> > It may also be related to the problem that the client IP is ending with
> > ..255, which is the broadcast address for the gateway on that network.
> >=20
> > I can send the firewall rules to you in a private mail, if you need it.
> >=20
> > This is an ecxcerpt of .config:
> >=20
> > #
> > #   IP: Netfilter Configuration
> > #
> > CONFIG_IP_NF_CONNTRACK=3Dy
> > CONFIG_IP_NF_FTP=3Dy
> > CONFIG_IP_NF_AMANDA=3Dy
> > CONFIG_IP_NF_TFTP=3Dy
> > CONFIG_IP_NF_IRC=3Dy
> > # CONFIG_IP_NF_QUEUE is not set
> > CONFIG_IP_NF_IPTABLES=3Dy
> > CONFIG_IP_NF_MATCH_LIMIT=3Dy
> > CONFIG_IP_NF_MATCH_MAC=3Dy
> > CONFIG_IP_NF_MATCH_PKTTYPE=3Dy
> > CONFIG_IP_NF_MATCH_MARK=3Dy
> > CONFIG_IP_NF_MATCH_MULTIPORT=3Dy
> > CONFIG_IP_NF_MATCH_TOS=3Dy
> > CONFIG_IP_NF_MATCH_RECENT=3Dy
> > CONFIG_IP_NF_MATCH_ECN=3Dy
> > CONFIG_IP_NF_MATCH_DSCP=3Dy
> > CONFIG_IP_NF_MATCH_AH_ESP=3Dy
> > CONFIG_IP_NF_MATCH_LENGTH=3Dy
> > CONFIG_IP_NF_MATCH_TTL=3Dy
> > CONFIG_IP_NF_MATCH_TCPMSS=3Dy
> > CONFIG_IP_NF_MATCH_HELPER=3Dy
> > CONFIG_IP_NF_MATCH_STATE=3Dy
> > CONFIG_IP_NF_MATCH_CONNTRACK=3Dy
> > # CONFIG_IP_NF_MATCH_UNCLEAN is not set
> > # CONFIG_IP_NF_MATCH_OWNER is not set
> > CONFIG_IP_NF_FILTER=3Dy
> > CONFIG_IP_NF_TARGET_REJECT=3Dy
> > # CONFIG_IP_NF_TARGET_MIRROR is not set
> > CONFIG_IP_NF_NAT=3Dy
> > CONFIG_IP_NF_NAT_NEEDED=3Dy
> > CONFIG_IP_NF_TARGET_MASQUERADE=3Dy
> > CONFIG_IP_NF_TARGET_REDIRECT=3Dy
> > CONFIG_IP_NF_NAT_AMANDA=3Dy
> > # CONFIG_IP_NF_NAT_LOCAL is not set
> > # CONFIG_IP_NF_NAT_SNMP_BASIC is not set
> > CONFIG_IP_NF_NAT_IRC=3Dy
> > CONFIG_IP_NF_NAT_FTP=3Dy
> > CONFIG_IP_NF_NAT_TFTP=3Dy
> > CONFIG_IP_NF_MANGLE=3Dy
> > CONFIG_IP_NF_TARGET_TOS=3Dy
> > CONFIG_IP_NF_TARGET_ECN=3Dy
> > CONFIG_IP_NF_TARGET_DSCP=3Dy
> > CONFIG_IP_NF_TARGET_MARK=3Dy
> > CONFIG_IP_NF_TARGET_LOG=3Dy
> > CONFIG_IP_NF_TARGET_ULOG=3Dy
> > CONFIG_IP_NF_TARGET_TCPMSS=3Dy
> > # CONFIG_IP_NF_ARPTABLES is not set
> >=20
> > > We haven't had something like this before.
> > >=20
> > > As a workaround, you could add an additional check into that piece of
> > > code.  At least it won't oops anymore, although it is still unclear h=
ow
> > > you end up with this kind of situation.
> > >=20
> > > if (expected
> > >     && expected->expectant->helper
> > >     && expected->expectant->helper->timeout
> > >     && !del_timer(&expected->timeout))
> > >         expected =3D NULL;
> >=20
> > Greetings,
> > Oliver
> >=20
> > --=20
> > Cyclades GmbH                       -              Everywhere with Linu=
x
> > Oliver Kurth                                               Cyclades Gmb=
H
> > Research & Development                                        Rennweg 3=
3
> > Fon/Fax: +49 (0) 8122 90999-34/-33                        D-85435 Erdin=
g
> >=20
> >=20
>=20
> --
> Ian Latter
> Internet and Networking Security Officer
> Macquarie University
>=20
>  Meet me at the Australian Unix and open systems
>    User Group (AUUG) Security Symposium; 2004
>   http://www.auug.org.au/events/2004/security/
>=20
--=20
Cyclades GmbH                       -              Everywhere with Linux
Oliver Kurth                                               Cyclades GmbH
Research & Development                                        Rennweg 33
Fon/Fax: +49 (0) 8122 90999-34/-33                        D-85435 Erding


--=-I6Cvys+lOJ8Gx4ryvgdk
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBAI2hUUmVSJkUeqxsRAqA1AJ9n+64cKCMbgcjSxlgCW9iOUt1clgCeJoPA
r2XMM0FKYM0uBCeCnSDMOHU=
=vBvQ
-----END PGP SIGNATURE-----

--=-I6Cvys+lOJ8Gx4ryvgdk--
