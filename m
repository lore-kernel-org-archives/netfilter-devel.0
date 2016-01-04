From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH 2/4] rule: when listing all sets,
 don't print empty tables
Date: Mon, 04 Jan 2016 13:18:31 +0100
Message-ID: <145190991185.22285.13328538132434564559.stgit@r2d2.cica.es>
References: <145190990642.22285.2420592085262978551.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:47713 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751603AbcADMSi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Jan 2016 07:18:38 -0500
In-Reply-To: <145190990642.22285.2420592085262978551.stgit@r2d2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The table may contain sets, but they are anonymous.

For example, using this ruleset:

==== 8< ====
table arp test_arp {
	chain test {
		meta nfproto { ipv4}
	}
}
==== 8< ====

Before this patch:

% nft list sets
table arp test_arp {
}


After this patch:

% nft list sets
<no output>

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 0 files changed

diff --git a/src/rule.c b/src/rule.c
index 18ff592..c0e45aa 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1009,12 +1009,24 @@ static int do_list_sets(struct netlink_ctx *ctx, struct cmd *cmd)
 	};
 	struct table *table;
 	struct set *set;
+	bool printable_sets = false;
 
 	list_for_each_entry(table, &table_list, list) {
 		if (cmd->handle.family != NFPROTO_UNSPEC &&
 		    cmd->handle.family != table->handle.family)
 			continue;
 
+		/* if there are no printable sets, don't print empty table */
+		list_for_each_entry(set, &table->sets, list) {
+			if (!set->flags & SET_F_ANONYMOUS) {
+				printable_sets = true;
+				break;
+			}
+		}
+
+		if (!printable_sets)
+			continue;
+
 		printf("table %s %s {\n",
 		       family2str(table->handle.family),
 		       table->handle.table);
@@ -1027,6 +1039,8 @@ static int do_list_sets(struct netlink_ctx *ctx, struct cmd *cmd)
 		}
 
 		printf("}\n");
+
+		printable_sets = false;
 	}
 	return 0;
 }

