From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables PATCH 3/3] nft: Print unknown target data only when relevant
Date: Wed,  7 Aug 2013 11:31:37 +0300
Message-ID: <1375864297-9347-4-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1375864297-9347-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:36647 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756486Ab3HGIby (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Aug 2013 04:31:54 -0400
In-Reply-To: <1375864297-9347-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bug is:
xtables -N test
xtables -A FORWARD -j test
xtables -L
Chain INPUT (policy ACCEPT)
target     prot opt source               destination

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination
test       all  --  anywhere             anywhere            [0 bytes of unknown target data]

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination

Chain test (1 references)
target     prot opt source               destination

"[0 bytes of unknown target data]" should not be printed in this case.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/nft-shared.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index ad3e675..f5f905f 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -549,7 +549,7 @@ int print_target(const char *targname, const void *targinfo,
 		if (target->print)
 			/* FIXME missing first parameter */
 			target->print(NULL, t, format & FMT_NUMERIC);
-	} else
+	} else if (target_len > 0)
 		printf("[%ld bytes of unknown target data] ", target_len);
 
 	free(t);
-- 
1.8.3.2

