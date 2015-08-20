From: Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH] iptables: update gitignore list
Date: Thu, 20 Aug 2015 07:13:02 -0400
Message-ID: <1440069182-21380-1-git-send-email-vapier@gentoo.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:39990 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022AbbHTLNF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Aug 2015 07:13:05 -0400
Received: from localhost.localdomain (localhost [127.0.0.1])
	by smtp.gentoo.org (Postfix) with ESMTP id D0831340A76
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Aug 2015 11:13:04 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/linux/netfilter_ipv4/ip_tables.h | 2 +-
 iptables/.gitignore                      | 3 +++
 libiptc/libiptc.c                        | 4 +++-
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ip_tables.h b/include/linux/netfilter_ipv4/ip_tables.h
index 38542b4..6c73f34 100644
--- a/include/linux/netfilter_ipv4/ip_tables.h
+++ b/include/linux/netfilter_ipv4/ip_tables.h
@@ -212,7 +212,7 @@ struct ipt_get_entries {
 
 	/* The entries. */
 	struct ipt_entry entrytable[0];
-};
+} __attribute__((packed));
 
 /* Helper functions */
 static __inline__ struct xt_entry_target *
diff --git a/iptables/.gitignore b/iptables/.gitignore
index 6c0ade1..7438ad1 100644
--- a/iptables/.gitignore
+++ b/iptables/.gitignore
@@ -7,9 +7,12 @@
 /iptables-extensions.8
 /iptables-extensions.8.tmpl
 /iptables-save
+/iptables-save.8
 /iptables-restore
+/iptables-restore.8
 /iptables-static
 /iptables-xml
+/iptables-xml.1
 /xtables-multi
 /xtables-config-parser.c
 /xtables-config-parser.h
diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
index 9c07bb4..e8091eb 100644
--- a/libiptc/libiptc.c
+++ b/libiptc/libiptc.c
@@ -1302,7 +1302,8 @@ struct xtc_handle *
 TC_INIT(const char *tablename)
 {
 	struct xtc_handle *h;
-	STRUCT_GETINFO info;
+	__attribute__((packed))
+STRUCT_GETINFO info;
 	unsigned int tmp;
 	socklen_t s;
 	int sockfd;
@@ -1350,6 +1351,7 @@ retry:
 
 	tmp = sizeof(STRUCT_GET_ENTRIES) + h->info.size;
 
+printf("getsockopt(, %i)\n", tmp);
 	if (getsockopt(h->sockfd, TC_IPPROTO, SO_GET_ENTRIES, h->entries,
 		       &tmp) < 0)
 		goto error;
-- 
2.4.4

