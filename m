From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf] netfilter: add missing xt_SYNPROXY.h header to Kbuild
Date: Fri, 17 Jun 2016 12:58:22 +0200
Message-ID: <1466161102-3326-1-git-send-email-pablo@netfilter.org>
Cc: kernel@mattwhitlock.name
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41711 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988AbcFQK6h (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Jun 2016 06:58:37 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 0D523210572
	for <netfilter-devel@vger.kernel.org>; Fri, 17 Jun 2016 12:58:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id F3DFA9EBA5
	for <netfilter-devel@vger.kernel.org>; Fri, 17 Jun 2016 12:58:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 83F969EBA4
	for <netfilter-devel@vger.kernel.org>; Fri, 17 Jun 2016 12:58:29 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Matt Whitlock says:

 Without this line, the file xt_SYNPROXY.h does not get installed in
 /usr/include/linux/netfilter/, and thus user-space programs cannot make
 use of it.

Reported-by: Matt Whitlock <kernel@mattwhitlock.name>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/Kbuild | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/netfilter/Kbuild b/include/uapi/linux/netfilter/Kbuild
index 1d973d2..cd26d7a 100644
--- a/include/uapi/linux/netfilter/Kbuild
+++ b/include/uapi/linux/netfilter/Kbuild
@@ -33,6 +33,7 @@ header-y += xt_NFLOG.h
 header-y += xt_NFQUEUE.h
 header-y += xt_RATEEST.h
 header-y += xt_SECMARK.h
+header-y += xt_SYNPROXY.h
 header-y += xt_TCPMSS.h
 header-y += xt_TCPOPTSTRIP.h
 header-y += xt_TEE.h
-- 
2.1.4

