From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/2] libxt_cgroup2: add support for cgroup2 path matching
Date: Tue, 22 Dec 2015 13:57:07 -0500
Message-ID: <20151222185707.GD5003@mtj.duckdns.org>
References: <20151222185626.GC5003@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yk0-f181.google.com ([209.85.160.181]:34324 "EHLO
	mail-yk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbbLVS5J (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Dec 2015 13:57:09 -0500
Received: by mail-yk0-f181.google.com with SMTP id p130so173073181yka.1
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 10:57:09 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20151222185626.GC5003@mtj.duckdns.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch updates xt_cgroup so that it supports revision 1 interface
which includes cgroup2 path based matching.

v3: Folded into xt_cgroup as a new revision interface as suggested by
    Pablo.

v2: cgroup2_match->userspacesize and ->save and man page updated as
    per Jan.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Daniel Borkmann <dborkman@redhat.com>
Cc: Jan Engelhardt <jengelh@inai.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
---
 extensions/libxt_cgroup.c           |   86 ++++++++++++++++++++++++++++++++++++
 extensions/libxt_cgroup.man         |   33 ++++++++-----
 include/linux/netfilter/xt_cgroup.h |   13 +++++
 3 files changed, 119 insertions(+), 13 deletions(-)

--- a/extensions/libxt_cgroup.c
+++ b/extensions/libxt_cgroup.c
@@ -4,6 +4,7 @@
 
 enum {
 	O_CLASSID = 0,
+	O_PATH = 1,
 };
 
 static void cgroup_help_v0(void)
@@ -13,6 +14,14 @@ static void cgroup_help_v0(void)
 "[!] --cgroup classid            Match cgroup classid\n");
 }
 
