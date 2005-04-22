From: Pawel Sikora <pluto@pld-linux.org>
Subject: [PATCH] gcc4 fixes ip_conntrack_core.c/nf_conntrack.h.
Date: Fri, 22 Apr 2005 16:57:37 +0200
Message-ID: <200504221657.37760.pluto@pld-linux.org>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_hDRaCfi35+cORjF"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Developers <netfilter-devel@lists.netfilter.org>
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

--Boundary-00=_hDRaCfi35+cORjF
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

Attached patches fix build issues exposed by gcc4.
Please review and apply.

Regards,
Pawel.

-- 
/* Copyright (C) 2003, SCO, Inc. This is valuable Intellectual Property. */

                           #define say(x) lie(x)

--Boundary-00=_hDRaCfi35+cORjF
Content-Type: text/x-diff; charset="utf-8";
	name="nf_conntrack.h-gcc4-unimplemented-inlining.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="nf_conntrack.h-gcc4-unimplemented-inlining.patch"


  CC [M]  net/ipv4/netfilter/ip_conntrack_core.o
  net/ipv4/netfilter/ip_conntrack_core.c: In function 'destroy_conntrack':
    include/linux/netfilter_ipv4/ip_conntrack.h:353:
    sorry, unimplemented: inlining failed in call to 'ip_conntrack_free':
    function body not available
  net/ipv4/netfilter/ip_conntrack_core.c:299:
    sorry, unimplemented: called from here

Index: include/linux/netfilter/nf_conntrack.h
===================================================================
--- include/linux/netfilter/nf_conntrack.h	(wersja 5865)
+++ include/linux/netfilter/nf_conntrack.h	(kopia robocza)
@@ -218,7 +218,7 @@
 }
 
 /* decrement reference count on a conntrack */
-extern inline void nf_ct_put(struct nf_conn *ct);
+extern void nf_ct_put(struct nf_conn *ct);
 
 /* call to create an explicit dependency on nf_conntrack. */
 extern void need_nf_conntrack(void);
Index: include/linux/netfilter_ipv4/ip_conntrack.h
===================================================================
--- include/linux/netfilter_ipv4/ip_conntrack.h	(wersja 5866)
+++ include/linux/netfilter_ipv4/ip_conntrack.h	(kopia robocza)
@@ -350,9 +350,9 @@
 extern struct ip_conntrack *ip_conntrack_alloc(struct ip_conntrack_tuple *,
 					       struct ip_conntrack_tuple *);
 
-extern inline void ip_conntrack_free(struct ip_conntrack *ct);
+extern void ip_conntrack_free(struct ip_conntrack *ct);
 
-extern inline void ip_conntrack_insert(struct ip_conntrack *ct);
+extern void ip_conntrack_insert(struct ip_conntrack *ct);
 
 extern struct ip_conntrack_expect *
 __ip_conntrack_expect_find(const struct ip_conntrack_tuple *tuple);

--Boundary-00=_hDRaCfi35+cORjF
Content-Type: text/x-diff; charset="utf-8";
	name="ip_conntrack_core.c-gcc4-declared-inline-after-being-called.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="ip_conntrack_core.c-gcc4-declared-inline-after-being-called.patch"


  CC [M]  net/ipv4/netfilter/ip_conntrack_core.o
  include/linux/netfilter_ipv4/ip_conntrack.h:353: warning:
    'ip_conntrack_free' declared inline after being called
  include/linux/netfilter_ipv4/ip_conntrack.h:353: warning:
    previous declaration of 'ip_conntrack_free' was here

Index: net/ipv4/netfilter/ip_conntrack_core.c
===================================================================
--- net/ipv4/netfilter/ip_conntrack_core.c	(wersja 5866)
+++ net/ipv4/netfilter/ip_conntrack_core.c	(kopia robocza)
@@ -247,6 +247,13 @@
 	ip_ct_remove_expectations(ct);
 }
 
+inline void
+ip_conntrack_free(struct ip_conntrack *conntrack)
+{
+	atomic_dec(&ip_conntrack_count);
+	kmem_cache_free(ip_conntrack_cachep, conntrack);
+}
+
 static void
 destroy_conntrack(struct nf_conntrack *nfct)
 {
@@ -559,13 +566,6 @@
 	return conntrack;
 }
 
-inline void
-ip_conntrack_free(struct ip_conntrack *conntrack)
-{
-	atomic_dec(&ip_conntrack_count);
-	kmem_cache_free(ip_conntrack_cachep, conntrack);
-}
-
 /* Allocate a new conntrack: we return -ENOMEM if classification
    failed due to stress.  Otherwise it really is unclassifiable. */
 static struct ip_conntrack_tuple_hash *

--Boundary-00=_hDRaCfi35+cORjF--
