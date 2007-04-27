From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: Libipq problem
Date: Fri, 27 Apr 2007 15:13:39 +0200
Message-ID: <1177679619.19587.14.camel@henriknordstrom.net>
References: <f015bcab0704190221u70fe1d9by1808eac18f53e669@mail.gmail.com>
	<1177422604.3032.1.camel@henriknordstrom.net>
	<f015bcab0704270245j647eb91eq74ff21c97dbdb134@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-nI+/llF6upbPbyvKBLZ9"
Cc: netfilter-devel@lists.netfilter.org
To: miguel Angel Vazquez <mikinho21@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <f015bcab0704270245j647eb91eq74ff21c97dbdb134@mail.gmail.com>
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


--=-nI+/llF6upbPbyvKBLZ9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

fre 2007-04-27 klockan 11:45 +0200 skrev miguel Angel Vazquez:

> Uops...that's a good question. I've not implemented a sequence number
> control but I'm trying to handle it with some local variables.

I'd suggest you better try doing what you are doing as a NAT helper
instead.. that way you leverage from all the packet rewriting and
sequence number adjusting done by the NAT kernel.

Doing this correctly via libipq will be very hard.

=20
> Well the fact is it seems that when I send a smaller packet than the
> original queued one, the rest of the packet still remains in the
> queue. Any idea about how to drop the rest of the package out of the
> queue??

Are you sure it's still in the queue and not a retransmission? When your
smaller packet is forwarded only that amount of data gets ACK:ed by the
recipient, and the sender sees that something went wrong and retransmits
the unacknowledged data after a short delay.=20

Regards
Henrik

--=-nI+/llF6upbPbyvKBLZ9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Detta =?ISO-8859-1?Q?=E4r?= en digitalt signerad
	meddelandedel

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iQCVAwUARjH3AENPQ5Kbx8daAQKvmAQAiL10USKVISwP7iU90drKIp7e2QoXLrHX
EZuNCH0/atS+Z+lRekYNKwoQsGTHx66t16srzGTbT4aBAAS0s7VJ5TVbgF2hUgXy
DriFM/LjybKrpwnj1m3WRb3m8Y9ttmdzLu4CF+il8jmEqrP58qlLt7pdcp72+/yn
wP9w25ZtS80=
=h1GY
-----END PGP SIGNATURE-----

--=-nI+/llF6upbPbyvKBLZ9--
