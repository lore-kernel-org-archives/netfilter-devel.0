From: Max Kellermann <max@duempel.org>
Subject: [PATCH pom-ng 3/6] H.323: minor code style fixes
Date: Wed, 11 May 2005 00:52:23 +0200
Message-ID: <20050510225223.GC5720@roonstrasse.net>
References: <20050510225019.GA5102@roonstrasse.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="XWOWbaMNXpFDWE00"
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


--XWOWbaMNXpFDWE00
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

h323-03-code_style.patch
- minor code style fixes


--XWOWbaMNXpFDWE00
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="h323-03-code_style.patch"

Tue Apr 19 22:46:24 CEST 2005  max@duempel.org
  * minor code style fixes
diff -rN -u old-h323-4/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_h323.c new-h323-4/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_h323.c
--- old-h323-4/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_h323.c	2005-05-10 23:48:35.000000000 +0200
+++ new-h323-4/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_h323.c	2005-05-10 23:48:35.000000000 +0200
@@ -160,7 +160,8 @@
 }
 
 /* H.245 helper is not registered! */
-static struct ip_conntrack_helper h245 = {
+static struct ip_conntrack_helper h245 =
+{
 	.name = "H.245",
 	.max_expected = 8,
 	.timeout = 240,
@@ -419,7 +420,8 @@
 	return ret;
 }
 
-static struct ip_conntrack_helper h225 = {
+static struct ip_conntrack_helper h225 =
+{
 	.name = "H.225",
 	.me = THIS_MODULE,
 	.max_expected = 2,


--XWOWbaMNXpFDWE00--
