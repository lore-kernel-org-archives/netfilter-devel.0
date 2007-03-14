From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: One unified table of nat/mangle/filter
Date: Wed, 14 Mar 2007 15:32:51 +0100
Message-ID: <1173882771.1760.13.camel@henriknordstrom.net>
References: <et6fp4$l04$1@sea.gmane.org>
	<Pine.LNX.4.61.0703131632190.18488@yvahk01.tjqt.qr>
	<45F6CD7C.40708@ufomechanic.net>
	<Pine.LNX.4.61.0703131717440.18488@yvahk01.tjqt.qr>
	<1173868532.26913.39.camel@henriknordstrom.net>
	<45F7D657.8070907@trash.net>
	<1173876211.26913.73.camel@henriknordstrom.net>
	<45F7F027.9050300@ufomechanic.net> <45F7F3C6.3060908@trash.net>
	<Pine.LNX.4.64.0703141415200.26704@blackhole.kfki.hu>
	<45F802AF.6010307@ufomechanic.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-+VobyKZXbIoXVr3obY4X"
Cc: netfilter-devel@lists.netfilter.org
To: Amin Azez <azez@ufomechanic.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45F802AF.6010307@ufomechanic.net>
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


--=-+VobyKZXbIoXVr3obY4X
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

ons 2007-03-14 klockan 14:11 +0000 skrev Amin Azez:

> It would make more sense to have only 1 table and let users invent
> NAT/MANGLE/FILTER chains if they wanted (for old times sake); and just
> treat snat and dnat targets as if they had an implicit "-m ctstate
> --ctstate NEW".

I generally agree on this.

Ideally I'd like to se a single table capable of the functions of nat
+mangle+filter, and hooking into the hooks for which there is rules
only.

However, nat is a bit too different due to the heavy tuple assignment
code and the fact that it only makes sense on the first packet of a
session so it's not entirely obvious how to mix it. But I have done this
for a customer in the past by separating the nat engine from the table,
and making custom NAT targets capable of setting the NAT tuples outside
of the nat table if not assigned already.. wasn't too hard in the old
NAT code, and probably not very hard today either.. If it makes much
sense is another question, but to that customer it did but only so in
combination with other changes to mimic the behavior of the nat table
(only first packet, kind of..).

> Am I right, or do tables still help?

To some it probably helps. But for most building automated rulesets it's
just an annoyance I think, placing almost arbitrary restrictions on how
rulesets can be built.

Generally the split in different tables is a good idea to structure the
ruleset management, but not always depending on the origin of the
ruleset..

Regards
Henrik

--=-+VobyKZXbIoXVr3obY4X
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Detta =?ISO-8859-1?Q?=E4r?= en digitalt signerad
	meddelandedel

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQCVAwUARfgHkENPQ5Kbx8daAQKpfAQAov5TAaO46SiamzQXFTLst9DhnJePJH5K
SBSeaEblEVMWBEV62AdVw+4rGWrQB9nD9qTJoQ1CNIZXZKJAWBpSdnEtuuNwwz+5
FfKqZ5RiVCVWl2+bz9LQF+mC04ytUezpT+K85OC5fAkqrzAmWEk04y6bcExAg2og
Abp/smbqkr0=
=bkpU
-----END PGP SIGNATURE-----

--=-+VobyKZXbIoXVr3obY4X--
