From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: Need fast reply: how does iptables interact with kernel space
	code ??
Date: Mon, 02 Apr 2007 17:16:55 +0200
Message-ID: <1175527015.4517.10.camel@henriknordstrom.net>
References: <354050.44203.qm@web36413.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-taDjjf7O0M8a16PYpDum"
Cc: netfilter-devel@lists.netfilter.org
To: Sergei Lavrov <lavrov2005@yahoo.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <354050.44203.qm@web36413.mail.mud.yahoo.com>
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


--=-taDjjf7O0M8a16PYpDum
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

l=C3=B6r 2007-03-17 klockan 07:39 -0700 skrev Sergei Lavrov:

> iptables -t nat -A PREROUTING -i ppp0 -p tcp -j
> REDIRECT --to-port 10080 --dport 80
>=20
> I went through extensions/ipt_REDIRECT.c and
> libiptc/libiptc.c and libiptc/libip4tc.c.
>=20
> But I still don't understand what iptables does to the
> kernel so that the kernel will redirect the traffic ?

The above communicates a NAT mapping to the netfilter NAT kernel when
the rule fires. See the netfilter hacking howto and the kernel side of
the REDIRECT target (net/ipv4/netfilter/ipt_REDIRECT.c) for valuable
insight in how this works in the kernel.

>  Can someone explain the gist to me ??

Not entirely sure which part you want explained. There is very many
components involved.

There is

 * Linux TCP/IP stack
 * Netfilter hooks in the above
 * conntrack
 * NAT
 * iptables, with it's different tables, matches and targets
 * and the iptables userspace command with extensions matching the same
as above..

Regards
Henrik

--=-taDjjf7O0M8a16PYpDum
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Detta =?ISO-8859-1?Q?=E4r?= en digitalt signerad
	meddelandedel

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iQCVAwUARhEeZENPQ5Kbx8daAQKfxwQAyP7tZhx8KUpuHv4sg7nqG5Ocd8dk3GrA
RtyksgwsmPE9GQT+7fbBCCZ+6Gvn99K+nDPePxAxgIFLnbRIBXcuLLXbMxDusF7x
PXEVxXt5gyjLUzGgjPcjVEIXjeUcHtOZsUPcTZWyx/7NeSwYoDqF6Lvx9TeYBDXn
FzukEd5xuEo=
=+4O4
-----END PGP SIGNATURE-----

--=-taDjjf7O0M8a16PYpDum--
