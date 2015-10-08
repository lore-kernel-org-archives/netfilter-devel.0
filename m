From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 5/7] rule: `list sets' only displays declaration, not definition
Date: Thu,  8 Oct 2015 22:49:28 +0200
Message-ID: <1444337370-8269-6-git-send-email-pablo@netfilter.org>
References: <1444337370-8269-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, fw@strlen.de, arturo.borrero.glez@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47767 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753811AbbJHUml (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Oct 2015 16:42:41 -0400
In-Reply-To: <1444337370-8269-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 # nft list sets
 table ip nat {
        set libssh {
                type ipv4_addr
        }
 }
 table inet filter {
        set set0 {
                type inet_service
                flags constant
        }
        set set1 {
                type inet_service
                flags constant
        }
        set set2 {
                type icmpv6_type
                flags constant
        }
 }

So in case you want to inspect the definition, you have to use `list set'
and the specific set that you want to inspect:

 # nft list set inet filter set0
 table inet filter {
        set set0 {
                type inet_service
                flags constant
                elements = { 2200, ssh}
        }
 }

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/rule.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index 58bac76..08db38b 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -254,7 +254,8 @@ static const char *set_policy2str(uint32_t policy)
 	}
 }
 
-static void do_set_print(const struct set *set, struct print_fmt_options *opts)
+static void set_print_declaration(const struct set *set,
+				  struct print_fmt_options *opts)
 {
 	const char *delim = "";
 	const char *type;
@@ -322,6 +323,11 @@ static void do_set_print(const struct set *set, struct print_fmt_options *opts)
 		time_print(set->gc_int / 1000);
 		printf("%s", opts->nl);
 	}
+}
+
+static void do_set_print(const struct set *set, struct print_fmt_options *opts)
+{
+	set_print_declaration(set, opts);
 
 	if (set->init != NULL && set->init->size > 0) {
 		printf("%s%selements = ", opts->tab, opts->tab);
@@ -985,6 +991,11 @@ static int do_list_table(struct netlink_ctx *ctx, struct cmd *cmd,
 
 static int do_list_sets(struct netlink_ctx *ctx, struct cmd *cmd)
 {
+	struct print_fmt_options opts = {
+		.tab		= "\t",
+		.nl		= "\n",
+		.stmt_separator	= "\n",
+	};
 	struct table *table;
 	struct set *set;
 
@@ -997,8 +1008,10 @@ static int do_list_sets(struct netlink_ctx *ctx, struct cmd *cmd)
 		       family2str(table->handle.family),
 		       table->handle.table);
 
-		list_for_each_entry(set, &table->sets, list)
-			set_print(set);
+		list_for_each_entry(set, &table->sets, list) {
+			set_print_declaration(set, &opts);
+			printf("%s}%s", opts.tab, opts.nl);
+		}
 
 		printf("}\n");
 	}
-- 
2.1.4

