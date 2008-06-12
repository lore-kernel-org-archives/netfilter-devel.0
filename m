From: Krzysztof Oledzki <ole@ans.pl>
Subject: [PATCH] (resent) ipset: make checkentry static
Date: Thu, 12 Jun 2008 22:19:37 +0200
Message-ID: <485184d9.5gAEw5xIpkNjuDn/%ole@ans.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org, kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:33723 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbYFLVTr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Jun 2008 17:19:47 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This function should be static also for >= 2.6.23

Signed-off-by: Krzysztof Piotr Oledzki <ole@ans.pl>

--- ipt_set.c	2007-08-28 13:29:12.000000000 +0200
+++ ipt_set.c-1	2008-05-30 11:58:02.000000000 +0200
@@ -57,7 +57,7 @@
 }
 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,23)
-bool
+static bool
 #else
 static int
 #endif
