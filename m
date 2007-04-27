From: "Jorge Boncompte [DTI2]" <jorge@dti2.net>
Subject: [PATCH] xx_nat_proto_gre: do not modify/corrupt GREv0 packets
	thought NAT
Date: Fri, 27 Apr 2007 13:47:52 +0200
Message-ID: <00ef01c788c1$e32a62e0$061010ac@intranet.dti2.net>
References: <00c501c7829e$6209edd0$061010ac@intranet.dti2.net>	<462DFD1D.1060706@trash.net>
	<101c01c78829$24a70230$061010ac@intranet.dti2.net>
	<4631DCA3.4020701@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_00EC_01C788D2.A6708490"
Cc: netfilter-devel@lists.netfilter.org
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

This is a multi-part message in MIME format.

------=_NextPart_000_00EC_01C788D2.A6708490
Content-Type: text/plain; format=flowed; charset="iso-8859-15";
	reply-type=original
Content-Transfer-Encoding: 7bit

----- Original Message ----- 
From: "Patrick McHardy" <kaber@trash.net>
To: "Jorge Boncompte [DTI2]" <jorge@dti2.net>
Cc: <netfilter-devel@lists.netfilter.org>
Sent: Friday, April 27, 2007 1:21 PM
Subject: Re: [PATCH] xx_nat_proto_gre: gre_key returns wrong pointer


>> + /* If there is no master conntrack we are not PPTP,
>> +    do not change tuples */
>> + if (!conntrack->master)
>> +  return 0;
>> +
>
>
> Thats a good idea, I thought it would be more complicated to
> determine the kind of connection in get_unique_tuple() since
> it doesn't get to see the packet.
>
> Please sign off on the patch so I can apply it.

    To be fair I thought that it were to be more complicated too and the 
only way that I could see to determine the kind of connection was to add the 
version field again to the tuple. What ringed some bells in my head was that 
I saw a line "no master !?!" from the DEBUGP statement on 
xx_conntrack_proto_gre::gre_destroy while looking at the logs ;-)

    -Jorge

---
From: Jorge Boncompte <jorge@dti2.net>

    Hi,

    While porting some changes of the 2.6.21-rc7 pptp/proto_gre conntrack
and nat modules to a 2.4.32 kernel I noticed that the gre_key function
returns a wrong pointer to the GRE key of a version 0 packet thus corrupting
the packet payload.
    The intended behaviour for GREv0 packets is to act like
nf_conntrack_proto_generic/nf_nat_proto_unknown so I have ripped the
offending functions (not used anymore) and modified the xx_nat_proto_gre
modules to not touch version 0 (non PPTP) packets.

Signed-off-by: Jorge Boncompte <jorge@dti2.net>

---
diff -uNr linux-2.6.21.orig/include/linux/netfilter/nf_conntrack_proto_gre.h 
linux-2.6.21/include/linux/netfilter/nf_conntrack_proto_gre.h
--- linux-2.6.21.orig/include/linux/netfilter/nf_conntrack_proto_gre.h 
2007-04-26 18:10:56.000000000 +0200
+++ linux-2.6.21/include/linux/netfilter/nf_conntrack_proto_gre.h 2007-04-26 
18:53:58.000000000 +0200
@@ -87,24 +87,6 @@
 /* delete keymap entries */
 void nf_ct_gre_keymap_destroy(struct nf_conn *ct);

-/* get pointer to gre key, if present */
-static inline __be32 *gre_key(struct gre_hdr *greh)
-{
- if (!greh->key)
-  return NULL;
- if (greh->csum || greh->routing)
-  return (__be32 *)(greh+sizeof(*greh)+4);
- return (__be32 *)(greh+sizeof(*greh));
-}
-
-/* get pointer ot gre csum, if present */
-static inline __sum16 *gre_csum(struct gre_hdr *greh)
-{
- if (!greh->csum)
-  return NULL;
- return (__sum16 *)(greh+sizeof(*greh));
-}
-
 extern void nf_ct_gre_keymap_flush(void);
 extern void nf_nat_need_gre(void);

