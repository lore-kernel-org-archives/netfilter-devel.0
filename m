From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6] NETFILTER (8/x): new ipt_sctp match
Date: Sat, 24 Jul 2004 10:52:39 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040724145239.GQ2848@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Sr/1Pkwuhjf1+ztR"
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


--Sr/1Pkwuhjf1+ztR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

This patch adds ipt_sctp, enabling iptables to match on sctp ports and
chunktypes.

Signed-off-by: Kiran Kumar Immidi <immidi_kiran@yahoo.com>
Signed-off-by: Harald Welte <laforge@netfilter.org>

diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.8-rc2-updates-modparm-expslab-ctacct-ctseq//incl=
ude/linux/netfilter_ipv4/ipt_sctp.h linux-2.6.8-rc2-updates-modparm-expslab=
-ctacct-sctp//include/linux/netfilter_ipv4/ipt_sctp.h
--- linux-2.6.8-rc2-updates-modparm-expslab-ctacct-ctseq//include/linux/net=
filter_ipv4/ipt_sctp.h	1969-12-31 19:00:00.000000000 -0500
+++ linux-2.6.8-rc2-updates-modparm-expslab-ctacct-sctp//include/linux/netf=
ilter_ipv4/ipt_sctp.h	2004-07-24 10:49:54.048505968 -0400
@@ -0,0 +1,107 @@
+#ifndef _IPT_SCTP_H_
+#define _IPT_SCTP_H_
+
+#define IPT_SCTP_SRC_PORTS	        0x01
+#define IPT_SCTP_DEST_PORTS	        0x02
+#define IPT_SCTP_CHUNK_TYPES		0x04
+
+#define IPT_SCTP_VALID_FLAGS		0x07
+
+#define ELEMCOUNT(x) (sizeof(x)/sizeof(x[0]))
+
+
+struct ipt_sctp_flag_info {
+	u_int8_t chunktype;
+	u_int8_t flag;
+	u_int8_t flag_mask;
+};
+
+#define IPT_NUM_SCTP_FLAGS	4
+
+struct ipt_sctp_info {
+	u_int16_t dpts[2];  /* Min, Max */
+	u_int16_t spts[2];  /* Min, Max */
+
+	u_int32_t chunkmap[256 / sizeof (u_int32_t)];  /* Bit mask of chunks to b=
e matched according to RFC 2960 */
+
+#define SCTP_CHUNK_MATCH_ANY   0x01  /* Match if any of the chunk types ar=
e present */
+#define SCTP_CHUNK_MATCH_ALL   0x02  /* Match if all of the chunk types ar=
e present */
+#define SCTP_CHUNK_MATCH_ONLY  0x04  /* Match if these are the only chunk =
types present */
+
+	u_int32_t chunk_match_type;
+	struct ipt_sctp_flag_info flag_info[IPT_NUM_SCTP_FLAGS];
+	int flag_count;
+
+	u_int32_t flags;
+	u_int32_t invflags;
+};
+
+#define bytes(type) (sizeof(type) * 8)
+
+#define SCTP_CHUNKMAP_SET(chunkmap, type) 		\
+	do { 						\
+		chunkmap[type / bytes(u_int32_t)] |=3D 	\
+			1 << (type % bytes(u_int32_t));	\
+	} while (0)
+
+#define SCTP_CHUNKMAP_CLEAR(chunkmap, type)		 	\
+	do {							\
+		chunkmap[type / bytes(u_int32_t)] &=3D 		\
+			~(1 << (type % bytes(u_int32_t)));	\
+	} while (0)
+
+#define SCTP_CHUNKMAP_IS_SET(chunkmap, type) 			\
+({								\
+	(chunkmap[type / bytes (u_int32_t)] & 			\
+		(1 << (type % bytes (u_int32_t)))) ? 1: 0;	\
+})
+
+#define SCTP_CHUNKMAP_RESET(chunkmap) 				\
+	do {							\
+		int i; 						\
+		for (i =3D 0; i < ELEMCOUNT(chunkmap); i++)	\
+			chunkmap[i] =3D 0;			\
+	} while (0)
+
+#define SCTP_CHUNKMAP_SET_ALL(chunkmap) 			\
+	do {							\
+		int i; 						\
+		for (i =3D 0; i < ELEMCOUNT(chunkmap); i++) 	\
+			chunkmap[i] =3D ~0;			\
+	} while (0)
+
+#define SCTP_CHUNKMAP_COPY(destmap, srcmap) 			\
+	do {							\
+		int i; 						\
+		for (i =3D 0; i < ELEMCOUNT(chunkmap); i++) 	\
+			destmap[i] =3D srcmap[i];			\
+	} while (0)
+
+#define SCTP_CHUNKMAP_IS_CLEAR(chunkmap) 		\
+({							\
+	int i; 						\
+	int flag =3D 1;					\
+	for (i =3D 0; i < ELEMCOUNT(chunkmap); i++) {	\
+		if (chunkmap[i]) {			\
+			flag =3D 0;			\
+			break;				\
+		}					\
+	}						\
+        flag;						\
+})
+
+#define SCTP_CHUNKMAP_IS_ALL_SET(chunkmap) 		\
+({							\
+	int i; 						\
+	int flag =3D 1;					\
+	for (i =3D 0; i < ELEMCOUNT(chunkmap); i++) {	\
+		if (chunkmap[i] !=3D ~0) {		\
+			flag =3D 0;			\
+				break;			\
+		}					\
+	}						\
+        flag;						\
+})
+
+#endif /* _IPT_SCTP_H_ */
+
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.8-rc2-updates-modparm-expslab-ctacct-ctseq//net/=
ipv4/netfilter/Kconfig linux-2.6.8-rc2-updates-modparm-expslab-ctacct-sctp/=
/net/ipv4/netfilter/Kconfig
--- linux-2.6.8-rc2-updates-modparm-expslab-ctacct-ctseq//net/ipv4/netfilte=
r/Kconfig	2004-07-24 10:36:35.244942000 -0400
+++ linux-2.6.8-rc2-updates-modparm-expslab-ctacct-sctp//net/ipv4/netfilter=
/Kconfig	2004-07-24 10:49:54.054505056 -0400
@@ -632,5 +632,9 @@
 	bool "Connection tracking flow accounting"
 	depends on IP_NF_CONNTRACK
