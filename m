From: Scott Andrew Baillie <sbaillie@bigpond.net.au>
Subject: [PATCH] ip_tables.h does not compile when using g++
Date: 16 Sep 2002 15:31:35 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1032190296.458.21.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-yWqKrOE82nbaBg11n9RI"
Cc: Harald Welte <laforge@gnumonks.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter List <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-yWqKrOE82nbaBg11n9RI
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


Hi,

The following patch fixes the 3 places in ip_tables.h that involve
pointer arithmetic using a void* type.

Pointer arithmetic involving a void* type does not compile with g++.

The header file ip_tables.h is included by the kernel and by user
space programs so it should compile when using g++.

Regards,

Scott.




--=-yWqKrOE82nbaBg11n9RI
Content-Disposition: attachment; filename=linux-2.4.19-new.patch
Content-Transfer-Encoding: quoted-printable
Content-Type: text/x-patch; name=linux-2.4.19-new.patch; charset=ISO-8859-1

diff -ur linux-2.4.19/include/linux/netfilter_ipv4/ip_tables.h linux-2.4.19=
-new/include/linux/netfilter_ipv4/ip_tables.h
--- linux-2.4.19/include/linux/netfilter_ipv4/ip_tables.h	Mon Feb 25 19:38:=
13 2002
+++ linux-2.4.19-new/include/linux/netfilter_ipv4/ip_tables.h	Mon Sep 16 15=
:18:38 2002
@@ -292,7 +292,7 @@
 static __inline__ struct ipt_entry_target *
 ipt_get_target(struct ipt_entry *e)
 {
-	return (void *)e + e->target_offset;
+	return ((struct ipt_entry_target *)((char *)e + e->target_offset));
 }
=20
 /* fn returns 0 to continue iteration */
@@ -305,7 +305,7 @@
 	for (__i =3D sizeof(struct ipt_entry);	\
 	     __i < (e)->target_offset;		\
 	     __i +=3D __match->u.match_size) {	\
-		__match =3D (void *)(e) + __i;	\
+		__match =3D (struct ipt_entry_match *)((char *)(e) + __i); \
 						\
 		__ret =3D fn(__match , ## args);	\
 		if (__ret !=3D 0)			\
@@ -322,7 +322,7 @@
 	struct ipt_entry *__entry;				\
 								\
 	for (__i =3D 0; __i < (size); __i +=3D __entry->next_offset) { \
-		__entry =3D (void *)(entries) + __i;		\
+		__entry =3D (struct ipt_entry *)((char *)(entries) + __i); \
 								\
 		__ret =3D fn(__entry , ## args);			\
 		if (__ret !=3D 0)					\

--=-yWqKrOE82nbaBg11n9RI--
