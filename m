From: Harald Welte <laforge@gnumonks.org>
Subject: Re: design-feature of nat?
Date: Sat, 2 Nov 2002 18:57:30 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021102185730.S8635@sunbeam.de.gnumonks.org>
References: <20021102153451.N8635@sunbeam.de.gnumonks.org> <200211021530.EREjZ0McAA@gate.tbc.sub.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tn/dP4bPCRmapcqv"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "juergen baumann" <jb@moenia.de>
Content-Disposition: inline
In-Reply-To: <200211021530.EREjZ0McAA@gate.tbc.sub.de>; from jb@moenia.de on Sat, Nov 02, 2002 at 04:30:26PM +0100
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--tn/dP4bPCRmapcqv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 02, 2002 at 04:30:26PM +0100, juergen baumann wrote:
> recently Harald Welte said ...
>=20
> > I don't really understand the problem.  Are you talking about SNAT not
> > occurring as long as the old conntrack entry is still in TIME_WAIT stat=
e?
>=20
> right. that's the problem.
>=20
> unfortunately some applications use the same source-port, so any *new*
> connection, which will be established during th TIME_WAIT-state will be
> handled by the old configuration.
>=20

Yes, this is true.  I've now read the respective RFC's again, and RFC793
states:

>      TIME-WAIT STATE
>
>          The only thing that can arrive in this state is a
>          retransmission of the remote FIN.  Acknowledge it, and restart
>          the 2 MSL timeout.

So we only need to use the old conntrack entry in case of FIN or FIN/ACK
packets, and create new conntrack entries if the packet establishes a new
connection (SYN, ..)

But then there is also another issue which we need to take into account
(excerpt from RFC2993):

>   For address translators (which do not translate ports) to comply with
>   the TCP_TIME_WAIT requirements, they must refrain from assigning the
>   same address to a different host until a period of 2*MSL has elapsed
>   since the last use of the address, where MSL is the Maximum Segment
>   Lifetime defined in RFC-793 as two minutes.  For address-and-port
>   translators to comply with this requirement, they similarly must
>   refrain from assigning the same host/port pair until 2*MSL has
>   elapsed since the end of its first use.  While these requirements are
>   simple to state, they can place a great deal of pressure on the NAT,
>   because they temporarily reduce the pool of available addresses and
>   ports.

This is ensured by the current configuration, since we cannot use the
same tuple until the old TIME_WAIT conntrack is gone.  Is this still
valid with your proposed change(s)?

> the other problem (which is not fixed by my patch) is, that while such a
> conntrack-entry exists no new connection triggers the counter of such a r=
ule
> nor a LOG-entry will be created, if one is prepended to the SNAT-rule. the
> packets pass the whole table invisible...

Well, since the packet is considered to be part of an already ESTABLISHED
connection, it will use the rules you have configured for ESTABLISHED packe=
ts.

> I hope, it's now more clear, what I talk about.

Yes, thanks for clarification.

> greetings=20
> jb
--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--tn/dP4bPCRmapcqv
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9xBIKXaXGVTD0i/8RAu+nAKCU8fYArIAYY1Eyuea4RALWXxONfQCaAvEz
7wpXXGVdGvdh4zKLvBL3nEg=
=AJ5/
-----END PGP SIGNATURE-----

--tn/dP4bPCRmapcqv--
