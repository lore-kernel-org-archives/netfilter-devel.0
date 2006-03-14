From: aton <aton@packetdropped.org>
Subject: Re: netfilter_queue reinjecting packets
Date: Tue, 14 Mar 2006 13:54:52 +0100
Message-ID: <20060314135452.19a2b219.aton@packetdropped.org>
References: <1142119489.2987.61.camel@localhost>
	<20060312151054.5a2020ad.aton@packetdropped.org>
	<441433C2.6010901@trash.net>
	<20060312202133.08f8d8ee.aton@packetdropped.org>
	<4414780C.60907@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
	micalg="PGP-SHA1";
	boundary="Signature=_Tue__14_Mar_2006_13_54_52_+0100_02qlHADxlMjxnONV"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4414780C.60907@trash.net>
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

--Signature=_Tue__14_Mar_2006_13_54_52_+0100_02qlHADxlMjxnONV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, 12 Mar 2006 20:35:40 +0100
Patrick McHardy <kaber@trash.net> wrote:

> aton wrote:
> >>nfnql_test already reinjects packets by the call to nfq_issue_verdict.
> >>It seems you need to read the documentation ..
> >>
> >=20
> > sorry, but i cannot find any call to nfq_issue_verdict in this file.
> > perhaps you mean nfq_set_verdict(qh, id, NF_ACCEPT, 0, NULL); ?
>=20
> Yes, thats what I meant.
>=20
> > i thought nfq_set_verdict was used to specify a handling routine for th=
e packets... in the case of nfq_test.c set the handling routine for packets=
 to the print_pkt() function.
> > am i wrong?
>=20
> Yes. nfq_set_verdict is used to tell the kernel to pass the packet
> on and possibly exchange it. Both print_pkt and nfq_set_verdict
> are called from the packet callback in the example code.
>=20
> > what documentation? i would _love_ to read some documentation about lib=
netfilter_queue.=20
> > i have looked through http://netfilter.org/documentation/index.html#doc=
umentation-howto but i cannot find anything specific about libnetfilter_que=
ue...
>=20
> I don't think there is specific libnetfilter_queue documentation yet
> (but its very simple and exports only a few functions, look at the
> code). But we have ip_queue documentation, which should at least
> help you understand it better conceptually.
>=20

okay i seem to understand how it works a bit better now.=20
what i dont understand is how to get the ethernet header from the library.
i tried nfq_get_packet_hw(), but it always returns NULL, is that correct?

here is the modified source and the output: http://rafb.net/paste/results/p=
b8tD850.html

greetings

--Signature=_Tue__14_Mar_2006_13_54_52_+0100_02qlHADxlMjxnONV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFEFr0l3tb8MHRI6dcRAufkAJ9UdaYZEuJC5ggG4MD//5W5xkPurwCdEhqo
zGR7o4N5cNtzmpPLpVs0Y8M=
=ojNO
-----END PGP SIGNATURE-----

--Signature=_Tue__14_Mar_2006_13_54_52_+0100_02qlHADxlMjxnONV--
