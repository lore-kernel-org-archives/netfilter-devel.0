From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH] new ip6tables matches
Date: Thu, 27 Feb 2003 13:05:54 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030227120554.GC22249@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uh9ZiVrAOUUm9fzH"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: David Miller <davem@redhat.com>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--uh9ZiVrAOUUm9fzH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

The following patch adds a couple of new ip6tables modules; all
wholefile patches:

- hoplimit match (ipv6 hoplimit match, like the ipv4 ttl match)
- ahesp match (ipv6 AH/ESP match, like the ipv4 version)
- frag6 match (ipv6 fragmentation header)
- ipv6header match (ipv6 extension header)
- hbh match (ipv6 hop-by-hop extension header)
- dst match (ipv6 destiation options header)

Please apply (2.4.x and 2.5.x):


diff -Nru --exclude .depend --exclude *.o --exclude *.ver --exclude .*.flag=
s --exclude *.orig --exclude *.rej --exclude *~ linuxppc-270203-nfsubmit/in=
clude/linux/netfilter_ipv6/ip6t_ah.h linuxppc-270203-davem/include/linux/ne=
tfilter_ipv6/ip6t_ah.h
--- linuxppc-270203-nfsubmit/include/linux/netfilter_ipv6/ip6t_ah.h	Thu Jan=
  1 01:00:00 1970
+++ linuxppc-270203-davem/include/linux/netfilter_ipv6/ip6t_ah.h	Thu Feb 27=
 12:25:32 2003
@@ -0,0 +1,30 @@
+#ifndef _IP6T_AH_H
+#define _IP6T_AH_H
+
+struct ip6t_ah
+{
+	u_int32_t spis[2];			/* Security Parameter Index */
+	u_int32_t hdrlen;			/* Header Length */
+	u_int8_t  hdrres;			/* Test of the Reserved Filed */
+	u_int8_t  invflags;			/* Inverse flags */
+};
+
+#define IP6T_AH_SPI 0x01
+#define IP6T_AH_LEN 0x02
+#define IP6T_AH_RES 0x04
+
+/* Values for "invflags" field in struct ip6t_ah. */
+#define IP6T_AH_INV_SPI		0x01	/* Invert the sense of spi. */
+#define IP6T_AH_INV_LEN		0x02	/* Invert the sense of length. */
+#define IP6T_AH_INV_MASK	0x03	/* All possible flags. */
+
+#define MASK_HOPOPTS    128
+#define MASK_DSTOPTS    64
+#define MASK_ROUTING    32
+#define MASK_FRAGMENT   16
+#define MASK_AH         8
+#define MASK_ESP        4
+#define MASK_NONE       2
+#define MASK_PROTO      1
+
+#endif /*_IP6T_AH_H*/
diff -Nru --exclude .depend --exclude *.o --exclude *.ver --exclude .*.flag=
s --exclude *.orig --exclude *.rej --exclude *~ linuxppc-270203-nfsubmit/in=
clude/linux/netfilter_ipv6/ip6t_esp.h linuxppc-270203-davem/include/linux/n=
etfilter_ipv6/ip6t_esp.h
--- linuxppc-270203-nfsubmit/include/linux/netfilter_ipv6/ip6t_esp.h	Thu Ja=
n  1 01:00:00 1970
+++ linuxppc-270203-davem/include/linux/netfilter_ipv6/ip6t_esp.h	Thu Feb 2=
7 12:25:32 2003
@@ -0,0 +1,23 @@
+#ifndef _IP6T_ESP_H
+#define _IP6T_ESP_H
+
+struct ip6t_esp
+{
+	u_int32_t spis[2];			/* Security Parameter Index */
+	u_int8_t  invflags;			/* Inverse flags */
+};
+
+#define MASK_HOPOPTS    128
+#define MASK_DSTOPTS    64
+#define MASK_ROUTING    32
+#define MASK_FRAGMENT   16
+#define MASK_AH         8
+#define MASK_ESP        4
+#define MASK_NONE       2
+#define MASK_PROTO      1
+
+/* Values for "invflags" field in struct ip6t_esp. */
+#define IP6T_ESP_INV_SPI		0x01	/* Invert the sense of spi. */
+#define IP6T_ESP_INV_MASK	0x01	/* All possible flags. */
+
+#endif /*_IP6T_ESP_H*/
diff -Nru --exclude .depend --exclude *.o --exclude *.ver --exclude .*.flag=
s --exclude *.orig --exclude *.rej --exclude *~ linuxppc-270203-nfsubmit/in=
clude/linux/netfilter_ipv6/ip6t_frag.h linuxppc-270203-davem/include/linux/=
netfilter_ipv6/ip6t_frag.h
--- linuxppc-270203-nfsubmit/include/linux/netfilter_ipv6/ip6t_frag.h	Thu J=
an  1 01:00:00 1970
+++ linuxppc-270203-davem/include/linux/netfilter_ipv6/ip6t_frag.h	Thu Feb =
27 12:25:35 2003
@@ -0,0 +1,33 @@
+#ifndef _IP6T_FRAG_H
+#define _IP6T_FRAG_H
+
+struct ip6t_frag
+{
+	u_int32_t ids[2];			/* Security Parameter Index */
+	u_int32_t hdrlen;			/* Header Length */
+	u_int8_t  flags;			/*  */
+	u_int8_t  invflags;			/* Inverse flags */
+};
+
+#define IP6T_FRAG_IDS 		0x01
+#define IP6T_FRAG_LEN 		0x02
+#define IP6T_FRAG_RES 		0x04
+#define IP6T_FRAG_FST 		0x08
+#define IP6T_FRAG_MF  		0x10
+#define IP6T_FRAG_NMF  		0x20
+
+/* Values for "invflags" field in struct ip6t_frag. */
+#define IP6T_FRAG_INV_IDS	0x01	/* Invert the sense of ids. */
+#define IP6T_FRAG_INV_LEN	0x02	/* Invert the sense of length. */
+#define IP6T_FRAG_INV_MASK	0x03	/* All possible flags. */
+
+#define MASK_HOPOPTS    128
+#define MASK_DSTOPTS    64
+#define MASK_ROUTING    32
+#define MASK_FRAGMENT   16
+#define MASK_AH         8
+#define MASK_ESP        4
+#define MASK_NONE       2
+#define MASK_PROTO      1
+
+#endif /*_IP6T_FRAG_H*/
diff -Nru --exclude .depend --exclude *.o --exclude *.ver --exclude .*.flag=
s --exclude *.orig --exclude *.rej --exclude *~ linuxppc-270203-nfsubmit/in=
clude/linux/netfilter_ipv6/ip6t_hl.h linuxppc-270203-davem/include/linux/ne=
tfilter_ipv6/ip6t_hl.h
--- linuxppc-270203-nfsubmit/include/linux/netfilter_ipv6/ip6t_hl.h	Thu Jan=
  1 01:00:00 1970
+++ linuxppc-270203-davem/include/linux/netfilter_ipv6/ip6t_hl.h	Thu Feb 27=
 12:25:28 2003
@@ -0,0 +1,22 @@
+/* ip6tables module for matching the Hop Limit value
+ * Maciej Soltysiak <solt@dns.toxicfilms.tv>
+ * Based on HW's ttl module */
+
+#ifndef _IP6T_HL_H
+#define _IP6T_HL_H
+
+enum {
+	IP6T_HL_EQ =3D 0,		/* equals */
+	IP6T_HL_NE,		/* not equals */
+	IP6T_HL_LT,		/* less than */
+	IP6T_HL_GT,		/* greater than */
+};
+
+
+struct ip6t_hl_info {
+	u_int8_t	mode;
+	u_int8_t	hop_limit;
+};
+
+
+#endif
diff -Nru --exclude .depend --exclude *.o --exclude *.ver --exclude .*.flag=
s --exclude *.orig --exclude *.rej --exclude *~ linuxppc-270203-nfsubmit/in=
clude/linux/netfilter_ipv6/ip6t_ipv6header.h linuxppc-270203-davem/include/=
linux/netfilter_ipv6/ip6t_ipv6header.h
--- linuxppc-270203-nfsubmit/include/linux/netfilter_ipv6/ip6t_ipv6header.h=
	Thu Jan  1 01:00:00 1970
+++ linuxppc-270203-davem/include/linux/netfilter_ipv6/ip6t_ipv6header.h	Th=
u Feb 27 12:25:39 2003
@@ -0,0 +1,27 @@
+/* ipv6header match - matches IPv6 packets based
+on whether they contain certain headers */
+
+/* Original idea: Brad Chapman=20
+ * Rewritten by: Andras Kis-Szabo <kisza@sch.bme.hu> */
+
+
+#ifndef __IPV6HEADER_H
+#define __IPV6HEADER_H
+
+struct ip6t_ipv6header_info
+{
+	u_int8_t matchflags;
+	u_int8_t invflags;
+	u_int8_t modeflag;
+};
+
+#define MASK_HOPOPTS    128
+#define MASK_DSTOPTS    64
+#define MASK_ROUTING    32
+#define MASK_FRAGMENT   16
+#define MASK_AH         8
+#define MASK_ESP        4
+#define MASK_NONE       2
+#define MASK_PROTO      1
+
+#endif /* __IPV6HEADER_H */
diff -Nru --exclude .depend --exclude *.o --exclude *.ver --exclude .*.flag=
s --exclude *.orig --exclude *.rej --exclude *~ linuxppc-270203-nfsubmit/in=
clude/linux/netfilter_ipv6/ip6t_opts.h linuxppc-270203-davem/include/linux/=
netfilter_ipv6/ip6t_opts.h
--- linuxppc-270203-nfsubmit/include/linux/netfilter_ipv6/ip6t_opts.h	Thu J=
an  1 01:00:00 1970
+++ linuxppc-270203-davem/include/linux/netfilter_ipv6/ip6t_opts.h	Thu Feb =
27 12:25:43 2003
@@ -0,0 +1,32 @@
+#ifndef _IP6T_OPTS_H
+#define _IP6T_OPTS_H
+
+#define IP6T_OPTS_OPTSNR 16
+
+struct ip6t_opts
+{
+	u_int32_t hdrlen;			/* Header Length */
+	u_int8_t flags;				/*  */
+	u_int8_t invflags;			/* Inverse flags */
+	u_int16_t opts[IP6T_OPTS_OPTSNR];	/* opts */
+	u_int8_t optsnr;			/* Nr of OPts */
+};
+
+#define IP6T_OPTS_LEN 		0x01
+#define IP6T_OPTS_OPTS 		0x02
+#define IP6T_OPTS_NSTRICT	0x04
+
+/* Values for "invflags" field in struct ip6t_rt. */
+#define IP6T_OPTS_INV_LEN	0x01	/* Invert the sense of length. */
+#define IP6T_OPTS_INV_MASK	0x01	/* All possible flags. */
+
+#define MASK_HOPOPTS    128
+#define MASK_DSTOPTS    64
+#define MASK_ROUTING    32
+#define MASK_FRAGMENT   16
+#define MASK_AH         8
+#define MASK_ESP        4
+#define MASK_NONE       2
+#define MASK_PROTO      1
+
+#endif /*_IP6T_OPTS_H*/
diff -Nru --exclude .depend --exclude *.o --exclude *.ver --exclude .*.flag=
s --exclude *.orig --exclude *.rej --exclude *~ linuxppc-270203-nfsubmit/in=
clude/linux/netfilter_ipv6/ip6t_rt.h linuxppc-270203-davem/include/linux/ne=
tfilter_ipv6/ip6t_rt.h
--- linuxppc-270203-nfsubmit/include/linux/netfilter_ipv6/ip6t_rt.h	Thu Jan=
  1 01:00:00 1970
+++ linuxppc-270203-davem/include/linux/netfilter_ipv6/ip6t_rt.h	Thu Feb 27=
 12:25:49 2003
