From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] netfilter: xt_SYNPROXY: include missing <linux/types.h>
Date: Fri, 17 Jun 2016 13:48:12 +0200
Message-ID: <1466164092-5229-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56445 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752665AbcFQLsS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Jun 2016 07:48:18 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 3D1B4C2B09
	for <netfilter-devel@vger.kernel.org>; Fri, 17 Jun 2016 13:48:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2F64B9EBA5
	for <netfilter-devel@vger.kernel.org>; Fri, 17 Jun 2016 13:48:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 06CDD9EBAB
	for <netfilter-devel@vger.kernel.org>; Fri, 17 Jun 2016 13:48:15 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

./usr/include/linux/netfilter/xt_SYNPROXY.h:11: found __[us]{8,16,32,64} type without #include <linux/types.h>

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/xt_SYNPROXY.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/netfilter/xt_SYNPROXY.h b/include/uapi/linux/netfilter/xt_SYNPROXY.h
index 2d59fba..ca67e61 100644
--- a/include/uapi/linux/netfilter/xt_SYNPROXY.h
+++ b/include/uapi/linux/netfilter/xt_SYNPROXY.h
@@ -1,6 +1,8 @@
 #ifndef _XT_SYNPROXY_H
 #define _XT_SYNPROXY_H
 
+#include <linux/types.h>
+
 #define XT_SYNPROXY_OPT_MSS		0x01
 #define XT_SYNPROXY_OPT_WSCALE		0x02
 #define XT_SYNPROXY_OPT_SACK_PERM	0x04
-- 
2.1.4