=20
+config IP_NF_MATCH_SCTP
+	tristate  'SCTP protocol match support'
+	depends on IP_NF_IPTABLES
+
 endmenu
=20
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.8-rc2-updates-modparm-expslab-ctacct-ctseq//net/=
ipv4/netfilter/Makefile linux-2.6.8-rc2-updates-modparm-expslab-ctacct-sctp=
//net/ipv4/netfilter/Makefile
--- linux-2.6.8-rc2-updates-modparm-expslab-ctacct-ctseq//net/ipv4/netfilte=
r/Makefile	2004-07-22 11:49:13.000000000 -0400
+++ linux-2.6.8-rc2-updates-modparm-expslab-ctacct-sctp//net/ipv4/netfilter=
/Makefile	2004-07-24 10:49:54.057504600 -0400
@@ -43,6 +43,7 @@
 # matches
 obj-$(CONFIG_IP_NF_MATCH_HELPER) +=3D ipt_helper.o
 obj-$(CONFIG_IP_NF_MATCH_LIMIT) +=3D ipt_limit.o
+obj-$(CONFIG_IP_NF_MATCH_SCTP) +=3D ipt_sctp.o
 obj-$(CONFIG_IP_NF_MATCH_MARK) +=3D ipt_mark.o
 obj-$(CONFIG_IP_NF_MATCH_MAC) +=3D ipt_mac.o
 obj-$(CONFIG_IP_NF_MATCH_IPRANGE) +=3D ipt_iprange.o
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.8-rc2-updates-modparm-expslab-ctacct-ctseq//net/=
ipv4/netfilter/ipt_sctp.c linux-2.6.8-rc2-updates-modparm-expslab-ctacct-sc=
tp//net/ipv4/netfilter/ipt_sctp.c
--- linux-2.6.8-rc2-updates-modparm-expslab-ctacct-ctseq//net/ipv4/netfilte=
r/ipt_sctp.c	1969-12-31 19:00:00.000000000 -0500
+++ linux-2.6.8-rc2-updates-modparm-expslab-ctacct-sctp//net/ipv4/netfilter=
/ipt_sctp.c	2004-07-24 10:49:54.049505816 -0400
@@ -0,0 +1,201 @@
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <net/ip.h>
+#include <linux/sctp.h>
+
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_sctp.h>
+
+#ifdef DEBUG_SCTP
+#define duprintf(format, args...) printk(format , ## args)
+#else
+#define duprintf(format, args...)
+#endif
+
+#define SCCHECK(cond, option, flag, invflag) (!((flag) & (option)) \
+					      || (!!((invflag) & (option)) ^ (cond)))
+
+static int
+match_flags(const struct ipt_sctp_flag_info *flag_info,
+	    const int flag_count,
+	    u_int8_t chunktype,
+	    u_int8_t chunkflags)
+{
+	int i;
+
+	for (i =3D 0; i < flag_count; i++) {
+		if (flag_info[i].chunktype =3D=3D chunktype) {
+			return (chunkflags & flag_info[i].flag_mask) =3D=3D flag_info[i].flag;
+		}
+	}
+
+	return 1;
+}
+
+static int
+match_packet(const struct sk_buff *skb,
+	     const u_int32_t *chunkmap,
+	     int chunk_match_type,
+	     const struct ipt_sctp_flag_info *flag_info,
+	     const int flag_count,
+	     int *hotdrop)
+{
+	int offset;
+	u_int32_t chunkmapcopy[256 / sizeof (u_int32_t)];
+	sctp_chunkhdr_t sch;
+
+#ifdef DEBUG_SCTP
+	int i =3D 0;
+#endif
+
+	if (chunk_match_type =3D=3D SCTP_CHUNK_MATCH_ALL) {
+		SCTP_CHUNKMAP_COPY(chunkmapcopy, chunkmap);
+	}
+
+	offset =3D skb->nh.iph->ihl * 4 + sizeof (sctp_sctphdr_t);
+	do {
+		if (skb_copy_bits(skb, offset, &sch, sizeof(sch)) < 0) {
+			duprintf("Dropping invalid SCTP packet.\n");
+			*hotdrop =3D 1;
+			return 0;
+        	}
+
+		duprintf("Chunk num: %d\toffset: %d\ttype: %d\tlength: %d\tflags: %x\n",=
=20
+				++i, offset, sch.type, htons(sch.length), sch.flags);
+
+		offset +=3D (htons(sch.length) + 3) & ~3;
+
+		duprintf("skb->len: %d\toffset: %d\n", skb->len, offset);
+
+		if (SCTP_CHUNKMAP_IS_SET(chunkmap, sch.type)) {
+			switch (chunk_match_type) {
+			case SCTP_CHUNK_MATCH_ANY:
+				if (match_flags(flag_info, flag_count,=20
+					sch.type, sch.flags)) {
+					return 1;
+				}
+				break;
+
+			case SCTP_CHUNK_MATCH_ALL:
+				if (match_flags(flag_info, flag_count,=20
+					sch.type, sch.flags)) {
+					SCTP_CHUNKMAP_CLEAR(chunkmapcopy, sch.type);
+				}
+				break;
+
+			case SCTP_CHUNK_MATCH_ONLY:
+				if (!match_flags(flag_info, flag_count,=20
+					sch.type, sch.flags)) {
+					return 0;
+				}
+				break;
+			}
+		} else {
+			switch (chunk_match_type) {
+			case SCTP_CHUNK_MATCH_ONLY:
+				return 0;
+			}
+		}
+	} while (offset < skb->len);
+
+	switch (chunk_match_type) {
+	case SCTP_CHUNK_MATCH_ALL:
+		return SCTP_CHUNKMAP_IS_CLEAR(chunkmap);
+	case SCTP_CHUNK_MATCH_ANY:
+		return 0;
+	case SCTP_CHUNK_MATCH_ONLY:
+		return 1;
+	}
+
+	/* This will never be reached, but required to stop compiler whine */
+	return 0;
+}
+
+static int
+match(const struct sk_buff *skb,
+      const struct net_device *in,
+      const struct net_device *out,
+      const void *matchinfo,
+      int offset,
+      int *hotdrop)
+{
+	const struct ipt_sctp_info *info;
+	sctp_sctphdr_t sh;
+
+	info =3D (const struct ipt_sctp_info *)matchinfo;
+
+	if (offset) {
+		duprintf("Dropping non-first fragment.. FIXME\n");
+		return 0;
+	}
+=09
+	if (skb_copy_bits(skb, skb->nh.iph->ihl*4, &sh, sizeof(sh)) < 0) {
+		duprintf("Dropping evil TCP offset=3D0 tinygram.\n");
+		*hotdrop =3D 1;
+		return 0;
+       	}
+	duprintf("spt: %d\tdpt: %d\n", ntohs(sh.source), ntohs(sh.dest));
+
+	return  SCCHECK(((ntohs(sh.source) >=3D info->spts[0])=20
+			&& (ntohs(sh.source) <=3D info->spts[1])),=20
+		   	IPT_SCTP_SRC_PORTS, info->flags, info->invflags)
+		&& SCCHECK(((ntohs(sh.dest) >=3D info->dpts[0])=20
+			&& (ntohs(sh.dest) <=3D info->dpts[1])),=20
+			IPT_SCTP_DEST_PORTS, info->flags, info->invflags)
+		&& SCCHECK(match_packet(skb, info->chunkmap, info->chunk_match_type,
+ 					info->flag_info, info->flag_count,=20
+					hotdrop),
+			   IPT_SCTP_CHUNK_TYPES, info->flags, info->invflags);
+}
+
+static int
+checkentry(const char *tablename,
+	   const struct ipt_ip *ip,
+	   void *matchinfo,
+	   unsigned int matchsize,
+	   unsigned int hook_mask)
+{
+	const struct ipt_sctp_info *info;
+
+	info =3D (const struct ipt_sctp_info *)matchinfo;
+
+	return ip->proto =3D=3D IPPROTO_SCTP
+		&& !(ip->invflags & IPT_INV_PROTO)
+		&& matchsize =3D=3D IPT_ALIGN(sizeof(struct ipt_sctp_info))
+		&& !(info->flags & ~IPT_SCTP_VALID_FLAGS)
+		&& !(info->invflags & ~IPT_SCTP_VALID_FLAGS)
+		&& !(info->invflags & ~info->flags)
+		&& ((!(info->flags & IPT_SCTP_CHUNK_TYPES)) ||=20
+			(info->chunk_match_type &
+				(SCTP_CHUNK_MATCH_ALL=20
+				| SCTP_CHUNK_MATCH_ANY
+				| SCTP_CHUNK_MATCH_ONLY)));
+}
+
+static struct ipt_match sctp_match =3D=20
+{=20
+	.list =3D { NULL, NULL},
+	.name =3D "sctp",
+	.match =3D &match,
+	.checkentry =3D &checkentry,
+	.destroy =3D NULL,
+	.me =3D THIS_MODULE
+};
+
+static int __init init(void)
+{
+	return ipt_register_match(&sctp_match);
+}
+
+static void __exit fini(void)
+{
+	ipt_unregister_match(&sctp_match);
+}
+
+module_init(init);
+module_exit(fini);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Kiran Kumar Immidi");
+MODULE_DESCRIPTION("Match for SCTP protocol packets");
+
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Sr/1Pkwuhjf1+ztR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFBAne3XaXGVTD0i/8RAiF/AJ9sZgRNehflw+TfphvZBSiw33rNRwCdHYzB
AIf+ooFpUt3lCvw0XiTk7yE=
=IDmf
-----END PGP SIGNATURE-----

--Sr/1Pkwuhjf1+ztR--
