From: Eric Leblond <eric@regit.org>
Subject: [nftables PATCH 4/4] display family in table listing.
Date: Mon, 16 Sep 2013 18:27:38 +0200
Message-ID: <1379348858-29187-5-git-send-email-eric@regit.org>
References: <1379348858-29187-1-git-send-email-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:37448 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab3IPRHl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Sep 2013 13:07:41 -0400
In-Reply-To: <1379348858-29187-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

As family was not displayed in table listing, it was not possible
to restore an ipv6 table saved via 'nft list table ip6 TABLE'.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/rule.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/src/rule.c b/src/rule.c
index 2cf024a..52f5e16 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -269,6 +269,23 @@ struct chain *chain_lookup(const struct table *table, const struct handle *h)
 	return NULL;
 }
 
+static const char *family2str(unsigned int family)
+{
+	switch (family) {
+		case NFPROTO_IPV4:
+			return "ip";
+		case NFPROTO_IPV6:
+			return "ip6";
+		case NFPROTO_ARP:
+			return "arp";
+		case NFPROTO_BRIDGE:
+			return "bridge";
+		default:
+			break;
+	}
+	return "unknown";
+}
+
 static const char *hooknum2str(unsigned int family, unsigned int hooknum)
 {
 	switch (family) {
@@ -371,8 +388,9 @@ static void table_print(const struct table *table)
 	struct chain *chain;
 	struct set *set;
 	const char *delim = "";
+	const char *family = family2str(table->handle.family);
 
-	printf("table %s {\n", table->handle.table);
+	printf("table %s %s {\n", family, table->handle.table);
 	list_for_each_entry(set, &table->sets, list) {
 		if (set->flags & SET_F_ANONYMOUS)
 			continue;
-- 
1.8.4.rc3

