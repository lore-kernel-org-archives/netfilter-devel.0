From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [RFC PATCH 1/1] xtables: allow to monitor table update event
Date: Tue,  2 Oct 2012 15:06:11 +0200
Message-ID: <1349183171-4136-2-git-send-email-nicolas.dichtel@6wind.com>
References: <1348501182-12470-1-git-send-email-nicolas.dichtel@6wind.com>
 <1349183171-4136-1-git-send-email-nicolas.dichtel@6wind.com>
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>
To: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 33.106-14-84.ripe.coltfrance.com ([84.14.106.33]:39280 "EHLO
	proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab2JBNBu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Oct 2012 09:01:50 -0400
In-Reply-To: <1349183171-4136-1-git-send-email-nicolas.dichtel@6wind.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

A new command (--monitor-table-update or -T) is added to be able to monitor
netlink event that inform when a table is updated.

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 include/linux/netfilter/nfnetlink_tables.h | 24 +++++++++
 include/xtables.h                          | 10 ++++
 iptables/ip6tables.c                       | 16 +++++-
 iptables/iptables.c                        | 16 +++++-
 libxtables/Makefile.am                     |  4 ++
 libxtables/xtables.c                       | 87 ++++++++++++++++++++++++++++++
 6 files changed, 153 insertions(+), 4 deletions(-)
 create mode 100644 include/linux/netfilter/nfnetlink_tables.h

diff --git a/include/linux/netfilter/nfnetlink_tables.h b/include/linux/netfilter/nfnetlink_tables.h
new file mode 100644
index 0000000..bb70039
--- /dev/null
+++ b/include/linux/netfilter/nfnetlink_tables.h
@@ -0,0 +1,24 @@
+#ifndef _NFNETLINK_TABLES_H
+#define _NFNETLINK_TABLES_H
+
+/* This file describes the netlink messages (i.e. 'protocol packets'),
+ * and not any kind of function definitions.  It is shared between kernel and
+ * userspace.  Don't put kernel specific stuff in here */
+
+#include <linux/types.h>
+#include <linux/netfilter/nfnetlink.h>
+
+enum nftbl_types {
+	NFTBL_UPDATE,
+
+	NFTBL_MSG_MAX
+};
+
+enum nfnl_tables_attr_type {
+	NFTBLA_UNSPEC,
+	NFTBLA_TABLENAME,
+	__NFTBLA_MAX
+};
+#define NFTBLA_MAX (__NFTBLA_MAX - 1)
+
+#endif /* _NFNETLINK_TABLES_H */
diff --git a/include/xtables.h b/include/xtables.h
index 2cc1a02..32c42b1 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -18,6 +18,11 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter/x_tables.h>
 
+#ifdef HAVE_LIBNFNETLINK
+#include <libnfnetlink/libnfnetlink.h>
+#include <linux/netfilter/nfnetlink_tables.h>
+#endif
+
 #ifndef IPPROTO_SCTP
 #define IPPROTO_SCTP 132
 #endif
@@ -432,8 +437,11 @@ extern u_int16_t xtables_parse_port(const char *port, const char *proto);
 extern void
 xtables_parse_interface(const char *arg, char *vianame, unsigned char *mask);
 
+#ifndef HAVE_LIBNFNETLINK
+/* already defined libnfnetlink/libnfnetlink.h */
 /* this is a special 64bit data type that is 8-byte aligned */
 #define aligned_u64 u_int64_t __attribute__((aligned(8)))
+#endif
 
 extern struct xtables_globals *xt_params;
 #define xtables_error (xt_params->exit_err)
@@ -511,6 +519,8 @@ extern void xtables_lmap_free(struct xtables_lmap *);
 extern int xtables_lmap_name2id(const struct xtables_lmap *, const char *);
 extern const char *xtables_lmap_id2name(const struct xtables_lmap *, int);
 
+extern int nfnl_monitor_table_udpate(void);
+
 #ifdef XTABLES_INTERNAL
 
 /* Shipped modules rely on this... */
diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 3661216..408c91e 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -83,7 +83,8 @@
 #define CMD_LIST_RULES		0x1000U
 #define CMD_ZERO_NUM		0x2000U
 #define CMD_CHECK		0x4000U
-#define NUMBER_OF_CMD	16
+#define CMD_MONITOR_TBLUPDT	0x8000U
+#define NUMBER_OF_CMD	17
 static const char cmdflags[] = { 'I', 'D', 'D', 'R', 'A', 'L', 'F', 'Z',
 				 'N', 'X', 'P', 'E', 'S', 'Z', 'C' };
 
@@ -105,6 +106,7 @@ static struct option original_opts[] = {
 	{.name = "delete-chain",  .has_arg = 2, .val = 'X'},
 	{.name = "rename-chain",  .has_arg = 1, .val = 'E'},
 	{.name = "policy",        .has_arg = 1, .val = 'P'},
+	{.name = "monitor-table-update",.has_arg = 0, .val = 'T'},
 	{.name = "source",        .has_arg = 1, .val = 's'},
 	{.name = "destination",   .has_arg = 1, .val = 'd'},
 	{.name = "src",           .has_arg = 1, .val = 's'}, /* synonym */
@@ -165,6 +167,7 @@ static const char commands_v_options[NUMBER_OF_CMD][NUMBER_OF_OPT] =
 /*RENAME*/    {'x','x','x','x','x',' ','x','x','x','x','x'},
 /*LIST_RULES*/{'x','x','x','x','x',' ','x','x','x','x','x'},
 /*CHECK*/     {'x',' ',' ',' ',' ',' ','x',' ',' ','x','x'},
+/*MONITOR*/   {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
 };
 
 static const unsigned int inverse_for_options[NUMBER_OF_OPT] =
@@ -248,6 +251,7 @@ exit_printhelp(const struct xtables_rule_match *matches)
 "  --rename-chain\n"
 "            -E old-chain new-chain\n"
 "				Change chain name, (moving any references)\n"
+"  --monitor-table-update	Monitor table update\n"
 
 "Options:\n"
 "    --ipv4	-4		Error (line is ignored by ip6tables-restore)\n"
@@ -1381,7 +1385,7 @@ int do_command6(int argc, char *argv[], char **table, struct xtc_handle **handle
 
 	opts = xt_params->orig_opts;
 	while ((cs.c = getopt_long(argc, argv,
-	   "-:A:C:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:bvnt:m:xc:g:46",
+	   "-:A:C:D:R:I:L::S::M:F::Z::N:X::E:P:VTh::o:p:s:d:j:i:bvnt:m:xc:g:46",
 					   opts, NULL)) != -1) {
 		switch (cs.c) {
 			/*
@@ -1530,6 +1534,11 @@ int do_command6(int argc, char *argv[], char **table, struct xtc_handle **handle
 					   cmd2char(CMD_SET_POLICY));
 			break;
 
+		case 'T':
+			add_command(&command, CMD_MONITOR_TBLUPDT, CMD_NONE,
+				    cs.invert);
+			break;
+
 		case 'h':
 			if (!optarg)
 				optarg = argv[optind];
@@ -1777,6 +1786,9 @@ int do_command6(int argc, char *argv[], char **table, struct xtc_handle **handle
 			   "chain name `%s' too long (must be under %u chars)",
 			   chain, XT_EXTENSION_MAXNAMELEN);
 
+	if (command ==  CMD_MONITOR_TBLUPDT)
+		ret = nfnl_monitor_table_udpate();
+
 	/* only allocate handle if we weren't called with a handle */
 	if (!*handle)
 		*handle = ip6tc_init(*table);
diff --git a/iptables/iptables.c b/iptables/iptables.c
index e935f65..b8a99ab 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -79,7 +79,8 @@
 #define CMD_LIST_RULES		0x1000U
 #define CMD_ZERO_NUM		0x2000U
 #define CMD_CHECK		0x4000U
-#define NUMBER_OF_CMD	16
+#define CMD_MONITOR_TBLUPDT	0x8000U
+#define NUMBER_OF_CMD	17
 static const char cmdflags[] = { 'I', 'D', 'D', 'R', 'A', 'L', 'F', 'Z',
 				 'N', 'X', 'P', 'E', 'S', 'Z', 'C' };
 
@@ -102,6 +103,7 @@ static struct option original_opts[] = {
 	{.name = "delete-chain",  .has_arg = 2, .val = 'X'},
 	{.name = "rename-chain",  .has_arg = 1, .val = 'E'},
 	{.name = "policy",        .has_arg = 1, .val = 'P'},
+	{.name = "monitor-table-update",.has_arg = 0, .val = 'T'},
 	{.name = "source",        .has_arg = 1, .val = 's'},
 	{.name = "destination",   .has_arg = 1, .val = 'd'},
 	{.name = "src",           .has_arg = 1, .val = 's'}, /* synonym */
@@ -164,6 +166,7 @@ static const char commands_v_options[NUMBER_OF_CMD][NUMBER_OF_OPT] =
 /*RENAME*/    {'x','x','x','x','x',' ','x','x','x','x','x','x'},
 /*LIST_RULES*/{'x','x','x','x','x',' ','x','x','x','x','x','x'},
 /*CHECK*/     {'x',' ',' ',' ',' ',' ','x',' ',' ','x','x',' '},
+/*MONITOR*/   {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
 };
 
 static const int inverse_for_options[NUMBER_OF_OPT] =
@@ -258,6 +261,7 @@ exit_printhelp(const struct xtables_rule_match *matches)
 "  --rename-chain\n"
 "            -E old-chain new-chain\n"
 "				Change chain name, (moving any references)\n"
+"  --monitor-table-update	Monitor table update\n"
 
 "Options:\n"
 "    --ipv4	-4		Nothing (line is ignored by ip6tables-restore)\n"
@@ -1394,7 +1398,7 @@ int do_command4(int argc, char *argv[], char **table, struct xtc_handle **handle
 
 	opts = xt_params->orig_opts;
 	while ((cs.c = getopt_long(argc, argv,
-	   "-:A:C:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:fbvnt:m:xc:g:46",
+	   "-:A:C:D:R:I:L::S::M:F::Z::N:X::E:P:VTh::o:p:s:d:j:i:fbvnt:m:xc:g:46",
 					   opts, NULL)) != -1) {
 		switch (cs.c) {
 			/*
@@ -1543,6 +1547,11 @@ int do_command4(int argc, char *argv[], char **table, struct xtc_handle **handle
 					   cmd2char(CMD_SET_POLICY));
 			break;
 
+		case 'T':
+			add_command(&command, CMD_MONITOR_TBLUPDT, CMD_NONE,
+				    cs.invert);
+			break;
+
 		case 'h':
 			if (!optarg)
 				optarg = argv[optind];
@@ -1791,6 +1800,9 @@ int do_command4(int argc, char *argv[], char **table, struct xtc_handle **handle
 			   "chain name `%s' too long (must be under %u chars)",
 			   chain, XT_EXTENSION_MAXNAMELEN);
 
+	if (command ==  CMD_MONITOR_TBLUPDT)
+		ret = nfnl_monitor_table_udpate();
+
 	/* only allocate handle if we weren't called with a handle */
 	if (!*handle)
 		*handle = iptc_init(*table);
diff --git a/libxtables/Makefile.am b/libxtables/Makefile.am
index c5795fe..b6b83a1 100644
--- a/libxtables/Makefile.am
+++ b/libxtables/Makefile.am
@@ -18,3 +18,7 @@ libxtables_la_LIBADD += -ldl
 else
 libxtables_la_CFLAGS  = ${AM_CFLAGS} -DNO_SHARED_LIBS=1
 endif
+if HAVE_LIBNFNETLINK
+libxtables_la_CFLAGS += ${libnfnetlink_CFLAGS} -DHAVE_LIBNFNETLINK
+libxtables_la_LIBADD += ${libnfnetlink_LIBS} -lnfnetlink
+endif
diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index 82c3643..348fcb1 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -1904,3 +1904,90 @@ void get_kernel_version(void)
 	sscanf(uts.release, "%d.%d.%d", &x, &y, &z);
 	kernel_version = LINUX_VERSION(x, y, z);
 }
+
+#ifdef HAVE_LIBNFNETLINK
+static int nfnl_monitor_table_udpate_cb(struct nlmsghdr *nlh,
+					struct nfattr *nfa[], void *data)
+{
+	struct nfgenmsg *nfmsg = NLMSG_DATA(nlh);
+
+	printf("Update table: family: ");
+	switch (nfmsg->nfgen_family) {
+	case NFPROTO_UNSPEC:
+		printf("unspec");
+		break;
+	case NFPROTO_IPV4:
+		printf("ipv4");
+		break;
+	case NFPROTO_ARP:
+		printf("arp");
+		break;
+	case NFPROTO_BRIDGE:
+		printf("bridge");
+		break;
+	case NFPROTO_IPV6:
+		printf("ipv6");
+		break;
+	case NFPROTO_DECNET:
+		printf("decnet");
+		break;
+	default:
+		printf("unknown");
+		break;
+	}
+
+	if (nfa[NFTBLA_TABLENAME-1] != NULL)
+		printf(", table: %s\n", (char *)NFA_DATA(nfa[NFTBLA_TABLENAME-1]));
+	else
+		printf(", NFTBLA_TABLENAME not set\n");
+
+	return NFNL_CB_CONTINUE;
+}
+#endif
+
+int nfnl_monitor_table_udpate(void)
+{
+#ifdef HAVE_LIBNFNETLINK
+	struct nfnl_handle *nfnlh;
+	struct nfnl_subsys_handle *nfnlsh;
+	struct nfnl_callback cb;
+	int err;
+
+	cb.call = nfnl_monitor_table_udpate_cb;
+	cb.data = NULL;
+	cb.attr_count = NFTBLA_MAX;
+
+	nfnlh = nfnl_open();
+	if (!nfnlh) {
+		err = -EINVAL;
+		perror("nfnl_open()");
+		goto err_out_exit;
+	}
+
+	nfnlsh = nfnl_subsys_open(nfnlh, NFNL_SUBSYS_TABLES, NFTBL_MSG_MAX,
+				  NF_NETLINK_TABLES);
+	if (!nfnlsh) {
+		err = -EINVAL;
+		perror("nfnl_subsys_open()");
+		goto err_out_close;
+	}
+
+	if ((err = nfnl_callback_register(nfnlsh, NFTBL_UPDATE, &cb)) < 0) {
+		perror("nfnl_callback_register()");
+		goto err_out_close_subsys;
+	}
+
+	if ((err = nfnl_catch(nfnlh)) < 0)
+		perror("nfnl_catch()");
+
+err_out_close_subsys:
+	nfnl_subsys_close(nfnlsh);
+err_out_close:
+	nfnl_close(nfnlh);
+err_out_exit:
+	return err;
+#else
+	fprintf(stderr, "tools compiled without nfnetlink support\n");
+	return -ENOTSUP;
+#endif
+}
-- 
1.7.12

