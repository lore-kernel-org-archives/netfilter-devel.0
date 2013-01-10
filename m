From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables RFC PATCH 1/6] nft: Add a family attribute to nft_handle
Date: Thu, 10 Jan 2013 16:29:34 +0200
Message-ID: <1357828179-18664-2-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1357828179-18664-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:29742 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586Ab3AJO3o (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Jan 2013 09:29:44 -0500
In-Reply-To: <1357828179-18664-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/nft.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/iptables/nft.h b/iptables/nft.h
index aed2498..1bd9ccc 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -4,6 +4,7 @@
 #include "xshared.h"
 
 struct nft_handle {
+	int			family;
 	struct mnl_socket	*nl;
 	uint32_t		portid;
 	uint32_t		seq;
-- 
1.8.0.2

