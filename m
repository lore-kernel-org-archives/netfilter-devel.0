From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: [RESEND][PATCH] string match compilation on 2.4.9
Date: Mon, 16 Jun 2003 13:41:50 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.51.0306161340060.14421@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-ID: <Pine.LNX.4.51.0306161340062.14421@dns.toxicfilms.tv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

we all know that the string match does not work on 2.4.9 because
2.4.9 had a different definition of the min/max macros.

This patch did not receive any comment so far.

Please consider this patch for the patch-o-matic.

Regards,
Maciej

diff -Nru netfilter.orig/patch-o-matic/extra/string.patch netfilter/patch-o-matic/extra/string.patch
--- netfilter.orig/patch-o-matic/extra/string.patch	2003-05-03 14:31:54.000000000 +0200
+++ netfilter/patch-o-matic/extra/string.patch	2003-05-04 17:06:29.000000000 +0200
@@ -26,12 +26,14 @@
 diff -urN linux.orig/net/ipv4/netfilter/ipt_string.c linux/net/ipv4/netfilter/ipt_string.c
 --- linux.orig/net/ipv4/netfilter/ipt_string.c	Thu Jan  1 01:00:00 1970
 +++ linux/net/ipv4/netfilter/ipt_string.c	Thu Feb 21 20:26:09 2002
-@@ -0,0 +1,216 @@
+@@ -0,0 +1,222 @@
 +/* Kernel module to match a string into a packet.
 + *
 + * Copyright (C) 2000 Emmanuel Roger  <winfield@freegates.be>
 + *
 + * ChangeLog
++ *	04.05.2003: Maciej Soltysiak <solt@dns.toxicfilms.tv>
++ *		Fixed 2.4.9 broken max macro usage.
 + *	19.02.2002: Gianni Tedesco <gianni@ecsc.co.uk>
 + *		Fixed SMP re-entrancy problem using per-cpu data areas
 + *		for the skip/shift tables.
@@ -106,7 +108,11 @@
 +
 +		sk = skip[haystack[right_end - i]];
 +		sh = shift[i];
++#if LINUX_VERSION_CODE == KERNEL_VERSION(2,4,9)
++		right_end = max(int , right_end - i + sk, right_end + sh);
++#else
 +		right_end = max(right_end - i + sk, right_end + sh);
++#endif
 +	}
 +
 +	return NULL;
diff -Nru netfilter.orig/patch-o-matic/extra/string.patch.help netfilter/patch-o-matic/extra/string.patch.help
--- netfilter.orig/patch-o-matic/extra/string.patch.help	2003-05-03 14:31:54.000000000 +0200
+++ netfilter/patch-o-matic/extra/string.patch.help	2003-05-04 17:07:11.000000000 +0200
@@ -1,8 +1,6 @@
 Author: Emmanuel Roger <winfield@freegates.be>
-Status: Working, not with kernel 2.4.9
+Status: Working

 This patch adds CONFIG_IP_NF_MATCH_STRING which allows you to
 match a string in a whole packet.

-THIS PATCH DOES NOT WORK WITH KERNEL 2.4.9 !!!
-
