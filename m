From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nft V2] src: add log flags syntax support
Date: Sat, 19 Nov 2016 19:31:15 +0800
Message-ID: <1479555075-41756-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-16.163.com ([220.181.12.16]:50943 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752499AbcKSLcM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Nov 2016 06:32:12 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

Now NF_LOG_XXX is exposed to the userspace, we can set it explicitly.
Like iptables LOG target, we can log TCP sequence numbers, TCP options,
IP options, UID owning local socket and decode MAC header. Note the
log flags are mutually exclusive with group.

Some examples are listed below:
 # nft add rule t c log flags tcp sequence,options
 # nft add rule t c log flags ip options
 # nft add rule t c log flags skuid
 # nft add rule t c log flags ether
 # nft add rule t c log flags all
 # nft add rule t c log flags all group 1
 <cmdline>:1:14-16: Error: flags and group are mutually exclusive
 add rule t c log flags all group 1
              ^^^

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 V2: Switch to the new syntax suggested by Pablo. Also combine the original
     three patches into a single one.

 doc/nft.xml                      | 56 ++++++++++++++++++++++++++++++++++++++++
 include/linux/netfilter/nf_log.h | 12 +++++++++
 include/statement.h              |  1 +
 src/evaluate.c                   | 12 +++++----
 src/netlink_delinearize.c        |  4 +++
 src/netlink_linearize.c          |  3 +++
 src/parser_bison.y               | 50 ++++++++++++++++++++++++++++++++++-
 src/scanner.l                    |  3 +++
 src/statement.c                  | 23 +++++++++++++++++
 tests/py/any/log.t               |  6 +++++
 tests/py/any/log.t.payload       | 15 +++++++++++
 11 files changed, 179 insertions(+), 6 deletions(-)
 create mode 100644 include/linux/netfilter/nf_log.h

diff --git a/doc/nft.xml b/doc/nft.xml
index d11abca..8026d85 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -2400,6 +2400,8 @@ ip forward ip dscp set 42
 					<replaceable>quoted_string</replaceable></arg>
 					<arg choice="opt">level
 					<replaceable>syslog-level</replaceable></arg>
+					<arg choice="opt">flags
+					<replaceable>log-flags</replaceable></arg>
 				</cmdsynopsis>
 				<cmdsynopsis>
 					<command>log</command>
@@ -2459,6 +2461,60 @@ ip forward ip dscp set 42
 						</tbody>
 					</tgroup>
 				</table>
+				<table frame="all">
+					<title>log-flags</title>
+					<tgroup cols='2' align='left' colsep='1' rowsep='1'>
+						<colspec colname='c1'/>
+						<colspec colname='c2'/>
+						<thead>
+							<row>
+								<entry>Flag</entry>
+								<entry>Description</entry>
+							</row>
+						</thead>
+						<tbody>
+							<row>
+								<entry>tcp sequence</entry>
+								<entry>Log TCP sequence numbers.</entry>
+							</row>
+							<row>
+								<entry>tcp options</entry>
+								<entry>Log options from the TCP packet header.</entry>
+							</row>
+							<row>
+								<entry>ip options</entry>
+								<entry>Log options from the IP/IPv6 packet header.</entry>
+							</row>
+							<row>
+								<entry>skuid</entry>
+								<entry>Log the userid of the process which generated the packet.</entry>
+							</row>
+							<row>
+								<entry>ether</entry>
+								<entry>Decode MAC addresses and protocol.</entry>
+							</row>
+							<row>
+								<entry>all</entry>
+								<entry>Enable all log flags listed above.</entry>
+							</row>
+						</tbody>
+					</tgroup>
+				</table>
+			</para>
+			<para>
+				<example>
+					<title>Using log statement</title>
+					<programlisting>
+# log the UID which generated the packet and ip options
+ip filter output log flags skuid flags ip options
+
+# log the tcp sequence numbers and tcp options from the TCP packet
+ip filter output log flags tcp sequence,options
+
+# enable all supported log flags
+ip6 filter output log flags all
+					</programlisting>
+				</example>
 			</para>
                 </refsect2>
 		<refsect2>
diff --git a/include/linux/netfilter/nf_log.h b/include/linux/netfilter/nf_log.h
new file mode 100644
index 0000000..8be21e0
--- /dev/null
+++ b/include/linux/netfilter/nf_log.h
@@ -0,0 +1,12 @@
+#ifndef _NETFILTER_NF_LOG_H
+#define _NETFILTER_NF_LOG_H
+
+#define NF_LOG_TCPSEQ		0x01	/* Log TCP sequence numbers */
+#define NF_LOG_TCPOPT		0x02	/* Log TCP options */
+#define NF_LOG_IPOPT		0x04	/* Log IP options */
+#define NF_LOG_UID		0x08	/* Log UID owning local socket */
+#define NF_LOG_NFLOG		0x10	/* Unsupported, don't reuse */
+#define NF_LOG_MACDECODE	0x20	/* Decode MAC header */
+#define NF_LOG_MASK		0x2f
+
+#endif /* _NETFILTER_NF_LOG_H */
diff --git a/include/statement.h b/include/statement.h
index fe83717..277ff2f 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -50,6 +50,7 @@ struct log_stmt {
 	uint16_t		group;
 	uint16_t		qthreshold;
 	uint32_t		level;
+	uint32_t		logflags;
 	uint32_t		flags;
 };
 
diff --git a/src/evaluate.c b/src/evaluate.c
index c60e0f1..8b113c8 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2429,12 +2429,14 @@ static int stmt_evaluate_queue(struct eval_ctx *ctx, struct stmt *stmt)
 
 static int stmt_evaluate_log(struct eval_ctx *ctx, struct stmt *stmt)
 {
-	if (stmt->log.flags & STMT_LOG_LEVEL &&
-	    (stmt->log.flags & STMT_LOG_GROUP	||
-	     stmt->log.flags & STMT_LOG_SNAPLEN	||
-	     stmt->log.flags & STMT_LOG_QTHRESHOLD)) {
-		return stmt_error(ctx, stmt,
+	if (stmt->log.flags & (STMT_LOG_GROUP | STMT_LOG_SNAPLEN |
+			       STMT_LOG_QTHRESHOLD)) {
+		if (stmt->log.flags & STMT_LOG_LEVEL)
+			return stmt_error(ctx, stmt,
 				  "level and group are mutually exclusive");
+		if (stmt->log.logflags)
+			return stmt_error(ctx, stmt,
+				  "flags and group are mutually exclusive");
 	}
 	return 0;
 }
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 66d38ca..0ebe368 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -738,6 +738,10 @@ static void netlink_parse_log(struct netlink_parse_ctx *ctx,
 			nftnl_expr_get_u32(nle, NFTNL_EXPR_LOG_LEVEL);
 		stmt->log.flags |= STMT_LOG_LEVEL;
 	}
+	if (nftnl_expr_is_set(nle, NFTNL_EXPR_LOG_FLAGS)) {
+		stmt->log.logflags =
+			nftnl_expr_get_u32(nle, NFTNL_EXPR_LOG_FLAGS);
+	}
 
 	ctx->stmt = stmt;
 }
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 2bee684..2945392 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -833,6 +833,9 @@ static void netlink_gen_log_stmt(struct netlink_linearize_ctx *ctx,
 		if (stmt->log.flags & STMT_LOG_LEVEL)
 			nftnl_expr_set_u32(nle, NFTNL_EXPR_LOG_LEVEL,
 					   stmt->log.level);
+		if (stmt->log.logflags)
+			nftnl_expr_set_u32(nle, NFTNL_EXPR_LOG_FLAGS,
+					   stmt->log.logflags);
 	}
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 91955c1..981ffc8 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -20,6 +20,7 @@
 #include <linux/netfilter/nf_tables.h>
 #include <linux/netfilter/nf_conntrack_tuple_common.h>
 #include <linux/netfilter/nf_nat.h>
+#include <linux/netfilter/nf_log.h>
 #include <netinet/ip_icmp.h>
 #include <netinet/icmp6.h>
 #include <libnftnl/common.h>
@@ -201,6 +202,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token EXPORT			"export"
 %token MONITOR			"monitor"
 
+%token ALL			"all"
+
 %token ACCEPT			"accept"
 %token DROP			"drop"
 %token CONTINUE			"continue"
@@ -268,6 +271,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token GATEWAY			"gateway"
 %token MTU			"mtu"
 
+%token OPTIONS			"options"
+
 %token IP6			"ip6"
 %token PRIORITY			"priority"
 %token FLOWLABEL		"flowlabel"
@@ -481,7 +486,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %destructor { stmt_free($$); }	meta_stmt
 %type <stmt>			log_stmt log_stmt_alloc
 %destructor { stmt_free($$); }	log_stmt log_stmt_alloc
-%type <val>			level_type
+%type <val>			level_type log_flags log_flags_tcp log_flag_tcp
 %type <stmt>			limit_stmt quota_stmt
 %destructor { stmt_free($$); }	limit_stmt quota_stmt
 %type <val>			limit_burst limit_mode time_unit quota_mode
@@ -1530,6 +1535,10 @@ log_arg			:	PREFIX			string
 				$<stmt>0->log.level	= $2;
 				$<stmt>0->log.flags 	|= STMT_LOG_LEVEL;
 			}
+			|	FLAGS			log_flags
+			{
+				$<stmt>0->log.logflags	|= $2;
+			}
 			;
 
 level_type		:	string
@@ -1558,6 +1567,45 @@ level_type		:	string
 			}
 			;
 
