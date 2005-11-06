From: Harald Welte <laforge@netfilter.org>
Subject: OSF: netlink related changes
Date: Sun, 6 Nov 2005 21:18:59 +0100
Message-ID: <20051106201859.GD26843@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/3yNEOqWowh/8j+e"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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


--/3yNEOqWowh/8j+e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

It seems like filtering for KOI8-R actually _does_ cause some problems,
since Evgeniy is now unable to send mails to our lists :(


Date: Sun, 6 Nov 2005 22:14:44 +0300
=46rom: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: netfilter-devel@lists.netfilter.org
Cc: PatriK McHardy <kaber@trash.net>, Harald Welte <laforge@netfilter.org>
Subject: [1/1] OSF: netlink related changes.
Message-ID: <20051106191444.GA30006@2ka.mipt.ru>

Hello, developers.
Due to new interface and changed API in netlink area
several patch-o-matic modules can not be compiled.
Passive OS fingerprinting OSF modules is one of them.=20
Consider for inclusion.
Thank you.

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

--- trunk/patch-o-matic-ng/patchlets/osf/linux-2.6/net/ipv4/netfilter/ipt_o=
sf.c      2005-11-05 12:35:02.000000000 -0500
+++ trunk/patch-o-matic-ng/patchlets/osf/linux-2.6/net/ipv4/netfilter/ipt_o=
sf.c       2005-11-05 12:43:54.000000000 -0500
@@ -30,6 +30,7 @@

 #include <linux/config.h>
 #include <linux/kernel.h>
+#include <linux/version.h>
 #include <linux/types.h>
 #include <linux/string.h>
 #include <linux/smp.h>
@@ -155,7 +156,11 @@
 	memcpy(&data->ip, sk->nh.iph, sizeof(struct iphdr));
 	memcpy(&data->tcp, (struct tcphdr *)((u_int32_t *)sk->nh.iph + sk->nh.iph=
->ihl), sizeof(struct tcphdr));

+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,14)
 	NETLINK_CB(skb).dst_groups =3D ipt_osf_groups;
+#else
+	NETLINK_CB(skb).dst_group =3D ipt_osf_groups;
+#endif
 	netlink_broadcast(nts, skb, 0, ipt_osf_groups, GFP_ATOMIC);

 nlmsg_failure:
@@ -821,7 +826,11 @@
 	p->write_proc->osf_proc_write;
 	p->read_proc->osf_proc_read;

+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,14)
 	nts->netlink_kernel_create(NETLINK_NFLOG, NULL);
+#else
+	nts->netlink_kernel_create(NETLINK_NFLOG, 1, NULL, THIS_MODULE);
+#endif
 	if (!nts) {
 		log("netlink_kernel_create() failed\n");
 	}


--=20
	Evgeniy Polyakov


--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--/3yNEOqWowh/8j+e
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDbmUzXaXGVTD0i/8RAunjAJ490I7x0HE3zR43qwl7HOYYz9UjqwCgkXBn
y6HyfWkaLdgwSRm9JNk+XjU=
=DRWp
-----END PGP SIGNATURE-----

--/3yNEOqWowh/8j+e--