diff -uNr 
linux-2.6.21.orig/include/linux/netfilter_ipv4/ip_conntrack_proto_gre.h 
linux-2.6.21/include/linux/netfilter_ipv4/ip_conntrack_proto_gre.h
--- linux-2.6.21.orig/include/linux/netfilter_ipv4/ip_conntrack_proto_gre.h 
2007-04-26 18:10:56.000000000 +0200
+++ linux-2.6.21/include/linux/netfilter_ipv4/ip_conntrack_proto_gre.h 
2007-04-26 18:54:39.000000000 +0200
@@ -90,25 +90,6 @@
 /* delete keymap entries */
 void ip_ct_gre_keymap_destroy(struct ip_conntrack *ct);

-
-/* get pointer to gre key, if present */
-static inline __be32 *gre_key(struct gre_hdr *greh)
-{
- if (!greh->key)
-  return NULL;
- if (greh->csum || greh->routing)
-  return (__be32 *) (greh+sizeof(*greh)+4);
- return (__be32 *) (greh+sizeof(*greh));
-}
-
-/* get pointer ot gre csum, if present */
-static inline __sum16 *gre_csum(struct gre_hdr *greh)
-{
- if (!greh->csum)
-  return NULL;
- return (__sum16 *) (greh+sizeof(*greh));
-}
-
 #endif /* __KERNEL__ */

 #endif /* _CONNTRACK_PROTO_GRE_H */
diff -uNr -X /root/diff-no-incluir 
linux-2.6.21.orig/net/ipv4/netfilter/ip_nat_proto_gre.c 
linux-2.6.21/net/ipv4/netfilter/ip_nat_proto_gre.c
--- linux-2.6.21.orig/net/ipv4/netfilter/ip_nat_proto_gre.c 2007-04-26 
18:10:57.000000000 +0200
+++ linux-2.6.21/net/ipv4/netfilter/ip_nat_proto_gre.c 2007-04-26 
19:01:02.000000000 +0200
@@ -70,6 +70,11 @@
  __be16 *keyptr;
  unsigned int min, i, range_size;

+ /* If there is no master conntrack we are not PPTP,
+    do not change tuples */
+ if (!conntrack->master)
+  return 0;
+
  if (maniptype == IP_NAT_MANIP_SRC)
   keyptr = &tuple->src.u.gre.key;
  else
