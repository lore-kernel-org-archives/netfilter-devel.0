From: "zze-Ganesh KERDONCUFF G ext RD-MAPS-REN"
	<gkerdoncuff.ext@orange-ftgroup.com>
Subject: [PATCH] Update SNMP basic for full IP address NAT
Date: Fri, 3 Nov 2006 11:44:58 +0100
Message-ID: <3418F3471F1CA4409901547349FFAE2E05A05077@FTRDMEL2.rd.francetelecom.fr>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
To: <netfilter-devel@lists.netfilter.org>
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

=20
All,

This patch applies to the netfilter file   nat_ip_snmp_basic.c

The algorithm now applies NAT to the complete IP address (and not only
the first byte) It also recomputes the UDP checksum accordingly.

Please apply this patch to the 2.6.18.1 official release.

Many thanks to Remy Harel for his early contributions on this code.

Gilles Kerdoncuff

---

--- linux-2.6.18.1/net/ipv4/netfilter/ip_nat_snmp_basic.c
2006-10-14 05:34:03.000000000 +0200
+++ linux/net/ipv4/netfilter/ip_nat_snmp_basic.c	2006-11-02
17:02:24.000000000 +0100
@@ -70,14 +70,12 @@
 static DEFINE_SPINLOCK(snmp_lock);
=20
 /*
- * Application layer address mapping mimics the NAT mapping, but
- * only for the first octet in this case (a more flexible system
- * can be implemented if needed).
+ * Application layer address mapping (complete IP)
  */
-struct oct1_map
+struct ip_map
 {
-	u_int8_t from;
-	u_int8_t to;
+	u_int32_t from;
+	u_int32_t to;
 };
=20
                                  =20
@@ -612,7 +610,7 @@
=20
 static inline void mangle_address(unsigned char *begin,
                                   unsigned char *addr,
-                                  const struct oct1_map *map,
+                                  const struct ip_map *map,
                                   u_int16_t *check);  struct snmp_cnv
{ @@ -907,6 +905,23 @@
 	csum[1] =3D x & 0xFF;
 }
=20
+/* Fast checksum update on 16 bits */
+static void update_csum(u_int16_t *csum,
+                        u_int16_t *old_addr,
+                        u_int16_t *new_addr,
+                        int       odd)
+{
+	/* The idea is to call 4 times the fast csum function which
recalculate the new
+	 * csum according to the new ip address in the payload
+	 */
+	int i;
+	for (i=3D0;i<4;i++) {
+		fast_csum((unsigned char*)csum, ((const unsigned
char*)(old_addr))+i, ((const unsigned char*)(new_addr))+i,(odd+i)%2 );
+	}
+}
+
+
+
 /*
  * Mangle IP address.
  * 	- begin points to the start of the snmp messgae
@@ -914,24 +929,22 @@
  */
 static inline void mangle_address(unsigned char *begin,
                                   unsigned char *addr,
-                                  const struct oct1_map *map,
+                                  const struct ip_map *map,
                                   u_int16_t *check)  {
-	if (map->from =3D=3D NOCT1(*addr)) {
-		u_int32_t old;
-	=09
-		if (debug)
-			memcpy(&old, (unsigned char *)addr,
sizeof(old));
-		=09
-		*addr =3D map->to;
-	=09
+	u_int32_t old;
+
+	memcpy(&old, (unsigned char *)addr, sizeof(old));
+
+	if (map->from =3D=3D old) {
+		*((u_int32_t*) addr) =3D map->to;
+
 		/* Update UDP checksum if being used */
 		if (*check) {
 			unsigned char odd =3D !((addr - begin) % 2);
 		=09
-			fast_csum((unsigned char *)check,
-			          &map->from, &map->to, odd);
-			         =20
+			update_csum(check, (u_int16_t*)&old,
(u_int16_t*)addr, odd);
+
 		}
 	=09
 		if (debug)
@@ -942,7 +955,7 @@
=20
 static unsigned char snmp_trap_decode(struct asn1_ctx *ctx,
                                       struct snmp_v1_trap *trap,
-                                      const struct oct1_map *map,
+                                      const struct ip_map *map,
                                       u_int16_t *check)  {
 	unsigned int cls, con, tag, len;
@@ -1036,7 +1049,7 @@
  */
 static int snmp_parse_mangle(unsigned char *msg,
                              u_int16_t len,
-                             const struct oct1_map *map,
+                             const struct ip_map *map,
                              u_int16_t *check)  {
 	unsigned char *eoc, *end;
@@ -1215,7 +1228,7 @@
 	u_int16_t udplen =3D ntohs(udph->len);
 	u_int16_t paylen =3D udplen - sizeof(struct udphdr);
 	int dir =3D CTINFO2DIR(ctinfo);
-	struct oct1_map map;
+	struct ip_map map;
=20
 	/*
 	 * Determine mappping for application layer addresses based @@
-1223,12 +1236,12 @@
 	 */
 	if (dir =3D=3D IP_CT_DIR_ORIGINAL) {
 		/* SNAT traps */
-		map.from =3D
NOCT1(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip);
-		map.to =3D
NOCT1(ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip);
+		map.from =3D
ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
+		map.to =3D ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip;
 	} else {
 		/* DNAT replies */
-		map.from =3D
NOCT1(ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip);
-		map.to =3D
NOCT1(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip);
+		map.from =3D ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip;
+		map.to =3D ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip;
 	}
 =09
 	if (map.from =3D=3D map.to)
