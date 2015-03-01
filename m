From: =?UTF-8?B?TWFya3VzIEvDtnR0ZXI=?= <koetter@rrzn.uni-hannover.de>
Subject: [RFC] nft trace
Date: Sun, 01 Mar 2015 19:06:13 +0100
Message-ID: <54F35515.5050807@rrzn.uni-hannover.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070702080100060908010503"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout2.uni-hannover.de ([130.75.2.114]:33205 "EHLO
	mailout2.uni-hannover.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbbCASQs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Mar 2015 13:16:48 -0500
Received: from localhost (localhost [127.0.0.1])
	by mailout2.uni-hannover.de (Postfix) with ESMTP id 89890607E
	for <netfilter-devel@vger.kernel.org>; Sun,  1 Mar 2015 19:06:11 +0100 (CET)
Received: from mailout2.uni-hannover.de ([127.0.0.1])
	by localhost (mailout2.uni-hannover.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6cP7SyPnPbVb for <netfilter-devel@vger.kernel.org>;
	Sun,  1 Mar 2015 19:06:11 +0100 (CET)
Received: from [192.168.53.226] (p5DDA5F6D.dip0.t-ipconnect.de [93.218.95.109])
	(Authenticated sender: koetter@rrzn.uni-hannover.de)
	by mailout2.uni-hannover.de (Postfix) with ESMTPSA id D2198607C
	for <netfilter-devel@vger.kernel.org>; Sun,  1 Mar 2015 19:06:10 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070702080100060908010503
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

the only thing which I do not like about
https://github.com/commonism/iptables-trace
is the timing.
Getting released more than 10 years after iptables had it's initial 
release, I decided to address nft in time.

So, I propose to add a new command to nft - "trace".

nft trace uses libnetfilter_log receive log messages, and gathers 
information from messages prefixed with "TRACE: ".
It looks up the chain, rule, and action, and prints a human readable 
representation.

such as

> IN=eth0 OUT= SRC=141.30.13.10 DST=10.0.2.15 LEN=1408 TOS=0x00 PREC=0x00 TTL=64 ID=60563
>         filter input (#2) NFMARK=0x0
>                  ip protocol icmp nftrace set 1
>         filter input (#3) NFMARK=0x0
>                  icmp type { echo-request, echo-reply} counter packets 5 bytes 420
>         filter input (#4) NFMARK=0x0
>                  ip protocol icmp jump test-0-0
>         filter test-0-0 (#1) NFMARK=0x1
>                  mark set 0x00000001
>         filter test-0-0 (#3) NFMARK=0x2
>                  mark set 0x00000002
>         filter test-0-0 NFMARK=0x2
>                  => RETURN
>         filter input (#5) NFMARK=0x2
>                  ip protocol icmp goto test-1-0
>         filter test-1-0 (#1) NFMARK=0x2
>                  ip protocol vmap { tcp : drop, icmp : jump test-0-0}
>         filter test-0-0 (#1) NFMARK=0x1
>                  mark set 0x00000001
>         filter test-0-0 (#3) NFMARK=0x2
>                  mark set 0x00000002
>         filter test-0-0 NFMARK=0x2
>                  => RETURN
>         filter test-1-0 NFMARK=0x2
>                  => RETURN
>         filter input NFMARK=0x2
>                 ACCEPT


So you can set an nftrace meta on a packet you want to debug, and use 
"nft trace" to follow the packets on their way through the kernel.
You can use "limit" to limit the amount of packets traced to 1 packet a 
second, making things smooth and easy to follow and avoiding overlaps 
when printing the trace.
The start of a trace is detected by looking for a nftrace meta on the 
currently matching rule, if it is set, you can print the packet header.

I really recommend such trace functionality, it is of great use to me 
when using iptables. And as I doubt nftables rulesets will get any 
easier to debug, I'm looking to get trace into nft.
In mose cases it is enough to know the ip address of the service which 
does not work, setup a trace rule, follow the packet, see where it gets 
lost. iptables-trace basically changed the way I write/adjust rules, and 
I want to keep it it this way with nft.

None of this works with current kernels, as changes to the netlink 
logging infrastructure in v3.17 prevent TRACE messages from being 
relayed to netlink.
I filed a report here:
http://bugzilla.netfilter.org/show_bug.cgi?id=1003

Using NULL as nf_loginfo works for me (messages end up in group 0 as 
before), but in order to get a first class trace functionality I'm 
looking to get NFLOG arguments to TRACE, so you can set a group and be a 
of type ULOG in the kernel, and get relayed to userspace.
For compatibility, TRACE without additional arguments can still be of 
type LOG, as it was before.
Having NFLOG groups would even allow multiple "nft trace" instances 
without interfering with each other, each instance addressing a 
different group.

Making this change in a compatible way for 
xtables/iptables/ip6tables/nftables requires quite some work on 
userspace and kernel space for all of the software providing TRACE 
functionality.

Attached is a patch on current nftables which can be used as technical 
demo, it is ugly, incomplete and rough, but short and will work for 
something to look at.
To use this, I patched my kernel to log TRACE messages using NULL as 
nf_loginfo as mentioned before.

I'd love a response regarding the odds of getting the nft trace 
functionality merged - I promise to continue working on it, clean things 
up, I'll take care it is optional and does not tie nft to 
libnetfilter_conntrack (e.g. for embedded platforms).
Same for changing TRACE to accept arguments - fixing the regression by 
using NULL as nf_loginfo for trace is trivial but ... having NFLOG 
groups in TRACE can be really handy.



MfG
Markus Kötter

--------------070702080100060908010503
Content-Type: text/x-patch;
 name="nft_trace_demo.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="nft_trace_demo.diff"

diff --git a/include/rule.h b/include/rule.h
index 491411e..325ac0f 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -119,6 +119,7 @@ struct chain {
 	const char		*type;
 	struct scope		scope;
 	struct list_head	rules;
+	uint32_t		policy;
 };
 
 extern const char *chain_type_name_lookup(const char *name);
@@ -224,6 +225,7 @@ extern void set_print_plain(const struct set *s);
  * @CMD_EXPORT:		export the ruleset in a given format
  * @CMD_MONITOR:	event listener
  * @CMD_DESCRIBE:	describe an expression
+ * @CMD_TRACE:		print the packets trace
  */
 enum cmd_ops {
 	CMD_INVALID,
@@ -237,6 +239,7 @@ enum cmd_ops {
 	CMD_EXPORT,
 	CMD_MONITOR,
 	CMD_DESCRIBE,
+	CMD_TRACE,
 };
 
 /**
@@ -253,6 +256,7 @@ enum cmd_ops {
  * @CMD_OBJ_EXPR:	expression
  * @CMD_OBJ_MONITOR:	monitor
  * @CMD_OBJ_EXPORT:	export
+ * @CMD_OBJ_TRACE:	trace
  */
 enum cmd_obj {
 	CMD_OBJ_INVALID,
@@ -266,6 +270,7 @@ enum cmd_obj {
 	CMD_OBJ_EXPR,
 	CMD_OBJ_MONITOR,
 	CMD_OBJ_EXPORT,
+	CMD_OBJ_TRACE,
 };
 
 struct export {
@@ -296,6 +301,14 @@ struct monitor {
 struct monitor *monitor_alloc(uint32_t format, uint32_t type, const char *event);
 void monitor_free(struct monitor *m);
 
+struct trace {
+	struct location	location;
+};
+
+struct trace *trace_alloc(void);
+void trace_free(struct trace *m);
+
+
 /**
  * struct cmd - command statement
  *
@@ -325,6 +338,7 @@ struct cmd {
 		struct table	*table;
 		struct monitor	*monitor;
 		struct export	*export;
+		struct trace	*trace;
 	};
 	const void		*arg;
 };
diff --git a/src/Makefile.am b/src/Makefile.am
index 2410fd3..2123013 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -57,4 +57,4 @@ mini-gmp.o: AM_CFLAGS += -Wno-sign-compare
 nft_SOURCES +=	mini-gmp.c
 endif
 
-nft_LDADD	= ${LIBMNL_LIBS} ${LIBNFTNL_LIBS}
+nft_LDADD	= ${LIBMNL_LIBS} ${LIBNFTNL_LIBS} -lnetfilter_log
diff --git a/src/evaluate.c b/src/evaluate.c
index a3484c6..6f7913d 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1971,6 +1971,8 @@ int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
 		return 0;
 	case CMD_MONITOR:
 		return cmd_evaluate_monitor(ctx, cmd);
+	case CMD_TRACE:
+		return 0; //cmd_evaluate_trace(ctx, cmd);
 	default:
 		BUG("invalid command operation %u\n", cmd->op);
 	};
diff --git a/src/netlink.c b/src/netlink.c
index 84d9d27..17aabd4 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -675,6 +675,10 @@ static struct chain *netlink_delinearize_chain(struct netlink_ctx *ctx,
 		chain->flags        |= CHAIN_F_BASECHAIN;
 	}
 
+	if (nft_chain_attr_is_set(nlc, NFT_CHAIN_ATTR_TYPE))
+		chain->policy =
+		nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_POLICY);
+
 	return chain;
 }
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index fd2407c..447f07b 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -190,6 +190,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token DESCRIBE			"describe"
 %token EXPORT			"export"
 %token MONITOR			"monitor"
+%token TRACE			"trace"
 
 %token ACCEPT			"accept"
 %token DROP			"drop"
@@ -402,8 +403,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <cmd>			line
 %destructor { cmd_free($$); }	line
 
-%type <cmd>			base_cmd add_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd
-%destructor { cmd_free($$); }	base_cmd add_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd
+%type <cmd>			base_cmd add_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd trace_cmd
+%destructor { cmd_free($$); }	base_cmd add_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd trace_cmd
 
 %type <handle>			table_spec tables_spec chain_spec chain_identifier ruleid_spec ruleset_spec
 %destructor { handle_free(&$$); } table_spec tables_spec chain_spec chain_identifier ruleid_spec ruleset_spec
@@ -640,6 +641,7 @@ base_cmd		:	/* empty */	add_cmd		{ $$ = $1; }
 			|	EXPORT		export_cmd	{ $$ = $2; }
 			|	MONITOR		monitor_cmd	{ $$ = $2; }
 			|	DESCRIBE	describe_cmd	{ $$ = $2; }
+			|	TRACE		trace_cmd	{ $$ = $2; }
 			;
 
 add_cmd			:	TABLE		table_spec
@@ -809,6 +811,16 @@ export_cmd		:	export_format
 			}
 			;
 
+trace_cmd	:
+			{
+				struct handle h = { .family = NFPROTO_UNSPEC };
+				struct trace *t = trace_alloc();
+				t->location = @-1;
+				$$ = cmd_alloc(CMD_TRACE, CMD_OBJ_TRACE, &h, &@$, t);
+			}
+			;
+
+
 monitor_cmd		:	monitor_event	monitor_object	monitor_format
 			{
 				struct handle h = { .family = NFPROTO_UNSPEC };
diff --git a/src/rule.c b/src/rule.c
index 8d76fd0..9cb8715 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -573,6 +573,19 @@ void monitor_free(struct monitor *m)
 	xfree(m);
 }
 
+struct trace *trace_alloc(void)
+{
+	struct trace *tr;
+
+	tr = xmalloc(sizeof(struct trace));
+	return tr;
+}
+
+void trace_free(struct trace *tr)
+{
+	xfree(tr);
+}
+
 void cmd_free(struct cmd *cmd)
 {
 	handle_free(&cmd->handle);
@@ -602,6 +615,9 @@ void cmd_free(struct cmd *cmd)
 		case CMD_OBJ_EXPORT:
 			export_free(cmd->export);
 			break;
+		case CMD_OBJ_TRACE:
+			trace_free(cmd->trace);
+			break;
 		default:
 			BUG("invalid command object type %u\n", cmd->obj);
 		}
@@ -945,6 +961,251 @@ static int do_command_rename(struct netlink_ctx *ctx, struct cmd *cmd)
 	return 0;
 }
 
+#include <libnetfilter_log/libnetfilter_log.h>
+#include "netlink.h"
+#include "mnl.h"
+
+static void *memrchr(const void *s, int c, size_t n)
+{
+    const unsigned char *cp;
+
+    if (n != 0) {
+	cp = (unsigned char *)s + n;
+	do {
+	    if (*(--cp) == (unsigned char)c)
+		return((void *)cp);
+	} while (--n != 0);
+    }
+    return((void *)0);
+}
+
+struct trace_prefix
+{
+	char *table;
+	char *chain;
+	char *action;
+	char *num;
+};
+
+static int parse_trace_prefix(char *prefix, struct trace_prefix *td)
+{
+	static const char *TRACE = "TRACE: ";
+	char *pos = prefix;
+	char *end = NULL;
+
+//	printf("%s\n", prefix);
+	/* "TRACE: filter:input:rule:2 " */
+	if (strncmp(prefix, TRACE, strlen(TRACE)) != 0)
+		return -1;
+
+	pos += strlen(TRACE);
+	end = pos + strlen(pos);
+	/* "filter:input:rule:2 " */
+	/* TABLE:CHAIN:ACTION:NUM */
+	/* parse reverse as : is allowed in iptables chain names */
+	if ( (end=memrchr(pos, ':', end-pos)) == NULL )
+		goto invalid_format_error;
+	*end = '\0';
+	td->num = end+1;
+
+	if ( (end=memrchr(pos, ':', end-1-pos)) == NULL )
+		goto invalid_format_error;
+	*end = '\0';
+	td->action = end+1;
+
+	td->table = pos;
+
+	if ( (end=strchr(pos, ':')) == NULL )
+		goto invalid_format_error;
+	*end = '\0';
+	td->chain = end + 1;
+
+//	printf("table '%s' chain '%s' action '%s' num '%s'\n", td->table, td->chain, td->action, td->num);
+
+	return 0;
+invalid_format_error:
+	return -1;
+}
+
+static int create_cache(struct netlink_ctx *ctx, struct handle *h, struct location *loc)
+{
+	struct table *t, *nt;
+	struct set *s, *ns;
+	struct chain *c, *nc;
+	struct rule *r, *rc;
+	struct netlink_ctx tmpctx;
+	LIST_HEAD(msgs);
+	struct handle filter;
+
+	/* create cache */
+	memset(&tmpctx, 0, sizeof(tmpctx));
+	init_list_head(&msgs);
+	tmpctx.msgs = &msgs;
+
+	if (netlink_list_tables(ctx, h, loc) < 0)
+		return -1;
+
+	printf("XXXXXXXXXXXXXX\n");
+	list_for_each_entry_safe(t, nt, &ctx->list, list) {
+		printf("%s\n", t->handle.table);
+		table_add_hash(t);
+
+		filter.family = t->handle.family;
+		filter.table = t->handle.table;
+		filter.chain = NULL;
+
+		init_list_head(&tmpctx.list);
+
+		if (netlink_list_sets(&tmpctx, &filter, loc) < 0)
+			return -1;
+
+		list_for_each_entry_safe(s, ns, &tmpctx.list, list) {
+			if (netlink_get_setelems(&tmpctx, &s->handle, loc, s) < 0)
+				return -1;
+			list_move_tail(&s->list, &t->sets);
+			set_add_hash(s, t);
+		}
+
+		init_list_head(&tmpctx.list);
+
+		if (netlink_list_chains(&tmpctx, &filter, loc) < 0)
+			return -1;
+
+		list_for_each_entry_safe(c, nc, &tmpctx.list, list) {
+			chain_add_hash(c, t);
+		}
+
+		init_list_head(&tmpctx.list);
+
+		if (netlink_list_table(&tmpctx, &filter, loc) < 0)
+			return -1;
+
+		list_for_each_entry_safe(r, rc, &tmpctx.list, list) {
+			c = chain_lookup(t, &r->handle);
+			if (c == NULL) {
+				c = chain_alloc(r->handle.chain);
+				chain_add_hash(c, t);
+			}
+			list_move_tail(&r->list, &c->rules);
+		}
+		init_list_head(&tmpctx.list);
+	}
+	return 0;
+}
+
+static int trace_cb(struct nflog_g_handle *gh, struct nfgenmsg *nfmsg,
+			  struct nflog_data *nfa, void *data)
+{
+	struct trace_prefix td = {};
+	char *prefix = NULL;
+	struct handle h;
+	struct table *table;
+	struct chain *chain;
+	struct rule *rule = NULL;
+	const struct stmt *stmt;
+	int i;
+
+	prefix = strdup(nflog_get_prefix(nfa));
+	if (parse_trace_prefix(prefix, &td) != 0)
+		goto invalid_format_error;
+
+	h.table = td.table;
+	h.family = NFPROTO_IPV4;
+	table = table_lookup(&h);
+
+	h.chain = td.chain;
+	chain = chain_lookup(table, &h);
+
+	if (strcmp(td.action, "rule") == 0) {
+		i = atoi(td.num);
+		list_for_each_entry(rule, &chain->rules, list) {
+			if (--i != 0)
+				continue;
+			break;
+		}
+		list_for_each_entry(stmt, &rule->stmts, list) {
+			if (stmt->ops->type == STMT_META &&
+				stmt->meta.key == NFT_META_NFTRACE)
+			{
+				printf("\n%s\n", "a->b");
+				break;
+			}
+		}
+	}
+
+
+	if (strcmp(td.action, "policy") == 0) {
+		char *policies[NF_MAX_VERDICT] = {
+			[NF_DROP] = "DROP",
+			[NF_ACCEPT] = "ACCEPT",
+			[NF_QUEUE] = "QUEUE",
+		};
+		printf("\t%s %s NFMARK=0x%x\n", td.table, td.chain, nflog_get_nfmark(nfa));
+		printf("\t\t%s\n", policies[chain->policy]);
+	} else
+	if (strcmp(td.action, "rule") == 0) {
+		printf("\t%s %s (#%i) NFMARK=0x%x\n", td.table, td.chain, atoi(td.num), nflog_get_nfmark(nfa));
+		printf("\t\t");
+		rule_print(rule);
+		printf("\n");
+	} else
+	if (strcmp(td.action, "return") == 0) {
+		printf("\t%s %s NFMARK=0x%x\n", td.table, td.chain, nflog_get_nfmark(nfa));
+		printf("\t\t => RETURN\n");
+	}
+
+invalid_format_error:
+	free(prefix);
+	return 0;
+}
+static int do_command_trace(struct netlink_ctx *ctx, struct cmd *cmd)
+{
+	struct nflog_handle *h;
+	struct nflog_g_handle *qh;
+	int fd;
+	int rv=0;
+	char buf[4096];
+
+	struct handle x = { .family = NFPROTO_IPV4 };
+	create_cache(ctx, &x, &cmd->location);
+
+    h = nflog_open();
+	if (!h) {
+		fprintf(stderr, "error during nflog_open()\n");
+		exit(1);
+	}
+	if (nflog_unbind_pf(h, AF_INET) < 0) {
+		fprintf(stderr, "error nflog_unbind_pf()\n");
+		exit(1);
+
+	}
+
+	if (nflog_bind_pf(h, AF_INET) < 0 ){
+		fprintf(stderr, "error during nflog_bind_pf()\n");
+		exit(1);
+	}
+
+	qh = nflog_bind_group(h, 0);
+	if (!qh) {
+		fprintf(stderr, "no handle for grup 0\n");
+		exit(1);
+	}
+
+	if (nflog_set_mode(qh, NFULNL_COPY_PACKET, 0xffff) < 0) {
+		fprintf(stderr, "can't set packet copy mode\n");
+		exit(1);
+	}
+
+	fd = nflog_fd(h);
+	nflog_callback_register(qh, &trace_cb, ctx);
+
+	while ((rv = recv(fd, buf, sizeof(buf), 0)) && rv >= 0) {
+		nflog_handle_packet(h, buf, rv);
+	}
+
+	return 0;
+}
+
 static int do_command_monitor(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	struct table *t, *nt;
@@ -1029,6 +1290,8 @@ int do_command(struct netlink_ctx *ctx, struct cmd *cmd)
 		return do_command_monitor(ctx, cmd);
 	case CMD_DESCRIBE:
 		return do_command_describe(ctx, cmd);
+	case CMD_TRACE:
+		return do_command_trace(ctx, cmd);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
diff --git a/src/scanner.l b/src/scanner.l
index 73c4f8b..4f8ace4 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -263,6 +263,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "rename"		{ return RENAME; }
 "export"		{ return EXPORT; }
 "monitor"		{ return MONITOR; }
+"trace"			{ return TRACE; }
 
 "position"		{ return POSITION; }
 "comment"		{ return COMMENT; }

--------------070702080100060908010503--
