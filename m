From: James Chapman <jchapman@katalix.com>
Subject: [PATCH v6] iptables: add support for l2tp match
Date: Mon,  6 Jan 2014 10:18:36 +0000
Message-ID: <1389003516-29715-1-git-send-email-jchapman@katalix.com>
Cc: James Chapman <jchapman@katalix.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from katalix.com ([82.103.140.233]:46466 "EHLO bert.katalix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782AbaAFKTR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jan 2014 05:19:17 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds an iptables extension to support the l2tp xtables
add-on. The matcher lets users filter on one or more fields of L2TP
packets: tunnel-id, session-id, protocol version, encapsulation type
(IP or UDP), packet type (control or data).

Requires corresponding netfilter xt_l2tp kernel support, submitted
separately.

Signed-off-by: James Chapman <jchapman@katalix.com>

---
Changes in v2:
Change check() function to be consistent with kernel

Changes in v3:
Add local copy of xt_l2tp.h

Changes in v4:
Update check() again to be consistent with kernel.

Changes in v5:
Derive encap=udp setting if user specifies l2tpv2.
Check that encap is specified.
Update man page.

Changes in v6:
Remove encap arg.
Update man page about needing to use a -p arg and give better use
examples.

---
Tested with the below script:

IPTABLES=./iptables

check_ok()
{
    echo $*
    $*
    if [ $? -ne 0 ]; then
	echo "FAIL: $*"
	exit 1
    fi
}

check_fail()
{
    echo $*
    $*
    if [ $? -eq 0 ]; then
	echo "FAIL: $*"
	exit 1
    fi
}

check_fail $IPTABLES -I OUTPUT -m l2tp
check_fail $IPTABLES -I OUTPUT -m l2tp --tid 42
check_fail $IPTABLES -I OUTPUT -m l2tp --sid 42
check_fail $IPTABLES -I OUTPUT -m l2tp --type control
check_fail $IPTABLES -I OUTPUT -m l2tp --type data
check_fail $IPTABLES -I OUTPUT -m l2tp --tid 42 --pversion 3
check_fail $IPTABLES -I OUTPUT -m l2tp --type invalid
check_fail $IPTABLES -I OUTPUT -m l2tp --tid 42 --pversion 1
check_fail $IPTABLES -I OUTPUT -p 22 -m l2tp --tid 42 --pversion 3
check_fail $IPTABLES -I OUTPUT -m l2tp --tid 65536 --pversion 2
check_fail $IPTABLES -I OUTPUT -m l2tp --tid 42 --sid 65536 --pversion 2
check_fail $IPTABLES -I OUTPUT -m l2tp --tid 42 --pversion 2
check_fail $IPTABLES -I OUTPUT -m l2tp --tid 42 --pversion 3
check_fail $IPTABLES -I OUTPUT -p udp -m l2tp --tid 42 --pversion 2
check_fail $IPTABLES -I OUTPUT -p 115 -m l2tp --tid 42 --pversion 2

check_ok $IPTABLES -I OUTPUT -p udp --sport 5000 -m l2tp --tid 42 --pversion 2
check_ok $IPTABLES -D OUTPUT -p udp --sport 5000 -m l2tp --tid 42 --pversion 2
check_ok $IPTABLES -I OUTPUT -p udp --sport 5000 -m l2tp --tid 42 --pversion 2 --sid 42
check_ok $IPTABLES -D OUTPUT -p udp --sport 5000 -m l2tp --tid 42 --pversion 2 --sid 42
check_ok $IPTABLES -I OUTPUT -p udp --sport 5000 -m l2tp --tid 42
check_ok $IPTABLES -D OUTPUT -p udp --sport 5000 -m l2tp --tid 42
check_ok $IPTABLES -I OUTPUT -p udp -m l2tp --pversion 2 --type control
check_ok $IPTABLES -D OUTPUT -p udp -m l2tp --pversion 2 --type control
check_ok $IPTABLES -I OUTPUT -p udp --sport 5000 -m l2tp --tid 42 --pversion 3
check_ok $IPTABLES -D OUTPUT -p udp --sport 5000 -m l2tp --tid 42 --pversion 3
check_ok $IPTABLES -I OUTPUT -p 115 -m l2tp --tid 42 --pversion 3
check_ok $IPTABLES -D OUTPUT -p 115 -m l2tp --tid 42 --pversion 3
check_ok $IPTABLES -I OUTPUT -p udp -m l2tp --pversion 3 --type control
check_ok $IPTABLES -D OUTPUT -p udp -m l2tp --pversion 3 --type control
check_ok $IPTABLES -I OUTPUT -p udp --sport 5000 -m l2tp --tid 42 --pversion 3 --sid 42
check_ok $IPTABLES -D OUTPUT -p udp --sport 5000 -m l2tp --tid 42 --pversion 3 --sid 42

---
:000000 100644 0000000... 14965c6... A	extensions/libxt_l2tp.c
:000000 100644 0000000... b28e462... A	extensions/libxt_l2tp.man
:000000 100644 0000000... be65e0b... A	include/linux/netfilter/xt_l2tp.h
 extensions/libxt_l2tp.c           |  176 +++++++++++++++++++++++++++++++++++++
 extensions/libxt_l2tp.man         |   39 ++++++++
 include/linux/netfilter/xt_l2tp.h |   29 ++++++
 3 files changed, 244 insertions(+), 0 deletions(-)

diff --git a/extensions/libxt_l2tp.c b/extensions/libxt_l2tp.c
new file mode 100644
index 0000000..14965c6
--- /dev/null
+++ b/extensions/libxt_l2tp.c
@@ -0,0 +1,176 @@
+#include <stdint.h>
+#include <stdio.h>
+#include <string.h>
+#include <strings.h>
+#include <netdb.h>
+#include <arpa/inet.h>
+#include <xtables.h>
+#include <linux/netfilter/xt_l2tp.h>
+
+enum {
+	O_TID = 0,
+	O_SID,
+	O_VERSION,
+	O_TYPE,
+};
+
+static void l2tp_help(void)
+{
+	printf(
+"l2tp match options:\n"
+" --tunnel-id id\n"
+" --tid ...\n"
+"				match tunnel-id\n"
+" --session-id id\n"
+" --sid ...\n"
+"				match session-id\n"
+" --pversion {2|3}\n"
+"				match version\n"
+" --type {control|data}\n"
+"				match packet type\n"
+" Must be used with -p udp|l2tpip\n");
+}
+
+#define s struct xt_l2tp_info
+static const struct xt_option_entry l2tp_opts[] = {
+	{.name = "tunnel-id", .id = O_TID, .type = XTTYPE_UINT32,
+	 .flags = XTOPT_PUT, XTOPT_POINTER(s, tid)},
+	{.name = "tid", .id = O_TID, .type = XTTYPE_UINT32,
+	 .flags = XTOPT_PUT, XTOPT_POINTER(s, tid)},
+	{.name = "session-id", .id = O_SID, .type = XTTYPE_UINT32,
+	 .flags = XTOPT_PUT, XTOPT_POINTER(s, sid)},
+	{.name = "sid", .id = O_SID, .type = XTTYPE_UINT32,
+	 .flags = XTOPT_PUT, XTOPT_POINTER(s, sid)},
+	{.name = "pversion", .id = O_VERSION, .type = XTTYPE_UINT8,
+	 .flags = XTOPT_PUT, XTOPT_POINTER(s, version)},
+	{.name = "type", .id = O_TYPE, .type = XTTYPE_STRING },
+	XTOPT_TABLEEND,
+};
+#undef s
+
+static int parse_type(const char *s)
+{
+	if (strcmp(s, "control") == 0)
+		return XT_L2TP_TYPE_CONTROL;
+	if (strcmp(s, "data") == 0)
+		return XT_L2TP_TYPE_DATA;
+	xtables_error(PARAMETER_PROBLEM, "l2tp: invalid type \"%s\"", s);
+}
+
+static void l2tp_parse(struct xt_option_call *cb)
+{
+	struct xt_l2tp_info *info = cb->data;
+
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_TID:
+		info->flags |= XT_L2TP_TID;
+		break;
+	case O_SID:
+		info->flags |= XT_L2TP_SID;
+		break;
+	case O_VERSION:
+		info->flags |= XT_L2TP_VERSION;
+		break;
+	case O_TYPE:
+		info->type = parse_type(cb->arg);
+		info->flags |= XT_L2TP_TYPE;
+		break;
+	}
+}
+
+static void l2tp_check(struct xt_fcheck_call *cb)
+{
+	struct xt_l2tp_info *info = cb->data;
+
+	if ((!(info->flags & XT_L2TP_TID)) &&
+	    (!(info->flags & XT_L2TP_SID)) &&
+	    ((!(info->flags & XT_L2TP_TYPE)) ||
+	     (info->type != XT_L2TP_TYPE_CONTROL)))
+		xtables_error(PARAMETER_PROBLEM,
+			      "l2tp tid, sid or control type not specified");
+
+	if (info->flags & XT_L2TP_VERSION) {
+		if ((info->version < 2) || (info->version > 3))
+			xtables_error(PARAMETER_PROBLEM,
+				      "l2tp: invalid version \"%d\"",
+				      info->version);
+
+		if (info->version == 2) {
+			if ((info->flags & XT_L2TP_TID) &&
+			    (info->tid > 0xffff))
+				xtables_error(PARAMETER_PROBLEM,
+					      "l2tp tid is 16 bits for L2TPv2");
+			if ((info->flags & XT_L2TP_SID) &&
+			    (info->sid > 0xffff))
+				xtables_error(PARAMETER_PROBLEM,
+					      "l2tp sid is 16 bits for L2TPv2");
+		}
+	}
+}
+
+static void print_type(uint8_t type, const char *prefix)
+{
+	printf(" %stype ", prefix);
+
+	switch (type) {
+	case XT_L2TP_TYPE_CONTROL:
+		printf("control");
+		break;
+	case XT_L2TP_TYPE_DATA:
+		printf("data");
+		break;
+	default:
+		printf("???");
+		break;
+	}
+}
+
+static void l2tp_print(const void *ip, const struct xt_entry_match *match, int numeric)
+{
+	const struct xt_l2tp_info *info = (struct xt_l2tp_info *)match->data;
+
+	printf(" l2tp");
+	if (info->flags & XT_L2TP_TID)
+		printf(" tid %u", info->tid);
+	if (info->flags & XT_L2TP_SID)
+		printf(" sid %u", info->sid);
+	if (info->flags & XT_L2TP_VERSION)
+		printf(" pver %hd", info->version);
+	if (info->flags & XT_L2TP_TYPE)
+		print_type(info->type, "");
+}
+
+static void l2tp_save(const void *ip, const struct xt_entry_match *match)
+{
+	const struct xt_l2tp_info *info = (struct xt_l2tp_info *)match->data;
+
+	if (info->flags & XT_L2TP_TID)
+		printf(" --tid %u", info->tid);
+	if (info->flags & XT_L2TP_SID)
+		printf(" --sid %u", info->sid);
+	if (info->flags & XT_L2TP_VERSION)
+		printf(" --pversion %hd", info->version);
+	if (info->flags & XT_L2TP_TYPE)
+		print_type(info->type, "--");
+}
+
+static struct xtables_match l2tp_match = {
+	.family		= NFPROTO_UNSPEC,
+	.name		= "l2tp",
+	.version	= XTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_l2tp_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_l2tp_info)),
+	.help		= l2tp_help,
+	.print		= l2tp_print,
+	.save		= l2tp_save,
+	.x6_fcheck	= l2tp_check,
+	.x6_parse	= l2tp_parse,
+	.x6_options	= l2tp_opts,
+};
+
+void
+_init(void)
+{
+	xtables_register_match(&l2tp_match);
+}
diff --git a/extensions/libxt_l2tp.man b/extensions/libxt_l2tp.man
new file mode 100644
index 0000000..b28e462
--- /dev/null
+++ b/extensions/libxt_l2tp.man
@@ -0,0 +1,39 @@
+This is used to match L2TP packets. L2TP tunnels are identified by
+tunnel-id and session-id fields in the L2TP header. L2TPv2 and L2TPv3
+are supported.
+.TP
+\fB\-\-tunnel\-id\fP,\fB\-\-tid\fP \fIid\fP
+.TP
+\fB\-\-session\-id\fP,\fB\-\-sid\fP \fIid\fP
+.TP
+\fB\-\-pversion\fP {\fB2\fP|\fB3\fP}
+.TP
+\fB\-\-type\fP {\fBcontrol\fP|\fBdata\fP}
+.PP
+At least one of \fB\-\-tunnel\-id\fP, \fB\-\-session\-id\fP or
+\fB\-\-type\fP must be
+specified.
+.PP
+L2TP match rules should always be used together with IP address and
+protocol specifiers since the tunnel-id and session-id fields are
+scoped by the L2TP sender or receiver. A \fB\-p\fP specifier is
+mandatory (udp or l2tpip). For UDP, one or both of \fB\-\-sport\fP and
+\fB\-\-dport\fP is also required if a tunnel-id or session-id is
+included in the L2TP rule.
+.PP
+To match L2TPv3 packets which use 32-bit tunnel and session ids, the
+\fBpversion\fP option must be used to set the protocol version to
+3. In L2TPv2, tunnel and session ids are 16-bit fields.
+.PP
+Examples:
+.IP
+iptables \-A INPUT \-p udp \-m l2tp
+\-\-type control \-j DROP
+.IP
+iptables \-A INPUT \-d 1.2.3.4 \-p udp \-\-dport 5000
+\-m l2tp \-\-tid 100042 \-\-sid 100043
+\-\-pversion 3 \-j DROP
+.IP
+iptables \-A INPUT \-s 1.2.3.4 \-p l2tpip
+\-m l2tp \-\-tid 100044 \-\-sid 100045
+\-\-pversion 3 \-j DROP
diff --git a/include/linux/netfilter/xt_l2tp.h b/include/linux/netfilter/xt_l2tp.h
new file mode 100644
index 0000000..be65e0b
--- /dev/null
+++ b/include/linux/netfilter/xt_l2tp.h
@@ -0,0 +1,29 @@
+#ifndef _LINUX_NETFILTER_XT_L2TP_H
+#define _LINUX_NETFILTER_XT_L2TP_H
+
+#include <linux/types.h>
+
+enum xt_l2tp_type {
+	XT_L2TP_TYPE_CONTROL,
+	XT_L2TP_TYPE_DATA,
+};
+
+/* L2TP matching stuff */
+struct xt_l2tp_info {
+	__u32 tid;			/* tunnel id */
+	__u32 sid;			/* session id */
+	__u8 version;			/* L2TP protocol version */
+	__u8 type;			/* L2TP packet type */
+	__u8 flags;			/* which fields to match */
+};
+
+enum {
+	XT_L2TP_TID	= (1 << 0),	/* match L2TP tunnel id */
+	XT_L2TP_SID	= (1 << 1),	/* match L2TP session id */
+	XT_L2TP_VERSION	= (1 << 2),	/* match L2TP protocol version */
+	XT_L2TP_TYPE	= (1 << 3),	/* match L2TP packet type */
+};
+
+
+#endif /* _LINUX_NETFILTER_XT_L2TP_H */
+
-- 
1.7.0.4