@@ -0,0 +1,42 @@
+#ifndef _IP6T_RT_H
+#define _IP6T_RT_H
+
+/*#include <linux/in6.h>*/
+
+#define IP6T_RT_HOPS 16
+
+struct ip6t_rt
+{
+	u_int32_t rt_type;			/* Routing Type */
+	u_int32_t segsleft[2];			/* Segments Left */
+	u_int32_t hdrlen;			/* Header Length */
+	u_int8_t  flags;			/*  */
+	u_int8_t  invflags;			/* Inverse flags */
+	struct in6_addr addrs[IP6T_RT_HOPS];	/* Hops */
+	u_int8_t addrnr;			/* Nr of Addresses */
+};
+
+#define IP6T_RT_TYP 		0x01
+#define IP6T_RT_SGS 		0x02
+#define IP6T_RT_LEN 		0x04
+#define IP6T_RT_RES 		0x08
+#define IP6T_RT_FST_MASK	0x30
+#define IP6T_RT_FST 		0x10
+#define IP6T_RT_FST_NSTRICT	0x20
+
+/* Values for "invflags" field in struct ip6t_rt. */
+#define IP6T_RT_INV_TYP		0x01	/* Invert the sense of type. */
+#define IP6T_RT_INV_SGS		0x02	/* Invert the sense of Segments. */
+#define IP6T_RT_INV_LEN		0x04	/* Invert the sense of length. */
+#define IP6T_RT_INV_MASK	0x07	/* All possible flags. */
+
+#define MASK_HOPOPTS    128
+#define MASK_DSTOPTS    64
+#define MASK_ROUTING    32
+#define MASK_FRAGMENT   16
+#define MASK_AH         8
+#define MASK_ESP        4
+#define MASK_NONE       2
+#define MASK_PROTO      1
+
+#endif /*_IP6T_RT_H*/
diff -Nru --exclude .depend --exclude *.o --exclude *.ver --exclude .*.flag=
s --exclude *.orig --exclude *.rej --exclude *~ linuxppc-270203-nfsubmit/ne=
t/ipv6/netfilter/Config.in linuxppc-270203-davem/net/ipv6/netfilter/Config.=
in
--- linuxppc-270203-nfsubmit/net/ipv6/netfilter/Config.in	Tue Feb 25 00:10:=
18 2003
+++ linuxppc-270203-davem/net/ipv6/netfilter/Config.in	Thu Feb 27 13:08:10 =
2003
@@ -18,12 +18,28 @@
 # The simple matches.
   dep_tristate '  limit match support' CONFIG_IP6_NF_MATCH_LIMIT $CONFIG_I=
P6_NF_IPTABLES
   dep_tristate '  MAC address match support' CONFIG_IP6_NF_MATCH_MAC $CONF=
IG_IP6_NF_IPTABLES
+  if [ "$CONFIG_EXPERIMENTAL" =3D "y" ]; then
+    dep_tristate '  Routing header match support (EXPERIMENTAL)' CONFIG_IP=
6_NF_MATCH_RT $CONFIG_IP6_NF_IPTABLES
+  fi
+  if [ "$CONFIG_EXPERIMENTAL" =3D "y" ]; then
+    dep_tristate '  Hop-by-Hop and Dst opts header match (EXPERIMENTAL)' C=
ONFIG_IP6_NF_MATCH_OPTS $CONFIG_IP6_NF_IPTABLES
+  fi
+  if [ "$CONFIG_EXPERIMENTAL" =3D "y" ]; then
+    dep_tristate '  Fragmentation header match support (EXPERIMENTAL)' CON=
FIG_IP6_NF_MATCH_FRAG $CONFIG_IP6_NF_IPTABLES
+  fi
+  dep_tristate '  HL match support' CONFIG_IP6_NF_MATCH_HL $CONFIG_IP6_NF_=
IPTABLES
   dep_tristate '  Multiple port match support' CONFIG_IP6_NF_MATCH_MULTIPO=
RT $CONFIG_IP6_NF_IPTABLES
   if [ "$CONFIG_EXPERIMENTAL" =3D "y" ]; then
     dep_tristate '  Owner match support (EXPERIMENTAL)' CONFIG_IP6_NF_MATC=
H_OWNER $CONFIG_IP6_NF_IPTABLES
   fi
 #  dep_tristate '  MAC address match support' CONFIG_IP6_NF_MATCH_MAC $CON=
FIG_IP6_NF_IPTABLES
   dep_tristate '  netfilter MARK match support' CONFIG_IP6_NF_MATCH_MARK $=
CONFIG_IP6_NF_IPTABLES
+  if [ "$CONFIG_EXPERIMENTAL" =3D "y" ]; then
+    dep_tristate '  IPv6 Extension Headers Match (EXPERIMENTAL)' CONFIG_IP=
6_NF_MATCH_IPV6HEADER $CONFIG_IP6_NF_IPTABLES
+  fi
+  if [ "$CONFIG_EXPERIMENTAL" =3D "y" ]; then
+    dep_tristate '  AH/ESP match support (EXPERIMENTAL)' CONFIG_IP6_NF_MAT=
CH_AHESP $CONFIG_IP6_NF_IPTABLES
+  fi
   dep_tristate '  Packet Length match support' CONFIG_IP6_NF_MATCH_LENGTH =
$CONFIG_IP6_NF_IPTABLES
   if [ "$CONFIG_EXPERIMENTAL" =3D "y" ]; then
     dep_tristate '  EUI64 address check (EXPERIMENTAL)' CONFIG_IP6_NF_MATC=
H_EUI64 $CONFIG_IP6_NF_IPTABLES
diff -Nru --exclude .depend --exclude *.o --exclude *.ver --exclude .*.flag=
s --exclude *.orig --exclude *.rej --exclude *~ linuxppc-270203-nfsubmit/ne=
t/ipv6/netfilter/Makefile linuxppc-270203-davem/net/ipv6/netfilter/Makefile
--- linuxppc-270203-nfsubmit/net/ipv6/netfilter/Makefile	Tue Feb 25 00:10:5=
0 2003
+++ linuxppc-270203-davem/net/ipv6/netfilter/Makefile	Thu Feb 27 13:08:11 2=
003
@@ -17,6 +17,11 @@
 obj-$(CONFIG_IP6_NF_MATCH_MARK) +=3D ip6t_mark.o
 obj-$(CONFIG_IP6_NF_MATCH_LENGTH) +=3D ip6t_length.o
 obj-$(CONFIG_IP6_NF_MATCH_MAC) +=3D ip6t_mac.o
+obj-$(CONFIG_IP6_NF_MATCH_RT) +=3D ip6t_rt.o
+obj-$(CONFIG_IP6_NF_MATCH_OPTS) +=3D ip6t_hbh.o ip6t_dst.o
+obj-$(CONFIG_IP6_NF_MATCH_IPV6HEADER) +=3D ip6t_ipv6header.o
+obj-$(CONFIG_IP6_NF_MATCH_FRAG) +=3D ip6t_frag.o
+obj-$(CONFIG_IP6_NF_MATCH_AHESP) +=3D ip6t_esp.o ip6t_ah.o
 obj-$(CONFIG_IP6_NF_MATCH_EUI64) +=3D ip6t_eui64.o
 obj-$(CONFIG_IP6_NF_MATCH_MULTIPORT) +=3D ip6t_multiport.o
 obj-$(CONFIG_IP6_NF_MATCH_OWNER) +=3D ip6t_owner.o
@@ -25,5 +30,6 @@
 obj-$(CONFIG_IP6_NF_TARGET_MARK) +=3D ip6t_MARK.o
 obj-$(CONFIG_IP6_NF_QUEUE) +=3D ip6_queue.o
 obj-$(CONFIG_IP6_NF_TARGET_LOG) +=3D ip6t_LOG.o
+obj-$(CONFIG_IP_NF_MATCH_HL) +=3D ipt_hl.o
=20
 include $(TOPDIR)/Rules.make
