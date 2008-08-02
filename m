From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] iptables-save saves hashlimit rules with error
Date: Sat, 2 Aug 2008 09:55:50 -0700
Message-ID: <20080802165550.GA19111@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="0OAP2g/MAC+5xKAE"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from adsl-67-120-171-161.dsl.lsan03.pacbell.net ([67.120.171.161]:57116
	"HELO linuxace.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755738AbYHBQzv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Aug 2008 12:55:51 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

In bugzilla 550, Xeb notes that the --hashlimit-htable-gcinterval argument
is saved incorrectly.  Patch below corrects.

Phil

Patch-from: Xeb <xeb@mail.ru>
Signed-off-by: Phil Oester <kernel@linuxace.com>


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-hashlimit

diff -ur iptables-1.4.0.orig/extensions/libxt_hashlimit.c iptables-1.4.0/extensions/libxt_hashlimit.c
--- iptables-1.4.0.orig/extensions/libxt_hashlimit.c	2007-10-15 16:45:09.000000000 +0400
+++ iptables-1.4.0/extensions/libxt_hashlimit.c	2008-07-18 07:18:06.000000000 +0400
@@ -613,7 +613,7 @@
 	if (r->cfg.max)
 		printf("--hashlimit-htable-max %u ", r->cfg.max);
 	if (r->cfg.gc_interval != XT_HASHLIMIT_GCINTERVAL)
-		printf("--hashlimit-htable-gcinterval %u", r->cfg.gc_interval);
+		printf("--hashlimit-htable-gcinterval %u ", r->cfg.gc_interval);
 	if (r->cfg.expire != XT_HASHLIMIT_EXPIRE)
 		printf("--hashlimit-htable-expire %u ", r->cfg.expire);
 }

--0OAP2g/MAC+5xKAE--
