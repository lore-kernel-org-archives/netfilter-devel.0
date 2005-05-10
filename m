From: Max Kellermann <max@duempel.org>
Subject: [PATCH pom-ng 1/6] H.323: remove struct ip_ct_h225_master
Date: Wed, 11 May 2005 00:51:10 +0200
Message-ID: <20050510225110.GA5720@roonstrasse.net>
References: <20050510225019.GA5102@roonstrasse.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="J2SCkAp4GZ/dPZZf"
Cc: laforge@gnumonks.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20050510225019.GA5102@roonstrasse.net>
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


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

h323-01-remove_ip_ct_h225_master.patch
- remove struct ip_ct_h225_master

--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="h323-01-remove_ip_ct_h225_master.patch"

Tue Apr 19 21:28:07 CEST 2005  max@duempel.org
  * removed dummy struct ip_ct_h225_master
diff -rN -u old-h323-4/h323-conntrack-nat/linux-2.6.11/include/linux/netfilter_ipv4/ip_conntrack.h.ladd new-h323-4/h323-conntrack-nat/linux-2.6.11/include/linux/netfilter_ipv4/ip_conntrack.h.ladd
--- old-h323-4/h323-conntrack-nat/linux-2.6.11/include/linux/netfilter_ipv4/ip_conntrack.h.ladd	2005-05-10 23:48:01.000000000 +0200
+++ new-h323-4/h323-conntrack-nat/linux-2.6.11/include/linux/netfilter_ipv4/ip_conntrack.h.ladd	1970-01-01 01:00:00.000000000 +0100
@@ -1,2 +0,0 @@
-	/* insert conntrack helper private data (master) here */
-	struct ip_ct_h225_master ct_h225_info;
diff -rN -u old-h323-4/h323-conntrack-nat/linux-2.6.11/include/linux/netfilter_ipv4/ip_conntrack.h.ladd_2 new-h323-4/h323-conntrack-nat/linux-2.6.11/include/linux/netfilter_ipv4/ip_conntrack.h.ladd_2
--- old-h323-4/h323-conntrack-nat/linux-2.6.11/include/linux/netfilter_ipv4/ip_conntrack.h.ladd_2	2005-05-10 23:48:01.000000000 +0200
+++ new-h323-4/h323-conntrack-nat/linux-2.6.11/include/linux/netfilter_ipv4/ip_conntrack.h.ladd_2	1970-01-01 01:00:00.000000000 +0100
@@ -1,2 +0,0 @@
-/* Add protocol helper include file here */
-#include <linux/netfilter_ipv4/ip_conntrack_h323.h>
diff -rN -u old-h323-4/h323-conntrack-nat/linux-2.6.11/include/linux/netfilter_ipv4/ip_conntrack_h323.h new-h323-4/h323-conntrack-nat/linux-2.6.11/include/linux/netfilter_ipv4/ip_conntrack_h323.h
--- old-h323-4/h323-conntrack-nat/linux-2.6.11/include/linux/netfilter_ipv4/ip_conntrack_h323.h	2005-05-10 23:48:01.000000000 +0200
+++ new-h323-4/h323-conntrack-nat/linux-2.6.11/include/linux/netfilter_ipv4/ip_conntrack_h323.h	2005-05-10 23:48:01.000000000 +0200
@@ -7,11 +7,6 @@
 /* Default H.225 port */
 #define H225_PORT	1720
 
-/* This structure exists only once per master */
-struct ip_ct_h225_master {
-	int dummy;
-};
-
 struct ip_conntrack_expect;
 struct ip_conntrack;
 


--J2SCkAp4GZ/dPZZf--
