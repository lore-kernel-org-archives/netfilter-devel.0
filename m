From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: default value of nf_conntrack_tcp_timeout_close_wait
Date: Wed, 04 Apr 2007 14:59:39 +0200
Message-ID: <1175691579.4008.52.camel@henriknordstrom.net>
References: <20070404122314.GP657@kriss.csbnet.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-7HrKnna5xkCoJyIRr/B6"
Cc: netfilter-devel@lists.netfilter.org
To: Joakim Axelsson <gozem@gozem.se>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070404122314.GP657@kriss.csbnet.se>
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


--=-7HrKnna5xkCoJyIRr/B6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

ons 2007-04-04 klockan 14:23 +0200 skrev Joakim Axelsson:

> I've notices that the default value of
> /proc/sys/net/netfilter/nf_conntrack_tcp_timeout_close_wait (atleast in
> kernel 2.6.20.4) is only set to 60 seconds. CLOSE_WAIT is the state where
> one side has sent a FIN but not the other. Meaning we can still send data=
 in
> one direction. This is a state which can live a long time. Much longer th=
an
> just 60 seconds.

I remember this.. was small due to being afraid that connections where
one of the endpoints have gone away may otherwise accumulate.

The best solution I can think of is to not look for FIN to detect such
connections but assymetric traffic where sent data (SYN, data or FIN) is
sent in one direction but no ACKs flowing in the other direction within
a reasonable timeframe (several minutes). Not perfect, but it's hard to
get perfect on this one..

Another idea to close the gaps further would be to drop the "assured"
bit on the connection when a FIN gets ACKed.

Regards
Henrik

--=-7HrKnna5xkCoJyIRr/B6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Detta =?ISO-8859-1?Q?=E4r?= en digitalt signerad
	meddelandedel

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iQCVAwUARhOhOUNPQ5Kbx8daAQL86AP/SiXiniVcBFZv7sGJj5h6UqF1nHcUBsaC
Yo8bpp/ND3KhGgQDzKdTNP2tIr6CELuvkWE8JRKcmmQeOx/7cpthwMAo4AYWCJk2
GP2hZTo2pbrM+bdQqXwQnZ0NDF1CgIcW0J1JCBbOWri1YYMSKkVuDFKS/UExFPUS
D1MCpwVRI5M=
=bYxH
-----END PGP SIGNATURE-----

--=-7HrKnna5xkCoJyIRr/B6--