@@ -122,18 +127,9 @@
  if (maniptype == IP_NAT_MANIP_DST) {
   /* key manipulation is always dest */
   switch (greh->version) {
-  case 0:
-   if (!greh->key) {
-    DEBUGP("can't nat GRE w/o key\n");
-    break;
-   }
-   if (greh->csum) {
-    /* FIXME: Never tested this code... */
-    nf_proto_csum_replace4(gre_csum(greh), *pskb,
-       *(gre_key(greh)),
-       tuple->dst.u.gre.key, 0);
-   }
-   *(gre_key(greh)) = tuple->dst.u.gre.key;
+  case GRE_VERSION_1701:
+   /* FIXME: We do not currently NAT any GREv0 packets */
+   /* try to behave like "ip_nat_proto_unknown" */
    break;
   case GRE_VERSION_PPTP:
    DEBUGP("call_id -> 0x%04x\n",
diff -uNr linux-2.6.21.orig/net/ipv4/netfilter/nf_nat_proto_gre.c 
linux-2.6.21/net/ipv4/netfilter/nf_nat_proto_gre.c
--- linux-2.6.21.orig/net/ipv4/netfilter/nf_nat_proto_gre.c 2007-04-26 
18:11:11.000000000 +0200
+++ linux-2.6.21/net/ipv4/netfilter/nf_nat_proto_gre.c 2007-04-26 
19:01:25.000000000 +0200
@@ -72,6 +72,11 @@
  __be16 *keyptr;
  unsigned int min, i, range_size;

+ /* If there is no master conntrack we are not PPTP,
+    do not change tuples */
+ if (!conntrack->master)
+  return 0;
+
  if (maniptype == IP_NAT_MANIP_SRC)
   keyptr = &tuple->src.u.gre.key;
  else
@@ -122,18 +127,9 @@
  if (maniptype != IP_NAT_MANIP_DST)
   return 1;
  switch (greh->version) {
- case 0:
-  if (!greh->key) {
-   DEBUGP("can't nat GRE w/o key\n");
-   break;
-  }
-  if (greh->csum) {
-   /* FIXME: Never tested this code... */
-   nf_proto_csum_replace4(gre_csum(greh), *pskb,
-            *(gre_key(greh)),
-            tuple->dst.u.gre.key, 0);
-  }
-  *(gre_key(greh)) = tuple->dst.u.gre.key;
+ case GRE_VERSION_1701:
+  /* FIXME: We do not currently NAT any GREv0 packets */
+  /* try to behave like "nf_nat_proto_unknown" */
   break;
  case GRE_VERSION_PPTP:
   DEBUGP("call_id -> 0x%04x\n", ntohs(tuple->dst.u.gre.key));



------=_NextPart_000_00EC_01C788D2.A6708490
Content-Type: application/octet-stream;
	name="nat-proto-gre-patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="nat-proto-gre-patch"

diff -uNr =
linux-2.6.21.orig/include/linux/netfilter/nf_conntrack_proto_gre.h =
linux-2.6.21/include/linux/netfilter/nf_conntrack_proto_gre.h=0A=
--- linux-2.6.21.orig/include/linux/netfilter/nf_conntrack_proto_gre.h	=
2007-04-26 18:10:56.000000000 +0200=0A=
+++ linux-2.6.21/include/linux/netfilter/nf_conntrack_proto_gre.h	=
2007-04-26 18:53:58.000000000 +0200=0A=
@@ -87,24 +87,6 @@=0A=
 /* delete keymap entries */=0A=
 void nf_ct_gre_keymap_destroy(struct nf_conn *ct);=0A=
 =0A=
-/* get pointer to gre key, if present */=0A=
-static inline __be32 *gre_key(struct gre_hdr *greh)=0A=
-{=0A=
-	if (!greh->key)=0A=
-		return NULL;=0A=
-	if (greh->csum || greh->routing)=0A=
-		return (__be32 *)(greh+sizeof(*greh)+4);=0A=
-	return (__be32 *)(greh+sizeof(*greh));=0A=
-}=0A=
-=0A=
-/* get pointer ot gre csum, if present */=0A=
-static inline __sum16 *gre_csum(struct gre_hdr *greh)=0A=
-{=0A=
-	if (!greh->csum)=0A=
-		return NULL;=0A=
-	return (__sum16 *)(greh+sizeof(*greh));=0A=
-}=0A=
-=0A=
 extern void nf_ct_gre_keymap_flush(void);=0A=
 extern void nf_nat_need_gre(void);=0A=
 =0A=
diff -uNr =
linux-2.6.21.orig/include/linux/netfilter_ipv4/ip_conntrack_proto_gre.h =
linux-2.6.21/include/linux/netfilter_ipv4/ip_conntrack_proto_gre.h=0A=
--- =
linux-2.6.21.orig/include/linux/netfilter_ipv4/ip_conntrack_proto_gre.h	=
2007-04-26 18:10:56.000000000 +0200=0A=
+++ linux-2.6.21/include/linux/netfilter_ipv4/ip_conntrack_proto_gre.h	=
2007-04-26 18:54:39.000000000 +0200=0A=
@@ -90,25 +90,6 @@=0A=
 /* delete keymap entries */=0A=
 void ip_ct_gre_keymap_destroy(struct ip_conntrack *ct);=0A=
 =0A=
-=0A=
-/* get pointer to gre key, if present */=0A=
-static inline __be32 *gre_key(struct gre_hdr *greh)=0A=
-{=0A=
-	if (!greh->key)=0A=
-		return NULL;=0A=
-	if (greh->csum || greh->routing)=0A=
-		return (__be32 *) (greh+sizeof(*greh)+4);=0A=
-	return (__be32 *) (greh+sizeof(*greh));=0A=
-}=0A=
-=0A=
-/* get pointer ot gre csum, if present */=0A=
-static inline __sum16 *gre_csum(struct gre_hdr *greh)=0A=
-{=0A=
-	if (!greh->csum)=0A=
-		return NULL;=0A=
-	return (__sum16 *) (greh+sizeof(*greh));=0A=
-}=0A=
-=0A=
 #endif /* __KERNEL__ */=0A=
 =0A=
 #endif /* _CONNTRACK_PROTO_GRE_H */=0A=
diff -uNr linux-2.6.21.orig/net/ipv4/netfilter/ip_nat_proto_gre.c =
linux-2.6.21/net/ipv4/netfilter/ip_nat_proto_gre.c=0A=
--- linux-2.6.21.orig/net/ipv4/netfilter/ip_nat_proto_gre.c	2007-04-26 =
18:10:57.000000000 +0200=0A=
+++ linux-2.6.21/net/ipv4/netfilter/ip_nat_proto_gre.c	2007-04-26 =
19:01:02.000000000 +0200=0A=
@@ -70,6 +70,11 @@=0A=
 	__be16 *keyptr;=0A=
 	unsigned int min, i, range_size;=0A=
 =0A=
+	/* If there is no master conntrack we are not PPTP,=0A=
+	   do not change tuples */=0A=
+	if (!conntrack->master)=0A=
+		return 0;=0A=
+		=0A=
 	if (maniptype =3D=3D IP_NAT_MANIP_SRC)=0A=
 		keyptr =3D &tuple->src.u.gre.key;=0A=
 	else=0A=
@@ -122,18 +127,9 @@=0A=
 	if (maniptype =3D=3D IP_NAT_MANIP_DST) {=0A=
 		/* key manipulation is always dest */=0A=
 		switch (greh->version) {=0A=
-		case 0:=0A=
-			if (!greh->key) {=0A=
-				DEBUGP("can't nat GRE w/o key\n");=0A=
-				break;=0A=
-			}=0A=
-			if (greh->csum) {=0A=
-				/* FIXME: Never tested this code... */=0A=
-				nf_proto_csum_replace4(gre_csum(greh), *pskb,=0A=
-							*(gre_key(greh)),=0A=
-							tuple->dst.u.gre.key, 0);=0A=
-			}=0A=
-			*(gre_key(greh)) =3D tuple->dst.u.gre.key;=0A=
+		case GRE_VERSION_1701:=0A=
+			/* FIXME: We do not currently NAT any GREv0 packets */=0A=
+			/* try to behave like "ip_nat_proto_unknown" */=0A=
 			break;=0A=
 		case GRE_VERSION_PPTP:=0A=
 			DEBUGP("call_id -> 0x%04x\n",=0A=
diff -uNr linux-2.6.21.orig/net/ipv4/netfilter/nf_nat_proto_gre.c =
linux-2.6.21/net/ipv4/netfilter/nf_nat_proto_gre.c=0A=
--- linux-2.6.21.orig/net/ipv4/netfilter/nf_nat_proto_gre.c	2007-04-26 =
18:11:11.000000000 +0200=0A=
+++ linux-2.6.21/net/ipv4/netfilter/nf_nat_proto_gre.c	2007-04-26 =
19:01:25.000000000 +0200=0A=
@@ -72,6 +72,11 @@=0A=
 	__be16 *keyptr;=0A=
 	unsigned int min, i, range_size;=0A=
 =0A=
+	/* If there is no master conntrack we are not PPTP,=0A=
+	   do not change tuples */=0A=
+	if (!conntrack->master)=0A=
+		return 0;=0A=
+		=0A=
 	if (maniptype =3D=3D IP_NAT_MANIP_SRC)=0A=
 		keyptr =3D &tuple->src.u.gre.key;=0A=
 	else=0A=
@@ -122,18 +127,9 @@=0A=
 	if (maniptype !=3D IP_NAT_MANIP_DST)=0A=
 		return 1;=0A=
 	switch (greh->version) {=0A=
-	case 0:=0A=
-		if (!greh->key) {=0A=
-			DEBUGP("can't nat GRE w/o key\n");=0A=
-			break;=0A=
-		}=0A=
-		if (greh->csum) {=0A=
-			/* FIXME: Never tested this code... */=0A=
-			nf_proto_csum_replace4(gre_csum(greh), *pskb,=0A=
-					       *(gre_key(greh)),=0A=
-					       tuple->dst.u.gre.key, 0);=0A=
-		}=0A=
-		*(gre_key(greh)) =3D tuple->dst.u.gre.key;=0A=
+	case GRE_VERSION_1701:=0A=
+		/* FIXME: We do not currently NAT any GREv0 packets */=0A=
+		/* try to behave like "nf_nat_proto_unknown" */=0A=
 		break;=0A=
 	case GRE_VERSION_PPTP:=0A=
 		DEBUGP("call_id -> 0x%04x\n", ntohs(tuple->dst.u.gre.key));=0A=

------=_NextPart_000_00EC_01C788D2.A6708490--
