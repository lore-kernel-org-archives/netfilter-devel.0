From: Nicolas CARRIER <nicolas.carrier.ext@parrot.com>
Subject: [PATCH]iptables-save: fix don't show counters by default
Date: Thu, 10 May 2012 11:40:33 +0200
Message-ID: <4FAB8D11.4040704@parrot.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="------------050004040107060502030802"
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from co202.xi-lite.net ([149.6.83.202]:33017 "EHLO co202.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758128Ab2EJJmM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 May 2012 05:42:12 -0400
Received: from ONYX.xi-lite.lan (unknown [193.34.35.244])
	by co202.xi-lite.net (Postfix) with ESMTPS id C6C232602D6
	for <netfilter-devel@vger.kernel.org>; Thu, 10 May 2012 11:42:10 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--------------050004040107060502030802
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit

When one issue an iptables-save command, counters are always shown in front of policies, which doesn't seem to be the desired result.
The attached patch tries to fix this. It uses the global show_counters flag to decide if counters will be shown.

-- 
Nicolas CARRIER - Parrot France - Software Engineer

--------------050004040107060502030802
Content-Type: text/x-diff;
	name="0001-iptables-save-fix-don-t-show-counters-by-default.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="0001-iptables-save-fix-don-t-show-counters-by-default.patch"

>From 8ccc08a6b0fde5544145f6831b7f80d1bf8bbdf0 Mon Sep 17 00:00:00 2001
From: Nicolas CARRIER <nicolas.carrier.ext@parrot.com>
Date: Thu, 10 May 2012 11:25:53 +0200
Subject: [PATCH] iptables-save: fix don't show counters by default

---
 iptables/ip6tables-save.c |    9 ++++++---
 iptables/iptables-save.c  |    9 ++++++---
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/iptables/ip6tables-save.c b/iptables/ip6tables-save.c
index d819b30..4e7e4e8 100644
--- a/iptables/ip6tables-save.c
+++ b/iptables/ip6tables-save.c
@@ -90,11 +90,14 @@ static int do_output(const char *tablename)
 		printf(":%s ", chain);
 		if (ip6tc_builtin(chain, h)) {
 			struct xt_counters count;
-			printf("%s ",
+			printf("%s",
 			       ip6tc_get_policy(chain, &count, h));
-			printf("[%llu:%llu]\n", (unsigned long long)count.pcnt, (unsigned long long)count.bcnt);
+			if (show_counters)
+				printf(" [%llu:%llu]\n", (unsigned long long)count.pcnt, (unsigned long long)count.bcnt);
+			else
+				printf("\n");
 		} else {
-			printf("- [0:0]\n");
+			printf("-%s\n", show_counters ? " [0:0]" : "");
 		}
 	}
 
diff --git a/iptables/iptables-save.c b/iptables/iptables-save.c
index e599fce..6322c51 100644
--- a/iptables/iptables-save.c
+++ b/iptables/iptables-save.c
@@ -88,11 +88,14 @@ static int do_output(const char *tablename)
 		printf(":%s ", chain);
 		if (iptc_builtin(chain, h)) {
 			struct xt_counters count;
-			printf("%s ",
+			printf("%s",
 			       iptc_get_policy(chain, &count, h));
-			printf("[%llu:%llu]\n", (unsigned long long)count.pcnt, (unsigned long long)count.bcnt);
+			if (show_counters)
+				printf(" [%llu:%llu]\n", (unsigned long long)count.pcnt, (unsigned long long)count.bcnt);
+			else
+				printf("\n");
 		} else {
-			printf("- [0:0]\n");
+			printf("-%s\n", show_counters ? " [0:0]" : "");
 		}
 	}
 
-- 
1.7.10


--------------050004040107060502030802--
