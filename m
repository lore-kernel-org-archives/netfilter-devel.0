From: Harald Welte <laforge@gnumonks.org>
Subject: Re: design-feature of nat?
Date: Mon, 4 Nov 2002 09:15:37 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021104091537.Z8635@sunbeam.de.gnumonks.org>
References: <20021102185730.S8635@sunbeam.de.gnumonks.org> <200211022114.ERG.50x8AA@gate.tbc.sub.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CfpASXuKXOK77on4"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "juergen baumann" <jb@moenia.de>
Content-Disposition: inline
In-Reply-To: <200211022114.ERG.50x8AA@gate.tbc.sub.de>; from jb@moenia.de on Sat, Nov 02, 2002 at 10:14:00PM +0100
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--CfpASXuKXOK77on4
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 02, 2002 at 10:14:00PM +0100, juergen baumann wrote:
> well, I see: I've to read some more RFCs next time, before wondering what
> happens there...

;) no problem, it's sometimes not easy to find the precise documents that
apply to a particular case, unless you've read them before and remember
there was a particular precondition.

> > This is ensured by the current configuration, since we cannot use the
> > same tuple until the old TIME_WAIT conntrack is gone.  Is this still
> > valid with your proposed change(s)?
>=20
> not under all circumstances...

that's a problem

> a tcpdump on eth0 shows, that the deleted snat-rule seems still to be act=
ive,
> the src-address of the outgoing packets is 1.2.3.4, not 4.3.2.1 as defined
> by the new snat-rule.

the snat rule is not active.  The NAT binding assigned by the SNAT rule for
this connection is still active.

> is this necessary due to the RFCs?

yes and no.  It is necessarry for FIN and FIN/ACK packets, but not for=20
SYN packets.  The problem is that we lookup connection tracking entries only
by [srcip:srcport,dstip:dstport] tuples, not by TCP flags. [tcp flags are
completely hidden by the layer 4 conntrack protocol helper, not known to the
conntrack core at all.

So either we comply with the RFC's (and have the strange side-effect you=20
are describing), _or_ we don't comply with the RFC's and avoid the side-eff=
ect.

> > Well, since the packet is considered to be part of an already ESTABLISH=
ED
> > connection, it will use the rules you have configured for ESTABLISHED p=
acke=3D
> > ts.
>=20
> mmmh. there's no such rule in table nat (but in table filter). does it me=
an,
> that the packet/byte-counter of a snat-rule only increase on session-star=
tup?

yes.  the chains of a nat table are only traversed  for the
connection-initiating (NEW) packets.  The nat mapping is then saved with=20
the conntrack entry and all other packets within the connection are manipul=
ated
according to this nat mapping.

> it seems, that the whole POSTROUTING-tables does not see the packages of =
an
> established connection at all...

no. only the POSTROUTING chain (and all others) of nat.  This is documented
in the HOWTOS.

> greetings
> j=FCrgen
--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--CfpASXuKXOK77on4
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9xiyoXaXGVTD0i/8RAvVOAJ0ZE3BaqdEHIYIB/vMX3zg1eDj3hwCdGuwC
3WRjnPWhnASNvij2RPMqLKY=
=IIZ8
-----END PGP SIGNATURE-----

--CfpASXuKXOK77on4--
