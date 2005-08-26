From: Harald Welte <laforge@netfilter.org>
Subject: Re: kernel option "Bridged IP/ARP packets filtering" degrades
	bridging per
Date: Fri, 26 Aug 2005 11:19:14 +0200
Message-ID: <20050826091914.GK4226@rama.de.gnumonks.org>
References: <20050826034724.88957.qmail@web70107.mail.krs.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QxN5xOWGsmh5a4wb"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: =?utf-8?B?7LSI7IicIOyehA==?= <csyimkor@yahoo.co.kr>
Content-Disposition: inline
In-Reply-To: <20050826034724.88957.qmail@web70107.mail.krs.yahoo.com>
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


--QxN5xOWGsmh5a4wb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

please note that netfilter bridging stuff is probably better discussed
at some ebtables and/or bridging related mailinglist.

On Fri, Aug 26, 2005 at 12:47:24PM +0900, =EC=B4=88=EC=88=9C =EC=9E=84 wrot=
e:
> I have tested the bridging performance of Linux.

please don't try to do performance tests (and be disappointed) without
first learning about all the important optimizations/toggles/switches,
bells and whistles that you can use to tune the performance in cases
like yours.
=20
> Linux machine;
>=20
> Xeon 3.06GHz * 2 CPU

dual cpu doesn't really help in most packet forwarding cases with only
two interfaces. try booting a UP kernel.

> 1 G Memory

which memory (speed)?  which chipset?=20
> intel e1000 NIC 2 port LC type * 1 driver version

which bus-width? which speed?  where are they in the bus hierarchy?

> But when I enabled that option(I recompiled the
> kernel), I got success rate 5%.
> It was a half of prior result.=20
> I did not add any filter rules. I just enabled that
> option because I wanted to use bridge
> firewalling.=20

some degradation is not really surprising since you will add a number of ne=
tfilter
hooks to the network stack, each of which will be consulted for every
packet.  Also, enabling bridging packet filter will enlarge "struct
sk_buff", which might cause it to grow another cacheline and thus
introduce more cache misses.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--QxN5xOWGsmh5a4wb
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDDt6SXaXGVTD0i/8RAvgPAKCfgxwcFZYoVFJe9D6+p9CIhO6ECgCfcB8j
UG2AYb4JONe/ZGDRs/qpRX0=
=u5mc
-----END PGP SIGNATURE-----

--QxN5xOWGsmh5a4wb--
