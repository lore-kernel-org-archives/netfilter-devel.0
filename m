From: Neutron Soutmun <neo.neutron@gmail.com>
Subject: [PATCH] ipset: Backports for the nla_put_net64() API changes
Date: Thu, 23 Jun 2016 17:22:11 +0700
Message-ID: <20160623102211.GA31272@hydrogen>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34614 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbcFWKWR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jun 2016 06:22:17 -0400
Received: by mail-pf0-f195.google.com with SMTP id 66so6472098pfy.1
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 03:22:16 -0700 (PDT)
Received: from hydrogen (ppp-58-8-31-246.revip2.asianet.co.th. [58.8.31.246])
        by smtp.gmail.com with ESMTPSA id ez6sm6295959pab.12.2016.06.23.03.22.14
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Thu, 23 Jun 2016 03:22:15 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Backports the patch "libnl: nla_put_net64():align on a 64-bit area" [1]
  by Nicolas Dichtel <nicolas.dichtel@6wind.com>

* Since the nla_put_net64() API has been changed, therefore, the
  ip_set_compat.h.in should provides the macro IPSET_NLA_PUT_NET64 that
  point to the nla_put_net64() with appropriate number of arguments.

  The build script should distinguish the API changes by detect for
  the existence of nla_put_64bit() function in include/net/netlink.h.
  This function was added in the same patches set and called by
  the nla_put_be64() that called by nla_put_net64() respectively.

[1] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit?=
id=3De9bbe898cbe89b17ad3993c136aa13d0431cd537

Signed-off-by: Neutron Soutmun <neo.neutron@gmail.com>
---
 configure.ac                                            | 10 ++++++++++
 kernel/include/linux/netfilter/ipset/ip_set_compat.h.in |  7 +++++++
 kernel/include/linux/netfilter/ipset/ip_set_counter.h   | 10 ++++++----
 kernel/include/linux/netfilter/ipset/ip_set_skbinfo.h   |  7 ++++---
 kernel/include/uapi/linux/netfilter/ipset/ip_set.h      |  1 +
 5 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/configure.ac b/configure.ac
index 7156ab8..b73b3cc 100644
--- a/configure.ac
+++ b/configure.ac
@@ -250,6 +250,16 @@ else
 	AC_SUBST(HAVE_NLA_PUT_BE64, undef)
 fi
=20
+AC_MSG_CHECKING([kernel source for nla_put_64bit])
+if test -f $ksourcedir/include/net/netlink.h && \
+   $GREP -q 'nla_put_64bit' $ksourcedir/include/net/netlink.h; then
+	AC_MSG_RESULT(yes)
+	AC_SUBST(HAVE_NLA_PUT_64BIT, define)
+else
+	AC_MSG_RESULT(no)
+	AC_SUBST(HAVE_NLA_PUT_64BIT, undef)
+fi
+
 AC_MSG_CHECKING([kernel source for portid in nl_info])
 if test -f $ksourcedir/include/linux/netlink.h && \
    $AWK '/^struct netlink_skb_parms/ {for(i=3D1; i<=3D5; i++) {getline; pr=
int}}' $ksourcedir/include/linux/netlink.h | $GREP -q 'portid;'; then
diff --git a/kernel/include/linux/netfilter/ipset/ip_set_compat.h.in b/kern=
el/include/linux/netfilter/ipset/ip_set_compat.h.in
index 15d0763..fe24255 100644
--- a/kernel/include/linux/netfilter/ipset/ip_set_compat.h.in
+++ b/kernel/include/linux/netfilter/ipset/ip_set_compat.h.in
@@ -10,6 +10,7 @@
 #@HAVE_ETHER_ADDR_EQUAL@ HAVE_ETHER_ADDR_EQUAL
 #@HAVE_NLA_PUT_BE16@ HAVE_NLA_PUT_BE16
 #@HAVE_NLA_PUT_BE64@ HAVE_NLA_PUT_BE64
+#@HAVE_NLA_PUT_64BIT@ HAVE_NLA_PUT_64BIT
 #@HAVE_NL_INFO_PORTID@ HAVE_NL_INFO_PORTID
 #define HAVE_NETLINK_DUMP_START_ARGS	@HAVE_NETLINK_DUMP_START_ARGS@
 #@HAVE_NS_CAPABLE@ HAVE_NS_CAPABLE
@@ -160,6 +161,12 @@ static inline int nla_put_net64(struct sk_buff *skb, i=
nt attrtype, __be64 value)
 }
 #endif
=20
+#ifdef HAVE_NLA_PUT_64BIT
+#define IPSET_NLA_PUT_NET64(skb, t, v, pa) nla_put_be64(skb, t, v, pa)
+#else
+#define IPSET_NLA_PUT_NET64(skb, t, v, pa) nla_put_be64(skb, t, v)
+#endif
+
 #ifdef HAVE_NL_INFO_PORTID
 #define NETLINK_PORTID(skb)	NETLINK_CB(skb).portid
 #else
