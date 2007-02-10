From: Masahide NAKAMURA <nakam@linux-ipv6.org>
Subject: Re: [NETFILTER]: ip6_tables: Support MH match.
Date: Sat, 10 Feb 2007 17:32:13 +0900
Message-ID: <200702101732.13634.nakam@linux-ipv6.org>
References: <200701260953.l0Q9rvv9022736@toshiba.co.jp>
	<Pine.LNX.4.64.0702021158250.3560@blackhole.kfki.hu>
	<200702091522.35894.nakam@linux-ipv6.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Cc: rdenis@simphalempin.com, usagi-core@linux-ipv6.org,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200702091522.35894.nakam@linux-ipv6.org>
Content-Disposition: inline
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

Hi,

> > > >> > > What happens if a node (including a non-Linux one) receives a =
MH packet
> > > >> > > with a non-none next protocol? I might be wrong, but I would a=
ssume it
> > > >> > > parses it, at least in some cases.
> > >
> > > The node will send ICMP parameter problem back with code depending on
> > > whether the node supports MH or not.
> > > If it supports, the code is 0 (erroneous header field) as RFC3775.
> > > Otherwise, the code 1 (unrecognized Next Header).
> > >
> > >
> > > >> > > If this is trye, this patch might introduce a trivial way to e=
vade
> > > >> > > firewall rules, as firewall admins will assume the next protoc=
ol is
> > > >> > > none, while it might not be.
> > > >> > >
> > > >> > > Of course, I could be plain wrong, since I do not know MH.
> > >
> > > If the sender creates MH with nexthdr=3DTCP for example,
> > > it may go through the firewall which is configured even MH=3DACCEPT
> > > TCP=3DDROP. However, the receiver cannot handle it as TCP.
> > >
> > > Can I add nexthdr check, or should I rewrite it as "-m" module
> > > to treat MH as an extension header?
> >=20
> > Personally, I'd prefer a check in the MH match that makes sure there is=
 no=20
> > more header, simply because we cannot assume that the sender keeps the=
=20
> > rules.
>=20
> Thanks for your comment.
> OK, I'll write additional patch to check no more header.
>=20

Please find my patch (can be applied for net-2.6 tree) below.

Thanks,

=2D-=20
Masahide NAKAMURA


=46rom 457af7826fc1f3ae7e0c7b554b61a002e702a4cb Mon Sep 17 00:00:00 2001
=46rom: Masahide NAKAMURA <nakam@linux-ipv6.org>
Date: Sat, 10 Feb 2007 14:46:05 +0900
Subject: [PATCH] [NETFILTER]: ip6_tables: Drop piggyback payload packet on =
MH.

Regarding RFC3775, MH payload proto field should be IPPROTO_NONE. Otherwise
it must be discarded (and the receiver should send ICMP error).

We assume filter should drop such piggyback everytime to disallow slipping =
through
firewall rules, even the final receiver will discard it.

Signed-off-by: Masahide NAKAMURA <nakam@linux-ipv6.org>
=2D--
 net/ipv6/netfilter/ip6t_mh.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_mh.c b/net/ipv6/netfilter/ip6t_mh.c
index 2c7efc6..c2a9098 100644
=2D-- a/net/ipv6/netfilter/ip6t_mh.c
+++ b/net/ipv6/netfilter/ip6t_mh.c
@@ -66,6 +66,13 @@ match(const struct sk_buff *skb,
 		return 0;
 	}
=20
+	if (mh->ip6mh_proto !=3D IPPROTO_NONE) {
+		duprintf("Dropping invalid MH Payload Proto: %u\n",
+			 mh->ip6mh_proto);
+		*hotdrop =3D 1;
+		return 0;
+	}
+
 	return type_match(mhinfo->types[0], mhinfo->types[1], mh->ip6mh_type,
 			  !!(mhinfo->invflags & IP6T_MH_INV_TYPE));
 }
=2D-=20
1.4.2
