From: Nicolas George <nicolas.george@ens.fr>
Subject: Re: TCPMSS target for IPv6
Date: Mon, 15 Dec 2003 22:07:05 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031215210705.GA2326@clipper.ens.fr>
References: <20031211122649.GA25739@clipper.ens.fr> <200312150127.KAA00902@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
In-Reply-To: <200312150127.KAA00902@toshiba.co.jp>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Le quintidi 25 frimaire, an CCXII, Yasuyuki Kozakai a =E9crit=A0:
>> IPv6-over-IPv4 tunnels: if the fragmentation problem arises in the IPv4
>> world, an ICMPv4 "fragmentation needed" is sent, but it can not be
>> converted into an ICMPv6 "too big", so path MTU discovery does not work.
> Please read subsection 3.2. in RFC 2893 .

You are right, the problem is adressed, and it should work. Alas, there
is difference between what is written in RFC and what programmers really
do.

> Do we have any other cases that TCPMSS is needed ? I think MTU issues
> should be solved in IPv6 stack (and lower layer in the case that MTU <
> 1280) and RFCs say so. So I think we don't need it.

I believe we all agree that things should work alone. But if that was
true, we would have enough IP addresses for everyone and programs with
powerful control access and no buffer overflows, and so no need for
nterilter, isn't it?

I did not beg for IPv6/TCPMSS just because I thought it was cool stuff.
I have a precise problem, where packets of the wrong size will get lost
without any ICMP, and therfore TCP connections freeze as soon as a large
segment is sent. It involves an IPv4 tunnel, and the sizes fit, so I
guess the problem comes from lost ICMPv4.

Unfortunately, I do not control any part of the tunnel itself (it is a
6to4 tunnel), so I can not track the exact problem, and even less
correct it. The only solution I see to avoid freezed TCP connections is
to advertise a small enough MSS. I can do that by globally lowering my
MTU, but this is a quite ugly solution. Being able to do that on a
per-IP basis would be great.

My point is that we do not need TCPMSS less for IPv6 than for IPv4
(except that IPv6 itself is seldom used): the goal of such a target is
to workaround bogus infrastructures ("criminally braindead ISPs"), and
there seems to exist as much of those for IPv6 as for IPv4 (and anyway
tunnels give us the worst of both worlds).

The rant is finished, you can resume your normal activities.

Regards,

--=20
  Nicolas George

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.0 (SunOS)

iD8DBQE/3iJ4sGPZlzblTJMRAgP4AKCzPGPO0S6WHUFhxHOsWnbfq4lZnwCbBbGo
0rxEVyn42rug+/HzfwSD5QY=
=mgml
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
