From: Kelvie Wong <kelvie@ieee.org>
Subject: [PATCH] expect: support NFCT_Q_CREATE_UPDATE in nfexp_query
Date: Wed,  2 May 2012 17:39:23 -0700
Message-ID: <1336005564-23171-2-git-send-email-kelvie@ieee.org>
References: <1336005564-23171-1-git-send-email-kelvie@ieee.org>
Cc: Kelvie Wong <kelvie@ieee.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:57556 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754409Ab2ECAjj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 May 2012 20:39:39 -0400
Received: by qcro28 with SMTP id o28so807896qcr.19
        for <netfilter-devel@vger.kernel.org>; Wed, 02 May 2012 17:39:39 -0700 (PDT)
In-Reply-To: <1336005564-23171-1-git-send-email-kelvie@ieee.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This will work as it does in conntrack; it won't pass NLM_F_ACK into
ctnetlink_new_expect in the kernel, and will thus invoke
ctnetlink_change_expect if the expectation already exists.

Signed-off-by: Kelvie Wong <kelvie@ieee.org>
---
 src/expect/api.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/expect/api.c b/src/expect/api.c
index 4da44a0..a101042 100644
--- a/src/expect/api.c
+++ b/src/expect/api.c
@@ -533,6 +533,9 @@ __build_query_exp(struct nfnl_subsys_handle *ssh,
 	case NFCT_Q_CREATE:
 		__build_expect(ssh, req, size, IPCTNL_MSG_EXP_NEW, NLM_F_REQUEST|NLM_F_CREATE|NLM_F_ACK|NLM_F_EXCL, data);
 		break;
+	case NFCT_Q_CREATE_UPDATE:
+		__build_expect(ssh, req, size, IPCTNL_MSG_EXP_NEW, NLM_F_REQUEST|NLM_F_CREATE|NLM_F_ACK, data);
+		break;
 	case NFCT_Q_GET:
 		__build_expect(ssh, req, size, IPCTNL_MSG_EXP_GET, NLM_F_REQUEST|NLM_F_ACK, data);
 		break;
-- 
1.7.9.5