+log_flags		:	TCP	log_flags_tcp
+			{
+				$$ = $2;
+			}
+			|	IP	OPTIONS
+			{
+				$$ = NF_LOG_IPOPT;
+			}
+			|	SKUID
+			{
+				$$ = NF_LOG_UID;
+			}
+			|	ETHER
+			{
+				$$ = NF_LOG_MACDECODE;
+			}
+			|	ALL
+			{
+				$$ = NF_LOG_MASK;
+			}
+			;
+
+log_flags_tcp		:	log_flags_tcp	COMMA	log_flag_tcp
+			{
+				$$ = $1 | $3;
+			}
+			|	log_flag_tcp
+			;
+
+log_flag_tcp		:	SEQUENCE
+			{
+				$$ = NF_LOG_TCPSEQ;
+			}
+			|	OPTIONS
+			{
+				$$ = NF_LOG_TCPOPT;
+			}
+			;
+
 limit_stmt		:	LIMIT	RATE	limit_mode	NUM	SLASH	time_unit	limit_burst
 	    		{
 				$$ = limit_stmt_alloc(&@$);
diff --git a/src/scanner.l b/src/scanner.l
index cd7398b..625023f 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -469,6 +469,9 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 
 "notrack"		{ return NOTRACK; }
 
+"options"		{ return OPTIONS; }
+"all"			{ return ALL; }
+
 "xml"			{ return XML; }
 "json"			{ return JSON; }
 
diff --git a/src/statement.c b/src/statement.c
index 8ccd489..e70eb51 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -27,6 +27,7 @@
 
 #include <netinet/in.h>
 #include <linux/netfilter/nf_nat.h>
+#include <linux/netfilter/nf_log.h>
 
 struct stmt *stmt_alloc(const struct location *loc,
 			const struct stmt_ops *ops)
@@ -193,6 +194,28 @@ static void log_stmt_print(const struct stmt *stmt)
 	if ((stmt->log.flags & STMT_LOG_LEVEL) &&
 	    stmt->log.level != LOG_WARNING)
 		printf(" level %s", log_level(stmt->log.level));
+
+	if ((stmt->log.logflags & NF_LOG_MASK) == NF_LOG_MASK) {
+		printf(" flags all");
+	} else {
+		if (stmt->log.logflags & (NF_LOG_TCPSEQ | NF_LOG_TCPOPT)) {
+			const char *delim = " ";
+
+			printf(" flags tcp");
+			if (stmt->log.logflags & NF_LOG_TCPSEQ) {
+				printf(" sequence");
+				delim = ",";
+			}
+			if (stmt->log.logflags & NF_LOG_TCPOPT)
+				printf("%soptions", delim);
+		}
+		if (stmt->log.logflags & NF_LOG_IPOPT)
+			printf(" flags ip options");
+		if (stmt->log.logflags & NF_LOG_UID)
+			printf(" flags skuid");
+		if (stmt->log.logflags & NF_LOG_MACDECODE)
+			printf(" flags ether");
+	}
 }
 
 static void log_stmt_destroy(struct stmt *stmt)
