From: "Hime Junior" <hime@engineer.com>
Subject: [PATCH] Fuzzy match userspace tool
Date: Mon, 09 Jun 2003 17:10:32 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030609221032.5265.qmail@mail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
Content-Disposition: inline
To: jf_patenaude@hotmail.com, laforge@netfilter.org,
	netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


 Hi Harald and Netfilter developers !

 A bug was found in libipt_fuzzy.c and libip6t_fuzzy.c modules .

(

 an inversion in the save function : 

printf("--upper-limit %u ",fuzzyinfo->minimum_rate);
printf("--lower-limit %u ",fuzzyinfo->maximum_rate);

                  SHOULD BE

printf("--lower-limit %u ",fuzzyinfo->minimum_rate);
printf("--upper-limit %u ",fuzzyinfo->maximum_rate);
 
)

  The enclosed patches will fix the problem .

    Please , apply them as soon as possible .

 Thanks in advance...

==================================================
==================================================
diff -Nru  old/libip6t_fuzzy.c new/libip6t_fuzzy.c
--- old/libip6t_fuzzy.c	Mon Jun  9 18:31:38 2003
+++ new/libip6t_fuzzy.c	Mon Jun  9 18:23:43 2003
@@ -7,6 +7,9 @@
 
 2002-08-07 Hime Aguiar e Oliveira Jr. <hime@engineer.com> : Initial version.
 2003-04-08 Maciej Soltysiak <solt@dns.toxicfilms.tv> : IPv6 Port
+2003-06-09 Hime Aguiar e Oliveira Jr. <hime@engineer.com> : Bug corrections in
+the save function , thanks to information given by Jean-Francois Patenaude.
+
 */
 
 #include <stdio.h>
@@ -131,8 +134,8 @@
 	const struct ip6t_fuzzy_info *fuzzyinfo
 		= (const struct ip6t_fuzzy_info *)match->data;
 
-	printf("--upper-limit %u ",fuzzyinfo->minimum_rate);
-	printf("--lower-limit %u ",fuzzyinfo->maximum_rate);
+	printf("--lower-limit %u ",fuzzyinfo->minimum_rate);
+	printf("--upper-limit %u ",fuzzyinfo->maximum_rate);
 
 }
=====================================================
=====================================================
diff -Nru  old/libipt_fuzzy.c new/libipt_fuzzy.c
--- old/libipt_fuzzy.c	Mon Jun  9 18:31:38 2003
+++ new/libipt_fuzzy.c	Mon Jun  9 18:23:49 2003
@@ -6,6 +6,8 @@
    ftp://prep.ai.mit.edu/pub/gnu/GPL
 
 2002-08-07 Hime Aguiar e Oliveira Jr. <hime@engineer.com> : Initial version.
+2003-06-09 Hime Aguiar e Oliveira Jr. <hime@engineer.com> : Bug corrections in
+the save function , thanks to information given by Jean-Francois Patenaude .
 
 */
 
@@ -131,8 +133,8 @@
 	const struct ipt_fuzzy_info *fuzzyinfo
 		= (const struct ipt_fuzzy_info *)match->data;
 
-	printf("--upper-limit %u ",fuzzyinfo->minimum_rate);
-	printf("--lower-limit %u ",fuzzyinfo->maximum_rate);
+	printf("--lower-limit %u ",fuzzyinfo->minimum_rate);
+	printf("--upper-limit %u ",fuzzyinfo->maximum_rate);
 
 }
======================================================
======================================================

 

-- 
__________________________________________________________
Sign-up for your own FREE Personalized E-mail at Mail.com
http://www.mail.com/?sr=signup
