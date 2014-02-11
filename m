From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [libnftnl PATCH 2/8] table: Break the line properly when printing out the table
Date: Tue, 11 Feb 2014 12:46:42 +0200
Message-ID: <1392115608-6733-3-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1392115608-6733-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:62051 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694AbaBKKrD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Feb 2014 05:47:03 -0500
In-Reply-To: <1392115608-6733-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

As when a rule is printed etc... It fixes a bug in iptables when
printing out the table in debug mode.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 src/table.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/table.c b/src/table.c
index f50a968..529f568 100644
--- a/src/table.c
+++ b/src/table.c
@@ -383,7 +383,7 @@ static int nft_table_snprintf_xml(char *buf, size_t size, struct nft_table *t)
 
 static int nft_table_snprintf_default(char *buf, size_t size, struct nft_table *t)
 {
-	return snprintf(buf, size, "table %s %s flags %x",
+	return snprintf(buf, size, "table %s %s flags %x\n",
 			t->name, nft_family2str(t->family), t->table_flags);
 }
 
-- 
1.8.3.2