diff -Nru --exclude .depend --exclude *.o --exclude *.ver --exclude .*.flag=
s --exclude *.orig --exclude *.rej --exclude *~ linuxppc-270203-nfsubmit/ne=
t/ipv6/netfilter/ip6t_ah.c linuxppc-270203-davem/net/ipv6/netfilter/ip6t_ah=
.c
--- linuxppc-270203-nfsubmit/net/ipv6/netfilter/ip6t_ah.c	Thu Jan  1 01:00:=
00 1970
+++ linuxppc-270203-davem/net/ipv6/netfilter/ip6t_ah.c	Thu Feb 27 12:25:32 =
2003
@@ -0,0 +1,218 @@
+/* Kernel module to match AH parameters. */
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/ipv6.h>
+#include <linux/types.h>
+#include <net/checksum.h>
+#include <net/ipv6.h>
+
+#include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter_ipv6/ip6t_ah.h>
+
+EXPORT_NO_SYMBOLS;
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("IPv6 AH match");
+MODULE_AUTHOR("Andras Kis-Szabo <kisza@sch.bme.hu>");
+
+#if 0
+#define DEBUGP printk
+#else
+#define DEBUGP(format, args...)
+#endif
+
+struct ahhdr {
+       __u8    nexthdr;
+       __u8    hdrlen;
+       __u16   reserved;
+       __u32   spi;
+};
+
+int ipv6_ext_hdr(u8 nexthdr)
+{
+        return ( (nexthdr =3D=3D NEXTHDR_HOP)       ||
+                 (nexthdr =3D=3D NEXTHDR_ROUTING)   ||
+                 (nexthdr =3D=3D NEXTHDR_FRAGMENT)  ||
+                 (nexthdr =3D=3D NEXTHDR_AUTH)      ||
+                 (nexthdr =3D=3D NEXTHDR_ESP)       ||
+                 (nexthdr =3D=3D NEXTHDR_NONE)      ||
+                 (nexthdr =3D=3D NEXTHDR_DEST) );
+}
+
+/* Returns 1 if the spi is matched by the range, 0 otherwise */
+static inline int
+spi_match(u_int32_t min, u_int32_t max, u_int32_t spi, int invert)
+{
+       int r=3D0;
+       DEBUGP("ah spi_match:%c 0x%x <=3D 0x%x <=3D 0x%x",invert? '!':' ',
+              min,spi,max);
+       r=3D(spi >=3D min && spi <=3D max) ^ invert;
+       DEBUGP(" result %s\n",r? "PASS\n" : "FAILED\n");
+       return r;
+}
+
+static int
+match(const struct sk_buff *skb,
+      const struct net_device *in,
+      const struct net_device *out,
+      const void *matchinfo,
+      int offset,
+      const void *protohdr,
+      u_int16_t datalen,
+      int *hotdrop)
+{
+       struct ahhdr *ah =3D NULL;
+       const struct ip6t_ah *ahinfo =3D matchinfo;
+       unsigned int temp;
+       int len;
+       u8 nexthdr;
+       unsigned int ptr;
+       unsigned int hdrlen =3D 0;
+
+       /*DEBUGP("IPv6 AH entered\n");*/
+       /* if (opt->auth =3D=3D 0) return 0;
+       * It does not filled on output */
+
+       /* type of the 1st exthdr */
+       nexthdr =3D skb->nh.ipv6h->nexthdr;
+       /* pointer to the 1st exthdr */
+       ptr =3D sizeof(struct ipv6hdr);
+       /* available length */
+       len =3D skb->len - ptr;
+       temp =3D 0;
+
+        while (ipv6_ext_hdr(nexthdr)) {
+               struct ipv6_opt_hdr *hdr;
+
+              DEBUGP("ipv6_ah header iteration \n");
+
+              /* Is there enough space for the next ext header? */
+                if (len < (int)sizeof(struct ipv6_opt_hdr))
+                        return 0;
+              /* No more exthdr -> evaluate */
+                if (nexthdr =3D=3D NEXTHDR_NONE) {
+                     break;
+              }
+              /* ESP -> evaluate */
+                if (nexthdr =3D=3D NEXTHDR_ESP) {
+                     break;
+              }
+
+              hdr=3D(struct ipv6_opt_hdr *)skb->data+ptr;
+
+              /* Calculate the header length */
+                if (nexthdr =3D=3D NEXTHDR_FRAGMENT) {
+                        hdrlen =3D 8;
+                } else if (nexthdr =3D=3D NEXTHDR_AUTH)
+                        hdrlen =3D (hdr->hdrlen+2)<<2;
+                else
+                        hdrlen =3D ipv6_optlen(hdr);
+
+              /* AH -> evaluate */
+                if (nexthdr =3D=3D NEXTHDR_AUTH) {
+                     temp |=3D MASK_AH;
+                     break;
+              }
+
+
+              /* set the flag */
+              switch (nexthdr){
+                     case NEXTHDR_HOP:
+                     case NEXTHDR_ROUTING:
+                     case NEXTHDR_FRAGMENT:
+                     case NEXTHDR_AUTH:
+                     case NEXTHDR_DEST:
+                            break;
+                     default:
+                            DEBUGP("ipv6_ah match: unknown nextheader %u\n=
",nexthdr);
+                            return 0;
+                            break;
+              }
+
+                nexthdr =3D hdr->nexthdr;
+                len -=3D hdrlen;
+                ptr +=3D hdrlen;
+		if ( ptr > skb->len ) {
+			DEBUGP("ipv6_ah: new pointer too large! \n");
+			break;
+		}
+        }
+
+       /* AH header not found */
+       if ( temp !=3D MASK_AH ) return 0;
+
+       if (len < (int)sizeof(struct ahhdr)){
+	       *hotdrop =3D 1;
+       		return 0;
+       }
+
+       ah=3Dskb->data+ptr;
+
+       DEBUGP("IPv6 AH LEN %u %u ", hdrlen, ah->hdrlen);
+       DEBUGP("RES %04X ", ah->reserved);
+       DEBUGP("SPI %u %08X\n", ntohl(ah->spi), ntohl(ah->spi));
+
+       DEBUGP("IPv6 AH spi %02X ",
+       		(spi_match(ahinfo->spis[0], ahinfo->spis[1],
+                           ntohl(ah->spi),
+                           !!(ahinfo->invflags & IP6T_AH_INV_SPI))));
+       DEBUGP("len %02X %04X %02X ",
+       		ahinfo->hdrlen, hdrlen,
+       		(!ahinfo->hdrlen ||
+                           (ahinfo->hdrlen =3D=3D hdrlen) ^
+                           !!(ahinfo->invflags & IP6T_AH_INV_LEN)));
+       DEBUGP("res %02X %04X %02X\n",=20
+       		ahinfo->hdrres, ah->reserved,
+       		!(ahinfo->hdrres && ah->reserved));
+
+       return (ah !=3D NULL)
+              &&
+              (spi_match(ahinfo->spis[0], ahinfo->spis[1],
+                           ntohl(ah->spi),
+                           !!(ahinfo->invflags & IP6T_AH_INV_SPI)))
+              &&
+              (!ahinfo->hdrlen ||
+                           (ahinfo->hdrlen =3D=3D hdrlen) ^
+                           !!(ahinfo->invflags & IP6T_AH_INV_LEN))
+              &&
+              !(ahinfo->hdrres && ah->reserved);
+}
+
+/* Called when user tries to insert an entry of this type. */
+static int
+checkentry(const char *tablename,
+          const struct ip6t_ip6 *ip,
+          void *matchinfo,
+          unsigned int matchinfosize,
+          unsigned int hook_mask)
+{
+       const struct ip6t_ah *ahinfo =3D matchinfo;
+
+       if (matchinfosize !=3D IP6T_ALIGN(sizeof(struct ip6t_ah))) {
+              DEBUGP("ip6t_ah: matchsize %u !=3D %u\n",
+                      matchinfosize, IP6T_ALIGN(sizeof(struct ip6t_ah)));
+              return 0;
+       }
+       if (ahinfo->invflags & ~IP6T_AH_INV_MASK) {
+              DEBUGP("ip6t_ah: unknown flags %X\n",
+                      ahinfo->invflags);
+              return 0;
+       }
+
+       return 1;
+}
+
+static struct ip6t_match ah_match
+=3D { { NULL, NULL }, "ah", &match, &checkentry, NULL, THIS_MODULE };
+
+static int __init init(void)
+{
+       return ip6t_register_match(&ah_match);
+}
+
+static void __exit cleanup(void)
+{
+       ip6t_unregister_match(&ah_match);
+}
+
+module_init(init);
+module_exit(cleanup);
diff -Nru --exclude .depend --exclude *.o --exclude *.ver --exclude .*.flag=
s --exclude *.orig --exclude *.rej --exclude *~ linuxppc-270203-nfsubmit/ne=
t/ipv6/netfilter/ip6t_dst.c linuxppc-270203-davem/net/ipv6/netfilter/ip6t_d=
st.c
--- linuxppc-270203-nfsubmit/net/ipv6/netfilter/ip6t_dst.c	Thu Jan  1 01:00=
:00 1970
+++ linuxppc-270203-davem/net/ipv6/netfilter/ip6t_dst.c	Thu Feb 27 12:25:43=
 2003
@@ -0,0 +1,287 @@
+/* Kernel module to match Hop-by-Hop and Destination parameters. */
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/ipv6.h>
+#include <linux/types.h>
+#include <net/checksum.h>
+#include <net/ipv6.h>
+
+#include <asm/byteorder.h>
+
+#include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter_ipv6/ip6t_opts.h>
+
+#define LOW(n)		(n & 0x00FF)
+
+#define HOPBYHOP	0
+
+EXPORT_NO_SYMBOLS;
+MODULE_LICENSE("GPL");
+#if HOPBYHOP
+MODULE_DESCRIPTION("IPv6 HbH match");
+#else
+MODULE_DESCRIPTION("IPv6 DST match");
+#endif
+MODULE_AUTHOR("Andras Kis-Szabo <kisza@sch.bme.hu>");
+
+#if 0
+#define DEBUGP printk
+#else
+#define DEBUGP(format, args...)
+#endif
+
+int ipv6_ext_hdr(u8 nexthdr)
+{
+        return ( (nexthdr =3D=3D NEXTHDR_HOP)       ||
+                 (nexthdr =3D=3D NEXTHDR_ROUTING)   ||
+                 (nexthdr =3D=3D NEXTHDR_FRAGMENT)  ||
+                 (nexthdr =3D=3D NEXTHDR_AUTH)      ||
+                 (nexthdr =3D=3D NEXTHDR_ESP)       ||
+                 (nexthdr =3D=3D NEXTHDR_NONE)      ||
+                 (nexthdr =3D=3D NEXTHDR_DEST) );
+}
+
+/*
+ * (Type & 0xC0) >> 6
+ * 	0	-> ignorable
+ * 	1	-> must drop the packet
+ * 	2	-> send ICMP PARM PROB regardless and drop packet
+ * 	3	-> Send ICMP if not a multicast address and drop packet
+ *  (Type & 0x20) >> 5
+ *  	0	-> invariant
+ *  	1	-> can change the routing
+ *  (Type & 0x1F) Type
+ *      0	-> PAD0 (only 1 byte!)
+ *      1	-> PAD1 LENGTH info (total length =3D length + 2)
+ *      C0 | 2	-> JUMBO 4 x x x x ( xxxx > 64k )
+ *      5	-> RTALERT 2 x x
+ */
+
+static int
+match(const struct sk_buff *skb,
+      const struct net_device *in,
+      const struct net_device *out,
+      const void *matchinfo,
+      int offset,
+      const void *protohdr,
+      u_int16_t datalen,
+      int *hotdrop)
+{
+       struct ipv6_opt_hdr *optsh =3D NULL;
+       const struct ip6t_opts *optinfo =3D matchinfo;
+       unsigned int temp;
+       unsigned int len;
+       u8 nexthdr;
+       unsigned int ptr;
+       unsigned int hdrlen =3D 0;
+       unsigned int ret =3D 0;
+       u_int16_t *optdesc =3D NULL;
+      =20
+       /* type of the 1st exthdr */
+       nexthdr =3D skb->nh.ipv6h->nexthdr;
+       /* pointer to the 1st exthdr */
+       ptr =3D sizeof(struct ipv6hdr);
+       /* available length */
+       len =3D skb->len - ptr;
+       temp =3D 0;
+
+        while (ipv6_ext_hdr(nexthdr)) {
+               struct ipv6_opt_hdr *hdr;
+
+              DEBUGP("ipv6_opts header iteration \n");
+
+              /* Is there enough space for the next ext header? */
+                if (len < (int)sizeof(struct ipv6_opt_hdr))
+                        return 0;
+              /* No more exthdr -> evaluate */
+                if (nexthdr =3D=3D NEXTHDR_NONE) {
+                     break;
+              }
+              /* ESP -> evaluate */
+                if (nexthdr =3D=3D NEXTHDR_ESP) {
+                     break;
+              }
+
+              hdr=3D(void *)(skb->data)+ptr;
+
+              /* Calculate the header length */
+                if (nexthdr =3D=3D NEXTHDR_FRAGMENT) {
+                        hdrlen =3D 8;
+                } else if (nexthdr =3D=3D NEXTHDR_AUTH)
+                        hdrlen =3D (hdr->hdrlen+2)<<2;
+                else
+                        hdrlen =3D ipv6_optlen(hdr);
+
+              /* OPTS -> evaluate */
+#if HOPBYHOP
+                if (nexthdr =3D=3D NEXTHDR_HOP) {
+                     temp |=3D MASK_HOPOPTS;
+#else
+                if (nexthdr =3D=3D NEXTHDR_DEST) {
+                     temp |=3D MASK_DSTOPTS;
+#endif
+                     break;
+              }
+
+
+              /* set the flag */
+              switch (nexthdr){
+                     case NEXTHDR_HOP:
+                     case NEXTHDR_ROUTING:
+                     case NEXTHDR_FRAGMENT:
+                     case NEXTHDR_AUTH:
+                     case NEXTHDR_DEST:
+                            break;
+                     default:
+                            DEBUGP("ipv6_opts match: unknown nextheader %u=
\n",nexthdr);
+                            return 0;
+                            break;
+              }
+
+                nexthdr =3D hdr->nexthdr;
+                len -=3D hdrlen;
+                ptr +=3D hdrlen;
+		if ( ptr > skb->len ) {
+			DEBUGP("ipv6_opts: new pointer is too large! \n");
+			break;
+		}
+        }
+
+       /* OPTIONS header not found */
+#if HOPBYHOP
+       if ( temp !=3D MASK_HOPOPTS ) return 0;
+#else
+       if ( temp !=3D MASK_DSTOPTS ) return 0;
+#endif
+
+       if (len < (int)sizeof(struct ipv6_opt_hdr)){
+	       *hotdrop =3D 1;
+       		return 0;
+       }
+
+       if (len < hdrlen){
+	       /* Packet smaller than it's length field */
+       		return 0;
+       }
+
+       optsh=3D(void *)(skb->data)+ptr;
+
+       DEBUGP("IPv6 OPTS LEN %u %u ", hdrlen, optsh->hdrlen);
+
+       DEBUGP("len %02X %04X %02X ",
+       		optinfo->hdrlen, hdrlen,
+       		(!(optinfo->flags & IP6T_OPTS_LEN) ||
+                           ((optinfo->hdrlen =3D=3D hdrlen) ^
+                           !!(optinfo->invflags & IP6T_OPTS_INV_LEN))));
+
+       ret =3D (optsh !=3D NULL)
+       		&&
+	      	(!(optinfo->flags & IP6T_OPTS_LEN) ||
+                           ((optinfo->hdrlen =3D=3D hdrlen) ^
+                           !!(optinfo->invflags & IP6T_OPTS_INV_LEN)));
+
+       temp =3D len =3D 0;
+       ptr +=3D 2;
+       hdrlen -=3D 2;
+       if ( !(optinfo->flags & IP6T_OPTS_OPTS) ){
+	       return ret;
+	} else if (optinfo->flags & IP6T_OPTS_NSTRICT) {
+		DEBUGP("Not strict - not implemented");
+	} else {
+		DEBUGP("Strict ");
+		DEBUGP("#%d ",optinfo->optsnr);
+		for(temp=3D0; temp<optinfo->optsnr; temp++){
+			optdesc =3D (void *)(skb->data)+ptr;
+			/* Type check */
+			if ( (unsigned char)*optdesc !=3D=20
+				(optinfo->opts[temp] & 0xFF00)>>8 ){
+				DEBUGP("Tbad %02X %02X\n",
+						(unsigned char)*optdesc,
+						(optinfo->opts[temp] &
+						 0xFF00)>>8);
+				return 0;
+			} else {
+				DEBUGP("Tok ");
+			}
+			/* Length check */
+			if (((optinfo->opts[temp] & 0x00FF) !=3D 0xFF) &&
+				(unsigned char)*optdesc !=3D 0){
+				if ( ntohs((u16)*optdesc) !=3D=20
+						optinfo->opts[temp] ){
+					DEBUGP("Lbad %02X %04X %04X\n",
+							(unsigned char)*optdesc,
+							ntohs((u16)*optdesc),
+							optinfo->opts[temp]);
+					return 0;
+				} else {
+					DEBUGP("Lok ");
+				}
+			}
+			/* Step to the next */
+			if ((unsigned char)*optdesc =3D=3D 0){
+				DEBUGP("PAD0 \n");
+				ptr++;
+				hdrlen--;
+			} else {
+				ptr +=3D LOW(ntohs(*optdesc));
+				hdrlen -=3D LOW(ntohs(*optdesc));
+				DEBUGP("len%04X \n",=20
+					LOW(ntohs(*optdesc)));
+			}
+			if (ptr > skb->len || ( !hdrlen &&=20
+				(temp !=3D optinfo->optsnr - 1))) {
+				DEBUGP("new pointer is too large! \n");
+				break;
+			}
+		}
+		if (temp =3D=3D optinfo->optsnr)
+			return ret;
+		else return 0;
+	}
+
+	return 0;
+}
+
+/* Called when user tries to insert an entry of this type. */
+static int
+checkentry(const char *tablename,
+          const struct ip6t_ip6 *ip,
+          void *matchinfo,
+          unsigned int matchinfosize,
+          unsigned int hook_mask)
+{
+       const struct ip6t_opts *optsinfo =3D matchinfo;
+
+       if (matchinfosize !=3D IP6T_ALIGN(sizeof(struct ip6t_opts))) {
+              DEBUGP("ip6t_opts: matchsize %u !=3D %u\n",
+                      matchinfosize, IP6T_ALIGN(sizeof(struct ip6t_opts)));
+              return 0;
+       }
+       if (optsinfo->invflags & ~IP6T_OPTS_INV_MASK) {
+              DEBUGP("ip6t_opts: unknown flags %X\n",
+                      optsinfo->invflags);
+              return 0;
+       }
+
+       return 1;
+}
+
+static struct ip6t_match opts_match
+#if HOPBYHOP
+=3D { { NULL, NULL }, "hbh", &match, &checkentry, NULL, THIS_MODULE };
+#else
+=3D { { NULL, NULL }, "dst", &match, &checkentry, NULL, THIS_MODULE };
+#endif
+
+static int __init init(void)
+{
+       return ip6t_register_match(&opts_match);
+}
+
+static void __exit cleanup(void)
+{
+       ip6t_unregister_match(&opts_match);
+}
+
+module_init(init);
+module_exit(cleanup);
diff -Nru --exclude .depend --exclude *.o --exclude *.ver --exclude .*.flag=
s --exclude *.orig --exclude *.rej --exclude *~ linuxppc-270203-nfsubmit/ne=
t/ipv6/netfilter/ip6t_esp.c linuxppc-270203-davem/net/ipv6/netfilter/ip6t_e=
sp.c
--- linuxppc-270203-nfsubmit/net/ipv6/netfilter/ip6t_esp.c	Thu Jan  1 01:00=
:00 1970
+++ linuxppc-270203-davem/net/ipv6/netfilter/ip6t_esp.c	Thu Feb 27 12:25:32=
 2003
@@ -0,0 +1,186 @@
+/* Kernel module to match ESP parameters. */
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/ipv6.h>
+#include <linux/types.h>
+#include <net/checksum.h>
+#include <net/ipv6.h>
+
+#include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter_ipv6/ip6t_esp.h>
+
+EXPORT_NO_SYMBOLS;
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("IPv6 ESP match");
+MODULE_AUTHOR("Andras Kis-Szabo <kisza@sch.bme.hu>");
+
+#if 0
+#define DEBUGP printk
+#else
+#define DEBUGP(format, args...)
+#endif
+
+struct esphdr {
+	__u32   spi;
+};
+
+int ipv6_ext_hdr(u8 nexthdr)
+{
+        return ( (nexthdr =3D=3D NEXTHDR_HOP)       ||
+                 (nexthdr =3D=3D NEXTHDR_ROUTING)   ||
+                 (nexthdr =3D=3D NEXTHDR_FRAGMENT)  ||
+                 (nexthdr =3D=3D NEXTHDR_AUTH)      ||
+                 (nexthdr =3D=3D NEXTHDR_ESP)       ||
+                 (nexthdr =3D=3D NEXTHDR_NONE)      ||
+                 (nexthdr =3D=3D NEXTHDR_DEST) );
+}
+
+/* Returns 1 if the spi is matched by the range, 0 otherwise */
+static inline int
+spi_match(u_int32_t min, u_int32_t max, u_int32_t spi, int invert)
+{
+	int r=3D0;
+        DEBUGP("esp spi_match:%c 0x%x <=3D 0x%x <=3D 0x%x",invert? '!':' ',
+        	min,spi,max);
+	r=3D(spi >=3D min && spi <=3D max) ^ invert;
+	DEBUGP(" result %s\n",r? "PASS\n" : "FAILED\n");
+	return r;
+}
+
+static int
+match(const struct sk_buff *skb,
+      const struct net_device *in,
+      const struct net_device *out,
+      const void *matchinfo,
+      int offset,
+      const void *protohdr,
+      u_int16_t datalen,
+      int *hotdrop)
+{
+	struct esphdr *esp =3D NULL;
+	const struct ip6t_esp *espinfo =3D matchinfo;
+	unsigned int temp;
+	int len;
+	u8 nexthdr;
+	unsigned int ptr;
+
+	/* Make sure this isn't an evil packet */
+	/*DEBUGP("ipv6_esp entered \n");*/
+
+	/* type of the 1st exthdr */
+	nexthdr =3D skb->nh.ipv6h->nexthdr;
+	/* pointer to the 1st exthdr */
+	ptr =3D sizeof(struct ipv6hdr);
+	/* available length */
+	len =3D skb->len - ptr;
+	temp =3D 0;
+
+        while (ipv6_ext_hdr(nexthdr)) {
+        	struct ipv6_opt_hdr *hdr;
+        	int hdrlen;
+
+		DEBUGP("ipv6_esp header iteration \n");
+
+		/* Is there enough space for the next ext header? */
+                if (len < (int)sizeof(struct ipv6_opt_hdr))
+                        return 0;
+		/* No more exthdr -> evaluate */
+                if (nexthdr =3D=3D NEXTHDR_NONE) {
+			break;
+		}
+		/* ESP -> evaluate */
+                if (nexthdr =3D=3D NEXTHDR_ESP) {
+			temp |=3D MASK_ESP;
+			break;
+		}
+
+		hdr=3D(struct ipv6_opt_hdr *)skb->data+ptr;
+
+		/* Calculate the header length */
+                if (nexthdr =3D=3D NEXTHDR_FRAGMENT) {
+                        hdrlen =3D 8;
+                } else if (nexthdr =3D=3D NEXTHDR_AUTH)
+                        hdrlen =3D (hdr->hdrlen+2)<<2;
+                else
+                        hdrlen =3D ipv6_optlen(hdr);
+
+		/* set the flag */
+		switch (nexthdr){
+			case NEXTHDR_HOP:
+			case NEXTHDR_ROUTING:
+			case NEXTHDR_FRAGMENT:
+			case NEXTHDR_AUTH:
+			case NEXTHDR_DEST:
+				break;
+			default:
+				DEBUGP("ipv6_esp match: unknown nextheader %u\n",nexthdr);
+				return 0;
+				break;
+		}
+
+                nexthdr =3D hdr->nexthdr;
+                len -=3D hdrlen;
+                ptr +=3D hdrlen;
+		if ( ptr > skb->len ) {
+			DEBUGP("ipv6_esp: new pointer too large! \n");
+			break;
+		}
+        }
+
+	/* ESP header not found */
+	if ( temp !=3D MASK_ESP ) return 0;
+
+       if (len < (int)sizeof(struct esphdr)){
+	       *hotdrop =3D 1;
+       		return 0;
+       }
+
+	esp=3Dskb->data+ptr;
+
+	DEBUGP("IPv6 ESP SPI %u %08X\n", ntohl(esp->spi), ntohl(esp->spi));
+
+	return (esp !=3D NULL)
+		&& spi_match(espinfo->spis[0], espinfo->spis[1],
+			      ntohl(esp->spi),
+			      !!(espinfo->invflags & IP6T_ESP_INV_SPI));
+}
+
+/* Called when user tries to insert an entry of this type. */
+static int
+checkentry(const char *tablename,
+	   const struct ip6t_ip6 *ip,
+	   void *matchinfo,
+	   unsigned int matchinfosize,
+	   unsigned int hook_mask)
+{
+	const struct ip6t_esp *espinfo =3D matchinfo;
+
+	if (matchinfosize !=3D IP6T_ALIGN(sizeof(struct ip6t_esp))) {
+		DEBUGP("ip6t_esp: matchsize %u !=3D %u\n",
+			 matchinfosize, IP6T_ALIGN(sizeof(struct ip6t_esp)));
+		return 0;
+	}
+	if (espinfo->invflags & ~IP6T_ESP_INV_MASK) {
+		DEBUGP("ip6t_esp: unknown flags %X\n",
+			 espinfo->invflags);
+		return 0;
+	}
+
+	return 1;
+}
+
+static struct ip6t_match esp_match
+=3D { { NULL, NULL }, "esp", &match, &checkentry, NULL, THIS_MODULE };
+
+static int __init init(void)
+{
+	return ip6t_register_match(&esp_match);
+}
+
+static void __exit cleanup(void)
+{
+	ip6t_unregister_match(&esp_match);
+}
+
+module_init(init);
+module_exit(cleanup);
diff -Nru --exclude .depend --exclude *.o --exclude *.ver --exclude .*.flag=
s --exclude *.orig --exclude *.rej --exclude *~ linuxppc-270203-nfsubmit/ne=
t/ipv6/netfilter/ip6t_frag.c linuxppc-270203-davem/net/ipv6/netfilter/ip6t_=
frag.c
--- linuxppc-270203-nfsubmit/net/ipv6/netfilter/ip6t_frag.c	Thu Jan  1 01:0=
0:00 1970
+++ linuxppc-270203-davem/net/ipv6/netfilter/ip6t_frag.c	Thu Feb 27 12:25:3=
5 2003
@@ -0,0 +1,250 @@
+/* Kernel module to match FRAG parameters. */
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/ipv6.h>
+#include <linux/types.h>
+#include <net/checksum.h>
+#include <net/ipv6.h>
+
+#include <asm/byteorder.h>
+
+#include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter_ipv6/ip6t_frag.h>
+
+EXPORT_NO_SYMBOLS;
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("IPv6 FRAG match");
+MODULE_AUTHOR("Andras Kis-Szabo <kisza@sch.bme.hu>");
+
+#if 0
+#define DEBUGP printk
+#else
+#define DEBUGP(format, args...)
+#endif
+
+#if 0
+#if     BYTE_ORDER =3D=3D BIG_ENDIAN
+#define IP6F_OFF_MASK       0xfff8  /* mask out offset from _offlg */
+#define IP6F_RESERVED_MASK  0x0006  /* reserved bits in ip6f_offlg */
+#define IP6F_MORE_FRAG      0x0001  /* more-fragments flag */
+#else   /* BYTE_ORDER =3D=3D LITTLE_ENDIAN */
+#define IP6F_OFF_MASK       0xf8ff  /* mask out offset from _offlg */
+#define IP6F_RESERVED_MASK  0x0600  /* reserved bits in ip6f_offlg */
+#define IP6F_MORE_FRAG      0x0100  /* more-fragments flag */
+#endif
+#endif
+
+#define IP6F_OFF_MASK       0xf8ff  /* mask out offset from _offlg */
+#define IP6F_RESERVED_MASK  0x0600  /* reserved bits in ip6f_offlg */
+#define IP6F_MORE_FRAG      0x0100  /* more-fragments flag */
+
+struct fraghdr {
+       __u8    nexthdr;
+       __u8    hdrlen;
+       __u16   info;
+       __u32   id;
+};
+
+int ipv6_ext_hdr(u8 nexthdr)
+{
+        return ( (nexthdr =3D=3D NEXTHDR_HOP)       ||
+                 (nexthdr =3D=3D NEXTHDR_ROUTING)   ||
+                 (nexthdr =3D=3D NEXTHDR_FRAGMENT)  ||
+                 (nexthdr =3D=3D NEXTHDR_AUTH)      ||
+                 (nexthdr =3D=3D NEXTHDR_ESP)       ||
+                 (nexthdr =3D=3D NEXTHDR_NONE)      ||
+                 (nexthdr =3D=3D NEXTHDR_DEST) );
+}
+
+/* Returns 1 if the id is matched by the range, 0 otherwise */
+static inline int
+id_match(u_int32_t min, u_int32_t max, u_int32_t id, int invert)
+{
+       int r=3D0;
+       DEBUGP("frag id_match:%c 0x%x <=3D 0x%x <=3D 0x%x",invert? '!':' ',
+              min,id,max);
+       r=3D(id >=3D min && id <=3D max) ^ invert;
+       DEBUGP(" result %s\n",r? "PASS" : "FAILED");
+       return r;
+}
+
+static int
+match(const struct sk_buff *skb,
+      const struct net_device *in,
+      const struct net_device *out,
+      const void *matchinfo,
+      int offset,
+      const void *protohdr,
+      u_int16_t datalen,
+      int *hotdrop)
+{
+       struct fraghdr *frag =3D NULL;
+       const struct ip6t_frag *fraginfo =3D matchinfo;
+       unsigned int temp;
+       int len;
+       u8 nexthdr;
+       unsigned int ptr;
+       unsigned int hdrlen =3D 0;
+
+       /* type of the 1st exthdr */
+       nexthdr =3D skb->nh.ipv6h->nexthdr;
+       /* pointer to the 1st exthdr */
+       ptr =3D sizeof(struct ipv6hdr);
+       /* available length */
+       len =3D skb->len - ptr;
+       temp =3D 0;
+
+        while (ipv6_ext_hdr(nexthdr)) {
+               struct ipv6_opt_hdr *hdr;
+
+              DEBUGP("ipv6_frag header iteration \n");
+
+              /* Is there enough space for the next ext header? */
+                if (len < (int)sizeof(struct ipv6_opt_hdr))
+                        return 0;
+              /* No more exthdr -> evaluate */
+                if (nexthdr =3D=3D NEXTHDR_NONE) {
+                     break;
+              }
+              /* ESP -> evaluate */
+                if (nexthdr =3D=3D NEXTHDR_ESP) {
+                     break;
+              }
+
+              hdr=3D(struct ipv6_opt_hdr *)skb->data+ptr;
+
+              /* Calculate the header length */
+                if (nexthdr =3D=3D NEXTHDR_FRAGMENT) {
+                        hdrlen =3D 8;
+                } else if (nexthdr =3D=3D NEXTHDR_AUTH)
+                        hdrlen =3D (hdr->hdrlen+2)<<2;
+                else
+                        hdrlen =3D ipv6_optlen(hdr);
+
+              /* FRAG -> evaluate */
+                if (nexthdr =3D=3D NEXTHDR_FRAGMENT) {
+                     temp |=3D MASK_FRAGMENT;
+                     break;
+              }
+
+
+              /* set the flag */
+              switch (nexthdr){
+                     case NEXTHDR_HOP:
+                     case NEXTHDR_ROUTING:
+                     case NEXTHDR_FRAGMENT:
+                     case NEXTHDR_AUTH:
+                     case NEXTHDR_DEST:
+                            break;
+                     default:
+                            DEBUGP("ipv6_frag match: unknown nextheader %u=
\n",nexthdr);
+                            return 0;
+                            break;
+              }
+
+                nexthdr =3D hdr->nexthdr;
+                len -=3D hdrlen;
+                ptr +=3D hdrlen;
+		if ( ptr > skb->len ) {
+			DEBUGP("ipv6_frag: new pointer too large! \n");
+			break;
+		}
+        }
+
+       /* FRAG header not found */
+       if ( temp !=3D MASK_FRAGMENT ) return 0;
+
+       if (len < (int)sizeof(struct fraghdr)){
+	       *hotdrop =3D 1;
+       		return 0;
+       }
+
+       frag=3Dskb->data+ptr;
+
+       DEBUGP("IPv6 FRAG LEN %u %u ", hdrlen, frag->hdrlen);
+       DEBUGP("INFO %04X ", frag->info);
+       DEBUGP("OFFSET %04X ", frag->info & IP6F_OFF_MASK);
+       DEBUGP("RES %04X ", frag->info & IP6F_RESERVED_MASK);
+       DEBUGP("MF %04X ", frag->info & IP6F_MORE_FRAG);
+       DEBUGP("ID %u %08X\n", ntohl(frag->id), ntohl(frag->id));
+
+       DEBUGP("IPv6 FRAG id %02X ",
+       		(id_match(fraginfo->ids[0], fraginfo->ids[1],
+                           ntohl(frag->id),
+                           !!(fraginfo->invflags & IP6T_FRAG_INV_IDS))));
+       DEBUGP("len %02X %04X %02X ",
+       		fraginfo->hdrlen, hdrlen,
+       		(!fraginfo->hdrlen ||
+                           (fraginfo->hdrlen =3D=3D hdrlen) ^
+                           !!(fraginfo->invflags & IP6T_FRAG_INV_LEN)));
+       DEBUGP("res %02X %02X %02X ",=20
+       		(fraginfo->flags & IP6T_FRAG_RES), frag->info & IP6F_RESERVED_MAS=
K,
+       		!((fraginfo->flags & IP6T_FRAG_RES) && (frag->info & IP6F_RESERVE=
D_MASK)));
+       DEBUGP("first %02X %02X %02X ",=20
+       		(fraginfo->flags & IP6T_FRAG_FST), frag->info & IP6F_OFF_MASK,
+       		!((fraginfo->flags & IP6T_FRAG_FST) && (frag->info & IP6F_OFF_MAS=
K)));
+       DEBUGP("mf %02X %02X %02X ",=20
+       		(fraginfo->flags & IP6T_FRAG_MF), frag->info & IP6F_MORE_FRAG,
+       		!((fraginfo->flags & IP6T_FRAG_MF) && !((frag->info & IP6F_MORE_F=
RAG))));
+       DEBUGP("last %02X %02X %02X\n",=20
+       		(fraginfo->flags & IP6T_FRAG_NMF), frag->info & IP6F_MORE_FRAG,
+       		!((fraginfo->flags & IP6T_FRAG_NMF) && (frag->info & IP6F_MORE_FR=
AG)));
+
+       return (frag !=3D NULL)
+       		&&
+       		(id_match(fraginfo->ids[0], fraginfo->ids[1],
+                           ntohl(frag->id),
+                           !!(fraginfo->invflags & IP6T_FRAG_INV_IDS)))
+		&&
+	      	(!fraginfo->hdrlen ||
+                           (fraginfo->hdrlen =3D=3D hdrlen) ^
+                           !!(fraginfo->invflags & IP6T_FRAG_INV_LEN))
+		&&
+		!((fraginfo->flags & IP6T_FRAG_RES) && (frag->info & IP6F_RESERVED_MASK))
+		&&
+		!((fraginfo->flags & IP6T_FRAG_FST) && (frag->info & IP6F_OFF_MASK))
+		&&
+		!((fraginfo->flags & IP6T_FRAG_MF) && !((frag->info & IP6F_MORE_FRAG)))
+		&&
+		!((fraginfo->flags & IP6T_FRAG_NMF) && (frag->info & IP6F_MORE_FRAG));
+}
+
+/* Called when user tries to insert an entry of this type. */
+static int
+checkentry(const char *tablename,
+          const struct ip6t_ip6 *ip,
+          void *matchinfo,
+          unsigned int matchinfosize,
+          unsigned int hook_mask)
+{
+       const struct ip6t_frag *fraginfo =3D matchinfo;
+
+       if (matchinfosize !=3D IP6T_ALIGN(sizeof(struct ip6t_frag))) {
+              DEBUGP("ip6t_frag: matchsize %u !=3D %u\n",
+                      matchinfosize, IP6T_ALIGN(sizeof(struct ip6t_frag)));
+              return 0;
+       }
+       if (fraginfo->invflags & ~IP6T_FRAG_INV_MASK) {
+              DEBUGP("ip6t_frag: unknown flags %X\n",
+                      fraginfo->invflags);
+              return 0;
+       }
+
+       return 1;
+}
+
+static struct ip6t_match frag_match
+=3D { { NULL, NULL }, "frag", &match, &checkentry, NULL, THIS_MODULE };
+
+static int __init init(void)
+{
+       return ip6t_register_match(&frag_match);
+}
+
+static void __exit cleanup(void)
+{
+       ip6t_unregister_match(&frag_match);
+}
+
+module_init(init);
+module_exit(cleanup);
diff -Nru --exclude .depend --exclude *.o --exclude *.ver --exclude .*.flag=
s --exclude *.orig --exclude *.rej --exclude *~ linuxppc-270203-nfsubmit/ne=
t/ipv6/netfilter/ip6t_hbh.c linuxppc-270203-davem/net/ipv6/netfilter/ip6t_h=
bh.c
--- linuxppc-270203-nfsubmit/net/ipv6/netfilter/ip6t_hbh.c	Thu Jan  1 01:00=
:00 1970
+++ linuxppc-270203-davem/net/ipv6/netfilter/ip6t_hbh.c	Thu Feb 27 12:25:43=
 2003
@@ -0,0 +1,287 @@
+/* Kernel module to match Hop-by-Hop and Destination parameters. */
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/ipv6.h>
+#include <linux/types.h>
+#include <net/checksum.h>
+#include <net/ipv6.h>
+
+#include <asm/byteorder.h>
+
+#include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter_ipv6/ip6t_opts.h>
+
+#define LOW(n)		(n & 0x00FF)
+
+#define HOPBYHOP	1
+
+EXPORT_NO_SYMBOLS;
+MODULE_LICENSE("GPL");
+#if HOPBYHOP
+MODULE_DESCRIPTION("IPv6 HbH match");
+#else
+MODULE_DESCRIPTION("IPv6 DST match");
+#endif
+MODULE_AUTHOR("Andras Kis-Szabo <kisza@sch.bme.hu>");
+
+#if 0
+#define DEBUGP printk
+#else
+#define DEBUGP(format, args...)
+#endif
+
+int ipv6_ext_hdr(u8 nexthdr)
+{
+        return ( (nexthdr =3D=3D NEXTHDR_HOP)       ||
+                 (nexthdr =3D=3D NEXTHDR_ROUTING)   ||
+                 (nexthdr =3D=3D NEXTHDR_FRAGMENT)  ||
+                 (nexthdr =3D=3D NEXTHDR_AUTH)      ||
+                 (nexthdr =3D=3D NEXTHDR_ESP)       ||
+                 (nexthdr =3D=3D NEXTHDR_NONE)      ||
+                 (nexthdr =3D=3D NEXTHDR_DEST) );
+}
+
+/*
+ * (Type & 0xC0) >> 6
+ * 	0	-> ignorable
+ * 	1	-> must drop the packet
+ * 	2	-> send ICMP PARM PROB regardless and drop packet
+ * 	3	-> Send ICMP if not a multicast address and drop packet
+ *  (Type & 0x20) >> 5
+ *  	0	-> invariant
+ *  	1	-> can change the routing
+ *  (Type & 0x1F) Type
+ *      0	-> PAD0 (only 1 byte!)
+ *      1	-> PAD1 LENGTH info (total length =3D length + 2)
+ *      C0 | 2	-> JUMBO 4 x x x x ( xxxx > 64k )
+ *      5	-> RTALERT 2 x x
+ */
+
+static int
+match(const struct sk_buff *skb,
+      const struct net_device *in,
+      const struct net_device *out,
+      const void *matchinfo,
+      int offset,
+      const void *protohdr,
+      u_int16_t datalen,
+      int *hotdrop)
+{
+       struct ipv6_opt_hdr *optsh =3D NULL;
+       const struct ip6t_opts *optinfo =3D matchinfo;
+       unsigned int temp;
+       unsigned int len;
+       u8 nexthdr;
+       unsigned int ptr;
+       unsigned int hdrlen =3D 0;
+       unsigned int ret =3D 0;
+       u_int16_t *optdesc =3D NULL;
+      =20
+       /* type of the 1st exthdr */
+       nexthdr =3D skb->nh.ipv6h->nexthdr;
+       /* pointer to the 1st exthdr */
+       ptr =3D sizeof(struct ipv6hdr);
+       /* available length */
+       len =3D skb->len - ptr;
+       temp =3D 0;
+
+        while (ipv6_ext_hdr(nexthdr)) {
+               struct ipv6_opt_hdr *hdr;
+
+              DEBUGP("ipv6_opts header iteration \n");
+
+              /* Is there enough space for the next ext header? */
+                if (len < (int)sizeof(struct ipv6_opt_hdr))
+                        return 0;
+              /* No more exthdr -> evaluate */
+                if (nexthdr =3D=3D NEXTHDR_NONE) {
+                     break;
+              }
+              /* ESP -> evaluate */
+                if (nexthdr =3D=3D NEXTHDR_ESP) {
+                     break;
+              }
+
+              hdr=3D(void *)(skb->data)+ptr;
+
+              /* Calculate the header length */
+                if (nexthdr =3D=3D NEXTHDR_FRAGMENT) {
+                        hdrlen =3D 8;
+                } else if (nexthdr =3D=3D NEXTHDR_AUTH)
+                        hdrlen =3D (hdr->hdrlen+2)<<2;
+                else
+                        hdrlen =3D ipv6_optlen(hdr);
+
+              /* OPTS -> evaluate */
+#if HOPBYHOP
+                if (nexthdr =3D=3D NEXTHDR_HOP) {
+                     temp |=3D MASK_HOPOPTS;
+#else
+                if (nexthdr =3D=3D NEXTHDR_DEST) {
+                     temp |=3D MASK_DSTOPTS;
+#endif
+                     break;
+              }
+
+
+              /* set the flag */
+              switch (nexthdr){
+                     case NEXTHDR_HOP:
+                     case NEXTHDR_ROUTING:
+                     case NEXTHDR_FRAGMENT:
+                     case NEXTHDR_AUTH:
+                     case NEXTHDR_DEST:
+                            break;
+                     default:
+                            DEBUGP("ipv6_opts match: unknown nextheader %u=
\n",nexthdr);
+                            return 0;
+                            break;
+              }
+
+                nexthdr =3D hdr->nexthdr;
+                len -=3D hdrlen;
+                ptr +=3D hdrlen;
+		if ( ptr > skb->len ) {
+			DEBUGP("ipv6_opts: new pointer is too large! \n");
+			break;
+		}
+        }
+
+       /* OPTIONS header not found */
+#if HOPBYHOP
+       if ( temp !=3D MASK_HOPOPTS ) return 0;
+#else
+       if ( temp !=3D MASK_DSTOPTS ) return 0;
+#endif
+
+       if (len < (int)sizeof(struct ipv6_opt_hdr)){
+	       *hotdrop =3D 1;
+       		return 0;
+       }
+
+       if (len < hdrlen){
+	       /* Packet smaller than it's length field */
+       		return 0;
+       }
+
+       optsh=3D(void *)(skb->data)+ptr;
+
+       DEBUGP("IPv6 OPTS LEN %u %u ", hdrlen, optsh->hdrlen);
+
+       DEBUGP("len %02X %04X %02X ",
+       		optinfo->hdrlen, hdrlen,
+       		(!(optinfo->flags & IP6T_OPTS_LEN) ||
+                           ((optinfo->hdrlen =3D=3D hdrlen) ^
+                           !!(optinfo->invflags & IP6T_OPTS_INV_LEN))));
+
+       ret =3D (optsh !=3D NULL)
+       		&&
+	      	(!(optinfo->flags & IP6T_OPTS_LEN) ||
+                           ((optinfo->hdrlen =3D=3D hdrlen) ^
+                           !!(optinfo->invflags & IP6T_OPTS_INV_LEN)));
+
+       temp =3D len =3D 0;
+       ptr +=3D 2;
+       hdrlen -=3D 2;
+       if ( !(optinfo->flags & IP6T_OPTS_OPTS) ){
+	       return ret;
+	} else if (optinfo->flags & IP6T_OPTS_NSTRICT) {
+		DEBUGP("Not strict - not implemented");
+	} else {
+		DEBUGP("Strict ");
+		DEBUGP("#%d ",optinfo->optsnr);
+		for(temp=3D0; temp<optinfo->optsnr; temp++){
+			optdesc =3D (void *)(skb->data)+ptr;
+			/* Type check */
+			if ( (unsigned char)*optdesc !=3D=20
+				(optinfo->opts[temp] & 0xFF00)>>8 ){
+				DEBUGP("Tbad %02X %02X\n",
+						(unsigned char)*optdesc,
+						(optinfo->opts[temp] &
+						 0xFF00)>>8);
+				return 0;
+			} else {
+				DEBUGP("Tok ");
+			}
+			/* Length check */
+			if (((optinfo->opts[temp] & 0x00FF) !=3D 0xFF) &&
+				(unsigned char)*optdesc !=3D 0){
+				if ( ntohs((u16)*optdesc) !=3D=20
+						optinfo->opts[temp] ){
+					DEBUGP("Lbad %02X %04X %04X\n",
+							(unsigned char)*optdesc,
+							ntohs((u16)*optdesc),
+							optinfo->opts[temp]);
+					return 0;
+				} else {
+					DEBUGP("Lok ");
+				}
+			}
+			/* Step to the next */
+			if ((unsigned char)*optdesc =3D=3D 0){
+				DEBUGP("PAD0 \n");
+				ptr++;
+				hdrlen--;
+			} else {
+				ptr +=3D LOW(ntohs(*optdesc));
+				hdrlen -=3D LOW(ntohs(*optdesc));
+				DEBUGP("len%04X \n",=20
+					LOW(ntohs(*optdesc)));
+			}
+			if (ptr > skb->len || ( !hdrlen &&=20
+				(temp !=3D optinfo->optsnr - 1))) {
+				DEBUGP("new pointer is too large! \n");
+				break;
+			}
+		}
+		if (temp =3D=3D optinfo->optsnr)
+			return ret;
+		else return 0;
+	}
+
+	return 0;
+}
+
+/* Called when user tries to insert an entry of this type. */
+static int
+checkentry(const char *tablename,
+          const struct ip6t_ip6 *ip,
+          void *matchinfo,
+          unsigned int matchinfosize,
+          unsigned int hook_mask)
+{
+       const struct ip6t_opts *optsinfo =3D matchinfo;
+
+       if (matchinfosize !=3D IP6T_ALIGN(sizeof(struct ip6t_opts))) {
+              DEBUGP("ip6t_opts: matchsize %u !=3D %u\n",
+                      matchinfosize, IP6T_ALIGN(sizeof(struct ip6t_opts)));
+              return 0;
+       }
+       if (optsinfo->invflags & ~IP6T_OPTS_INV_MASK) {
+              DEBUGP("ip6t_opts: unknown flags %X\n",
+                      optsinfo->invflags);
+              return 0;
+       }
+
+       return 1;
+}
+
+static struct ip6t_match opts_match
+#if HOPBYHOP
+=3D { { NULL, NULL }, "hbh", &match, &checkentry, NULL, THIS_MODULE };
+#else
+=3D { { NULL, NULL }, "dst", &match, &checkentry, NULL, THIS_MODULE };
+#endif
+
+static int __init init(void)
+{
+       return ip6t_register_match(&opts_match);
+}
+
+static void __exit cleanup(void)
+{
+       ip6t_unregister_match(&opts_match);
+}
+
+module_init(init);
+module_exit(cleanup);
diff -Nru --exclude .depend --exclude *.o --exclude *.ver --exclude .*.flag=
s --exclude *.orig --exclude *.rej --exclude *~ linuxppc-270203-nfsubmit/ne=
t/ipv6/netfilter/ip6t_hl.c linuxppc-270203-davem/net/ipv6/netfilter/ip6t_hl=
.c
--- linuxppc-270203-nfsubmit/net/ipv6/netfilter/ip6t_hl.c	Thu Jan  1 01:00:=
00 1970
+++ linuxppc-270203-davem/net/ipv6/netfilter/ip6t_hl.c	Thu Feb 27 12:25:28 =
2003
@@ -0,0 +1,74 @@
+/*
+ * Hop Limit matching module
+ * Maciej Soltysiak <solt@dns.toxicfilms.tv>
+ * Based on HW's ttl module
+ *
+ * This software is distributed under the terms  GNU GPL
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+
+#include <linux/netfilter_ipv6/ip6t_hl.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
+
+MODULE_AUTHOR("Maciej Soltysiak <solt@dns.toxicfilms.tv>");
+MODULE_DESCRIPTION("IP tables Hop Limit matching module");
+MODULE_LICENSE("GPL");
+
+static int match(const struct sk_buff *skb, const struct net_device *in,
+		 const struct net_device *out, const void *matchinfo,
+		 int offset, const void *hdr, u_int16_t datalen,
+		 int *hotdrop)
+{
+	const struct ip6t_hl_info *info =3D matchinfo;
+	const struct ipv6hdr *ip6h =3D skb->nh.ipv6h;
+
+	switch (info->mode) {
+		case IP6T_HL_EQ:
+			return (ip6h->hop_limit =3D=3D info->hop_limit);
+			break;
+		case IP6T_HL_NE:
+			return (!(ip6h->hop_limit =3D=3D info->hop_limit));
+			break;
+		case IP6T_HL_LT:
+			return (ip6h->hop_limit < info->hop_limit);
+			break;
+		case IP6T_HL_GT:
+			return (ip6h->hop_limit > info->hop_limit);
+			break;
+		default:
+			printk(KERN_WARNING "ip6t_hl: unknown mode %d\n",=20
+				info->mode);
+			return 0;
+	}
+
+	return 0;
+}
+
+static int checkentry(const char *tablename, const struct ip6t_ip6 *ip,
+		      void *matchinfo, unsigned int matchsize,
+		      unsigned int hook_mask)
+{
+	if (matchsize !=3D IP6T_ALIGN(sizeof(struct ip6t_hl_info)))
+		return 0;
+
+	return 1;
+}
+
+static struct ip6t_match hl_match =3D { { NULL, NULL }, "hl", &match,
+		&checkentry, NULL, THIS_MODULE };
+
+static int __init init(void)
+{
+	return ip6t_register_match(&hl_match);
+}
+
+static void __exit fini(void)
+{
+	ip6t_unregister_match(&hl_match);
+
+}
+
+module_init(init);
+module_exit(fini);
diff -Nru --exclude .depend --exclude *.o --exclude *.ver --exclude .*.flag=
s --exclude *.orig --exclude *.rej --exclude *~ linuxppc-270203-nfsubmit/ne=
t/ipv6/netfilter/ip6t_ipv6header.c linuxppc-270203-davem/net/ipv6/netfilter=
/ip6t_ipv6header.c
--- linuxppc-270203-nfsubmit/net/ipv6/netfilter/ip6t_ipv6header.c	Thu Jan  =
1 01:00:00 1970
+++ linuxppc-270203-davem/net/ipv6/netfilter/ip6t_ipv6header.c	Thu Feb 27 1=
2:25:39 2003
@@ -0,0 +1,222 @@
+/* ipv6header match - matches IPv6 packets based
+on whether they contain certain headers */
+
+/* Original idea: Brad Chapman=20
+ * Rewritten by: Andras Kis-Szabo <kisza@sch.bme.hu> */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/ipv6.h>
+#include <linux/types.h>
+#include <net/checksum.h>
+#include <net/ipv6.h>
+
+#include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter_ipv6/ip6t_ipv6header.h>
+
+EXPORT_NO_SYMBOLS;
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("IPv6 headers match");
+MODULE_AUTHOR("Andras Kis-Szabo <kisza@sch.bme.hu>");
+
+#if 0
+#define DEBUGP printk
+#else
+#define DEBUGP(format, args...)
+#endif
+
+int ipv6_ext_hdr(u8 nexthdr)
+{
+        return ( (nexthdr =3D=3D NEXTHDR_HOP)       ||
+                 (nexthdr =3D=3D NEXTHDR_ROUTING)   ||
+                 (nexthdr =3D=3D NEXTHDR_FRAGMENT)  ||
+                 (nexthdr =3D=3D NEXTHDR_AUTH)      ||
+                 (nexthdr =3D=3D NEXTHDR_ESP)       ||
+                 (nexthdr =3D=3D NEXTHDR_NONE)      ||
+                 (nexthdr =3D=3D NEXTHDR_DEST) );
+}
+
+static int
+ipv6header_match(const struct sk_buff *skb,
+		 const struct net_device *in,
+		 const struct net_device *out,
+		 const void *matchinfo,
+		 int offset,
+		 const void *protohdr,
+		 u_int16_t datalen,
+		 int *hotdrop)
+{
+	const struct ip6t_ipv6header_info *info =3D matchinfo;
+	unsigned int temp;
+	int len;
+	u8 nexthdr;
+	unsigned int ptr;
+        struct inet6_skb_parm *opt =3D (struct inet6_skb_parm *)skb->cb;
+
+	/* Make sure this isn't an evil packet */
+	DEBUGP("ipv6_header entered \n");
+
+	/* type of the 1st exthdr */
+	nexthdr =3D skb->nh.ipv6h->nexthdr;
+	/* pointer to the 1st exthdr */
+	ptr =3D sizeof(struct ipv6hdr);
+	/* available length */
+	len =3D skb->len - ptr;
+	temp =3D 0;
+
+	DEBUGP("ipv6_header nexthdr %02X \n",nexthdr);
+	DEBUGP("ipv6_header ptr %08X \n",ptr);
+	DEBUGP("ipv6_header skblen %04X \n",skb->len);
+	DEBUGP("ipv6_header skbdatalen %04X \n",skb->data_len);
+	DEBUGP("ipv6_header len %04X \n",len);
+#if 0
+	for (temp=3D0;temp<skb->len;temp++){
+		if (!(temp % 16 )) DEBUGP("\nipv6_header data ");
+		DEBUGP("%02X ",skb->data[temp]);
+	}
+#endif
+	DEBUGP("\nipv6_header h.raw %02X %02X %02X %02X \n",
+			skb->h.raw[0],
+			skb->h.raw[1],
+			skb->h.raw[2],
+			skb->h.raw[3]);
+	DEBUGP("ipv6_header nh.raw %02X %02X %02X %02X \n",
+			skb->nh.raw[0],
+			skb->nh.raw[1],
+			skb->nh.raw[2],
+			skb->nh.raw[3]);
+	DEBUGP("ipv6_header CB %02X %02X %02X %02X %02X %02X %02X \n",
+			opt->iif,
+			opt->ra,
+			opt->hop,
+			opt->auth,
+			opt->dst0,
+			opt->srcrt,
+			opt->dst1);
+
+	temp =3D 0;
+
+        while (ipv6_ext_hdr(nexthdr)) {
+        	struct ipv6_opt_hdr *hdr;
+        	int hdrlen;
+
+		DEBUGP("ipv6_header header iteration \n");
+
+		/* Is there enough space for the next ext header? */
+                if (len < (int)sizeof(struct ipv6_opt_hdr))
+                        return 0;
+		/* No more exthdr -> evaluate */
+                if (nexthdr =3D=3D NEXTHDR_NONE) {
+			temp |=3D MASK_NONE;
+			break;
+		}
+		/* ESP -> evaluate */
+                if (nexthdr =3D=3D NEXTHDR_ESP) {
+			temp |=3D MASK_ESP;
+			break;
+		}
+
+		hdr=3D(struct ipv6_opt_hdr *)skb->data+ptr;
+
+		/* Calculate the header length */
+                if (nexthdr =3D=3D NEXTHDR_FRAGMENT) {
+                        hdrlen =3D 8;
+                } else if (nexthdr =3D=3D NEXTHDR_AUTH)
+                        hdrlen =3D (hdr->hdrlen+2)<<2;
+                else
+                        hdrlen =3D ipv6_optlen(hdr);
+
+		DEBUGP("ipv6_header hdrlen %04X \n",hdrlen);
+
+		/* set the flag */
+		switch (nexthdr){
+			case NEXTHDR_HOP:
+				temp |=3D MASK_HOPOPTS;
+				break;
+			case NEXTHDR_ROUTING:
+				temp |=3D MASK_ROUTING;
+				break;
+			case NEXTHDR_FRAGMENT:
+				temp |=3D MASK_FRAGMENT;
+				break;
+			case NEXTHDR_AUTH:
+				temp |=3D MASK_AH;
+				break;
+			case NEXTHDR_DEST:
+				temp |=3D MASK_DSTOPTS;
+				break;
+			default:
+				DEBUGP("IPV6HEADER match: unknown nextheader %u\n",nexthdr);
+				return 0;
+				break;
+		}
+
+                nexthdr =3D hdr->nexthdr;
+                len -=3D hdrlen;
+                ptr +=3D hdrlen;
+		if ( ptr > skb->len ) {
+			DEBUGP("ipv6_header new ptr %04X \n",ptr);
+			break;
+		}
+        }
+
+	if ( (nexthdr !=3D NEXTHDR_NONE ) && (nexthdr !=3D NEXTHDR_ESP) )
+		temp |=3D MASK_PROTO;
+
+	DEBUGP ("ipv6header: %02X %02X \n", temp, info->matchflags);
+
+	if (info->modeflag)
+		return (!( (temp & info->matchflags)
+			^ info->matchflags) ^ info->invflags);
+	else
+		return (!( temp ^ info->matchflags) ^ info->invflags);
+}
+
+static int
+ipv6header_checkentry(const char *tablename,
+		      const struct ip6t_ip6 *ip,
+		      void *matchinfo,
+		      unsigned int matchsize,
+		      unsigned int hook_mask)
+{
+	/* Check for obvious errors */
+	/* This match is valid in all hooks! */
+	if (matchsize !=3D IP6T_ALIGN(sizeof(struct ip6t_ipv6header_info))) {
+		DEBUGP("ip6t_ipv6header: matchsize !=3D %u\n",
+			 IP6T_ALIGN(sizeof(struct ip6t_ipv6header_info)));
+		return 0;
+	}
+
+	return 1;
+}
+
+static void
+ipv6header_destroy(void *matchinfo,
+		   unsigned int matchinfosize)
+{
+	return;
+}
+
+static struct ip6t_match
+ip6t_ipv6header_match =3D {
+	{ NULL, NULL },
+	"ipv6header",
+	&ipv6header_match,
+	&ipv6header_checkentry,
+	&ipv6header_destroy,
+	THIS_MODULE
+};
+
+static int  __init ipv6header_init(void)
+{
+	return ip6t_register_match(&ip6t_ipv6header_match);
+}
+
+static void __exit ipv6header_exit(void)
+{
+	ip6t_unregister_match(&ip6t_ipv6header_match);
+}
+
+module_init(ipv6header_init);
+module_exit(ipv6header_exit);
+
diff -Nru --exclude .depend --exclude *.o --exclude *.ver --exclude .*.flag=
s --exclude *.orig --exclude *.rej --exclude *~ linuxppc-270203-nfsubmit/ne=
t/ipv6/netfilter/ip6t_rt.c linuxppc-270203-davem/net/ipv6/netfilter/ip6t_rt=
.c
--- linuxppc-270203-nfsubmit/net/ipv6/netfilter/ip6t_rt.c	Thu Jan  1 01:00:=
00 1970
+++ linuxppc-270203-davem/net/ipv6/netfilter/ip6t_rt.c	Thu Feb 27 12:25:49 =
2003
@@ -0,0 +1,305 @@
+/* Kernel module to match ROUTING parameters. */
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/ipv6.h>
+#include <linux/types.h>
+#include <net/checksum.h>
+#include <net/ipv6.h>
+
+#include <asm/byteorder.h>
+
+#include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter_ipv6/ip6t_rt.h>
+
+EXPORT_NO_SYMBOLS;
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("IPv6 RT match");
+MODULE_AUTHOR("Andras Kis-Szabo <kisza@sch.bme.hu>");
+
+#if 0
+#define DEBUGP printk
+#else
+#define DEBUGP(format, args...)
+#endif
+
+int ipv6_ext_hdr(u8 nexthdr)
+{
+        return ( (nexthdr =3D=3D NEXTHDR_HOP)       ||
+                 (nexthdr =3D=3D NEXTHDR_ROUTING)   ||
+                 (nexthdr =3D=3D NEXTHDR_FRAGMENT)  ||
+                 (nexthdr =3D=3D NEXTHDR_AUTH)      ||
+                 (nexthdr =3D=3D NEXTHDR_ESP)       ||
+                 (nexthdr =3D=3D NEXTHDR_NONE)      ||
+                 (nexthdr =3D=3D NEXTHDR_DEST) );
+}
+
+/* Returns 1 if the id is matched by the range, 0 otherwise */
+static inline int
+segsleft_match(u_int32_t min, u_int32_t max, u_int32_t id, int invert)
+{
+       int r=3D0;
+       DEBUGP("rt segsleft_match:%c 0x%x <=3D 0x%x <=3D 0x%x",invert? '!':=
' ',
+              min,id,max);
+       r=3D(id >=3D min && id <=3D max) ^ invert;
+       DEBUGP(" result %s\n",r? "PASS" : "FAILED");
+       return r;
+}
+
+static int
+match(const struct sk_buff *skb,
+      const struct net_device *in,
+      const struct net_device *out,
+      const void *matchinfo,
+      int offset,
+      const void *protohdr,
+      u_int16_t datalen,
+      int *hotdrop)
+{
+       struct ipv6_rt_hdr *route =3D NULL;
+       const struct ip6t_rt *rtinfo =3D matchinfo;
+       unsigned int temp;
+       unsigned int len;
+       u8 nexthdr;
+       unsigned int ptr;
+       unsigned int hdrlen =3D 0;
+       unsigned int ret =3D 0;
+
+       /* type of the 1st exthdr */
+       nexthdr =3D skb->nh.ipv6h->nexthdr;
+       /* pointer to the 1st exthdr */
+       ptr =3D sizeof(struct ipv6hdr);
+       /* available length */
+       len =3D skb->len - ptr;
+       temp =3D 0;
+
+        while (ipv6_ext_hdr(nexthdr)) {
+               struct ipv6_opt_hdr *hdr;
+
+              DEBUGP("ipv6_rt header iteration \n");
+
+              /* Is there enough space for the next ext header? */
+                if (len < (int)sizeof(struct ipv6_opt_hdr))
+                        return 0;
+              /* No more exthdr -> evaluate */
+                if (nexthdr =3D=3D NEXTHDR_NONE) {
+                     break;
+              }
+              /* ESP -> evaluate */
+                if (nexthdr =3D=3D NEXTHDR_ESP) {
+                     break;
+              }
+
+              hdr=3D(struct ipv6_opt_hdr *)skb->data+ptr;
+
+              /* Calculate the header length */
+                if (nexthdr =3D=3D NEXTHDR_FRAGMENT) {
+                        hdrlen =3D 8;
+                } else if (nexthdr =3D=3D NEXTHDR_AUTH)
+                        hdrlen =3D (hdr->hdrlen+2)<<2;
+                else
+                        hdrlen =3D ipv6_optlen(hdr);
+
+              /* ROUTING -> evaluate */
+                if (nexthdr =3D=3D NEXTHDR_ROUTING) {
+                     temp |=3D MASK_ROUTING;
+                     break;
+              }
+
+
+              /* set the flag */
+              switch (nexthdr){
+                     case NEXTHDR_HOP:
+                     case NEXTHDR_ROUTING:
+                     case NEXTHDR_FRAGMENT:
+                     case NEXTHDR_AUTH:
+                     case NEXTHDR_DEST:
+                            break;
+                     default:
+                            DEBUGP("ipv6_rt match: unknown nextheader %u\n=
",nexthdr);
+                            return 0;
+                            break;
+              }
+
+                nexthdr =3D hdr->nexthdr;
+                len -=3D hdrlen;
+                ptr +=3D hdrlen;
+		if ( ptr > skb->len ) {
+			DEBUGP("ipv6_rt: new pointer is too large! \n");
+			break;
+		}
+        }
+
+       /* ROUTING header not found */
+       if ( temp !=3D MASK_ROUTING ) return 0;
+
+       if (len < (int)sizeof(struct ipv6_rt_hdr)){
+	       *hotdrop =3D 1;
+       		return 0;
+       }
+
+       if (len < hdrlen){
+	       /* Pcket smaller than its length field */
+       		return 0;
+       }
+
+       route=3Dskb->data+ptr;
+
+       DEBUGP("IPv6 RT LEN %u %u ", hdrlen, route->hdrlen);
+       DEBUGP("TYPE %04X ", route->type);
+       DEBUGP("SGS_LEFT %u %08X\n", ntohl(route->segments_left), ntohl(rou=
te->segments_left));
+
+       DEBUGP("IPv6 RT segsleft %02X ",
+       		(segsleft_match(rtinfo->segsleft[0], rtinfo->segsleft[1],
+                           ntohl(route->segments_left),
+                           !!(rtinfo->invflags & IP6T_RT_INV_SGS))));
+       DEBUGP("type %02X %02X %02X ",
+       		rtinfo->rt_type, route->type,=20
+       		(!(rtinfo->flags & IP6T_RT_TYP) ||
+                           ((rtinfo->rt_type =3D=3D route->type) ^
+                           !!(rtinfo->invflags & IP6T_RT_INV_TYP))));
+       DEBUGP("len %02X %04X %02X ",
+       		rtinfo->hdrlen, hdrlen,
+       		(!(rtinfo->flags & IP6T_RT_LEN) ||
+                           ((rtinfo->hdrlen =3D=3D hdrlen) ^
+                           !!(rtinfo->invflags & IP6T_RT_INV_LEN))));
+       DEBUGP("res %02X %02X %02X ",=20
+       		(rtinfo->flags & IP6T_RT_RES), ((struct rt0_hdr *)route)->bitmap,
+       		!((rtinfo->flags & IP6T_RT_RES) && (((struct rt0_hdr *)route)->bi=
tmap)));
+
+       ret =3D (route !=3D NULL)
+       		&&
+       		(segsleft_match(rtinfo->segsleft[0], rtinfo->segsleft[1],
+                           ntohl(route->segments_left),
+                           !!(rtinfo->invflags & IP6T_RT_INV_SGS)))
+		&&
+	      	(!(rtinfo->flags & IP6T_RT_LEN) ||
+                           ((rtinfo->hdrlen =3D=3D hdrlen) ^
+                           !!(rtinfo->invflags & IP6T_RT_INV_LEN)))
+		&&
+       		(!(rtinfo->flags & IP6T_RT_TYP) ||
+                           ((rtinfo->rt_type =3D=3D route->type) ^
+                           !!(rtinfo->invflags & IP6T_RT_INV_TYP)))
+		&&
+       		!((rtinfo->flags & IP6T_RT_RES) && (((struct rt0_hdr *)route)->bi=
tmap));
+
+	DEBUGP("#%d ",rtinfo->addrnr);
+       temp =3D len =3D ptr =3D 0;
+       if ( !(rtinfo->flags & IP6T_RT_FST) ){
+	       return ret;
+	} else if (rtinfo->flags & IP6T_RT_FST_NSTRICT) {
+		DEBUGP("Not strict ");
+		if ( rtinfo->addrnr > (unsigned int)((hdrlen-8)/16) ){
+			DEBUGP("There isn't enough space\n");
+			return 0;
+		} else {
+			DEBUGP("#%d ",rtinfo->addrnr);
+			ptr =3D 0;
+			for(temp=3D0; temp<(unsigned int)((hdrlen-8)/16); temp++){
+				len =3D 0;
+				while ((u8)(((struct rt0_hdr *)route)->
+						addr[temp].s6_addr[len]) =3D=3D
+					(u8)(rtinfo->addrs[ptr].s6_addr[len])){
+					DEBUGP("%02X?%02X ",
+		(u8)(((struct rt0_hdr *)route)->addr[temp].s6_addr[len]),
+					(u8)(rtinfo->addrs[ptr].s6_addr[len]));
+					len++;
+					if ( len =3D=3D 16 ) break;
+				}
+				if (len=3D=3D16) {
+					DEBUGP("ptr=3D%d temp=3D%d;\n",ptr,temp);
+					ptr++;
+				} else {
+					DEBUGP("%02X?%02X ",
+		(u8)(((struct rt0_hdr *)route)->addr[temp].s6_addr[len]),
+					(u8)(rtinfo->addrs[ptr].s6_addr[len]));
+					DEBUGP("!ptr=3D%d temp=3D%d;\n",ptr,temp);
+				}
+				if (ptr=3D=3Drtinfo->addrnr) break;
+			}
+			DEBUGP("ptr=3D%d len=3D%d #%d\n",ptr,len, rtinfo->addrnr);
+			if ( (len =3D=3D 16) && (ptr =3D=3D rtinfo->addrnr))
+				return ret;
+			else return 0;
+		}
+	} else {
+		DEBUGP("Strict ");
+		if ( rtinfo->addrnr > (unsigned int)((hdrlen-8)/16) ){
+			DEBUGP("There isn't enough space\n");
+			return 0;
+		} else {
+			DEBUGP("#%d ",rtinfo->addrnr);
+			for(temp=3D0; temp<rtinfo->addrnr; temp++){
+				len =3D 0;
+				while ((u8)(((struct rt0_hdr *)route)->
+						addr[temp].s6_addr[len]) =3D=3D
+					(u8)(rtinfo->addrs[temp].s6_addr[len])){
+					DEBUGP("%02X?%02X ",
+		(u8)(((struct rt0_hdr *)route)->addr[temp].s6_addr[len]),
+					(u8)(rtinfo->addrs[temp].s6_addr[len]));
+					len++;
+					if ( len =3D=3D 16 ) break;
+				}
+				if (len!=3D16) {
+					DEBUGP("%02X?%02X ",
+		(u8)(((struct rt0_hdr *)route)->addr[temp].s6_addr[len]),
+					(u8)(rtinfo->addrs[temp].s6_addr[len]));
+					DEBUGP("!len=3D%d temp=3D%d;\n",len,temp);
+					break;
+				}
+			}
+			DEBUGP("temp=3D%d len=3D%d #%d\n",temp,len,rtinfo->addrnr);
+			if ( (len =3D=3D 16) && (temp =3D=3D rtinfo->addrnr) && (temp =3D=3D (u=
nsigned int)((hdrlen-8)/16)))
+				return ret;
+			else return 0;
+		}
+	}
+
+	return 0;
+}
+
+/* Called when user tries to insert an entry of this type. */
+static int
+checkentry(const char *tablename,
+          const struct ip6t_ip6 *ip,
+          void *matchinfo,
+          unsigned int matchinfosize,
+          unsigned int hook_mask)
+{
+       const struct ip6t_rt *rtinfo =3D matchinfo;
+
+       if (matchinfosize !=3D IP6T_ALIGN(sizeof(struct ip6t_rt))) {
+              DEBUGP("ip6t_rt: matchsize %u !=3D %u\n",
+                      matchinfosize, IP6T_ALIGN(sizeof(struct ip6t_rt)));
+              return 0;
+       }
+       if (rtinfo->invflags & ~IP6T_RT_INV_MASK) {
+              DEBUGP("ip6t_rt: unknown flags %X\n",
+                      rtinfo->invflags);
+              return 0;
+       }
+       if ( (rtinfo->flags & (IP6T_RT_RES|IP6T_RT_FST_MASK)) &&=20
+		       (!(rtinfo->flags & IP6T_RT_TYP) ||=20
+		       (rtinfo->rt_type !=3D 0) ||=20
+		       (rtinfo->invflags & IP6T_RT_INV_TYP)) ) {
+	      DEBUGP("`--rt-type 0' required before `--rt-0-*'");
+              return 0;
+       }
+
+       return 1;
+}
+
+static struct ip6t_match rt_match
+=3D { { NULL, NULL }, "rt", &match, &checkentry, NULL, THIS_MODULE };
+
+static int __init init(void)
+{
+       return ip6t_register_match(&rt_match);
+}
+
+static void __exit cleanup(void)
+{
+       ip6t_unregister_match(&rt_match);
+}
+
+module_init(init);
+module_exit(cleanup);
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--uh9ZiVrAOUUm9fzH
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+Xf8iXaXGVTD0i/8RAs21AJ4lKSsHq1P2c5Li44hrxd0cCuiK+gCgh9ym
PYavuhMulu3DvxrPlZHUmeo=
=10iV
-----END PGP SIGNATURE-----

--uh9ZiVrAOUUm9fzH--
