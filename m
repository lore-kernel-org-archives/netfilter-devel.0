From: Florian Westphal <fw@strlen.de>
Subject: [PATCH iptables] extensions: libxt_connlabel: use libnetfilter_conntrack
Date: Wed, 10 Jul 2013 10:28:34 +0200
Message-ID: <1373444914-30397-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:38660 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751659Ab3GJIab (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jul 2013 04:30:31 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo suggested to make it depend on lnf-conntrack, and get rid of
the example config file as well.

The problem is that the file must be in a fixed path,
/etc/xtables/connlabel.conf, else userspace needs to "guess-the-right-file"
when translating names to their bit values (and vice versa).

Originally "make install" did put an example file into /etc/xtables/,
but distributors complained about iptables ignoring the sysconfdir.

So rather remove the example file, the man-page explains the format,
and connlabels are inherently system-specific anyway.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 WARNING: checks for lnf_conntrack 1.03, which is bogus.
 It needs to test for 1.1.0 or 1.0.4, depending on
 what version number will be chosen for the upcoming release.

 Makefile.am                    |    4 -
 configure.ac                   |    9 +++
 etc/xtables/connlabel.conf     |    8 --
 extensions/GNUmakefile.in      |    5 +-
 extensions/libxt_connlabel.c   |  142 ++++++++--------------------------------
 extensions/libxt_connlabel.man |    1 +
 6 files changed, 42 insertions(+), 127 deletions(-)
 delete mode 100644 etc/xtables/connlabel.conf

diff --git a/Makefile.am b/Makefile.am
index 73f1352..c38d360 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -24,9 +24,5 @@ tarball:
 	tar -C /tmp -cjf ${PACKAGE_TARNAME}-${PACKAGE_VERSION}.tar.bz2 --owner=root --group=root ${PACKAGE_TARNAME}-${PACKAGE_VERSION}/;
 	rm -Rf /tmp/${PACKAGE_TARNAME}-${PACKAGE_VERSION};
 
-install-data-hook:
-	@mkdir -p -m 755 @sysconfdir@/xtables/ || :
-	@test -f @sysconfdir@/xtables/connlabel.conf || $(INSTALL) -m 644 etc/xtables/connlabel.conf @sysconfdir@/xtables/connlabel.conf || :
-
 config.status: extensions/GNUmakefile.in \
 	include/xtables-version.h.in include/iptables/internal.h.in
diff --git a/configure.ac b/configure.ac
index d209494..4b6c96a 100644
--- a/configure.ac
+++ b/configure.ac
@@ -82,6 +82,15 @@ if test "$ac_cv_header_linux_ip_vs_h" != "yes"; then
 	blacklist_modules="$blacklist_modules ipvs";
 fi;
 
+PKG_CHECK_MODULES([libnetfilter_conntrack], [libnetfilter_conntrack >= 1.0.3],
+	[nfconntrack=1], [nfconntrack=0])
+AM_CONDITIONAL([HAVE_LIBNETFILTER_CONNTRACK], [test "$nfconntrack" = 1])
+
+if test "$nfconntrack" -ne 1; then
+	blacklist_modules="$blacklist_modules connlabel";
+	echo "WARNING: libnetfilter_conntrack not found, connlabel match will not be built";
+fi;
+
 AC_SUBST([blacklist_modules])
 AC_CHECK_SIZEOF([struct ip6_hdr], [], [#include <netinet/ip6.h>])
 
diff --git a/etc/xtables/connlabel.conf b/etc/xtables/connlabel.conf
deleted file mode 100644
index 9167029..0000000
--- a/etc/xtables/connlabel.conf
+++ /dev/null
@@ -1,8 +0,0 @@
-# example connlabel.conf mapping file.
-# used by the "connlabel" match to translate names to their bit-value.
-0	eth0-in
-1	eth0-out
-2	ppp-in
-3	ppp-out
-4	bulk-traffic
-5	interactive
diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index 1ae7f74..14e7c57 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -93,7 +93,7 @@ lib%.so: lib%.oo
 	${AM_VERBOSE_CCLD} ${CCLD} ${AM_LDFLAGS} -shared ${LDFLAGS} -o $@ $< -L../libxtables/.libs -lxtables ${$*_LIBADD};
 
 lib%.oo: ${srcdir}/lib%.c
-	${AM_VERBOSE_CC} ${CC} ${AM_CPPFLAGS} ${AM_DEPFLAGS} ${AM_CFLAGS} -D_INIT=lib$*_init -DPIC -fPIC ${CFLAGS} -o $@ -c $<;
+	${AM_VERBOSE_CC} ${CC} ${AM_CPPFLAGS} ${AM_DEPFLAGS} ${AM_CFLAGS} -D_INIT=lib$*_init -DPIC -fPIC ${CFLAGS} ${$*_CFLAGADD} -o $@ -c $<;
 
 libxt_NOTRACK.so: libxt_CT.so
 	ln -fs $< $@
@@ -103,6 +103,9 @@ libxt_state.so: libxt_conntrack.so
 # Need the LIBADDs in iptables/Makefile.am too for libxtables_la_LIBADD
 xt_RATEEST_LIBADD   = -lm
 xt_statistic_LIBADD = -lm
+@HAVE_LIBNETFILTER_CONNTRACK_TRUE@xt_connlabel_LIBADD = @libnetfilter_conntrack_LIBS@
+
+@HAVE_LIBNETFILTER_CONNTRACK_TRUE@xt_connlabel_CFLAGADD = @libnetfilter_conntrack_CFLAGS@
 
 #
 #	Static bits
diff --git a/extensions/libxt_connlabel.c b/extensions/libxt_connlabel.c
index ae52901..c84a167 100644
--- a/extensions/libxt_connlabel.c
+++ b/extensions/libxt_connlabel.c
@@ -5,13 +5,14 @@
 #include <stdint.h>
 #include <xtables.h>
 #include <linux/netfilter/xt_connlabel.h>
+#include <libnetfilter_conntrack/libnetfilter_conntrack.h>
 
 enum {
 	O_LABEL = 0,
 	O_SET = 1,
 };
 
-#define CONNLABEL_CFG "/etc/xtables/connlabel.conf"
+static struct nfct_labelmap *map;
 
 static void connlabel_mt_help(void)
 {
@@ -28,107 +29,6 @@ static const struct xt_option_entry connlabel_mt_opts[] = {
 	XTOPT_TABLEEND,
 };
 
-static int
-xtables_parse_connlabel_numerical(const char *s, char **end)
-{
-	uintmax_t value;
-
-	if (!xtables_strtoul(s, end, &value, 0, XT_CONNLABEL_MAXBIT))
-		return -1;
-	return value;
-}
-
-static bool is_space_posix(int c)
-{
-	return c == ' ' || c == '\f' || c == '\r' || c == '\t' || c == '\v';
-}
-
-static char * trim_label(char *label)
-{
-	char *end;
-
-	while (is_space_posix(*label))
-		label++;
-	end = strchr(label, '\n');
-	if (end)
-		*end = 0;
-	else
-		end = strchr(label, '\0');
-	end--;
-
-	while (is_space_posix(*end) && end > label) {
-		*end = 0;
-		end--;
-	}
-
-	return *label ? label : NULL;
-}
-
-static void
-xtables_get_connlabel(uint16_t bit, char *buf, size_t len)
-{
-	FILE *fp = fopen(CONNLABEL_CFG, "r");
-	char label[1024];
-	char *end;
-
-	if (!fp)
-		goto error;
-
-	while (fgets(label, sizeof(label), fp)) {
-		int tmp;
-
-		if (label[0] == '#')
-			continue;
-		tmp = xtables_parse_connlabel_numerical(label, &end);
-		if (tmp < 0 || tmp < (int) bit)
-			continue;
-		if (tmp > (int) bit)
-			break;
-
-		end = trim_label(end);
-		if (!end)
-			continue;
-		snprintf(buf, len, "%s", end);
-		fclose(fp);
-		return;
-	}
-	fclose(fp);
- error:
-	snprintf(buf, len, "%u", (unsigned int) bit);
-}
-
-
-static uint16_t xtables_parse_connlabel(const char *s)
-{
-	FILE *fp = fopen(CONNLABEL_CFG, "r");
-	char label[1024];
-	char *end;
-	int bit;
-
-	if (!fp)
-		xtables_error(PARAMETER_PROBLEM, "label '%s': could not open '%s': %s",
-						s, CONNLABEL_CFG, strerror(errno));
-
-	while (fgets(label, sizeof(label), fp)) {
-		if (label[0] == '#' || !strstr(label, s))
-			continue;
-		bit = xtables_parse_connlabel_numerical(label, &end);
-		if (bit < 0)
-			continue;
-
-		end = trim_label(end);
-		if (!end)
-			continue;
-		if (strcmp(end, s) == 0) {
-			fclose(fp);
-			return bit;
-		}
-	}
-	fclose(fp);
-	xtables_error(PARAMETER_PROBLEM, "label '%s' not found in config file %s",
-					s, CONNLABEL_CFG);
-}
-
 static void connlabel_mt_parse(struct xt_option_call *cb)
 {
 	struct xt_connlabel_mtinfo *info = cb->data;
@@ -138,9 +38,10 @@ static void connlabel_mt_parse(struct xt_option_call *cb)
 
 	switch (cb->entry->id) {
 	case O_LABEL:
-		tmp = xtables_parse_connlabel_numerical(cb->arg, NULL);
-		info->bit = tmp < 0 ? xtables_parse_connlabel(cb->arg) : tmp;
-
+		tmp = nfct_labelmap_get_bit(map, cb->arg);
+		if (tmp < 0)
+			xtables_error(PARAMETER_PROBLEM, "label '%s' not found", cb->arg);
+		info->bit = tmp;
 		if (cb->invert)
 			info->options |= XT_CONNLABEL_OP_INVERT;
 		break;
@@ -151,6 +52,14 @@ static void connlabel_mt_parse(struct xt_option_call *cb)
 
 }
 
+static const char *connlabel_get_name(int b)
+{
+	const char *name = nfct_labelmap_get_name(map, b);
+	if (name && strcmp(name, ""))
+		return name;
+	return NULL;
+}
+
 static void
 connlabel_mt_print_op(const struct xt_connlabel_mtinfo *info, const char *prefix)
 {
@@ -162,16 +71,15 @@ static void
 connlabel_mt_print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
 	const struct xt_connlabel_mtinfo *info = (const void *)match->data;
-	char buf[1024];
+	const char *name = connlabel_get_name(info->bit);
 
 	printf(" connlabel");
 	if (info->options & XT_CONNLABEL_OP_INVERT)
 		printf(" !");
-	if (numeric) {
+	if (numeric || name == NULL) {
 		printf(" %u", info->bit);
 	} else {
-		xtables_get_connlabel(info->bit, buf, sizeof(buf));
-		printf(" '%s'", buf);
+		printf(" '%s'", name);
 	}
 	connlabel_mt_print_op(info, "");
 }
@@ -180,14 +88,14 @@ static void
 connlabel_mt_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct xt_connlabel_mtinfo *info = (const void *)match->data;
-	char buf[1024];
+	const char *name = connlabel_get_name(info->bit);
 
 	if (info->options & XT_CONNLABEL_OP_INVERT)
 		printf(" !");
-
-	xtables_get_connlabel(info->bit, buf, sizeof(buf));
-	printf(" --label \"%s\"", buf);
-
+	if (name)
+		printf(" --label \"%s\"", name);
+	else
+		printf(" --label \"%u\"", info->bit);
 	connlabel_mt_print_op(info, "--");
 }
 
@@ -206,5 +114,11 @@ static struct xtables_match connlabel_mt_reg = {
 
 void _init(void)
 {
+	map = nfct_labelmap_new(NULL);
+	if (!map) {
+		fprintf(stderr, "cannot open connlabel.conf, not registering '%s' match: %s\n",
+			connlabel_mt_reg.name, strerror(errno));
+		return;
+	}
 	xtables_register_match(&connlabel_mt_reg);
 }
diff --git a/extensions/libxt_connlabel.man b/extensions/libxt_connlabel.man
index 9fd2043..cb25f80 100644
--- a/extensions/libxt_connlabel.man
+++ b/extensions/libxt_connlabel.man
@@ -17,6 +17,7 @@ the time the connection is created.
 In this case, the match will fail (or succeed, in case \fB\-\-label\fP
 option was negated).
 .PP
+This match depends on libnetfilter_conntrack.
 Label translation is done via the \fB/etc/xtables/connlabel.conf\fP configuration file.
 .PP
 Example:
-- 
1.7.8.6

