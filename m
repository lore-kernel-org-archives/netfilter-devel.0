From: Huang Weiyi <weiyi.huang@gmail.com>
Subject: netfilter: remove unused #include <version.h>
Date: Sun, 12 Oct 2008 23:12:51 +0800
Message-ID: <20081012231045.E7EC.WEIYI.HUANG@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	coreteam@netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.185]:56220 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040AbYJLPM7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 Oct 2008 11:12:59 -0400
Received: by ti-out-0910.google.com with SMTP id b6so670538tic.23
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Oct 2008 08:12:57 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The file(s) below do not use LINUX_VERSION_CODE nor KERNEL_VERSION.
  net/netfilter/nf_tproxy_core.c

This patch removes the said #include <version.h>.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>

diff --git a/net/netfilter/nf_tproxy_core.c b/net/netfilter/nf_tproxy_core.c
index fe34f4b..cdc97f3 100644
--- a/net/netfilter/nf_tproxy_core.c
+++ b/net/netfilter/nf_tproxy_core.c
@@ -10,7 +10,6 @@
  *
  */

-#include <linux/version.h>
 #include <linux/module.h>

 #include <linux/net.h>

