From: Florian Westphal <fw@strlen.de>
Subject: [PATCH next] extensions: add connlabel match
Date: Fri, 11 Jan 2013 17:35:28 +0100
Message-ID: <1357922128-29950-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:50611 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755091Ab3AKQd3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Jan 2013 11:33:29 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

allows to "tag" connections with up to 128 label names.

Labels are defined in /etc/xtables/connlabel.conf, example:
0 from eth0
1 via eth0

Labels can then be attached to flows, e.g.

-A PREROUTING  -i eth0 -m connlabel --label "from eth0" --set

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 The main issue with this patch is the location of the connlabel config file.
 Upcoming patches to libnetfilter_conntrack add a lookup helper API, these
 need to know the pathname of said file.

 [ preview at
   http://git.breakpoint.cc/cgit.cgi/fw/libnetfilter_conntrack.git/log/?h=ctlabel_08 ]

 I'd like to avoid that users of that API need to try out X different locations,
 thats why its hard-coded to /etc/xtables/connlabel.conf.

 I'd be interested in feedback (esp. from disto maintainers)
 and possible alternatives to naming/location of this file.

 Makefile.am                            |    4 +
 etc/xtables/connlabel.conf             |    9 ++
 extensions/libxt_connlabel.c           |  210 ++++++++++++++++++++++++++++++++
 extensions/libxt_connlabel.man         |   32 +++++
 include/linux/netfilter/xt_connlabel.h |   12 ++
 5 files changed, 267 insertions(+), 0 deletions(-)
 create mode 100644 etc/xtables/connlabel.conf
 create mode 100644 extensions/libxt_connlabel.c
 create mode 100644 extensions/libxt_connlabel.man
 create mode 100644 include/linux/netfilter/xt_connlabel.h

diff --git a/Makefile.am b/Makefile.am
index 6400ba4..4ae5075 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -26,5 +26,9 @@ tarball:
 	tar -C /tmp -cjf ${PACKAGE_TARNAME}-${PACKAGE_VERSION}.tar.bz2 --owner=root --group=root ${PACKAGE_TARNAME}-${PACKAGE_VERSION}/;
 	rm -Rf /tmp/${PACKAGE_TARNAME}-${PACKAGE_VERSION};
 
+install-data-hook:
+	@mkdir -p -m 755 $(DESTDIR)/etc/xtables/ || :
+	@test -f /etc/xtables/connlabel.conf || $(INSTALL) -m 644 etc/xtables/connlabel.conf $(DESTDIR)/etc/xtables/connlabel.conf || :
+
 config.status: extensions/GNUmakefile.in \
 	include/xtables-version.h.in include/iptables/internal.h.in
diff --git a/etc/xtables/connlabel.conf b/etc/xtables/connlabel.conf
new file mode 100644
index 0000000..9bd52c7
--- /dev/null
+++ b/etc/xtables/connlabel.conf
@@ -0,0 +1,9 @@
+# example connlabel.conf mapping file.
+# used by the "connlabel" match to translate
+# names to their bit-value.
+0	eth0-in
+1	eth0-out
+2	ppp-in
+3	ppp-out
+4	bulk-traffic
+5	interactive
diff --git a/extensions/libxt_connlabel.c b/extensions/libxt_connlabel.c
new file mode 100644
index 0000000..ae52901
--- /dev/null
+++ b/extensions/libxt_connlabel.c
@@ -0,0 +1,210 @@
+#include <errno.h>
+#include <stdbool.h>
+#include <string.h>
+#include <stdio.h>
+#include <stdint.h>
+#include <xtables.h>
+#include <linux/netfilter/xt_connlabel.h>
+
+enum {
+	O_LABEL = 0,
+	O_SET = 1,
+};
+
+#define CONNLABEL_CFG "/etc/xtables/connlabel.conf"
+
+static void connlabel_mt_help(void)
+{
+	puts(
+"connlabel match options:\n"
+"[!] --label name     Match if label has been set on connection\n"
+"    --set            Set label on connection");
+}
+
+static const struct xt_option_entry connlabel_mt_opts[] = {
+	{.name = "label", .id = O_LABEL, .type = XTTYPE_STRING,
+	 .min = 1, .flags = XTOPT_MAND|XTOPT_INVERT},
+	{.name = "set", .id = O_SET, .type = XTTYPE_NONE},
+	XTOPT_TABLEEND,
+};
+
+static int
+xtables_parse_connlabel_numerical(const char *s, char **end)
+{
+	uintmax_t value;
+
+	if (!xtables_strtoul(s, end, &value, 0, XT_CONNLABEL_MAXBIT))
+		return -1;
+	return value;
+}
+
+static bool is_space_posix(int c)
+{
+	return c == ' ' || c == '\f' || c == '\r' || c == '\t' || c == '\v';
+}
+
+static char * trim_label(char *label)
+{
+	char *end;
+
+	while (is_space_posix(*label))
+		label++;
+	end = strchr(label, '\n');
+	if (end)
+		*end = 0;
+	else
+		end = strchr(label, '\0');
+	end--;
+
+	while (is_space_posix(*end) && end > label) {
+		*end = 0;
+		end--;
+	}
+
+	return *label ? label : NULL;
+}
+
+static void
+xtables_get_connlabel(uint16_t bit, char *buf, size_t len)
+{
+	FILE *fp = fopen(CONNLABEL_CFG, "r");
+	char label[1024];
+	char *end;
+
+	if (!fp)
+		goto error;
+
+	while (fgets(label, sizeof(label), fp)) {
+		int tmp;
+
+		if (label[0] == '#')
+			continue;
+		tmp = xtables_parse_connlabel_numerical(label, &end);
+		if (tmp < 0 || tmp < (int) bit)
+			continue;
+		if (tmp > (int) bit)
+			break;
+
+		end = trim_label(end);
+		if (!end)
+			continue;
+		snprintf(buf, len, "%s", end);
+		fclose(fp);
+		return;
+	}
+	fclose(fp);
+ error:
+	snprintf(buf, len, "%u", (unsigned int) bit);
+}
+
+
+static uint16_t xtables_parse_connlabel(const char *s)
+{
+	FILE *fp = fopen(CONNLABEL_CFG, "r");
+	char label[1024];
+	char *end;
+	int bit;
+
+	if (!fp)
+		xtables_error(PARAMETER_PROBLEM, "label '%s': could not open '%s': %s",
+						s, CONNLABEL_CFG, strerror(errno));
+
+	while (fgets(label, sizeof(label), fp)) {
+		if (label[0] == '#' || !strstr(label, s))
+			continue;
+		bit = xtables_parse_connlabel_numerical(label, &end);
+		if (bit < 0)
+			continue;
+
+		end = trim_label(end);
+		if (!end)
+			continue;
+		if (strcmp(end, s) == 0) {
+			fclose(fp);
+			return bit;
+		}
+	}
+	fclose(fp);
+	xtables_error(PARAMETER_PROBLEM, "label '%s' not found in config file %s",
+					s, CONNLABEL_CFG);
+}
+
+static void connlabel_mt_parse(struct xt_option_call *cb)
+{
+	struct xt_connlabel_mtinfo *info = cb->data;
+	int tmp;
+
+	xtables_option_parse(cb);
+
+	switch (cb->entry->id) {
+	case O_LABEL:
+		tmp = xtables_parse_connlabel_numerical(cb->arg, NULL);
+		info->bit = tmp < 0 ? xtables_parse_connlabel(cb->arg) : tmp;
+
+		if (cb->invert)
+			info->options |= XT_CONNLABEL_OP_INVERT;
+		break;
+	case O_SET:
+		info->options |= XT_CONNLABEL_OP_SET;
+		break;
+	}
+
+}
+
+static void
+connlabel_mt_print_op(const struct xt_connlabel_mtinfo *info, const char *prefix)
+{
+	if (info->options & XT_CONNLABEL_OP_SET)
+		printf(" %sset", prefix);
+}
+
+static void
+connlabel_mt_print(const void *ip, const struct xt_entry_match *match, int numeric)
+{
+	const struct xt_connlabel_mtinfo *info = (const void *)match->data;
+	char buf[1024];
+
+	printf(" connlabel");
+	if (info->options & XT_CONNLABEL_OP_INVERT)
+		printf(" !");
+	if (numeric) {
+		printf(" %u", info->bit);
+	} else {
+		xtables_get_connlabel(info->bit, buf, sizeof(buf));
+		printf(" '%s'", buf);
+	}
+	connlabel_mt_print_op(info, "");
+}
+
+static void
+connlabel_mt_save(const void *ip, const struct xt_entry_match *match)
+{
+	const struct xt_connlabel_mtinfo *info = (const void *)match->data;
+	char buf[1024];
+
+	if (info->options & XT_CONNLABEL_OP_INVERT)
+		printf(" !");
+
+	xtables_get_connlabel(info->bit, buf, sizeof(buf));
+	printf(" --label \"%s\"", buf);
+
+	connlabel_mt_print_op(info, "--");
+}
+
+static struct xtables_match connlabel_mt_reg = {
+	.family        = NFPROTO_UNSPEC,
+	.name          = "connlabel",
+	.version       = XTABLES_VERSION,
+	.size          = XT_ALIGN(sizeof(struct xt_connlabel_mtinfo)),
+	.userspacesize = offsetof(struct xt_connlabel_mtinfo, bit),
+	.help          = connlabel_mt_help,
+	.print         = connlabel_mt_print,
+	.save          = connlabel_mt_save,
+	.x6_parse      = connlabel_mt_parse,
+	.x6_options    = connlabel_mt_opts,
+};
+
+void _init(void)
+{
+	xtables_register_match(&connlabel_mt_reg);
+}
diff --git a/extensions/libxt_connlabel.man b/extensions/libxt_connlabel.man
new file mode 100644
index 0000000..d5ee079
--- /dev/null
+++ b/extensions/libxt_connlabel.man
@@ -0,0 +1,32 @@
+Module matches or adds connlabels to a connection.
+connlabels are similar to connmarks, except labels are bit-based; i.e.
+all labels may be attached to a flow at the same time.
+Up to 128 unique labels are currently supported.
+.TP
+[\fB!\fP] \fB\-\-label\fP \fBname\fP
+matches if label \fBname\fP has been set on a connection.
+Instead of a name (which will be translated to a number, see EXAMPLE below),
+a number may be used instead.  Using a number always overrides connlabel.conf.
+.TP
+\fB\-\-set\fP
+if the label has not been set on the connection, set it.
+Note that setting a label can fail.  This is because the kernel allocates the
+conntrack label storage area when the connection is created, and it only
+reserves the amount of memory required by the ruleset that exists at
+the time the connection is created.
+In this case, the match will fail (or succeed, in case \fB\-\-label\fP
+option was negated).
+.PP
+Label translation is done via the \fB/etc/xtables/connlabel.conf\fP configuration file.
+.PP
+Example:
+.IP
+.nf
+0	eth0-in
+1	eth0-out
+2	ppp-in
+3	ppp-out
+4	bulk-traffic
+5	interactive
+.fi
+.PP
diff --git a/include/linux/netfilter/xt_connlabel.h b/include/linux/netfilter/xt_connlabel.h
new file mode 100644
index 0000000..c4bc9ee
--- /dev/null
+++ b/include/linux/netfilter/xt_connlabel.h
@@ -0,0 +1,12 @@
+#include <linux/types.h>
+
+#define XT_CONNLABEL_MAXBIT 127
+enum xt_connlabel_mtopts {
+	XT_CONNLABEL_OP_INVERT = 1 << 0,
+	XT_CONNLABEL_OP_SET    = 1 << 1,
+};
+
+struct xt_connlabel_mtinfo {
+	__u16 bit;
+	__u16 options;
+};
-- 
1.7.8.6

