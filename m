From: =?ISO-8859-2?Q?=22Wojciech_=5C=22Sas=5C=22_Ci=EAciwa=22?=
	<cieciwa@alpha.zarz.agh.edu.pl>
Subject: [PATCH] patch-o-matic-ng snap 20060329 some fix
Date: Wed, 29 Mar 2006 17:59:24 +0200
Message-ID: <442AAEDC.2080107@alpha.zarz.agh.edu.pl>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030307060407070802020908"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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
--------------030307060407070802020908
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit

I try to add this snap to kernel 2.6.16.1, and got 3 error in module:
fuzzy, nth and random.

In attachment ane patches, pleas check and applay if this is correct.

Thanx.
	Wojtek.
  --
{Wojciech 'Sas' Cieciwa} {Member of PLD Team}
{   e-mail: cieciwa@alpha.zarz.agh.edu.pl   }

--------------030307060407070802020908
Content-Type: text/plain;
 name="random-ipv6.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="random-ipv6.patch"

diff -Nur patch-o-matic-ng/patchlets/random.org/linux-2.6/net/ipv6/netfilter/ip6t_random.c patch-o-matic-ng/patchlets/random/linux-2.6/net/ipv6/netfilter/ip6t_random.c
--- patch-o-matic-ng/patchlets/random.org/linux-2.6/net/ipv6/netfilter/ip6t_random.c	2006-03-29 08:41:00.000000000 +0200
+++ patch-o-matic-ng/patchlets/random/linux-2.6/net/ipv6/netfilter/ip6t_random.c	2006-03-29 17:52:00.000000000 +0200
@@ -70,12 +70,10 @@
 }
 
 static struct ip6t_match ip6t_rand_reg = { 
-	{NULL, NULL},
-	"random",
-	ip6t_rand_match,
-	ip6t_rand_checkentry,
-	NULL,
-	THIS_MODULE };
+	.name 		= "random",
+	.match		= ip6t_rand_match,
+	.checkentry	= ip6t_rand_checkentry,
+	.me		= THIS_MODULE };
 
 static int __init init(void)
 {

--------------030307060407070802020908
Content-Type: text/plain;
 name="fuzzy-ipv6.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fuzzy-ipv6.patch"

diff -Nur patch-o-matic-ng/patchlets/fuzzy.org/linux-2.6.10/net/ipv6/netfilter/ip6t_fuzzy.c patch-o-matic-ng/patchlets/fuzzy/linux-2.6.10/net/ipv6/netfilter/ip6t_fuzzy.c
--- patch-o-matic-ng/patchlets/fuzzy.org/linux-2.6.10/net/ipv6/netfilter/ip6t_fuzzy.c	2006-03-29 08:41:02.000000000 +0200
+++ patch-o-matic-ng/patchlets/fuzzy/linux-2.6.10/net/ipv6/netfilter/ip6t_fuzzy.c	2006-03-29 17:43:43.000000000 +0200
@@ -164,12 +164,10 @@
 }
 
 static struct ip6t_match ip6t_fuzzy_reg = {
-	{NULL, NULL},
-	"fuzzy",
-	ip6t_fuzzy_match,
-	ip6t_fuzzy_checkentry,
-	NULL,
-	THIS_MODULE };
+	.name		= "fuzzy",
+	.match		= ip6t_fuzzy_match,
+	.checkentry	= ip6t_fuzzy_checkentry,
+	.me		= THIS_MODULE };
 
 static int __init init(void)
 {

--------------030307060407070802020908
Content-Type: text/plain;
 name="nth-ipv6.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nth-ipv6.patch"

diff -Nur patch-o-matic-ng/patchlets/nth.org/linux-2.6.10/net/ipv6/netfilter/ip6t_nth.c patch-o-matic-ng/patchlets/nth/linux-2.6.10/net/ipv6/netfilter/ip6t_nth.c
--- patch-o-matic-ng/patchlets/nth.org/linux-2.6.10/net/ipv6/netfilter/ip6t_nth.c	2006-03-29 08:40:55.000000000 +0200
+++ patch-o-matic-ng/patchlets/nth/linux-2.6.10/net/ipv6/netfilter/ip6t_nth.c	2006-03-29 17:50:12.000000000 +0200
@@ -140,12 +140,10 @@
 }
 
 static struct ip6t_match ip6t_nth_reg = { 
-	{NULL, NULL},
-	"nth",
-	ip6t_nth_match,
-	ip6t_nth_checkentry,
-	NULL,
-	THIS_MODULE };
+	.name		= "nth",
+	.match		= ip6t_nth_match,
+	.checkentry	= ip6t_nth_checkentry,
+	.me		= THIS_MODULE };
 
 static int __init init(void)
 {

--------------030307060407070802020908--
