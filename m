From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 1/2] conntrack: add support for mark mask
Date: Wed, 15 Jun 2011 14:13:39 +0200
Message-ID: <1308140020-13487-2-git-send-email-fw@strlen.de>
References: <1308140020-13487-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:36350 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751592Ab1FOMLy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jun 2011 08:11:54 -0400
In-Reply-To: <1308140020-13487-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Extend --mark option to optionally take a mask, seperated
by '/', e.g. --mark 0x80/0xf0.

When used with -L, only test those bits of the mark that
are in the mask range (behaves like iptables like -m mark).

When used with -U, zero out those bits indicated by the mask and
XOR the new mark into the result (behaves like iptables -j MARK
--set-xmark).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 conntrack.8     |    8 +++++-
 src/conntrack.c |   68 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 73 insertions(+), 3 deletions(-)

diff --git a/conntrack.8 b/conntrack.8
index 0565907..6525123 100644
--- a/conntrack.8
+++ b/conntrack.8
@@ -135,8 +135,12 @@ This option is only required in conjunction with "-L, --dump". If this option is
 .BI "-t, --timeout " "TIMEOUT"
 Specify the timeout.
 .TP
-.BI "-m, --mark " "MARK"
-Specify the conntrack mark.
+.BI "-m, --mark " "MARK[/MASK]"
+Specify the conntrack mark.  Optionally, a mask value can be specified.
+In "--update" mode, this mask specifies the bits that should be zeroed before XORing
+the MARK value into the ctmark.
+Otherwise, the mask is logically ANDed with the existing mark before the comparision.
+In "--create" mode, the mask is ignored.
 .TP
 .BI "-c, --secmark " "SECMARK"
 Specify the conntrack selinux security mark.
diff --git a/src/conntrack.c b/src/conntrack.c
index aca36eb..fb133f1 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -58,12 +58,20 @@
 #include <fcntl.h>
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
 
+struct u32_mask {
+	uint32_t value;
+	uint32_t mask;
+};
+
 /* These are the template objects that are used to send commands. */
 static struct {
 	struct nf_conntrack *ct;
 	struct nf_expect *exp;
 	/* Expectations require the expectation tuple and the mask. */
 	struct nf_conntrack *exptuple, *mask;
+
+	/* Allows filtering/setting specific bits in the ctmark */
+	struct u32_mask mark;
 } tmpl;
 
 static int alloc_tmpl_objects(void)
@@ -73,6 +81,8 @@ static int alloc_tmpl_objects(void)
 	tmpl.mask = nfct_new();
 	tmpl.exp = nfexp_new();
 
+	memset(&tmpl.mark, 0, sizeof(tmpl.mark));
+
 	return tmpl.ct != NULL && tmpl.exptuple != NULL &&
 	       tmpl.mask != NULL && tmpl.exp != NULL;
 }
@@ -692,6 +702,12 @@ err2str(int err, enum ct_command command)
 	return strerror(err);
 }
 
+static int mark_cmp(const struct u32_mask *m, const struct nf_conntrack *ct)
+{
+	return nfct_attr_is_set(ct, ATTR_MARK) &&
+		(nfct_get_attr_u32(ct, ATTR_MARK) & m->mask) == m->value;
+}
+
 #define PARSE_STATUS 0
 #define PARSE_EVENT 1
 #define PARSE_OUTPUT 2
@@ -774,6 +790,19 @@ parse_parameter(const char *arg, unsigned int *status, int parse_type)
 }
 
 static void
