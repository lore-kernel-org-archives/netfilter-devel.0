From: Rennie deGraaf <rgndegra@ucalgary.ca>
Subject: Re: remarkably Increase iptables' speed on SMP system.
Date: Fri, 28 Sep 2007 10:01:56 -0600
Message-ID: <46FD2574.6000800@ucalgary.ca>
References: <00de01c80175$7402ef90$ca8510ac@asimco> <46FCF121.8010807@ufomechanic.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF3C209CBA08596B64ED094CB"
Cc: John Ye <johny@asimco.com.cn>, netfilter-devel@vger.kernel.org,
	YE QY <iceburgue@gmail.com>
To: Amin Azez <azez@ufomechanic.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ensa.cpsc.ucalgary.ca ([136.159.2.1]:54527 "EHLO
	ensa.cpsc.ucalgary.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbXI1QxK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Sep 2007 12:53:10 -0400
In-Reply-To: <46FCF121.8010807@ufomechanic.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF3C209CBA08596B64ED094CB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Amin Azez wrote:
> * John Ye wrote, On 28/09/07 03:15:
>=20
>> There is a kernel patch to let softirq network code(iptables included =
in) concurrently run on every CPUs on SMP system.
>> We wrote the kernel patch, a loadable module as well, to totally resol=
ve iptables SMP issue.
>> Have discussed with kernel netdev experts. it should be working.
>>
>> The patch(module) will greatly increase the speed of iptalbes by makin=
g full use of every CPUs in SMP system.
>>
>> It can be viewed and downloaded from blog http://blog.chinaunix.net/u/=
12848/showart.php?id=3D389602
>> You are welcome to review and test without patching and re-compiling t=
he kerenl.
>=20
>=20
> This looks interesting, and I hope worthwhile.
>=20
> I wonder if it will likely re-order packets with the same flow?
>=20
> i.e. packets which take more processing may leave the bridge/router
> after a packet of the same flow which arrived later.
>=20
> Cases where this seems more likely are generally where not every packet=

> of the same flow requires the same level of processing.
>=20
> Obvious examples are:
> * udp snat, where only the first packet follows the nat table
> * layer7 when it stops matching, the very next packet may get through
> before the one that was the last to be matched.
> * packet count or rate based rules that only sometimes call secondary
> chains may be delayed more than the next packet if it doesn't match.
>=20
> TCP (with SACK) may not be so bothered about this, but some GRE or UDP
> protocols may care (get degraded service), it may also foil upstream
> flow analysis which makes me realise that the layer7 match (and probabl=
y
> string match) are open to being deceived by deliberate out-of-order
> packets or intermediate fake packets with bad tcp sequence numbers. Hmm=


Unless something is seriously wrong with netfilter or the patch, packets
should almost never be re-ordered unless their inter-arrival times are
less than a few milliseconds.  If the packets are that close together,
then existing network equipment will re-order them with non-trivial
probability, so any additional re-ordering introduced by this patch
shouldn't matter.  Applications need to be built to handle this, and if
anything in netfilter depends on packets arriving in the correct order
(other than stuff like TCP SYN segments that can't be delivered out of
order if both endpoints are following the protocol), it should be fixed.

There is a great paper by Bennet, Partridge and Shectman titled "Packet
Reordering is Not Pathological Network Behavior" published in IEEE/ACM
Transactions on Networking in December 1999 that examines this issue and
its effects on TCP, so the observation that parallelism in network
devices causes packet re-ordering is nothing new.  I did an experimental
analysis on the effects of inter-packet time on delivery order last
winter; my results are in Appendix A of my MSc thesis, which is
available at
http://pages.cpsc.ucalgary.ca/~degraaf/papers/thesis-degraaf.pdf

Rennie deGraaf


--------------enigF3C209CBA08596B64ED094CB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQFG/SV3IdbcyzdF7kkRAlQBAJ9xXE5AtHMbrU59gXqajHRlB/NVKACfbxmg
u6+GKqZewMu6FDG3Q3RULuo=
=nvMk
-----END PGP SIGNATURE-----

--------------enigF3C209CBA08596B64ED094CB--
