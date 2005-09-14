From: Tom Eastep <teastep@shorewall.net>
Subject: Re: [ANNOUNCE] ipset 2.2.3 released
Date: Wed, 14 Sep 2005 10:02:30 -0700
Message-ID: <200509141002.40185.teastep@shorewall.net>
References: <Pine.LNX.4.58.0509141241230.23538@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3982315.a8xJbuj6sH";
	protocol="application/pgp-signature"; micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.58.0509141241230.23538@blackhole.kfki.hu>
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

--nextPart3982315.a8xJbuj6sH
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 14 September 2005 03:46, Jozsef Kadlecsik wrote:
> Hi,
>
> I'm happy to announce ipset 2.2.3. The changes compared to the previous
> release are:

=2E..

> - lockhelp.h was removed from the 2.6.13 kernel tree, ip_set.c is
>   updated accordingly (Cardoso Didier, Samir Bellabes)

This patch doesn't seem to be in svn or in the snapshot tarball linked from=
 your site.

CC [M]  net/ipv4/netfilter/ip_set.o
net/ipv4/netfilter/ip_set.c:35: warning: type defaults to =E2=80=98int=E2=
=80=99 in declaration of =E2=80=98DECLARE_RWLOCK=E2=80=99
net/ipv4/netfilter/ip_set.c:35: warning: parameter names (without types) in=
 function declaration
net/ipv4/netfilter/ip_set.c: In function =E2=80=98ip_set_find_in_hash=E2=80=
=99:
net/ipv4/netfilter/ip_set.c:86: warning: implicit declaration of function =
=E2=80=98MUST_BE_READ_LOCKED=E2=80=99
net/ipv4/netfilter/ip_set.c:86: error: =E2=80=98ip_set_lock=E2=80=99 undecl=
ared (first use in this function)
net/ipv4/netfilter/ip_set.c:86: error: (Each undeclared identifier is repor=
ted only once
net/ipv4/netfilter/ip_set.c:86: error: for each function it appears in.)
net/ipv4/netfilter/ip_set.c: In function =E2=80=98__set_hash_del=E2=80=99:
net/ipv4/netfilter/ip_set.c:103: warning: implicit declaration of function =
=E2=80=98MUST_BE_WRITE_LOCKED=E2=80=99
net/ipv4/netfilter/ip_set.c:103: error: =E2=80=98ip_set_lock=E2=80=99 undec=
lared (first use in this function)
net/ipv4/netfilter/ip_set.c: In function =E2=80=98ip_set_hash_del=E2=80=99:
net/ipv4/netfilter/ip_set.c:120: warning: implicit declaration of function =
=E2=80=98WRITE_LOCK=E2=80=99
net/ipv4/netfilter/ip_set.c:120: error: =E2=80=98ip_set_lock=E2=80=99 undec=
lared (first use in this function)
net/ipv4/netfilter/ip_set.c:129: warning: implicit declaration of function =
=E2=80=98WRITE_UNLOCK=E2=80=99
net/ipv4/netfilter/ip_set.c: In function =E2=80=98ip_set_hash_add=E2=80=99:
=2E..


=2DTom
=2D-=20
Tom Eastep    \ Nothing is foolproof to a sufficiently talented fool
Shoreline,     \ http://shorewall.net
Washington USA  \ teastep@shorewall.net
PGP Public Key   \ https://lists.shorewall.net/teastep.pgp.key

--nextPart3982315.a8xJbuj6sH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBDKFewO/MAbZfjDLIRAqN7AJ416LShEnGusJJ34fuQVbuD04dQuACdGwxt
FK/s1BE8PJD0VJXRNNGi/aw=
=k7tp
-----END PGP SIGNATURE-----

--nextPart3982315.a8xJbuj6sH--