+parse_u32_mask(const char *arg, struct u32_mask *m)
+{
+	char *end;
+
+	m->value = (uint32_t) strtoul(arg, &end, 0);
+
+	if (*end == '/')
+		m->mask = (uint32_t) strtoul(end+1, NULL, 0);
+	else
+		m->mask = ~0;
+}
+
+static void
 add_command(unsigned int *cmd, const int newcmd)
 {
 	if (*cmd)
@@ -923,6 +952,17 @@ usage(char *prog)
 
 static unsigned int output_mask;
 
+
+static int
+filter_mark(const struct nf_conntrack *ct)
+{
+	if ((options & CT_OPT_MARK) &&
+	     !mark_cmp(&tmpl.mark, ct))
+		return 1;
+	return 0;
+}
+
+
 static int 
 filter_nat(const struct nf_conntrack *obj, const struct nf_conntrack *ct)
 {
@@ -1036,6 +1076,9 @@ static int event_cb(enum nf_conntrack_msg_type type,
 	if (filter_nat(obj, ct))
 		return NFCT_CB_CONTINUE;
 
+	if (filter_mark(ct))
+		return NFCT_CB_CONTINUE;
+
 	if (options & CT_COMPARISON &&
 	    !nfct_cmp(obj, ct, NFCT_CMP_ALL | NFCT_CMP_MASK))
 		return NFCT_CB_CONTINUE;
@@ -1085,6 +1128,9 @@ static int dump_cb(enum nf_conntrack_msg_type type,
 	if (filter_nat(obj, ct))
 		return NFCT_CB_CONTINUE;
 
+	if (filter_mark(ct))
+		return NFCT_CB_CONTINUE;
+
 	if (options & CT_COMPARISON &&
 	    !nfct_cmp(obj, ct, NFCT_CMP_ALL | NFCT_CMP_MASK))
 		return NFCT_CB_CONTINUE;
@@ -1125,6 +1171,9 @@ static int delete_cb(enum nf_conntrack_msg_type type,
 	if (filter_nat(obj, ct))
 		return NFCT_CB_CONTINUE;
 
+	if (filter_mark(ct))
+		return NFCT_CB_CONTINUE;
+
 	if (options & CT_COMPARISON &&
 	    !nfct_cmp(obj, ct, NFCT_CMP_ALL | NFCT_CMP_MASK))
 		return NFCT_CB_CONTINUE;
@@ -1171,6 +1220,17 @@ static int print_cb(enum nf_conntrack_msg_type type,
 	return NFCT_CB_CONTINUE;
 }
 
+static void copy_mark(struct nf_conntrack *tmp,
+		      const struct nf_conntrack *ct,
+		      const struct u32_mask *m)
+{
+	if (options & CT_OPT_MARK) {
+		uint32_t mark = nfct_get_attr_u32(ct, ATTR_MARK);
+		mark = (mark & ~m->mask) ^ m->value;
+		nfct_set_attr_u32(tmp, ATTR_MARK, mark);
+	}
+}
+
 static int update_cb(enum nf_conntrack_msg_type type,
 		     struct nf_conntrack *ct,
 		     void *data)
@@ -1196,6 +1256,7 @@ static int update_cb(enum nf_conntrack_msg_type type,
 
 	nfct_copy(tmp, ct, NFCT_CP_ORIG);
 	nfct_copy(tmp, obj, NFCT_CP_META);
+	copy_mark(tmp, ct, &tmpl.mark);
 
 	res = nfct_query(ith, NFCT_Q_UPDATE, tmp);
 	if (res < 0) {
@@ -1494,12 +1555,14 @@ int main(int argc, char *argv[])
 					  strtoul(optarg, NULL, 0));
 			break;
 		case 'i':
-		case 'm':
 		case 'c':
 			options |= opt2type[c];
 			nfct_set_attr_u32(tmpl.ct,
 					  opt2attr[c],
 					  strtoul(optarg, NULL, 0));
+		case 'm':
+			options |= opt2type[c];
+			parse_u32_mask(optarg, &tmpl.mark);
 			break;
 		case 'a':
 			fprintf(stderr, "WARNING: ignoring -%c, "
@@ -1615,6 +1678,9 @@ int main(int argc, char *argv[])
 		else if (!(options & CT_OPT_ORIG) && (options & CT_OPT_REPL))
 			nfct_setobjopt(tmpl.ct, NFCT_SOPT_SETUP_ORIGINAL);
 
+		if (options & CT_OPT_MARK)
+			nfct_set_attr_u32(tmpl.ct, ATTR_MARK, tmpl.mark.value);
+
 		cth = nfct_open(CONNTRACK, 0);
 		if (!cth)
 			exit_error(OTHER_PROBLEM, "Can't open handler");
-- 
1.7.3.4

