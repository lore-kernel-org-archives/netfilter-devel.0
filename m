From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH 1/4] rule: don't list anonymous sets
Date: Mon, 04 Jan 2016 13:18:26 +0100
Message-ID: <145190990642.22285.2420592085262978551.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:47709 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751456AbcADMSf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Jan 2016 07:18:35 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Don't list anonymous sets when listing all sets.

For example, using this ruleset:

==== 8< ====
table inet test {
	set set1 {
		type ipv4_addr
	}

	chain test {
		tcp dport { 80 } accept
	}
}
==== 8< ====

Before this patch:

% nft list sets
table inet test {
	set set0 {
		type inet_service
		flags constant
	}

	set set1 {
		type ipv4_addr
	}
}

After this patch:

% nft list sets
table inet test {
	set set1 {
		type ipv4_addr
	}
}

Fixes: 8f297010 ("rule: `list sets' only displays declaration, not definition")
Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 0 files changed

diff --git a/src/rule.c b/src/rule.c
index 5d3cd84..18ff592 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1020,6 +1020,8 @@ static int do_list_sets(struct netlink_ctx *ctx, struct cmd *cmd)
 		       table->handle.table);
 
 		list_for_each_entry(set, &table->sets, list) {
+			if (set->flags & SET_F_ANONYMOUS)
+				continue;
 			set_print_declaration(set, &opts);
 			printf("%s}%s", opts.tab, opts.nl);
 		}