diff --git a/tests/py/any/log.t b/tests/py/any/log.t
index 99a7f1f..3798202 100644
--- a/tests/py/any/log.t
+++ b/tests/py/any/log.t
@@ -25,3 +25,9 @@ log prefix aaaaa-aaaaaa group 2 snaplen 33;ok;log prefix "aaaaa-aaaaaa" group 2
 log group 2 queue-threshold 2;ok
 log group 2 snaplen 33;ok
 log group 2 prefix \"nft-test: \";ok;log prefix "nft-test: " group 2
+
+log flags all;ok
+log level debug flags ip options flags skuid;ok
+log flags tcp sequence,options;ok
+log flags ip options flags ether flags skuid flags tcp sequence,options;ok;log flags all
+log flags all group 2;fail
diff --git a/tests/py/any/log.t.payload b/tests/py/any/log.t.payload
index dc885b4..385b8bb 100644
--- a/tests/py/any/log.t.payload
+++ b/tests/py/any/log.t.payload
@@ -50,3 +50,18 @@ ip test-ip4 output
 ip test-ip4 output
   [ log prefix nft-test:  group 2 snaplen 0 qthreshold 0 ]
 
+# log flags all
+ip test-ip4 output
+  [ log tcpseq tcpopt ipopt uid macdecode ]
+
+# log level debug flags ip options flags skuid
+ip test-ip4 output
+  [ log level 7 ipopt uid ]
+
+# log flags tcp sequence,options
+ip test-ip4 output
+  [ log tcpseq tcpopt ]
+
+# log flags ip options flags ether flags skuid flags tcp sequence,options
+ip test-ip4 output
+  [ log tcpseq tcpopt ipopt uid macdecode ]
-- 
2.5.5


