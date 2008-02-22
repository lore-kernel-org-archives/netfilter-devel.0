From: Paul P Komkoff Jr <i@stingr.net>
Subject: Small fixes for newer glibc/gcc compat
Date: Sat, 23 Feb 2008 00:30:25 +0300
Message-ID: <20080222213025.GV3726@stingr.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="VMt1DrMGOVs3KQwf"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stingr.net ([212.193.32.15]:49726 "EHLO stingr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756344AbYBVVlb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Feb 2008 16:41:31 -0500
Received: from localhost (palevo.sgu.ru [212.193.32.3])
	by stingr.net (Postfix) with ESMTP id 801F82502C6
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Feb 2008 00:30:30 +0300 (MSK)
Received: from stingr.net ([212.193.32.15])
	by localhost (palevo.sgu.ru [212.193.32.3]) (amavisd-new, port 10026)
	with ESMTP id 2XUkxhroRAet for <netfilter-devel@vger.kernel.org>;
	Sat, 23 Feb 2008 00:30:34 +0300 (MSK)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--VMt1DrMGOVs3KQwf
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline

Hi!

Please find attached 2 patches I made for
libnetfilter_{conntrack,queue}.

They both fix compilation issues on newer toolchains.

-- 
Paul P 'Stingray' Komkoff Jr // http://stingr.net/key <- my pgp key
 This message represents the official view of the voices in my head

--VMt1DrMGOVs3KQwf
Content-Type: text/plain; charset=koi8-r
Content-Disposition: attachment; filename="libnetfilter_conntrack-in6addr.patch"

diff --git a/l3extensions/libnetfilter_conntrack_ipv6.c b/l3extensions/libnetfilter_conntrack_ipv6.c
index b0c7a3f..5f173f3 100644
--- a/l3extensions/libnetfilter_conntrack_ipv6.c
+++ b/l3extensions/libnetfilter_conntrack_ipv6.c
@@ -48,8 +48,8 @@ static int print_proto(char *buf, struct nfct_tuple *tuple)
 	char tmp[INET6_ADDRSTRLEN];
 	int size;
 
-	memcpy(&src.in6_u, tuple->src.v6, sizeof(struct in6_addr));
-	memcpy(&dst.in6_u, tuple->dst.v6, sizeof(struct in6_addr));
+	memcpy(&src, tuple->src.v6, sizeof(struct in6_addr));
+	memcpy(&dst, tuple->dst.v6, sizeof(struct in6_addr));
 
 	if (!inet_ntop(AF_INET6, &src, tmp, sizeof(tmp)))
 		return 0;
diff --git a/src/conntrack/snprintf_default.c b/src/conntrack/snprintf_default.c
index 996fe1a..382b2d9 100644
--- a/src/conntrack/snprintf_default.c
+++ b/src/conntrack/snprintf_default.c
@@ -92,8 +92,8 @@ int __snprintf_address_ipv6(char *buf,
 	struct in6_addr dst;
 	char tmp[INET6_ADDRSTRLEN];
 
-	memcpy(&src.in6_u, &tuple->src.v6, sizeof(struct in6_addr));
-	memcpy(&dst.in6_u, &tuple->dst.v6, sizeof(struct in6_addr));
+	memcpy(&src, &tuple->src.v6, sizeof(struct in6_addr));
+	memcpy(&dst, &tuple->dst.v6, sizeof(struct in6_addr));
 
 	if (!inet_ntop(AF_INET6, &src, tmp, sizeof(tmp)))
 		return -1;
diff --git a/src/conntrack/snprintf_xml.c b/src/conntrack/snprintf_xml.c
index 56b2016..7bd1b43 100644
--- a/src/conntrack/snprintf_xml.c
+++ b/src/conntrack/snprintf_xml.c
@@ -98,7 +98,7 @@ static int __snprintf_ipv6_xml(char *buf,
 	static char tmp[INET6_ADDRSTRLEN];
 	const void *p = (type == __ADDR_SRC) ? &tuple->src.v6 : &tuple->dst.v6;
 
-	memcpy(&addr.in6_u, p, sizeof(struct in6_addr));
+	memcpy(&addr, p, sizeof(struct in6_addr));
 
 	if (!inet_ntop(AF_INET6, &addr, tmp, sizeof(tmp)))
 		return -1;

--VMt1DrMGOVs3KQwf
Content-Type: text/plain; charset=koi8-r
Content-Disposition: attachment; filename="libnetfilter_queue-linuxtypes.patch"

diff --git a/utils/nfqnl_test.c b/utils/nfqnl_test.c
index af224de..be72974 100644
--- a/utils/nfqnl_test.c
+++ b/utils/nfqnl_test.c
@@ -3,6 +3,7 @@
 #include <stdlib.h>
 #include <unistd.h>
 #include <netinet/in.h>
+#include <linux/types.h>
 #include <linux/netfilter.h>		/* for NF_ACCEPT */
 
 #include <libnetfilter_queue/libnetfilter_queue.h>

--VMt1DrMGOVs3KQwf--
