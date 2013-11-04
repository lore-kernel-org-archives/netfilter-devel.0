From: James Chapman <jchapman@katalix.com>
Subject: [PATCH] iptables: add support for l2tp match
Date: Mon,  4 Nov 2013 16:41:40 +0000
Message-ID: <1383583300-26424-1-git-send-email-jchapman@katalix.com>
Cc: James Chapman <jchapman@katalix.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from katalix.com ([82.103.140.233]:43627 "EHLO bert.katalix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848Ab3KDQu7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Nov 2013 11:50:59 -0500
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
:000000 100644 0000000... bb1e567... A	extensions/libxt_l2tp.c
:000000 100644 0000000... b492725... A	extensions/libxt_l2tp.man
 extensions/libxt_l2tp.c   |  213 +++++++++++++++++++++++++++++++++++++++++++++
 extensions/libxt_l2tp.man |   32 +++++++
 2 files changed, 245 insertions(+), 0 deletions(-)

diff --git a/extensions/libxt_l2tp.c b/extensions/libxt_l2tp.c
new file mode 100644
index 0000000..bb1e567
--- /dev/null
+++ b/extensions/libxt_l2tp.c
@@ -0,0 +1,213 @@
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
+	O_ENCAP,
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
+" --encap {udp|ip}\n"
+"				match encapsulation\n"
+" --type {control|data}\n"
+"				match packet type\n");
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
+	{.name = "encap", .id = O_ENCAP, .type = XTTYPE_STRING },
+	{.name = "type", .id = O_TYPE, .type = XTTYPE_STRING },
+	XTOPT_TABLEEND,
+};
+#undef s
+
+static int parse_encap(const char *s)
+{
+	if (strcmp(s, "udp") == 0)
+		return XT_L2TP_ENCAP_UDP;
+	if (strcmp(s, "ip") == 0)
+		return XT_L2TP_ENCAP_IP;
+	xtables_error(PARAMETER_PROBLEM, "l2tp: invalid encap \"%s\"", s);
+}
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
+	case O_ENCAP:
+		info->encap = parse_encap(cb->arg);
+		info->flags |= XT_L2TP_ENCAP;
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
+	    ((!(info->flags & XT_L2TP_TYPE)) || (info->type != XT_L2TP_TYPE_CONTROL)))
+		xtables_error(PARAMETER_PROBLEM,
+			      "l2tp tid, sid or control type not specified");
+
+	if ((info->flags & XT_L2TP_VERSION) &&
+	    ((info->version < 2) || (info->version > 3)))
+		xtables_error(PARAMETER_PROBLEM, "l2tp: invalid version \"%d\"", info->version);
+
+	if (info->version < 3) {
+		if (!(info->flags & XT_L2TP_TID))
+			xtables_error(PARAMETER_PROBLEM,
+				      "l2tp tid is required unless version is 3");
+		if (info->encap == XT_L2TP_ENCAP_IP)
+			xtables_error(PARAMETER_PROBLEM,
+				      "l2tp encap ip invalid unless version is 3");
+		if (info->tid > 0xffff)
+			xtables_error(PARAMETER_PROBLEM,
+				      "l2tp tid is 16 bits unless version is 3");
+		if (info->sid > 0xffff)
+			xtables_error(PARAMETER_PROBLEM,
+				      "l2tp sid is 16 bits unless version is 3");
+	}
+}
+
+static void print_encap(uint8_t encap, const char *prefix)
+{
+	printf(" %sencap ", prefix);
+
+	switch (encap) {
+	case XT_L2TP_ENCAP_UDP:
+		printf("udp");
+		break;
+	case XT_L2TP_ENCAP_IP:
+		printf("ip");
+		break;
+	default:
+		printf("???");
+		break;
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
+	if (info->flags & XT_L2TP_ENCAP)
+		print_encap(info->encap, "");
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
+	if (info->flags & XT_L2TP_ENCAP)
+		print_encap(info->encap, "--");
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
index 0000000..b492725
--- /dev/null
+++ b/extensions/libxt_l2tp.man
@@ -0,0 +1,32 @@
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
+\fB\-\-encap\fP {\fBudp\fP|\fBip\fP}
+.TP
+\fB\-\-type\fP {\fBcontrol\fP|\fBdata\fP}
+.PP
+At least one of \fB\-\-tunnel\-id\fP, \fB\-\-session\-id\fP must be
+specified.
+.PP
+L2TP match rules should always be used together with IP address
+specifiers since the tunnel-id and session-id fields are scoped by the
+L2TP sender or receiver.
+.PP
+To match L2TPv3 packets which use 32-bit tunnel and session ids, the
+\fBpversion\fP option must be used to set the protocol version to 3.
+.PP
+Examples:
+.IP
+iptables \-A INPUT \-s 1.2.3.4 \-m l2tp
+\-\-tid 42 \-j DROP
+.IP
+iptables \-A OUTPUT \-d 1.2.3.5 \-m l2tp
+\-\-tid 43 \-\-sid 42 \-j DROP
+
-- 
1.7.0.4

