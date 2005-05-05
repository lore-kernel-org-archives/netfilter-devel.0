From: Christian Hentschel <chentschel@arnet.com.ar>
Subject: ip_nat_mangle_udp_packet problems
Date: Thu, 05 May 2005 13:32:51 -0300
Message-ID: <1115310771.1852.11.camel@www.l-chr.com.ar>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-6m1Ws1D0VefPE4hkUl+t"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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


--=-6m1Ws1D0VefPE4hkUl+t
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,=20
	i hope someone could answer this problem i'm experimenting. I'm writing
a SIP/RTP conntrack/NAT helper, and i need to mangle packets multiple
times, since there are lots of fields to be mangled.
	I'm using new conntrack/nat framework (>2.6.11) and the way i took to
do it is causing me some problems.
	Basically, i just look for string into the packet, mangle it and call
ip_nat_mangle_udp_packet(). The problem is when i try to search the
nexts strings, i get the wrong offsets.=20
I saw ip_nat_mangle_udp_packet() does not do it manipulation
immediatelly. Please could someone explain this ?.
Is there a way to "sync" so have the skbuff mangled immediately?
is multiple manips of the packets supported in new framework?.=20

Thanks in advance.=20

--=20
Christian Hentschel <chentschel@arnet.com.ar>

--=-6m1Ws1D0VefPE4hkUl+t
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQBCekqz/jxG54BC3LgRAvcZAKCU9561mFEYxDvmQtu8ON4dwAEprACaAti1
1RWEY7EELFD3LwGO4tCU4tU=
=nAeE
-----END PGP SIGNATURE-----

--=-6m1Ws1D0VefPE4hkUl+t--
