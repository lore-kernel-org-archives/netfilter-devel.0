From: Kurt Garloff <garloff@suse.de>
Subject: [PATCH] Unaligend accesses nulldevname
Date: Thu, 8 Jan 2004 00:00:11 +0100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20040107230011.GG23133@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tctmm6wHVGT/P6vA"
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: Linux kernel list <linux-kernel@vger.kernel.org>,
	netfilter-devel@lists.netfilter.org
Content-Disposition: inline
List-Id: netfilter-devel.vger.kernel.org


--tctmm6wHVGT/P6vA
Content-Type: multipart/mixed; boundary="CEUtFxTsmBsHRLs3"
Content-Disposition: inline


--CEUtFxTsmBsHRLs3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I found an excessive amount of unaligned accesses on my AXP workstation
and tracked it down to ip_packet_match() in the ip_tables module.
indev and outdev are not properly aligned if set to nulldevname in
ipt_do_table().
This destroys the benefits of comparing names in units of (long) and
on architectures with expensive unaligned accesses (such as ia64 or
alpha), it even hurts a lot.

Find attached a patch against 2.6.0. A similar patch is needed for 2.4,
also attached.

Please consider merging them.

Looking at ip_packet_match(), I have two more thoughts:
* It should not be inlined. It's too large to benefit from inlining,
  IMHO. (OTOH, it's only called from one place, so it does not
  really matter.)
* There's a comment about the compiler being able to unroll the 2/4
  (64/32bit) iter loop which is not completely appropriate: We don't
  pass -funroll-loops, so gcc does not do it :-(
  It would be beneficial though.

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--CEUtFxTsmBsHRLs3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="iptables-nulldevname-unaligned26.diff"

--- linux-2.6.0.ix86/net/ipv4/netfilter/ip_tables.c.orig	2003-12-18 03:58:28.000000000 +0100
+++ linux-2.6.0.ix86/net/ipv4/netfilter/ip_tables.c	2004-01-07 23:49:29.000000000 +0100
@@ -260,7 +260,7 @@
 	     struct ipt_table *table,
 	     void *userdata)
 {
-	static const char nulldevname[IFNAMSIZ];
+	static const char nulldevname[IFNAMSIZ] __attribute__((aligned(sizeof(long))));
 	u_int16_t offset;
 	struct iphdr *ip;
 	u_int16_t datalen;

--CEUtFxTsmBsHRLs3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="iptables-nulldevname-unaligned24.diff"

--- linux-2.4.19/net/ipv4/netfilter/ip_tables.c	2002-02-25 20:38:14.000000000 +0100
+++ linux-2.4.19.AXP/net/ipv4/netfilter/ip_tables.c	2004-01-09 01:55:01.000000000 +0100
@@ -259,7 +264,7 @@
 	     struct ipt_table *table,
 	     void *userdata)
 {
-	static const char nulldevname[IFNAMSIZ] = { 0 };
+	static const char nulldevname[IFNAMSIZ] __attribute__((aligned(sizeof(long)))) = { 0 };
 	u_int16_t offset;
 	struct iphdr *ip;
 	void *protohdr;

--CEUtFxTsmBsHRLs3--

--tctmm6wHVGT/P6vA
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE//I96xmLh6hyYd04RAlpzAJ9G3v+AfXv7fo7WukJt+lX9ogguOQCeIY5a
tbb6eUsHezqUrmAOCuhWKGc=
=/bAN
-----END PGP SIGNATURE-----

--tctmm6wHVGT/P6vA--