diff --git a/kernel/include/linux/netfilter/ipset/ip_set_counter.h b/kernel=
/include/linux/netfilter/ipset/ip_set_counter.h
index d61e0e5..f2f1e8f 100644
--- a/kernel/include/linux/netfilter/ipset/ip_set_counter.h
+++ b/kernel/include/linux/netfilter/ipset/ip_set_counter.h
@@ -53,10 +53,12 @@ ip_set_update_counter(struct ip_set_counter *counter,
 static inline bool
 ip_set_put_counter(struct sk_buff *skb, const struct ip_set_counter *count=
er)
 {
-	return nla_put_net64(skb, IPSET_ATTR_BYTES,
-			     cpu_to_be64(ip_set_get_bytes(counter))) ||
-	       nla_put_net64(skb, IPSET_ATTR_PACKETS,
-			     cpu_to_be64(ip_set_get_packets(counter)));
+	return IPSET_NLA_PUT_NET64(skb, IPSET_ATTR_BYTES,
+				   cpu_to_be64(ip_set_get_bytes(counter)),
+				   IPSET_ATTR_PAD) ||
+	       IPSET_NLA_PUT_NET64(skb, IPSET_ATTR_PACKETS,
+				   cpu_to_be64(ip_set_get_packets(counter)),
+				   IPSET_ATTR_PAD);
 }
=20
 static inline void
diff --git a/kernel/include/linux/netfilter/ipset/ip_set_skbinfo.h b/kernel=
/include/linux/netfilter/ipset/ip_set_skbinfo.h
index b03dd6a..c6df3a1 100644
--- a/kernel/include/linux/netfilter/ipset/ip_set_skbinfo.h
+++ b/kernel/include/linux/netfilter/ipset/ip_set_skbinfo.h
@@ -23,9 +23,10 @@ ip_set_put_skbinfo(struct sk_buff *skb, const struct ip_=
set_skbinfo *skbinfo)
 {
 	/* Send nonzero parameters only */
 	return ((skbinfo->skbmark || skbinfo->skbmarkmask) &&
-		nla_put_net64(skb, IPSET_ATTR_SKBMARK,
-			      cpu_to_be64((u64)skbinfo->skbmark << 32 |
-					  skbinfo->skbmarkmask))) ||
+		IPSET_NLA_PUT_NET64(skb, IPSET_ATTR_SKBMARK,
+				    cpu_to_be64((u64)skbinfo->skbmark << 32 |
+						skbinfo->skbmarkmask),
+				    IPSET_ATTR_PAD)) ||
 	       (skbinfo->skbprio &&
 		nla_put_net32(skb, IPSET_ATTR_SKBPRIO,
 			      cpu_to_be32(skbinfo->skbprio))) ||
diff --git a/kernel/include/uapi/linux/netfilter/ipset/ip_set.h b/kernel/in=
clude/uapi/linux/netfilter/ipset/ip_set.h
index def91b9..4a6776f 100644
--- a/kernel/include/uapi/linux/netfilter/ipset/ip_set.h
+++ b/kernel/include/uapi/linux/netfilter/ipset/ip_set.h
@@ -118,6 +118,7 @@ enum {
 	IPSET_ATTR_SKBMARK,
 	IPSET_ATTR_SKBPRIO,
 	IPSET_ATTR_SKBQUEUE,
+	IPSET_ATTR_PAD,
 	__IPSET_ATTR_ADT_MAX,
 };
 #define IPSET_ATTR_ADT_MAX	(__IPSET_ATTR_ADT_MAX - 1)
--=20
2.8.1


--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCAAGBQJXa7hTAAoJEJ0EcL2mzcRXz/QQALM4QLdwKPkkocJqS35NEQ4H
9EWhh3Acv7JCIz5w8yeL3Uw1uhnc7x0OmutdafIXi6Eegz+fMOw/J5RGYGhhWvYk
0jDyl7herMN8gB+Dhbn9jwT67u3PasgHvRoOv0E9bo/8MNNbHkIqpipdd+CiTASQ
ga9GA+adrzwq+KMUYcm6C3T6KlQT4flCRXL+zVdBtwsN3oUqtcmMfdXgCiRmtMqI
4cILSNCLRp8MeOJzs6+joihfVjNFV/f377wlwUXnifokt73aN3omZSf4KD8RPF1z
749aD4h0cY+e3FUA6MiS4B9l4NaocIsT3pM9zHj5eN+5zFc6vahuL/HWJsiZXBN8
Mxo5qWQ5+YqBnoFyF1fa77SSHfbVtvzCIdPkxuh3yfrX7PSl6NcxNfa/CdTtXtMg
nx6D1E4PL4gzGPplQyX7KWg4J/6wPi0tVEe9iZU9f1yDsmsCkbDGl6CNkHpRlUGS
lNWpdmMyPeVZ4NIeOCAo4MbVEi0Fpqn3eYNaL7gVALwk5BicFouEnrcqMSRzGvmg
OYw2sPIM+VzYMAzZgsauKjROawyhRufEqbx0FttfMSBSnM3uOI1FyYGjyGloqJoR
OtVY09NGKskYiiD6J0u3vsN0vrQkAF4H3XjYMoujzVzn9jSejxa1m2JOathJjG7m
vHNTYq7dAcqDlTQ5Blrk
=j0px
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
