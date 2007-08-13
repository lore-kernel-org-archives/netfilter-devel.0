From: "Nesser, Phil" <nesser@amazon.com>
Subject: rule limitations?
Date: Mon, 13 Aug 2007 16:48:06 -0700
Message-ID: <4D25F22093241741BC1D0EEBC2DBB1DA365FFCDB@EX-SEA5-D.ant.amazon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
To: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Language: en-US
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

For relatively obscure reasons, I am trying to build a set of rules that ru=
n into the hundreds of thousands.  I was experimenting on a Redhat Release =
5 machine with 2.6.18 kernel and 1.3.5  iptables.  I was able to load aroun=
d 340k rules before getting an error of iptables-restore: line XXXXXX faile=
d.

So I try it out on a server (much beefier, 8G ram, dual quad core 2GHz proc=
) running the same kernel/iptables versions.  This time it died in the same=
 way at about 40k rules.  After some research I found a log message on Vmal=
loc failures, so I figured what the hell and rebuilt the server using the 6=
4 bit version of RH 5.  Now no more vmalloc failures, but still dies at aro=
und 40k entries.

I am more than happy to build a custom kernel if that what I need to do.  I=
 have poked around the sources and it is not obvious what needs to change.

Any help would be appreciated.

Thanks!

- - --->  Phil
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (MingW32)

iD8DBQFGwO22a2RfHGe2XK4RAieYAJ4zyhQ9TZVfCmVIn6PQYzXP5SsSPgCfRmxW
AoW2WX8lau75nY7WzGnPpjA=3D
=3DBM8m
-----END PGP SIGNATURE-----