+static void cgroup_help_v1(void)
+{
+	printf(
+"cgroup match options:\n"
+"[!] --path path                 Recursively match path relative to cgroup2 root\n"
+"[!] --cgroup claasid            Match cgroup classid, can't be used with --path\n");
+}
+
 static const struct xt_option_entry cgroup_opts_v0[] = {
 	{
 		.name = "cgroup",
@@ -24,6 +33,24 @@ static const struct xt_option_entry cgro
 	XTOPT_TABLEEND,
 };
 
+static const struct xt_option_entry cgroup_opts_v1[] = {
+	{
+		.name = "path",
+		.id = O_PATH,
+		.type = XTTYPE_STRING,
+		.flags = XTOPT_INVERT | XTOPT_PUT,
+		XTOPT_POINTER(struct xt_cgroup_info_v1, path)
+	},
+	{
+		.name = "cgroup",
+		.id = O_CLASSID,
+		.type = XTTYPE_UINT32,
+		.flags = XTOPT_INVERT | XTOPT_PUT,
+		XTOPT_POINTER(struct xt_cgroup_info_v1, classid)
+	},
+	XTOPT_TABLEEND,
+};
+
 static void cgroup_parse_v0(struct xt_option_call *cb)
 {
 	struct xt_cgroup_info_v0 *cgroupinfo = cb->data;
@@ -33,6 +60,26 @@ static void cgroup_parse_v0(struct xt_op
 		cgroupinfo->invert = true;
 }
 
+static void cgroup_parse_v1(struct xt_option_call *cb)
+{
+	struct xt_cgroup_info_v1 *info = cb->data;
+
+	xtables_option_parse(cb);
+
+	switch (cb->entry->id) {
+	case O_PATH:
+		info->has_path = true;
+		if (cb->invert)
+			info->invert_path = true;
+		break;
+	case O_CLASSID:
+		info->has_classid = true;
+		if (cb->invert)
+			info->invert_classid = true;
+		break;
+	}
+}
+
 static void
 cgroup_print_v0(const void *ip, const struct xt_entry_match *match, int numeric)
 {
@@ -48,6 +95,32 @@ static void cgroup_save_v0(const void *i
 	printf("%s --cgroup %u", info->invert ? " !" : "", info->id);
 }
 
+static void
+cgroup_print_v1(const void *ip, const struct xt_entry_match *match, int numeric)
+{
+	const struct xt_cgroup_info_v1 *info = (void *)match->data;
+
+	printf(" cgroup");
+	if (info->has_path)
+		printf(" %s%s", info->invert_path ? "! ":"", info->path);
+	if (info->has_classid)
+		printf(" %s%u", info->invert_classid ? "! ":"", info->classid);
+}
+
+static void cgroup_save_v1(const void *ip, const struct xt_entry_match *match)
+{
+	const struct xt_cgroup_info_v1 *info = (void *)match->data;
+
+	if (info->has_path) {
+		printf("%s --path", info->invert_path ? " !" : "");
+		xtables_save_string(info->path);
+	}
+
+	if (info->has_classid)
+		printf("%s --cgroup %u", info->invert_classid ? " !" : "",
+		       info->classid);
+}
+
 static struct xtables_match cgroup_match[] = {
 	{
 		.family		= NFPROTO_UNSPEC,
@@ -62,6 +135,19 @@ static struct xtables_match cgroup_match
 		.x6_parse	= cgroup_parse_v0,
 		.x6_options	= cgroup_opts_v0,
 	},
+	{
+		.family		= NFPROTO_UNSPEC,
+		.revision	= 1,
+		.name		= "cgroup",
+		.version	= XTABLES_VERSION,
+		.size		= XT_ALIGN(sizeof(struct xt_cgroup_info_v1)),
+		.userspacesize	= offsetof(struct xt_cgroup_info_v1, priv),
+		.help		= cgroup_help_v1,
+		.print		= cgroup_print_v1,
+		.save		= cgroup_save_v1,
+		.x6_parse	= cgroup_parse_v1,
+		.x6_options	= cgroup_opts_v1,
+	},
 };
 
 void _init(void)
--- a/extensions/libxt_cgroup.man
+++ b/extensions/libxt_cgroup.man
@@ -1,23 +1,30 @@
 .TP
-[\fB!\fP] \fB\-\-cgroup\fP \fIfwid\fP
-Match corresponding cgroup for this packet.
+[\fB!\fP] \fB\-\-path\fP \fIpath\fP
+Match cgroup2 membership.
 
-Can be used in the OUTPUT chain to assign particular firewall
-policies for aggregated task/jobs on the system. This allows
-for more fine-grained firewall policies that only match for a
-subset of the system's processes. fwid is the maker set through
-the net_cls cgroup's id.
+Each socket is associated with the v2 cgroup of the creating process.
+This matches packets coming from or going to all sockets in the
+sub-hierarchy of the specified path.  The path should be relative to
+the root of the cgroup2 hierarchy.
+.TP
+[\fB!\fP] \fB\-\-cgroup\fP \fIclassid\fP
+Match cgroup net_cls classid.
 
-\fBIMPORTANT\fP: when being used in the INPUT chain, the cgroup
-matcher is currently only of limited functionality, meaning it
-will only match on packets that are processed for local sockets
-through early socket demuxing. Therefore, general usage on the
-INPUT chain is disadviced unless the implications are well
-understood.
+classid is the marker set through the cgroup net_cls controller.  This
+option and \-\-path can't be used together.
 .PP
 Example:
 .IP
+iptables \-A OUTPUT \-p tcp \-\-sport 80 \-m cgroup ! \-\-path service/http-server \-j DROP
+.IP
 iptables \-A OUTPUT \-p tcp \-\-sport 80 \-m cgroup ! \-\-cgroup 1
 \-j DROP
 .PP
+\fBIMPORTANT\fP: when being used in the INPUT chain, the cgroup
+matcher is currently only of limited functionality, meaning it
+will only match on packets that are processed for local sockets
+through early socket demuxing. Therefore, general usage on the
+INPUT chain is not advised unless the implications are well
+understood.
+.PP
 Available since Linux 3.14.
--- a/include/linux/netfilter/xt_cgroup.h
+++ b/include/linux/netfilter/xt_cgroup.h
@@ -2,10 +2,23 @@
 #define _XT_CGROUP_H
 
 #include <linux/types.h>
+#include <linux/limits.h>
 
 struct xt_cgroup_info_v0 {
 	__u32 id;
 	__u32 invert;
 };
 
+struct xt_cgroup_info_v1 {
+	__u8		has_path;
+	__u8		has_classid;
+	__u8		invert_path;
+	__u8		invert_classid;
+	char		path[PATH_MAX];
+	__u32		classid;
+
+	/* kernel internal data */
+	void		*priv __attribute__((aligned(8)));
+};
+
 #endif /* _XT_CGROUP_H */
